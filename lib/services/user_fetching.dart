import 'package:inturn/view_models/colleges.dart';
import 'package:inturn/view_models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserFetching {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Users>> fetchAllUsers() async {
    final response = await supabase.from('users').select();

    return response
        .map((user) => Users(
              email: user['email'],
              firstName: user['firstName'],
              lastName: user['lastName'],
              role: user['role'],
              // colleges: user['colleges'],
              course: user['course'],
              yearSection: user['yearSection'],
            ))
        .toList();
  }
}

class CollegeFetching {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Colleges>> fetchAllColleges() async {
    final response = await _client.from('colleges').select();

    return response
        .map((college) => Colleges(
              id: college['id'],
              college: college['college'],
              description: college['description'],
            ))
        .toList();
  }
}
