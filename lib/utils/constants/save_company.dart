import 'dart:developer';

import 'package:inturn/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SaveCompany {
  Future<void> addToSaves(String companyId) async {
    final user = supabase.auth.currentUser;
    try {
      final response = await supabase.from('savedCompanies').insert(
        {
          'userId': user?.id.toString(),
          'companyId': companyId,
        },
      );
      if (response.error != null) {
        throw Exception('Failed to save company: ${response.error!.message}');
      }
    } catch (e) {
      log("$e");
    }
  }
}
