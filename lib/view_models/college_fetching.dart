import 'dart:developer';

import 'package:inturn/models/colleges.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CollegeFetching {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Colleges>> fetchColleges() async {
    final response = await supabase.from("colleges").select();

    return (response as List).map((college) {
      return Colleges(
        id: college['id'],
        college: college['college'],
        description: college['description'],
      );
    }).toList();
  }

  Future<Colleges> fetchCollege(String collegeId) async {
    final response = await supabase
        .from("colleges")
        .select()
        .eq("id", collegeId)
        .maybeSingle();
    log(response.toString());
    if (response == null) {
      throw Exception("College not found");
    }

    return Colleges(
      id: response['id'],
      college: response['college'],
      description: response['description'],
    );
  }
}
