import 'package:flutter/material.dart';

enum ContactCategory { developer, family, friends, vip, intern, other, work }

class Contact {
  final String id;
  String name;
  String phone;
  String email;
  String company;
  String jobTitle;
  String linkedin;
  ContactCategory category;
  DateTime? birthday;
  String address;
  String notes;
  bool isFavorite;
  int colorIndex;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    this.email = '',
    this.company = '',
    this.jobTitle = '',
    this.linkedin = '',
    this.category = ContactCategory.developer,
    this.birthday,
    this.address = '',
    this.notes = '',
    this.isFavorite = false,
    this.colorIndex = 0,
  });

  // JSON Serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'company': company,
      'jobTitle': jobTitle,
      'linkedin': linkedin,
      'category': category.name,
      'birthday': birthday?.toIso8601String(),
      'address': address,
      'notes': notes,
      'isFavorite': isFavorite,
      'colorIndex': colorIndex,
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    ContactCategory parsedCat = ContactCategory.developer;
    if (json['category'] != null) {
      final catStr = json['category'].toString();
      if (catStr == 'work') {
        parsedCat = ContactCategory.developer;
      } else {
        for (final cat in ContactCategory.values) {
          if (cat.name == catStr) {
            parsedCat = cat;
            break;
          }
        }
      }
    }

    return Contact(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      jobTitle: json['jobTitle']?.toString() ?? '',
      linkedin: json['linkedin']?.toString() ?? '',
      category: parsedCat,
      birthday: json['birthday'] != null ? DateTime.tryParse(json['birthday'].toString()) : null,
      address: json['address']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      isFavorite: json['isFavorite'] == true,
      colorIndex: json['colorIndex'] is int ? json['colorIndex'] as int : 0,
    );
  }

  // URL Launchers Clean Formatting
  String get phoneUriString {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    return 'tel:$cleanPhone';
  }

  String get whatsappUriString {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    return 'https://wa.me/$cleanPhone';
  }

  String get mailtoUriString {
    return 'mailto:$email';
  }

  String get linkedinUriString {
    if (linkedin.trim().isEmpty) return '';
    if (linkedin.startsWith('http://') || linkedin.startsWith('https://')) {
      return linkedin.trim();
    }
    return 'https://www.linkedin.com/in/${linkedin.trim()}';
  }

  // Get Initials from Contact Name (e.g. "Rahul Sharma" -> "RS")
  String get initials {
    if (name.trim().isEmpty) return 'C';
    List<String> parts = name.trim().split(' ');
    if (parts.length >= 2 && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  // Get Display Label for Category
  String get categoryLabel {
    switch (category) {
      case ContactCategory.developer:
        return 'Developer';
      case ContactCategory.work:
        return 'Developer';
      case ContactCategory.family:
        return 'Family';
      case ContactCategory.friends:
        return 'Friends';
      case ContactCategory.vip:
        return 'VIP';
      case ContactCategory.intern:
        return 'Intern';
      case ContactCategory.other:
        return 'Other';
    }
  }

  // Get Category Accent Color
  Color get categoryColor {
    switch (category) {
      case ContactCategory.developer:
        return const Color(0xFF3B82F6); // Blue
      case ContactCategory.work:
        return const Color(0xFF3B82F6); // Blue
      case ContactCategory.family:
        return const Color(0xFF10B981); // Emerald
      case ContactCategory.friends:
        return const Color(0xFFEC4899); // Pink
      case ContactCategory.vip:
        return const Color(0xFFA855F7); // Purple
      case ContactCategory.intern:
        return const Color(0xFFF97316); // Orange
      case ContactCategory.other:
        return const Color(0xFF6B7280); // Gray
    }
  }

  // Get Gradient background for avatar based on colorIndex
  List<Color> get avatarGradient {
    final gradients = [
      [const Color(0xFF6366F1), const Color(0xFFA855F7)], // Indigo Purple
      [const Color(0xFF10B981), const Color(0xFF06B6D4)], // Emerald Cyan
      [const Color(0xFFF59E0B), const Color(0xFFEF4444)], // Amber Red
      [const Color(0xFFEC4899), const Color(0xFF8B5CF6)], // Pink Violet
      [const Color(0xFF3B82F6), const Color(0xFF0284C7)], // Blue Ocean
    ];
    return gradients[colorIndex % gradients.length];
  }

  // Calculate upcoming birthday days
  int? get daysUntilBirthday {
    if (birthday == null) return null;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime nextBday = DateTime(now.year, birthday!.month, birthday!.day);
    if (nextBday.isBefore(today)) {
      nextBday = DateTime(now.year + 1, birthday!.month, birthday!.day);
    }
    return nextBday.difference(today).inDays;
  }
}
