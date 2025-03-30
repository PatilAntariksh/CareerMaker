import 'package:flutter/material.dart';
import '../models/job_model.dart';
import '../screens/job_detail.dart';

class JobCard extends StatelessWidget {
  final Job job;

  const JobCard({required this.job, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(job.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.company, style: TextStyle(fontSize: 14)),
            SizedBox(height: 4),
            Text("💲 ${job.salary}", style: TextStyle(fontSize: 14, color: Colors.green[700])),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
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
