import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/models/users.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:inturn/view_models/companies_fetching.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:inturn/components/company_item.dart';
import 'package:inturn/models/companies.dart';

class ViewCompanyPage extends StatefulWidget {
  final Users? user;
  const ViewCompanyPage({super.key, required this.user});

  @override
  State<ViewCompanyPage> createState() => _ViewCompanyPageState();
}

class _ViewCompanyPageState extends State<ViewCompanyPage> {
  final supabase = Supabase.instance.client;
  List<Companies> companies = [];
  bool isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchAdminCompanies(widget.user!.userId);
  }

  Future<void> fetchAdminCompanies(String userId) async {
    setState(() {
      isLoading = true;
    });
    final fetchedAdminCompanies =
        await CompaniesFetching().fetchAdminCreatedCompanies(userId);
    setState(() {
      companies = fetchedAdminCompanies;
      log(companies.length.toString());
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "View Your Companies",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: $_error',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      // ElevatedButton(
                      //   onPressed: fetchAdminCompanies(widget.user!.userId);,
                      //   child: const Text('Retry'),
                      // ),
                    ],
                  ),
                )
              : companies.isEmpty
                  ? const Center(child: Text('No companies found'))
                  : Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RefreshIndicator(
                        onRefresh: () =>
                            fetchAdminCompanies(widget.user!.userId),
                        child: ListView.builder(
                          itemCount: companies.length,
                          itemBuilder: (context, index) {
                            final company = companies[index];
                            return CompanyItem(
                              company: company,
                            );
                          },
                        ),
                      ),
                    ),
    );
  }
}
