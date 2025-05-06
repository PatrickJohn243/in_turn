import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:inturn/models/companies.dart';
import 'package:inturn/view_models/save_company.dart';

class FavoritesProvider extends ChangeNotifier {
  List<Companies> savedCompanies = [];

  // List<Companies> get _savedCompanies => savedCompanies;

  void setInitialFavorites(List<Companies> companies) {
    savedCompanies = companies;
    // log(companies.length.toString());
    notifyListeners();
  }

  Future<void> toggleFavorite(Companies company, bool isFavorite) async {
    if (!isFavorite) {
      // Remove from favorites
      savedCompanies.removeWhere((c) => c.companyId == company.companyId);
      await SaveCompany().removeFromSaves(company.companyId);
    } else {
      // Add to favorites if not already there
      if (!savedCompanies.any((c) => c.companyId == company.companyId)) {
        savedCompanies.add(company);
      }
      await SaveCompany().addToSaves(company.companyId);
    }
    notifyListeners();
  }

  bool isFavorite(String companyId) {
    return savedCompanies.any((company) => company.companyId == companyId);
  }
}
