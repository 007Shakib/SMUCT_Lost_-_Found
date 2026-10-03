import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

/// Login Screen (UC-02 / FR-02)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'mahin.241071018@shanto-mariam.edu.bd');
  final _passwordController = TextEditingController(text: 'password123');
  final _authService = AuthService();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    final user = await _authService.loginWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (user != null && mounted) {
      if (user.role == 'Admin') {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        Navigator.pushReplacementNamed(context, '/home-feed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.search_off_rounded, size: 64, color: Color(0xFF0284C7)),
              const SizedBox(height: 16),
              const Text(
                'SMUCT Lost & Found',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Campus Belongings Recovery Portal',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading ? const CircularProgressIndicator() : const Text('Sign In'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  _emailController.text = 'admin@shanto-mariam.edu.bd';
                  _handleLogin();
                },
                child: const Text('Simulate Admin Login'),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text('New user? Register here (UC-01)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
