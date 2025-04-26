import 'dart:developer';

import 'package:inturn/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SaveCompany {
  Future<void> addToSaves(String companyId) async {
    final user = supabase.auth.currentUser;
    try {
      final response = await supabase
          .from('savedCompanies')
          .insert({
            'userId': user?.id.toString(),
            'companyId': companyId,
          })
          .select()
          .single();

      // log("Saved: $response");
    } catch (e) {
      log("$e");
    }
  }

  Future<void> removeFromSaves(String companyId) async {
    log(companyId);
    final user = supabase.auth.currentUser;
    try {
      final response = await supabase
          .from("savedCompanies")
          .delete()
          .eq('companyId', companyId)
          .eq('userId', user!.id);
      // log("removed: $response");
    } catch (e) {
      log("$e");
    }
  }
}
