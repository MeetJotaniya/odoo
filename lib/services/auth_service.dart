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

  // Login user
  Future<bool> login(String email, String password) async {
    try {
      final user = await _databaseService.authenticateUser(email, password);
      if (user != null) {
        _isLoggedIn = true;
        _currentUser = user;
        notifyListeners();
        return true;
      }
      return false;
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
  Future<bool> register(String name, String email, String password, String? location) async {
    try {
      // Check if user already exists
      final existingUser = await _databaseService.getUserByEmail(email);
      if (existingUser != null) {
        return false; // User already exists
      }

      // Create new user
      final user = User(
        name: name,
        email: email,
        password: password,
        location: location,
      );

      final userId = await _databaseService.insertUser(user);
      if (userId > 0) {
        // Auto-login after registration
        final newUser = await _databaseService.getUserById(userId);
        if (newUser != null) {
          _isLoggedIn = true;
          _currentUser = newUser;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  // Google sign-in
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
}
