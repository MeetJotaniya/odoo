import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool _isLoggedIn = false;
  String? _userEmail;
  String? _userName;

  bool get isLoggedIn => _isLoggedIn;
  String? get userEmail => _userEmail;
  String? get userName => _userName;

  // Initialize auth state
  Future<void> initialize() async {
    // In a real app, you would check shared preferences or secure storage
    // For now, we'll start with logged out state
    _isLoggedIn = false;
    _userEmail = null;
    _userName = null;
    notifyListeners();
  }

  // Check if user is logged in
  bool checkLoginStatus() {
    return _isLoggedIn;
  }

  // Login user
  Future<bool> login(String email, String password) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock authentication logic
      if (email == 'test@example.com' && password == 'password123') {
        _isLoggedIn = true;
        _userEmail = email;
        _userName = 'Test User';
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Logout user
  void logout() {
    _isLoggedIn = false;
    _userEmail = null;
    _userName = null;
    notifyListeners();
  }

  // Google sign-in
  Future<bool> loginWithGoogle() async {
    try {
      // Simulate Google sign-in
      await Future.delayed(const Duration(seconds: 1));

      // Mock Google authentication success
      _isLoggedIn = true;
      _userEmail = 'user@gmail.com';
      _userName = 'Google User';
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
