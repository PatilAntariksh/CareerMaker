import 'dart:convert';
import 'package:http/http.dart' as http;

class SalaryApiService {
  static const String apiKey =
      '3eafc73572mshb87d5eabc2d041bp14ff39jsn3b03fb55a688';
  static const String baseUrl = 'https://job-salary-data.p.rapidapi.com';

  Future<Map<String, dynamic>?> fetchSalary(
      {required String jobTitle, required String location}) async {
    final uri =
        Uri.parse('$baseUrl/job-salary?job_title=$jobTitle&location=$location');

    final response = await http.get(
      uri,
      headers: {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': 'job-salary-data.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Error fetching salary data: ${response.statusCode}");
      return null;
    }
  }
}
