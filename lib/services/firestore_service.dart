import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Job>> getJobs() async {
    final snapshot = await _db.collection('jobs').get();
    return snapshot.docs.map((doc) => Job.fromMap(doc.data())).toList();
  }

  Future<void> postJob(Job job) async {
    await _db.collection('jobs').add(job.toMap());
  }

  Future<void> deleteJob(String docId) async {
    await _db.collection('jobs').doc(docId).delete();
  }
}