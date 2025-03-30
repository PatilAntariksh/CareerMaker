class Job {
  final String title;
  final String company;
  final String salary;
  final String description;

  Job({
    required this.title,
    required this.company,
    required this.salary,
    required this.description,
  });

  factory Job.fromMap(Map<String, dynamic> data) {
    return Job(
      title: data['title'] ?? '',
      company: data['company'] ?? '',
      salary: data['salary'] ?? '0',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'company': company,
      'salary': salary,
      'description': description,
    };
  }
}
