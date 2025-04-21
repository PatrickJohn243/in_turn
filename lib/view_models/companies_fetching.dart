import 'dart:developer';
import 'package:inturn/models/companies.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CompaniesFetching {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Companies>> fetchCompanies() async {
    try {
      final response = await supabase.from("companies").select();
      // log(response.toString());

      return (response as List).map((company) {
        return Companies.fromJson(company);
      }).toList();
    } catch (e) {
      log("Error fetching companies: $e");
      return [];
    }
  }
}
