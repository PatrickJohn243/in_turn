import 'package:flutter/foundation.dart';
import 'package:inturn/models/companies.dart';
import 'package:inturn/view_models/save_company.dart';

class FavoritesProvider extends ChangeNotifier {
  List<Companies> _savedCompanies = [];

  List<Companies> get savedCompanies => _savedCompanies;

  void setInitialFavorites(List<Companies> companies) {
    _savedCompanies = companies;
    notifyListeners();
  }

  Future<void> toggleFavorite(Companies company, bool isFavorite) async {
    if (!isFavorite) {
      // Remove from favorites
      _savedCompanies.removeWhere((c) => c.companyId == company.companyId);
      await SaveCompany().removeFromSaves(company.companyId);
    } else {
      // Add to favorites if not already there
      if (!_savedCompanies.any((c) => c.companyId == company.companyId)) {
        _savedCompanies.add(company);
      }
      await SaveCompany().addToSaves(company.companyId);
    }
    notifyListeners();
  }

  bool isFavorite(String companyId) {
    return _savedCompanies.any((company) => company.companyId == companyId);
  }
}
