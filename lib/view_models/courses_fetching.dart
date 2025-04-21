import 'dart:developer';

import 'package:inturn/models/courses.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoursesFetching {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Courses>> fetchCourses(String collegeId) async {
    final response =
        await supabase.from("courses").select().eq('collegeId', collegeId);

    return (response as List).map((course) {
      return Courses.fromJson(course as Map<String, dynamic>);
    }).toList();
  }

  Future<Courses?> fetchCourse(String collegeId, String courseId) async {
    try {
      final response = await supabase
          .from('courses')
          .select()
          .eq('id', courseId)
          .eq('collegeId', collegeId)
          .single();
      return Courses.fromJson(response);
    } catch (e) {
      log("$e");
      return null;
    }
  }
}
