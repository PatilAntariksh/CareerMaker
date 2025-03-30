import 'package:flutter/material.dart';
import '../services/job_api_service.dart';
import '../widgets/job_card.dart';
import '../models/job_model.dart';

class HomeScreen extends StatelessWidget {
  final JobApiService jobApiService = JobApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Explore Jobs")),
      body: FutureBuilder<List<Job>>(
        future: jobApiService.fetchJobs(query: 'Flutter Developer'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: \${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No jobs found."));
          }

          final jobs = snapshot.data!;
          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (_, i) => JobCard(job: jobs[i]),
          );
        },
      ),
    );
  }
}