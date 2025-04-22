import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteCompany extends StatefulWidget {
  const DeleteCompany({super.key});

  @override
  State<DeleteCompany> createState() => _DeleteCompanyState();
}

class _DeleteCompanyState extends State<DeleteCompany> {
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

  Future<void> _deleteCompany(String companyId) async {
    try {
      await _supabase.from('companies').delete().eq('id', companyId);
      // Refresh the list after deletion
      _fetchCompanies();
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
        title: const Text('Select Company to Delete'),
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
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _showDeleteConfirmationDialog(
                                company['id'],
                                company['companyName'] ?? 'Unnamed Company',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
