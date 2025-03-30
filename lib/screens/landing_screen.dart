import 'package:flutter/material.dart';
import 'package:my_app/screens/gpt_screen.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/profile_screen.dart';
import '../services/auth_services.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // ✅ Proper back icon
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("CareerGPT Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), // ✅ Clear logout icon
            tooltip: 'Logout',
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false); // ✅ Back to login
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 20),
          _buildCardButton(
            context,
            icon: Icons.work_outline,
            label: 'Explore Jobs',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  HomeScreen())),
          ),
          const SizedBox(height: 16),
          _buildCardButton(
            context,
            icon: Icons.chat_bubble_outline,
            label: 'Ask CareerGPT',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatGPTScreen())),
          ),
          const SizedBox(height: 16),
          _buildCardButton(
            context,
            icon: Icons.person_outline,
            label: 'My Profile',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildCardButton(BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 28, color: Colors.indigo),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
