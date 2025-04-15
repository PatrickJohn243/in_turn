import 'package:flutter/material.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddCompany extends StatefulWidget {
  const AddCompany({Key? key}) : super(key: key);

  @override
  _AddCompanyState createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  final _supabase = Supabase.instance.client;
  String? _internshipMode;
  final List<String> internshipModes = ['Virtual', 'F2F', 'Combined'];

  // Course selection
  List<Map<String, dynamic>> _courses = [];
  Set<String> _selectedCourseIds = {};
  bool _isLoadingCourses = true;

  // Controllers for all text fields
  late TextEditingController companyNameController;
  late TextEditingController websiteController;
  late TextEditingController locationController;
  late TextEditingController addressController;
  late TextEditingController moaDurationController;
  late TextEditingController contactPersonController;
  late TextEditingController contactDetailsController;
  late TextEditingController designationController;
  late TextEditingController contactPerson2Controller;

  String? _companyImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    companyNameController = TextEditingController();
    websiteController = TextEditingController();
    locationController = TextEditingController();
    addressController = TextEditingController();
    moaDurationController = TextEditingController();
    contactPersonController = TextEditingController();
    contactDetailsController = TextEditingController();
    designationController = TextEditingController();
    contactPerson2Controller = TextEditingController();
    testConnection(); // Test connection first
    _fetchCourses();
  }

  @override
  void dispose() {
    companyNameController.dispose();
    websiteController.dispose();
    locationController.dispose();
    addressController.dispose();
    moaDurationController.dispose();
    contactPersonController.dispose();
    contactDetailsController.dispose();
    designationController.dispose();
    contactPerson2Controller.dispose();
    super.dispose();
  }

  Future<void> _fetchCourses() async {
    try {
      setState(() {
        _isLoadingCourses = true;
      });

      final response = await _supabase
          .from('courses')
          .select()
          .order('name')
          .timeout(const Duration(seconds: 10));

      if (response == null) {
        throw Exception('No courses found');
      }

      setState(() {
        _courses = List<Map<String, dynamic>>.from(response);
        _isLoadingCourses = false;
      });
    } catch (e) {
      print('Error fetching courses: $e'); // Add debug print
      if (mounted) {
        setState(() {
          _isLoadingCourses = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching courses: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _uploadImage() async {
    // TODO: Implement image upload to Supabase Storage
    // For now, we'll just use a placeholder
    setState(() {
      _companyImageUrl = 'https://via.placeholder.com/150';
    });
  }

  Future<void> _saveCompany() async {
    if (companyNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Company name is required')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _supabase.from('companies').insert({
        'company_name': companyNameController.text,
        'company_image': _companyImageUrl,
        'website': websiteController.text,
        'location': locationController.text,
        'address': addressController.text,
        'mode': _internshipMode,
        'moa_duration': moaDurationController.text,
        'contact_person': contactPersonController.text,
        'contact_details': contactDetailsController.text,
        'designation': designationController.text,
        'contact_person2': contactPerson2Controller.text,
        'course_ids': _selectedCourseIds.toList(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Company added successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding company: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> testConnection() async {
    try {
      debugPrint('Attempting to connect to Supabase...');

      final response = await _supabase
          .from('courses')
          .select()
          .limit(1)
          .timeout(const Duration(seconds: 5));

      if (response != null) {
        debugPrint('✅ Connected to Supabase. Course data received.');
        debugPrint('Response: $response');
      } else {
        debugPrint('❌ No response received from Supabase');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Supabase connection failed: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColors.primary),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Add Company",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.save, color: Colors.white),
                onPressed: _isLoading ? null : _saveCompany,
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _uploadImage,
                              child: Ink(
                                decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.shadow),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white),
                                child: SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo_rounded,
                                        size: 40,
                                        color: _companyImageUrl != null
                                            ? Colors.green
                                            : null,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        _companyImageUrl != null
                                            ? "Image Uploaded"
                                            : "Upload Company Photo",
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 24.0),
                          child: Text(
                            "Company Info",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: TextField(
                            controller: companyNameController,
                            decoration: InputDecoration(
                                hintText: "Enter Company Name",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                labelText: "Company Name"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: TextField(
                            controller: websiteController,
                            decoration: InputDecoration(
                                hintText: "Enter Company Website",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                labelText: "Company Website"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: TextField(
                            controller: locationController,
                            decoration: InputDecoration(
                              hintText: "Enter Company Location",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              labelText: "Company Location",
                            ),
                            minLines: 1,
                            maxLines: 2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: TextField(
                            controller: addressController,
                            decoration: InputDecoration(
                                hintText: "Enter Company Address",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                labelText: "Address"),
                            minLines: 1,
                            maxLines: 2,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Divider(),
                        ),
                        const Text(
                          "Agreement Details",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: DropdownButtonFormField<String>(
                            alignment: Alignment.bottomCenter,
                            value: _internshipMode,
                            decoration: InputDecoration(
                              labelText: "Internship Mode",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  gapPadding: 4),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                            ),
                            items: internshipModes
                                .map((mode) => DropdownMenuItem(
                                      value: mode,
                                      child: Text(mode),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _internshipMode = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: TextField(
                            controller: moaDurationController,
                            decoration: InputDecoration(
                                hintText: "MOA Duration(months)",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                labelText: "Enter duration in months"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Courses",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (_isLoadingCourses)
                                const Center(child: CircularProgressIndicator())
                              else
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: _courses.map((course) {
                                    return FilterChip(
                                      label: Text(course['name']),
                                      selected: _selectedCourseIds
                                          .contains(course['id']),
                                      onSelected: (bool selected) {
                                        setState(() {
                                          if (selected) {
                                            _selectedCourseIds
                                                .add(course['id']);
                                          } else {
                                            _selectedCourseIds
                                                .remove(course['id']);
                                          }
                                        });
                                      },
                                      selectedColor:
                                          Theme.of(context).colorScheme.primary,
                                      checkmarkColor: Colors.white,
                                      labelStyle: TextStyle(
                                        color: _selectedCourseIds
                                                .contains(course['id'])
                                            ? Colors.white
                                            : null,
                                      ),
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Divider(),
                        ),
                        const Text(
                          "Primary Contact",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: TextField(
                            controller: contactPersonController,
                            decoration: InputDecoration(
                                hintText: "Contact Person Name",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                labelText: "Enter Contact Person Name"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: TextField(
                            controller: contactDetailsController,
                            decoration: InputDecoration(
                                hintText: "Contact Details",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                labelText: "Enter Contact Details"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: TextField(
                            controller: designationController,
                            decoration: InputDecoration(
                                hintText: "Designation",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                labelText: "Enter Designation"),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Divider(),
                        ),
                        const Text(
                          "Secondary Contact",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: TextField(
                            controller: contactPerson2Controller,
                            decoration: InputDecoration(
                                hintText: "Contact Person 2",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                labelText: "Enter Contact Person 2 Name"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
