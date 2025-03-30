import 'package:flutter/material.dart';
import '../models/job_model.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailScreen extends StatelessWidget {
  final Job job;
  const JobDetailScreen({required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(job.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.company, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(job.location, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(job.description),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.open_in_new),
              label: Text("Apply Now"),
              onPressed: () => launchUrl(Uri.parse(job.url)),
            )
          ],
        ),
      ),
    );
  }
}