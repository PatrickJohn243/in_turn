import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/components/company_item.dart';
import 'package:inturn/models/companies.dart';
import 'package:inturn/models/users.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:inturn/view_models/companies_fetching.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteCompany extends StatefulWidget {
  final Users? user;
  const DeleteCompany({super.key, required this.user});

  @override
  State<DeleteCompany> createState() => _DeleteCompanyState();
}

class _DeleteCompanyState extends State<DeleteCompany> {
  final _supabase = Supabase.instance.client;
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

      isLoading = false;
    });
  }

  Future<void> _deleteCompany(String companyId) async {
    try {
      await _supabase.from('companies').delete().eq('id', companyId);
      // Refresh the list after deletion
      fetchAdminCompanies(widget.user!.userId);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting company: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmationDialog(String companyId, String companyName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete $companyName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCompany(companyId);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Delete Company",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12),
                child: RefreshIndicator(
                  onRefresh: () => fetchAdminCompanies(widget.user!.userId),
                  child: SingleChildScrollView(
                    child: Column(
                      children: companies
                          .map((company) => CompanyItem(
                                company: company,
                                canDelete: true,
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ));
  }
}
