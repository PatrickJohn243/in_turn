import 'dart:developer';

import 'package:inturn/models/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserFetching {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Users?> fetchUser(String loggedUserId) async {
    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('userId', loggedUserId)
          .maybeSingle();

      // log(response.toString());
      return Users.fromJson(response!);
    } catch (e) {
      log('$e');
      return null;
    }
  }
}
