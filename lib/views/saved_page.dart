import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/components/company_item.dart';
import 'package:inturn/main.dart';
import 'package:inturn/models/companies.dart';
import 'package:inturn/models/savedCompanies.dart';
import 'package:inturn/models/users.dart';
import 'package:inturn/provider/favorites_provider.dart';
import 'package:inturn/view_models/companies_fetching.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SavedPage extends StatefulWidget {
  final Users? user;
  const SavedPage({super.key, required this.user});

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  List<SavedCompanies> savedCompaniesId = [];
  List<Companies> savedCompanies = [];

  Future<void> fetchSavedCompanies() async {
    List<Companies> companies = [];
    if (widget.user == null) return;

    final savedIds =
        await CompaniesFetching().fetchSavedCompanies(widget.user!.userId);
    setState(() {
      savedCompaniesId = savedIds;
    });

    for (var saved in savedCompaniesId) {
      final fetchedList =
          await CompaniesFetching().fetchCompaniesByCompanyId(saved.companyId);
      if (fetchedList.isNotEmpty) {
        setState(() {
          companies.add(fetchedList.first);
        });
      }
    }
    Provider.of<FavoritesProvider>(context, listen: false)
        .setInitialFavorites(companies);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSavedCompanies();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final savedCompanies = favoritesProvider.savedCompanies;
    return SafeArea(
        child: Scaffold(
      body: widget.user != null
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Check your favorites!",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 44),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: savedCompanies
                          .map((company) => CompanyItem(company: company))
                          .toList(),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.lock_outline, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "Log in to save your favorites!",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
    ));
  }
}
