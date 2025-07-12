import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'database_service.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool _isLoggedIn = false;
  User? _currentUser;
  final DatabaseService _databaseService = DatabaseService();

  bool get isLoggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;
  String? get userEmail => _currentUser?.email;
  String? get userName => _currentUser?.name;

  // Initialize auth state
  Future<void> initialize() async {
    // In a real app, you would check shared preferences or secure storage
    // For now, we'll start with logged out state
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }

  // Check if user is logged in
  bool checkLoginStatus() {
    return _isLoggedIn;
  }

  Future<bool> register(String name, String email, String password, String? location) async {
    try {
      // No checks, always succeed
      final user = User(
        name: name,
        email: email,
        password: password,
        location: location,
      );
      _isLoggedIn = true;
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      // No checks, always succeed
      final user = User(
        name: email.split('@').first,
        email: email,
        password: password,
        location: '',
      );
      _isLoggedIn = true;
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Logout user
  void logout() {
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }

  // Register new user
  Future<bool> loginWithGoogle() async {
    try {
      // For now, simulate Google sign-in
      // In a real app, you would integrate with Google Sign-In API
      await Future.delayed(const Duration(seconds: 1));
      
      // Create or get Google user
      final googleUser = await _databaseService.getUserByEmail('google.user@gmail.com');
      if (googleUser != null) {
        _isLoggedIn = true;
        _currentUser = googleUser;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<User?> getUserByEmail(String email) async {
    return await _databaseService.getUserByEmail(email);
  }

  Future<void> updateCurrentUser(User updatedUser) async {
    _currentUser = updatedUser;
    notifyListeners();
    // If you want to persist to database, add:
    // await _databaseService.updateUser(updatedUser);
  }
}
