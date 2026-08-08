import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contact.dart';

class ContactService extends ChangeNotifier {
  static const String _storageKey = 'nexus_user_contacts_clean_v3';
  static const String _fileName = 'nexus_contacts_database.json';

  // Singleton pattern
  static final ContactService _instance = ContactService._internal();
  factory ContactService() => _instance;
  ContactService._internal() {
    _initPersistence();
  }

  final List<Contact> _contacts = [];
  String _searchQuery = '';
  String _selectedCategory = 'all'; // 'all', 'favorite', 'work', 'family', 'friends', 'vip', 'intern'
  bool _isDarkMode = true;
  final ValueNotifier<bool> darkModeNotifier = ValueNotifier<bool>(true);
  bool _isGridView = false;
  bool _isInitialized = false;

  // Cached Filtered Results & Counts
  List<Contact> _cachedFilteredContacts = [];
  List<Contact> _cachedFavoriteContacts = [];
  int _cachedDeveloperCount = 0;
  int _cachedFamilyCount = 0;
  int _cachedFriendsCount = 0;
  int _cachedVipCount = 0;
  int _cachedInternCount = 0;

  // Getters
  List<Contact> get allContacts => List.unmodifiable(_contacts);
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get isDarkMode => _isDarkMode;
  bool get isGridView => _isGridView;
  bool get isInitialized => _isInitialized;

  List<Contact> get filteredContacts => _cachedFilteredContacts;
  List<Contact> get favoriteContacts => _cachedFavoriteContacts;

  // Helper for desktop/mobile physical file
  Future<File?> _getLocalFile() async {
    if (kIsWeb) return null;
    try {
      final dir = await getApplicationDocumentsDirectory();
      return File('${dir.path}/$_fileName');
    } catch (e) {
      debugPrint('Error getting local directory: $e');
      return null;
    }
  }

