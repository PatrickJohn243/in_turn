import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/components/company_item.dart';
import 'package:inturn/main.dart';
import 'package:inturn/models/companies.dart';
import 'package:inturn/models/savedCompanies.dart';
import 'package:inturn/provider/favorites_provider.dart';
import 'package:inturn/view_models/companies_fetching.dart';
import 'package:provider/provider.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final user = supabase.auth.currentUser;
  List<SavedCompanies> savedCompaniesId = [];
  List<Companies> savedCompanies = [];

  Future<void> fetchSavedCompanies() async {
    List<Companies> companies = [];
    if (user == null) return;

    final savedIds = await CompaniesFetching().fetchSavedCompanies(user!.id);
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
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final savedCompanies = favoritesProvider.savedCompanies;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Your favorites",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
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
        ),
      ),
    );
  }
}
