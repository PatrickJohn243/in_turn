import 'dart:developer';

import 'package:inturn/models/adminCompanies.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertCompany {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> addCompanyToAdmin(AdminCompanies adminCompanies) async {
    try {
      await supabase.from('companiesByAdmin').insert(adminCompanies.toJson());
    } catch (e) {
      throw Exception('Error adding company: $e');
    }
  }
}
