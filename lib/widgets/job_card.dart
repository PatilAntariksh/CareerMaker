import 'package:flutter/material.dart';
import '../models/job_model.dart';
import '../screens/job_detail.dart';

class JobCard extends StatelessWidget {
  final Job job;
  const JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(job.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(job.company),
        trailing: Icon(Icons.arrow_forward_ios_rounded),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => JobDetailScreen(job: job)),
          );
        },
      ),
    );
  }
}