import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Register a new user and store details in Firestore
  Future<void> registerUser({
    required BuildContext context,
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String role,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      await _db.collection('users').doc(uid).set({
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'role': role,
        'bio': '',
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful! Please login.')),
      );

      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration failed')),
      );
    }
  }

  // Sign in existing user
  Future<void> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacementNamed(context, '/land');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    }
  }

  // Reset password
  Future<void> resetPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Failed to send reset email')),
      );
    }
  }

  // Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
