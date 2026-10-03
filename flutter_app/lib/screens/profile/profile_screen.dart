import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

/// Manage Profile Screen (UC-03 / FR-14)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController(text: 'Md. Mahin Mia');
  final _phoneController = TextEditingController(text: '+880 1712-345678');
  final _authService = AuthService();
  bool _isSaving = false;

  void _handleSaveProfile() async {
    setState(() => _isSaving = true);
    await _authService.updateProfile(
      name: _nameController.text,
      phone: _phoneController.text,
    );
    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile information updated successfully (FR-14)!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile (UC-03 / FR-14)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundColor: Color(0xFF0284C7),
              child: Icon(Icons.person, size: 56, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Mahin Mia',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'mahin.241071018@shanto-mariam.edu.bd',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Contact Phone Number',
                prefixIcon: Icon(Icons.phone_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSaving ? null : _handleSaveProfile,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('Save Profile Changes'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                _authService.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
