import 'package:flutter/material.dart';

class RecruiterCard extends StatelessWidget {
  final String name;
  final String company;
  final String position;

  RecruiterCard({required this.name, required this.company, required this.position});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: Text(name),
        subtitle: Text("$position at $company"),
      ),
    );
  }
}