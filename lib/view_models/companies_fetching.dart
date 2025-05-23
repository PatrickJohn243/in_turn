import 'dart:convert';
import 'dart:developer';
import 'package:inturn/models/adminCompanies.dart';
import 'package:inturn/models/companies.dart';
import 'package:inturn/models/courses.dart';
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

  Future<List<Companies>> fetchCompaniesByCourse(List<String> courses) async {
    try {
      final response = await supabase
          .from('companies')
          .select()
          .overlaps('applicableCourses', courses);
      return (response as List)
          .map((json) => Companies.fromJson(json))
          .toList();
    } catch (e) {
      log("$e");
      return [];
    }
  }

  Future<List<Companies>> fetchBySearchAndCourse(
      String value, List<Courses> coursesSelected) async {
    final coursesName =
        coursesSelected.map((course) => course.courseName).toList();
    // log("Fetching Companies From: $coursesName");
    try {
      var query = supabase.from('companies').select();

      if (value.isNotEmpty || value == '') {
        // log("search by query");
        query = query.ilike('companyName', '%$value%');
      }
      if (coursesSelected.isNotEmpty) {
        // log("Search by courses");
        query = query.overlaps('applicableCourses', coursesName);
      }
      final response = await query;
      return (response as List)
          .map((json) => Companies.fromJson(json))
          .toList();
    } catch (e) {
      log("$e");
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

  // Future<List<AdminCompanies>> fetchAdminCreatedCompanies(
  //     String adminId) async {
  //   try {
  //     final response = await supabase
  //         .from("companiesByAdmin")
  //         .select()
  //         .eq('adminId', adminId);
  //     return (response as List<dynamic>)
  //         .map((company) =>
  //             AdminCompanies.fromJson(company as Map<String, dynamic>))
  //         .toList();
  //   } catch (e) {
  //     throw Exception("$e");
  //   }
  // }
  Future<List<Companies>> fetchAdminCreatedCompanies(String adminId) async {
    try {
      final response = await supabase
          .from("companiesByAdmin")
          .select()
          .eq('adminId', adminId);

      final companyIds = (response as List).map((e) => e['companyId']).toList();
      // log(companyIds.length.toString());
      List<Companies> adminCompanies = [];
      for (var id in companyIds) {
        final companies = await fetchCompaniesByCompanyId(id);
        adminCompanies.addAll(companies);
      }
      return adminCompanies;
    } catch (e) {
      throw Exception("$e");
    }
  }
}