  // Persistence Setup
  Future<void> _initPersistence() async {
    try {
      String? savedString;

      // 1. Try reading physical disk file on Desktop/Mobile
      if (!kIsWeb) {
        final file = await _getLocalFile();
        if (file != null && await file.exists()) {
          savedString = await file.readAsString();
        }
      }

      // 2. Fallback to SharedPreferences (Web / Backup)
      if (savedString == null || savedString.trim().isEmpty) {
        final prefs = await SharedPreferences.getInstance();
        savedString = prefs.getString(_storageKey);
      }

      if (savedString != null && savedString.trim().isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(savedString);
        final List<Contact> loaded = [];
        for (final item in decoded) {
          if (item is Map) {
            loaded.add(Contact.fromJson(Map<String, dynamic>.from(item)));
          }
        }
        _contacts.clear();
        _contacts.addAll(loaded);
      }
    } catch (e) {
      debugPrint('Error loading saved contacts: $e');
    } finally {
      _isInitialized = true;
      _recalculateCache();
      notifyListeners();
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final jsonList = _contacts.map((c) => c.toJson()).toList();
      final stringData = jsonEncode(jsonList);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, stringData);

      // Save to physical disk file on Windows / Desktop / Mobile
      if (!kIsWeb) {
        final file = await _getLocalFile();
        if (file != null) {
          await file.writeAsString(stringData);
        }
      }
    } catch (e) {
      debugPrint('Error saving contacts to storage: $e');
    }
  }

  // Export JSON Backup String
  String exportBackupJson() {
    final jsonList = _contacts.map((c) => c.toJson()).toList();
    return jsonEncode(jsonList);
  }

  // Import JSON Backup String
  Future<bool> importBackupJson(String rawJson) async {
    try {
      final List<dynamic> decoded = jsonDecode(rawJson);
      final List<Contact> imported = [];
      for (final item in decoded) {
        if (item is Map) {
          imported.add(Contact.fromJson(Map<String, dynamic>.from(item)));
        }
      }
      if (imported.isNotEmpty) {
        _contacts.clear();
        _contacts.addAll(imported);
        _recalculateCache();
        notifyListeners();
        await _saveToPrefs();
        return true;
      }
    } catch (e) {
      debugPrint('Error importing JSON backup: $e');
    }
    return false;
  }

  // Upcoming Birthdays (Within 30 Days)
  List<Contact> get upcomingBirthdays {
    return _contacts.where((c) {
      final days = c.daysUntilBirthday;
      return days != null && days <= 30;
    }).toList();
  }

  // Stats
  int get totalCount => _contacts.length;
  int get favCount => _cachedFavoriteContacts.length;
  int get developerCount => _cachedDeveloperCount;
  int get workCount => _cachedDeveloperCount;
  int get familyCount => _cachedFamilyCount;
  int get friendsCount => _cachedFriendsCount;
  int get vipCount => _cachedVipCount;
  int get internCount => _cachedInternCount;
  int get companyCount => _contacts.map((c) => c.company.trim()).where((c) => c.isNotEmpty).toSet().length;

  void _recalculateCache() {
    // 1. Recalculate Category Counts
    int developer = 0, family = 0, friends = 0, vip = 0, intern = 0;
    List<Contact> favs = [];

    for (final c in _contacts) {
      if (c.isFavorite) favs.add(c);
      switch (c.category) {
        case ContactCategory.developer:
        case ContactCategory.work:
          developer++;
          break;
        case ContactCategory.family:
          family++;
          break;
        case ContactCategory.friends:
          friends++;
          break;
        case ContactCategory.vip:
          vip++;
          break;
        case ContactCategory.intern:
          intern++;
          break;
        default:
          break;
      }
    }

    _cachedFavoriteContacts = favs;
    _cachedDeveloperCount = developer;
    _cachedFamilyCount = family;
    _cachedFriendsCount = friends;
    _cachedVipCount = vip;
    _cachedInternCount = intern;

    // 2. Recalculate Filtered Contacts
    final query = _searchQuery.trim().toLowerCase();

    _cachedFilteredContacts = _contacts.where((contact) {
      bool categoryMatch = true;
      if (_selectedCategory == 'favorite') {
        categoryMatch = contact.isFavorite;
      } else if (_selectedCategory == 'developer' || _selectedCategory == 'work') {
        categoryMatch = contact.category == ContactCategory.developer || contact.category == ContactCategory.work;
      } else if (_selectedCategory == 'family') {
        categoryMatch = contact.category == ContactCategory.family;
      } else if (_selectedCategory == 'friends') {
        categoryMatch = contact.category == ContactCategory.friends;
      } else if (_selectedCategory == 'vip') {
        categoryMatch = contact.category == ContactCategory.vip;
      } else if (_selectedCategory == 'intern') {
        categoryMatch = contact.category == ContactCategory.intern;
      }

      bool searchMatch = true;
      if (query.isNotEmpty) {
        searchMatch = contact.name.toLowerCase().contains(query) ||
            contact.phone.toLowerCase().contains(query) ||
            contact.email.toLowerCase().contains(query) ||
            contact.company.toLowerCase().contains(query) ||
            contact.jobTitle.toLowerCase().contains(query) ||
            contact.address.toLowerCase().contains(query) ||
            contact.notes.toLowerCase().contains(query);
      }

      return categoryMatch && searchMatch;
    }).toList();
  }

  // Actions
  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    _recalculateCache();
    notifyListeners();
  }

  void setCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _recalculateCache();
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    darkModeNotifier.value = _isDarkMode;
    notifyListeners();
  }

  void toggleViewMode() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  Future<void> toggleFavorite(String contactId) async {
    final index = _contacts.indexWhere((c) => c.id == contactId);
    if (index != -1) {
      _contacts[index].isFavorite = !_contacts[index].isFavorite;
      _recalculateCache();
      notifyListeners();
      _saveToPrefs();
    }
  }

  Future<void> addContact(Contact contact) async {
    _contacts.insert(0, contact);
    _recalculateCache();
    notifyListeners();
    _saveToPrefs();
  }

  Future<void> updateContact(Contact updatedContact) async {
    final index = _contacts.indexWhere((c) => c.id == updatedContact.id);
    if (index != -1) {
      _contacts[index] = updatedContact;
      _recalculateCache();
      notifyListeners();
      _saveToPrefs();
    }
  }

  Future<void> deleteContact(String contactId) async {
    _contacts.removeWhere((c) => c.id == contactId);
    _recalculateCache();
    notifyListeners();
    _saveToPrefs();
  }

  // Pre-populated Sample Data
}
