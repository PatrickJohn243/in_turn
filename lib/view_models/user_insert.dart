import 'dart:developer';

import 'package:inturn/models/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserInsert {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> insertUser(Users userData) async {
    final user = supabase.auth.currentUser;

    final response = await supabase.from("users").insert({
      'userId': user?.id,
      'firstName': userData.firstName,
      'lastName': userData.lastName,
      'course': userData.course,
      'role': userData.role,
      'collegeId': userData.collegeId,
    });
    if (response.error != null) {
      throw Exception('Failed to insert user: ${response.error!.message}');
    }

    log('User successfully inserted!');
  }
}
