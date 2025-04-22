import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewCompanyPage extends StatefulWidget {
  const ViewCompanyPage({super.key});

  @override
  State<ViewCompanyPage> createState() => _ViewCompanyPageState();
}

class _ViewCompanyPageState extends State<ViewCompanyPage> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _companies = [];
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
        _companies = List<Map<String, dynamic>>.from(response);
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
        title: const Text('Companies'),
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
                  : RefreshIndicator(
                      onRefresh: _fetchCompanies,
                      child: ListView.builder(
                        itemCount: _companies.length,
                        itemBuilder: (context, index) {
                          final company = _companies[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: company['imageUrl'] != null
                                  ? NetworkImage(company['imageUrl'])
                                  : null,
                              child: company['imageUrl'] == null
                                  ? const Icon(Icons.business, size: 25)
                                  : null,
                            ),
                            title: Text(
                                company['companyName'] ?? 'Unnamed Company'),
                            subtitle: Text(
                              '${company['location'] ?? 'No location'} • ${company['mode'] ?? 'N/A'}',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              // Navigate to a detailed view if you want
                            },
                          );
                        },
                      ),
                    ),
    );
  }
}
