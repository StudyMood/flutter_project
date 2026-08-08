class ActivityLogModel {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final String actionType; // 'add', 'update', 'delete', 'export'
  final String adminEmail;

  ActivityLogModel({
    required this.id,
    required this.title,
    required this.description,
    DateTime? timestamp,
    required this.actionType,
    this.adminEmail = 'admin@digicoders.com',
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'actionType': actionType,
      'adminEmail': adminEmail,
    };
  }

  factory ActivityLogModel.fromMap(Map<String, dynamic> map) {
    return ActivityLogModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp']) ?? DateTime.now()
          : DateTime.now(),
      actionType: map['actionType'] ?? 'info',
      adminEmail: map['adminEmail'] ?? 'admin@digicoders.com',
    );
  }
}
