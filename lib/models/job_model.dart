class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String description;
  final String salary;
  final String url;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.salary,
    required this.url,
  });

  // For Firestore
  factory Job.fromMap(Map<String, dynamic> data) {
    return Job(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      company: data['company'] ?? '',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      salary: data['salary'] ?? 'Not disclosed',
      url: data['url'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'description': description,
      'salary': salary,
      'url': url,
    };
  }

  // ✅ This is the method you just asked about
  // For parsing API response (like JSearch)
  factory Job.fromJson(Map<String, dynamic> data) {
    return Job(
      id: data['job_id'] ?? '',
      title: data['job_title'] ?? '',
      company: data['employer_name'] ?? '',
      location: data['job_city'] ?? '',
      description: data['job_description'] ?? '',
      salary: data['job_min_salary'] != null && data['job_max_salary'] != null
          ? "\$${data['job_min_salary']} - \$${data['job_max_salary']}"
          : "Not disclosed",
      url: data['job_apply_link'] ?? '',
    );
  }
}
