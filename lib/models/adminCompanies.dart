class AdminCompanies {
  final String adminId;
  final String companyId;

  AdminCompanies({
    required this.adminId,
    required this.companyId,
  });

  factory AdminCompanies.fromJson(Map<String, dynamic> json) {
    return AdminCompanies(
      adminId: json['adminId'] ?? '',
      companyId: json['companyId'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'adminId': adminId,
      'companyId': companyId,
    };
  }
}
