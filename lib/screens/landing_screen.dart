import 'package:flutter/material.dart';
import 'gpt_screen.dart';
import 'profile_screen.dart';
import 'home_screen.dart';
import '../services/auth_services.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CareerGPT Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => AuthService().signOut(),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          ListTile(title: Text("Explore Jobs"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()))),
          ListTile(title: Text("Ask CareerGPT"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatGPTScreen()))),
          ListTile(title: Text("My Profile"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()))),
        ],
      ),
    );
  }
}