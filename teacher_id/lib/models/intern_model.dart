class InternModel {
  final String id;
  final String fullName;
  final String internId;
  final String image;
  final String email;
  final String phone;
  final String joiningDate;
  final String technology;
  final String college;
  final String address;
  final String status; // 'Active' or 'Completed'
  final String qrCode;
  final String barcode;
  final DateTime createdAt;

  InternModel({
    required this.id,
    required this.fullName,
    required this.internId,
    required this.image,
    required this.email,
    required this.phone,
    required this.joiningDate,
    required this.technology,
    required this.college,
    required this.address,
    this.status = 'Active',
    required this.qrCode,
    required this.barcode,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'internId': internId,
      'image': image,
      'email': email,
      'phone': phone,
      'joiningDate': joiningDate,
      'technology': technology,
      'college': college,
      'address': address,
      'status': status,
      'qrCode': qrCode,
      'barcode': barcode,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory InternModel.fromMap(Map<String, dynamic> map) {
    return InternModel(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      internId: map['internId'] ?? '',
      image: map['image'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      joiningDate: map['joiningDate'] ?? '',
      technology: map['technology'] ?? '',
      college: map['college'] ?? '',
      address: map['address'] ?? '',
      status: map['status'] ?? 'Active',
      qrCode: map['qrCode'] ?? map['internId'] ?? '',
      barcode: map['barcode'] ?? map['internId'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  InternModel copyWith({
    String? id,
    String? fullName,
    String? internId,
    String? image,
    String? email,
    String? phone,
    String? joiningDate,
    String? technology,
    String? college,
    String? address,
    String? status,
    String? qrCode,
    String? barcode,
    DateTime? createdAt,
  }) {
    return InternModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      internId: internId ?? this.internId,
      image: image ?? this.image,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      joiningDate: joiningDate ?? this.joiningDate,
      technology: technology ?? this.technology,
      college: college ?? this.college,
      address: address ?? this.address,
      status: status ?? this.status,
      qrCode: qrCode ?? this.qrCode,
      barcode: barcode ?? this.barcode,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
