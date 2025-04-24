class SavedCompanies {
  final String companyId;
  final String userId;

  SavedCompanies({
    required this.companyId,
    required this.userId,
  });
  factory SavedCompanies.fromJson(Map<String, dynamic> json) {
    return SavedCompanies(
      companyId: json["companyId"],
      userId: json["userId"],
    );
  }
}
