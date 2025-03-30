import 'package:flutter/material.dart';
import '../models/job_model.dart';

class JobDetailScreen extends StatelessWidget {
  final Job job;
  JobDetailScreen({required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(job.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.company, style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Salary: \$${job.salary}"),
            SizedBox(height: 20),
            Text(job.description),
          ],
        ),
      ),
    );
  }
}