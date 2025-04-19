import 'package:inturn/models/colleges.dart';

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
}
