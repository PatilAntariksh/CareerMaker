import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job_model.dart';

class JobApiService {
  static const String apiKey =
      '3eafc73572mshb87d5eabc2d041bp14ff39jsn3b03fb55a688';
  static const String apiUrl = 'https://jsearch.p.rapidapi.com/search';

  Future<List<Job>> fetchJobs({String query = 'Software Engineer'}) async {
    final response = await http.get(
      Uri.parse('$apiUrl?query=$query&num_pages=1'),
      headers: {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': 'jsearch.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List jobs = jsonData['data'];
      return jobs.map((job) => Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to fetch jobs');
    }
  }
}
