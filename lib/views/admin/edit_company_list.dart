import 'package:flutter/material.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:inturn/components/company_item.dart';
import 'package:inturn/models/companies.dart';
import 'package:inturn/views/admin/edit_company.dart';

class EditCompanyList extends StatefulWidget {
  const EditCompanyList({super.key});

  @override
  State<EditCompanyList> createState() => _EditCompanyListState();
}

class _EditCompanyListState extends State<EditCompanyList> {
  final _supabase = Supabase.instance.client;
  List<Companies> _companies = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

  Future<void> _fetchCompanies() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final response = await _supabase
          .from('companies')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        _companies =
            (response as List).map((data) => Companies.fromJson(data)).toList();
        _loading = false;
      });
    } catch (error) {
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  void _navigateToEditCompany(Companies company) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => EditCompany(
    //       companyData: company,
    //     ),
    //   ),
    // );
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
      body: _loading
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
                      ElevatedButton(
                        onPressed: _fetchCompanies,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _companies.isEmpty
                  ? const Center(child: Text('No companies found'))
                  : Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RefreshIndicator(
                        onRefresh: _fetchCompanies,
                        child: ListView.builder(
                          itemCount: _companies.length,
                          itemBuilder: (context, index) {
                            final company = _companies[index];
                            return GestureDetector(
                              onTap: () => _navigateToEditCompany(company),
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
