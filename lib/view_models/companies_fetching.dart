import 'dart:developer';
import 'package:inturn/models/companies.dart';
import 'package:inturn/models/savedCompanies.dart';
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

  Future<List<Companies>> fetchCompaniesByCompanyId(String companyId) async {
    try {
      final response =
          await supabase.from("companies").select().eq('companyId', companyId);
      // log(response.toString());
      return (response as List)
          .map((savedCompany) => Companies.fromJson(savedCompany))
          .toList();
    } catch (e) {
      log("Error fetching saved companies: $e");
      return [];
    }
  }

  Future<List<SavedCompanies>> fetchSavedCompanies(String userId) async {
    try {
      final response =
          await supabase.from("savedCompanies").select().eq('userId', userId);
      // log(response.toString());
      return (response as List)
          .map((savedCompany) => SavedCompanies.fromJson(savedCompany))
          .toList();
    } catch (e) {
      log("Error fetching saved companies: $e");
      return [];
    }
  }
}
