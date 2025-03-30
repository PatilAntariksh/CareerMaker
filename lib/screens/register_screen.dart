import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String role = 'Job Seeker';
  bool isLoading = false;

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        final uid = userCredential.user!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'fullName': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phoneNumber': phoneController.text.trim(),
          'role': role.toLowerCase(),
          'bio': '',
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration successful! Please log in.")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Registration failed')),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 30),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                  validator: (value) => value!.isEmpty ? 'Enter full name' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) => value!.isEmpty ? 'Enter email' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) => value!.isEmpty ? 'Enter phone number' : null,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: role,
                  decoration: InputDecoration(labelText: 'Role'),
                  items: ['Job Seeker', 'Recruiter'].map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => role = value!),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value!.length < 6 ? 'Minimum 6 characters' : null,
                ),
                SizedBox(height: 24),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _registerUser,
                        child: Text("Register"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
