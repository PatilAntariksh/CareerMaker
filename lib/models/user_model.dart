class AppUser {
  final String email;
  final String fullName;
  final String phoneNumber;
  final String bio;
  final String role;

  AppUser({
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.bio,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
    
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'role': role,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      bio: map['bio'] ?? '',
      role: map['role'] ?? '',
    );
  }
}
