class Courses {
  final String id;
  final String courseName;
  final String collegeId;

  Courses({
    required this.id,
    required this.courseName,
    required this.collegeId,
  });

  factory Courses.fromJson(Map<String, dynamic> json) {
    return Courses(
      id: json['id'],
      courseName: json['courseName'],
      collegeId: json['collegeId'],
    );
  }
}
