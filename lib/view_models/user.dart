import 'package:inturn/view_models/colleges.dart';

class Users {
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? role;
  final Colleges? colleges;
  final String? course;
  final String? yearSection;

  Users({
    this.email,
    this.firstName,
    this.lastName,
    this.role,
    this.colleges,
    this.course,
    this.yearSection,
  });
  @override
  String toString() {
    return 'Users(email: $email, firstName: $firstName, lastName: $lastName, role: $role, colleges: $colleges, course: $course, yearSection: $yearSection)';
  }
}
