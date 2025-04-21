class Users {
  final String userId;
  final String firstName;
  final String lastName;
  final String course;
  final String collegeId;
  final String role;

  Users({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.course,
    required this.collegeId,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'],
      collegeId: json['collegeId'],
      course: json['course'],
    );
  }
}
