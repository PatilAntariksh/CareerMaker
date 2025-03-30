import 'package:flutter/material.dart';
import '../widgets/job_card.dart';
import '../services/firestore_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Job Listings")),
      body: FutureBuilder(
        future: FirestoreService().getJobs(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
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
