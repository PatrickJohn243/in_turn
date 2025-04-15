class Companies {
  final int? id;
  final String? companyId;
  final String? companyName;
  final String? companyImage;
  final String? website;
  final String? location;
  final String? contactPerson;
  final String? designation;
  final String? contactPerson2;
  final String? contactDetails;
  final String? mode;
  final String? moaDuration;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? colleges;
  final String? collegeId;
  final List<String>? courseIds;

  Companies({
    this.id,
    this.companyId,
    this.companyName,
    this.companyImage,
    this.website,
    this.location,
    this.contactPerson,
    this.designation,
    this.contactPerson2,
    this.contactDetails,
    this.mode,
    this.moaDuration,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.colleges,
    this.collegeId,
    this.courseIds,
  });

  @override
  String toString() {
    return 'Companies(id: $id, companyId: $companyId, companyName: $companyName, companyImage: $companyImage, website: $website, location: $location, contactPerson: $contactPerson, designation: $designation, contactPerson2: $contactPerson2, contactDetails: $contactDetails, mode: $mode, moaDuration: $moaDuration, address: $address, createdAt: $createdAt, updatedAt: $updatedAt, colleges: $colleges, collegeId: $collegeId, courseIds: $courseIds)';
  }
}
