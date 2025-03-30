import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../services/salary_api.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String fullName = '';
  String email = '';
  String phoneNumber = '';
  String role = '';
  String bio = '';
  List<String> skills = [];
  String experience = '';
  double? minSalary;
  double? maxSalary;

  final TextEditingController _bioController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _db.collection('users').doc(user.uid).get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          fullName = data['fullName'] ?? '';
          email = data['email'] ?? '';
          phoneNumber = data['phoneNumber'] ?? '';
          role = data['role'] ?? '';
          bio = data['bio'] ?? '';
          skills = List<String>.from(data['skills'] ?? []);
          experience = data['experience'] ?? '';
          _bioController.text = bio;
        });
        _fetchSalaryPrediction();
      }
    }
  }

  Future<void> _updateBio() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _db.collection('users').doc(user.uid).update({
        'bio': _bioController.text,
      });
      setState(() {
        bio = _bioController.text;
        _isEditing = false;
      });
    }
  }

  Future<void> _uploadAndParseResume() async {
    final input = html.FileUploadInputElement();
    input.accept = '.pdf';
    input.click();

    input.onChange.listen((event) async {
      final file = input.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);

        reader.onLoadEnd.listen((_) async {
          try {
            final Uint8List bytes = reader.result as Uint8List;
            final PdfDocument document = PdfDocument(inputBytes: bytes);
            final String text = PdfTextExtractor(document).extractText();
            document.dispose();

            final extractedSkills = _extractSkills(text);
            final extractedExperience = _extractExperience(text);

            final user = _auth.currentUser;
            if (user != null) {
              await _db.collection('users').doc(user.uid).update({
                'skills': extractedSkills,
                'experience': extractedExperience,
              });
              _loadUserProfile();
            }
          } catch (e) {
            print("Resume parsing error: $e");
          }
        });
      }
    });
  }

  List<String> _extractSkills(String text) {
    final keywords = [
      'Flutter',
      'Firebase',
      'Python',
      'Java',
      'SQL',
      'Dart',
      'Machine Learning',
      'Data Science',
      'React',
      'Node.js'
    ];
    return keywords
        .where((word) =>
            text.contains(RegExp(r'\b' + word + r'\b', caseSensitive: false)))
        .toList();
  }

  String _extractExperience(String text) {
    final match = RegExp(r'(\d+)\+?\s+(years|yrs)').firstMatch(text);
    return match != null ? '${match.group(1)} years' : 'Not mentioned';
  }

  Future<void> _fetchSalaryPrediction() async {
    if (skills.isEmpty) return;
    final prediction = await SalaryApiService().fetchSalary(
      jobTitle: skills.first,
      location: 'New York',
    );
    if (prediction != null) {
      setState(() {
        minSalary =
            double.tryParse(prediction['min_salary']?.toString() ?? '0');
        maxSalary =
            double.tryParse(prediction['max_salary']?.toString() ?? '0');
      });
    }
  }

  Widget _buildSalaryChart() {
    if (minSalary == null || maxSalary == null) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Estimated Salary Range",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: [
            Text("Min: \$${minSalary?.toStringAsFixed(0)}",
                style: TextStyle(fontSize: 16)),
            SizedBox(width: 20),
            Text("Max: \$${maxSalary?.toStringAsFixed(0)}",
                style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 12),
        LinearProgressIndicator(
          value: minSalary != null && maxSalary != null && maxSalary! > 0
              ? minSalary! / maxSalary!
              : 0,
          minHeight: 8,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadUserProfile,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: $fullName', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Email: $email', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Phone: $phoneNumber', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Role: ${role == 'recruiter' ? 'Recruiter' : 'Job Seeker'}',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              _isEditing
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _bioController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Edit Bio',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: _updateBio,
                              child: Text('Save'),
                            ),
                            SizedBox(width: 8),
                            TextButton(
                              onPressed: () =>
                                  setState(() => _isEditing = false),
                              child: Text('Cancel'),
                            )
                          ],
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bio:', style: TextStyle(fontSize: 18)),
                        SizedBox(height: 4),
                        Text(bio.isNotEmpty ? bio : 'No bio added.',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        TextButton(
                          onPressed: () => setState(() => _isEditing = true),
                          child: Text('Edit Bio'),
                        )
                      ],
                    ),
              SizedBox(height: 16),
              Text('Skills:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(skills.isNotEmpty ? skills.join(', ') : 'No skills found.',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              Text('Experience:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(experience.isNotEmpty ? experience : 'No experience data.',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _uploadAndParseResume,
                icon: Icon(Icons.upload_file),
                label: Text("Upload Resume to Parse"),
              ),
              SizedBox(height: 20),
              _buildSalaryChart(),
            ],
          ),
        ),
      ),
    );
  }
}
