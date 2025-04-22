class Companies {
  final String companyId;
  final String companyName;
  final String companyImage;
  final String website;
  final String location;
  final String contactPerson;
  final String designation;
  final String contactPerson2;
  final String contactDetails;
  final String mode;
  final String moaDuration;
  final String address;
  final String collegeId;
  final List<String> applicableCourse;
  final String description;
  final String fieldSpecialization;

  Companies({
    required this.companyId,
    required this.companyName,
    required this.companyImage,
    required this.website,
    required this.location,
    required this.contactPerson,
    required this.designation,
    required this.contactPerson2,
    required this.contactDetails,
    required this.mode,
    required this.moaDuration,
    required this.address,
    required this.collegeId,
    required this.applicableCourse,
    required this.description,
    required this.fieldSpecialization,
  });

  factory Companies.fromJson(Map<String, dynamic> json) {
    return Companies(
      companyId: json['companyId'],
      companyName: json['companyName'],
      companyImage: json['companyImage'] ?? '',
      website: json['website'],
      location: json['location'],
      contactPerson: json['contactPerson'],
      designation: json['designation'],
      contactPerson2: json['contactPerson2'],
      contactDetails: json['contactDetails'],
      mode: json['mode'],
      moaDuration: json['moaDuration'],
      address: json['address'],
      collegeId: json['collegeId'],
      applicableCourse: List<String>.from(json['applicableCourses'] ?? []),
      description: json['description'],
      fieldSpecialization: json['fieldSpecialization'],
    );
  }
}
