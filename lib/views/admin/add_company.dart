import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class AddCompany extends StatefulWidget {
  const AddCompany({Key? key}) : super(key: key);

  @override
  _AddCompanyState createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  final _supabase = Supabase.instance.client;
  String? _internshipMode;
  final List<String> internshipModes = ['Remote', 'F2F', 'Blended'];

  // Course selection
  List<Map<String, dynamic>> _courses = [];
  Set<String> _selectedCourseNames = {};
  bool _isLoadingCourses = true;

  // Controllers for all text fields
  late TextEditingController companyNameController;
  late TextEditingController websiteController;
  late TextEditingController locationController;
  late TextEditingController addressController;
  late TextEditingController moaDurationController;

  late TextEditingController contactPerson1Controller;
  late TextEditingController contactPerson2Controller;
  late TextEditingController contactDetailsController;
  late TextEditingController designationController;

  late TextEditingController collegeController;
  late TextEditingController descriptionController;
  late TextEditingController fieldSpecializationController;

  String? _companyImageUrl;
  bool _isLoading = false;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    companyNameController = TextEditingController();
    websiteController = TextEditingController();
    locationController = TextEditingController();
    addressController = TextEditingController();
    moaDurationController = TextEditingController();
    collegeController = TextEditingController();

    contactPerson1Controller = TextEditingController();
    contactPerson2Controller = TextEditingController();
    contactDetailsController = TextEditingController();
    designationController = TextEditingController();

    descriptionController = TextEditingController();
    fieldSpecializationController = TextEditingController();
    testConnection();
    _fetchCourses();
  }

  @override
  void dispose() {
    companyNameController.dispose();
    websiteController.dispose();
    locationController.dispose();
    addressController.dispose();
    moaDurationController.dispose();
    contactPerson1Controller.dispose();
    contactDetailsController.dispose();
    designationController.dispose();
    contactPerson1Controller.dispose();
    contactPerson2Controller.dispose();
    descriptionController.dispose();
    fieldSpecializationController.dispose();
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
          .order('courseName')
          .timeout(const Duration(seconds: 10));

      if (response == null) {
        throw Exception('No courses found');
      }

      setState(() {
        _courses = List<Map<String, dynamic>>.from(response);
        _isLoadingCourses = false;
      });
    } catch (e) {
      print('Error fetching courses: $e');
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

  Future<void> uploadImage() async {
    try {
      setState(() {
        _isUploadingImage = true;
      });

      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception("User not authenticated");

      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final pickedFile = result.files.first;
        final bytes = pickedFile.bytes;
        if (bytes == null) throw Exception("File is empty");

        final userId = user.id;
        final extension = path.extension(pickedFile.name); // e.g. .jpeg
        final fileName = '$userId/user_image$extension';
        final storagePath = fileName;

        final storageRef = _supabase.storage.from('images');

        // Upload the image file
        final response = await storageRef.uploadBinary(
          storagePath,
          bytes,
          fileOptions: const FileOptions(
            upsert: true, // allows overwriting if same filename is used
          ),
        );

        if (response.isEmpty) throw Exception("Upload failed");

        // Get the public URL
        // final imageUrl = storageRef.getPublicUrl(storagePath);

        setState(() {
          _companyImageUrl = fileName;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  Future<void> _saveCompany() async {
    if (companyNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Company name is required')),
      );
      return;
    }

    if (collegeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('College is required')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Convert selected course names to a comma-separated string
      final applicableCourses = _selectedCourseNames.toList();
      await _supabase.from('companies').insert({
        'companyName': companyNameController.text,
        'companyImage': _companyImageUrl,
        'website': websiteController.text,
        'location': locationController.text,
        'address': addressController.text,
        'mode': _internshipMode,
        'moaDuration': moaDurationController.text,
        'contactPerson': contactPerson1Controller.text,
        'contactPerson2': contactPerson2Controller.text,
        'contactDetails': contactDetailsController.text,
        'designation': designationController.text,
        // 'college': collegeController.text,
        'applicableCourses': applicableCourses,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'description': descriptionController.text,
        'fieldSpecialization': fieldSpecializationController.text,
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
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Add Company",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
          : Container(
              color: Colors.white,
              child: Padding(
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
                            onTap: _isUploadingImage ? null : uploadImage,
                            child: Ink(
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.shadow),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white),
                              child: SizedBox(
                                height: 150,
                                width: 150,
                                child: _isUploadingImage
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          if (_companyImageUrl != null)
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                _companyImageUrl!,
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          else
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
                                                ? "Change Image"
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
                          controller: collegeController,
                          decoration: InputDecoration(
                              hintText: "Enter College",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              labelText: "College"),
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
                                    label: Text(course['courseName']),
                                    selected: _selectedCourseNames
                                        .contains(course['courseName']),
                                    onSelected: (bool selected) {
                                      setState(() {
                                        if (selected) {
                                          _selectedCourseNames
                                              .add(course['courseName']);
                                        } else {
                                          _selectedCourseNames
                                              .remove(course['courseName']);
                                        }
                                      });
                                    },
                                    backgroundColor: AppColors.primary,
                                    selectedColor: AppColors.primary,
                                    checkmarkColor: Colors.white,
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
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
                        "Contact Personnel",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: TextField(
                          controller: contactPerson1Controller,
                          decoration: InputDecoration(
                              hintText: "Contact Person 1 Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              labelText: "Enter Contact Person 1 Name"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: TextField(
                          controller: contactPerson2Controller,
                          decoration: InputDecoration(
                              hintText: "Contact Person 2 Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              labelText: "Enter Contact Person 2 Name"),
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
                        "About Company",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                              hintText: "Company Description",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              labelText: "Enter Company Description"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: TextField(
                          controller: fieldSpecializationController,
                          decoration: InputDecoration(
                              hintText: "Field Specialization",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              labelText: "Enter Field Specialization"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
