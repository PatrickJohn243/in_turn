import 'package:inturn/models/courses.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoursesFetching {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Courses>> fetchCourses(String collegeId) async {
    final response =
        await supabase.from("courses").select().eq('collegeId', collegeId);

    return (response as List).map((course) {
      return Courses(
        id: course['id'],
        courseName: course['courseName'],
        collegeId: course['collegeId'],
      );
    }).toList();
  }
}
