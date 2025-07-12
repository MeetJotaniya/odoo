import 'package:flutter/material.dart';
import 'login_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = LoginController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Skill Swap Platform',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(maxWidth: 400),
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Google Sign-In Button (Primary)
                              Container(
                                width: double.infinity,
                                height: 56,
                                margin: EdgeInsets.only(bottom: 32),
                                child: ElevatedButton(
                                  onPressed: _controller.isLoading ? null : _handleGoogleSignIn,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black87,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: _controller.isLoading
                                      ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                                  )
                                      : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/google_logo.png', // You'll need to add this asset
                                        height: 24,
                                        width: 24,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(Icons.login, size: 24);
                                        },
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Continue with Google',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Divider
                              Row(
                                children: [
                                  Expanded(child: Divider(color: Colors.grey[600])),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      'or',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Divider(color: Colors.grey[600])),
                                ],
                              ),

                              SizedBox(height: 32),

                              // Email Input
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextField(
                                      controller: _controller.emailController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 16,
                                        ),
                                        hintText: 'Enter your email',
                                        hintStyle: TextStyle(color: Colors.grey[400]),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      onChanged: (value) => _controller.clearError(),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 24),

                              // Password Input
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Password',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextField(
                                      controller: _controller.passwordController,
                                      obscureText: _controller.obscurePassword,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 16,
                                        ),
                                        hintText: 'Enter your password',
                                        hintStyle: TextStyle(color: Colors.grey[400]),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _controller.obscurePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.grey[400],
                                          ),
                                          onPressed: _controller.togglePasswordVisibility,
                                        ),
                                      ),
                                      onChanged: (value) => _controller.clearError(),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 32),

                              // Login Button
                              Container(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _controller.isLoading ? null : _handleEmailLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                      side: BorderSide(color: Colors.white, width: 2),
                                    ),
                                  ),
                                  child: _controller.isLoading
                                      ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  )
                                      : Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 16),

                              // Forgot Password
                              TextButton(
                                onPressed: () {
                                  // Handle forgot password
                                  _showForgotPasswordDialog();
                                },
                                child: Text(
                                  'Forgot username/password',
                                  style: TextStyle(
                                    color: Colors.blue[300],
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),

                              // Error Message
                              if (_controller.errorMessage != null)
                                Container(
                                  margin: EdgeInsets.only(top: 16),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    border: Border.all(color: Colors.red),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.error_outline, color: Colors.red, size: 20),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _controller.errorMessage!,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    final success = await _controller.loginWithGoogle();
    if (success) {
      _navigateToHome();
    }
  }

  Future<void> _handleEmailLogin() async {
    final success = await _controller.loginWithEmail();
    if (success) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
    // Or navigate to your home screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login successful!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Forgot Password',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter your email address to receive password reset instructions.',
                style: TextStyle(color: Colors.grey[300]),
              ),
              SizedBox(height: 16),
              TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Email address',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Password reset email sent!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text('Send Reset Email'),
            ),
          ],
        );
      },
    );
  }
}