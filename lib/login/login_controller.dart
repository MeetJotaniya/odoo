import 'package:flutter/material.dart';
import 'login_model.dart';

class LoginController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  String? get errorMessage => _errorMessage;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> loginWithEmail() async {
    if (!_validateInputs()) return false;

    _setLoading(true);

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Mock authentication logic
      if (emailController.text == 'test@example.com' &&
          passwordController.text == 'password123') {
        _setLoading(false);
        return true;
      } else {
        _setError('Invalid email or password');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Login failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    _setLoading(true);

    try {
      // Simulate Google sign-in
      await Future.delayed(Duration(seconds: 1));

      // Mock Google authentication success
      final userData = UserModel.fromGoogle({
        'email': 'user@gmail.com',
        'displayName': 'John Doe',
        'id': 'google_123456'
      });

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Google sign-in failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  bool _validateInputs() {
    if (emailController.text.isEmpty) {
      _setError('Please enter your email');
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text)) {
      _setError('Please enter a valid email address');
      return false;
    }

    if (passwordController.text.isEmpty) {
      _setError('Please enter your password');
      return false;
    }

    if (passwordController.text.length < 6) {
      _setError('Password must be at least 6 characters');
      return false;
    }

    return true;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}