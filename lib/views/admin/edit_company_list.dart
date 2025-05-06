import 'package:flutter/material.dart';
import 'package:inturn/models/users.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:inturn/view_models/companies_fetching.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:inturn/components/company_item.dart';
import 'package:inturn/models/companies.dart';
import 'package:inturn/views/admin/edit_company.dart';

class EditCompanyList extends StatefulWidget {
  final Users? user;
  const EditCompanyList({super.key, required this.user});

  @override
  State<EditCompanyList> createState() => _EditCompanyListState();
}

class _EditCompanyListState extends State<EditCompanyList> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Edit Companies",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: RefreshIndicator(
                onRefresh: () => fetchAdminCompanies(widget.user!.userId),
                child: ListView.builder(
                  itemCount: companies.length,
                  itemBuilder: (context, index) {
                    final company = companies[index];
                    return GestureDetector(
                      child: CompanyItem(
                        company: company,
                        canEdit: true,
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
