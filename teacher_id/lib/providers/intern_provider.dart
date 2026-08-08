import 'package:flutter/material.dart';
import '../models/intern_model.dart';
import '../models/activity_log_model.dart';

class InternProvider extends ChangeNotifier {
  final List<InternModel> _interns = [
    InternModel(
      id: '1',
      fullName: 'Rahul Sharma',
      internId: 'INT2026001',
      image: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=400',
      email: 'rahul.sharma@digicoders.in',
      phone: '+91 9876543210',
      joiningDate: '01 Jan 2026',
      technology: 'Flutter',
      college: 'LPU Lucknow',
      address: 'Hazratganj, Lucknow, UP',
      status: 'Active',
      qrCode: 'INT2026001',
      barcode: 'INT2026001',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    InternModel(
      id: '2',
      fullName: 'Priya Verma',
      internId: 'INT2026002',
      image: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=400',
      email: 'priya.v@digicoders.in',
      phone: '+91 9123456789',
      joiningDate: '15 Jan 2026',
      technology: 'MERN Stack',
      college: 'AKTU Lucknow',
      address: 'Alambagh, Lucknow, UP',
      status: 'Active',
      qrCode: 'INT2026002',
      barcode: 'INT2026002',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    InternModel(
      id: '3',
      fullName: 'Amit Kumar',
      internId: 'INT2026003',
      image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=400',
      email: 'amit.k@digicoders.in',
      phone: '+91 9988776655',
      joiningDate: '10 Feb 2026',
      technology: 'Python',
      college: 'BBU Lucknow',
      address: 'Gomti Nagar, Lucknow, UP',
      status: 'Completed',
      qrCode: 'INT2026003',
      barcode: 'INT2026003',
      createdAt: DateTime.now().subtract(const Duration(days: 40)),
    ),
    InternModel(
      id: '4',
      fullName: 'Sneha Patel',
      internId: 'INT2026004',
      image: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&q=80&w=400',
      email: 'sneha.patel@digicoders.in',
      phone: '+91 9765432109',
      joiningDate: '01 Mar 2026',
      technology: 'AI/ML',
      college: 'Integral University',
      address: 'Indira Nagar, Lucknow, UP',
      status: 'Active',
      qrCode: 'INT2026004',
      barcode: 'INT2026004',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    InternModel(
      id: '5',
      fullName: 'Vikas Singh',
      internId: 'INT2026005',
      image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=400',
      email: 'vikas.s@digicoders.in',
      phone: '+91 9543210987',
      joiningDate: '12 Mar 2026',
      technology: 'UI/UX',
      college: 'Amity Lucknow',
      address: 'Mahanagar, Lucknow, UP',
      status: 'Active',
      qrCode: 'INT2026005',
      barcode: 'INT2026005',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  final List<ActivityLogModel> _logs = [
    ActivityLogModel(
      id: 'l1',
      title: 'System Initialized',
      description: 'DigiCoders Intern Digital ID System initialized with sample interns.',
      actionType: 'add',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    )
  ];

  String _searchQuery = '';
  String _selectedTechnology = 'All';
  String _selectedStatus = 'All';
  bool _isDarkMode = false;

  // Getters
  List<InternModel> get allInterns => List.unmodifiable(_interns);
  List<ActivityLogModel> get activityLogs => List.unmodifiable(_logs);
  String get searchQuery => _searchQuery;
  String get selectedTechnology => _selectedTechnology;
  String get selectedStatus => _selectedStatus;
  bool get isDarkMode => _isDarkMode;

  // Statistics
  int get totalInternsCount => _interns.length;
  int get activeInternsCount => _interns.where((i) => i.status == 'Active').length;
  int get completedInternsCount => _interns.where((i) => i.status == 'Completed').length;
  int get technologiesCount => _interns.map((i) => i.technology).toSet().length;

  // Recent Joined Interns (Top 5 sorted by creation)
  List<InternModel> get recentInterns {
    final sorted = List<InternModel>.from(_interns)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(5).toList();
  }

  // Filtered Interns list
  List<InternModel> get filteredInterns {
    return _interns.where((intern) {
      // Tech filter
      final matchesTech = _selectedTechnology == 'All' ||
          intern.technology.toLowerCase() == _selectedTechnology.toLowerCase();

      // Status filter
      final matchesStatus = _selectedStatus == 'All' ||
          intern.status.toLowerCase() == _selectedStatus.toLowerCase();

      // Search query (Name, Intern ID, Tech, Email, Phone)
      final query = _searchQuery.trim().toLowerCase();
      final matchesQuery = query.isEmpty ||
          intern.fullName.toLowerCase().contains(query) ||
          intern.internId.toLowerCase().contains(query) ||
          intern.technology.toLowerCase().contains(query) ||
          intern.email.toLowerCase().contains(query) ||
          intern.phone.toLowerCase().contains(query);

      return matchesTech && matchesStatus && matchesQuery;
    }).toList();
  }

  // Generate next unique Intern ID
  String generateNextInternId() {
    int nextNumber = _interns.length + 1;
    String formattedNum = nextNumber.toString().padLeft(3, '0');
    return 'INT2026$formattedNum';
  }

  // CRUD Actions
  void addIntern(InternModel newIntern) {
    _interns.insert(0, newIntern);
    logActivity(
      'Intern Added',
      'Added new intern ${newIntern.fullName} (${newIntern.internId}) under ${newIntern.technology}',
      'add',
    );
    notifyListeners();
  }

  void updateIntern(InternModel updatedIntern) {
    int index = _interns.indexWhere((i) => i.id == updatedIntern.id);
    if (index != -1) {
      _interns[index] = updatedIntern;
      logActivity(
        'Intern Updated',
        'Updated profile for ${updatedIntern.fullName} (${updatedIntern.internId})',
        'update',
      );
      notifyListeners();
    }
  }

  void deleteIntern(String id) {
    int index = _interns.indexWhere((i) => i.id == id);
    if (index != -1) {
      final removed = _interns[index];
      _interns.removeAt(index);
      logActivity(
        'Intern Removed',
        'Deleted intern record ${removed.fullName} (${removed.internId})',
        'delete',
      );
      notifyListeners();
    }
  }

  InternModel? findByInternIdOrQr(String query) {
    final clean = query.trim().toLowerCase();
    for (var intern in _interns) {
      if (intern.internId.toLowerCase() == clean ||
          intern.qrCode.toLowerCase() == clean ||
          intern.barcode.toLowerCase() == clean) {
        return intern;
      }
    }
    return null;
  }

  // Search & Filter controls
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setTechnologyFilter(String tech) {
    _selectedTechnology = tech;
    notifyListeners();
  }

  void setStatusFilter(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void logActivity(String title, String description, String actionType) {
    _logs.insert(
      0,
      ActivityLogModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        actionType: actionType,
      ),
    );
  }

  // Export Intern List to CSV Format
  String generateCsvData() {
    StringBuffer csv = StringBuffer();
    csv.writeln('Intern ID,Full Name,Technology,Status,Joining Date,Email,Phone,College,Address');
    for (var intern in _interns) {
      csv.writeln(
        '"${intern.internId}","${intern.fullName}","${intern.technology}","${intern.status}","${intern.joiningDate}","${intern.email}","${intern.phone}","${intern.college}","${intern.address}"',
      );
    }
    logActivity(
      'Exported Data',
      'Exported ${totalInternsCount} intern records to CSV/Excel format',
      'export',
    );
    return csv.toString();
  }
}
