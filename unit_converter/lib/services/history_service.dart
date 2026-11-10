import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';

class HistoryService {
  static const String _key = 'unit_converter_history_v1';
  final List<HistoryItem> _memoryHistory = [];

  /// Loads history items from SharedPreferences with in-memory fallback.
  Future<List<HistoryItem>> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? rawList = prefs.getStringList(_key);
      if (rawList != null && rawList.isNotEmpty) {
        _memoryHistory.clear();
        for (final itemStr in rawList) {
          try {
            _memoryHistory.add(HistoryItem.fromJson(itemStr));
          } catch (_) {
            // Skip corrupted entries
          }
        }
      }
    } catch (e) {
      // In-memory fallback if platform channel unavailable
    }
    return List.unmodifiable(_memoryHistory);
  }

  /// Adds a new conversion entry to history (kept up to max 50 items).
  Future<void> addHistoryItem(HistoryItem item) async {
    _memoryHistory.insert(0, item);
    if (_memoryHistory.length > 50) {
      _memoryHistory.removeLast();
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final stringList = _memoryHistory.map((e) => e.toJson()).toList();
      await prefs.setStringList(_key, stringList);
    } catch (_) {
      // Fallback persists in-memory
    }
  }

  /// Clears all stored conversion history.
  Future<void> clearHistory() async {
    _memoryHistory.clear();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (_) {}
  }
}

