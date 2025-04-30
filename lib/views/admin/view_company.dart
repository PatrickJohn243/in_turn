import 'package:flutter/material.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:inturn/components/company_item.dart';
import 'package:inturn/models/companies.dart';

class ViewCompanyPage extends StatefulWidget {
  const ViewCompanyPage({super.key});

  @override
  State<ViewCompanyPage> createState() => _ViewCompanyPageState();
}

class _ViewCompanyPageState extends State<ViewCompanyPage> {
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
