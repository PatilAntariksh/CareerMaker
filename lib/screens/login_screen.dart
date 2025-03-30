import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Login", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              ),
              SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _showForgotPasswordDialog(context);
                  },
                  child: Text("Forgot Password?"),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _authService.signInUser(
                  context: context,
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                ),
                child: Text("Login"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterScreen()),
                ),
                child: Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final TextEditingController resetEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Reset Password"),
        content: TextField(
          controller: resetEmailController,
          decoration: InputDecoration(labelText: "Enter your email"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              _authService.resetPassword(
                context: context,
                email: resetEmailController.text.trim(),
              );
              Navigator.pop(context);
            },
            child: Text("Send Reset Link"),
          ),
        ],
      ),
    );
  }
}
