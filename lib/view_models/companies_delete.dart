import 'dart:developer';

import 'package:inturn/main.dart';

class CompaniesDelete {
  Future<void> DeleteCompany(String companyId) async {
    log("deleting $companyId");
    try {
      final response =
          await supabase.from("companies").delete().eq('companyId', companyId);
      log("Deleted $response");
    } catch (e) {
      log("Throw exception $e");
    }
  }
}
