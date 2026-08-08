import 'package:flutter/material.dart';

enum UserRole { admin, intern }

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = true; // Default logged in for fast testing/demo
  UserRole _role = UserRole.admin;
  String _userEmail = 'admin@digicoders.com';
  String _userName = 'DigiCoders Admin';

  bool get isLoggedIn => _isLoggedIn;
  UserRole get role => _role;
  String get userEmail => _userEmail;
  String get userName => _userName;
  bool get isAdmin => _role == UserRole.admin;

  Future<bool> login(String email, String password, {UserRole role = UserRole.admin}) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate auth
    if (email.trim().isNotEmpty && password.trim().isNotEmpty) {
      _isLoggedIn = true;
      _role = role;
      _userEmail = email.trim();
      _userName = role == UserRole.admin ? 'DigiCoders Admin' : 'DigiCoders Intern';
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void switchRole(UserRole newRole) {
    _role = newRole;
    if (_role == UserRole.admin) {
      _userEmail = 'admin@digicoders.com';
      _userName = 'DigiCoders Admin';
    } else {
      _userEmail = 'intern@digicoders.com';
      _userName = 'DigiCoders Intern';
    }
    notifyListeners();
  }
}
