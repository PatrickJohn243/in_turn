class Colleges {
  final String id;
  final String college;
  final String description;

  Colleges({
    required this.id,
    required this.college,
    required this.description,
  });

  @override
  String toString() {
    return 'Colleges(id: $id, name: $college, description: $description)';
  }
}
