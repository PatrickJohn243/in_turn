import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/models/adminCompanies.dart';
import 'package:inturn/models/colleges.dart';
import 'package:inturn/models/companies.dart';
import 'package:inturn/models/courses.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:inturn/view_models/college_fetching.dart';
import 'package:inturn/view_models/courses_fetching.dart';
import 'package:inturn/view_models/insert_company.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class EditCompany extends StatefulWidget {
  final Companies company;
  const EditCompany({super.key, required this.company});

  @override
  _EditCompanyState createState() => _EditCompanyState();
}

class _EditCompanyState extends State<EditCompany> {
  // Controllers for all text fields
  late TextEditingController companyNameController;
  late TextEditingController websiteController;
  late TextEditingController locationController;
  late TextEditingController addressController;

  late TextEditingController contactPerson1Controller;
  late TextEditingController contactPerson2Controller;
  late TextEditingController contactDetailsController;
  late TextEditingController designationController;

  late TextEditingController descriptionController;
  late TextEditingController fieldSpecializationController;

  final supabase = Supabase.instance.client;
  User? user;

  //Internship selection
  String? selectedMode;
  final List<String> internshipModes = ['Remote', 'F2F', 'Blended'];

  //College selection
  List<Colleges> collegeList = [];
  Colleges? college;
  Colleges? selectedCollege;
  bool _isLoadingColleges = true;

  // Course selection
  List<Courses> _courses = [];
  Set<String> _selectedCourseNames = {};
  bool _isLoadingCourses = true;
  bool _isLoading = false;

  String? _companyImageUrl;
  File? companyImg;
  FilePickerResult? selectedImage;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    companyNameController =
        TextEditingController(text: widget.company.companyName);
    websiteController = TextEditingController(text: widget.company.website);
    locationController = TextEditingController(text: widget.company.location);
    addressController = TextEditingController(text: widget.company.address);

    contactPerson1Controller =
        TextEditingController(text: widget.company.contactPerson);
    contactPerson2Controller =
        TextEditingController(text: widget.company.contactPerson2);
    contactDetailsController =
        TextEditingController(text: widget.company.contactDetails);
    designationController =
        TextEditingController(text: widget.company.designation);

    descriptionController =
        TextEditingController(text: widget.company.description);
    fieldSpecializationController =
        TextEditingController(text: widget.company.fieldSpecialization);

    _initializeData();
  }

  Future<void> _initializeData() async {
    user = supabase.auth.currentUser;
    selectedMode = widget.company.mode;
    _companyImageUrl = widget.company.companyImage;

    _selectedCourseNames = Set<String>.from(widget.company.applicableCourse);

    try {
      await fetchColleges();
      await fetchInitialCollege();
      if (selectedCollege != null) {
        await fetchCourses(selectedCollege!.id);
      }
    } catch (e) {
      log('Error initializing data: $e');
    }
  }

  @override
  void dispose() {
    companyNameController.dispose();
    websiteController.dispose();
    locationController.dispose();
    addressController.dispose();
    contactPerson1Controller.dispose();
    contactDetailsController.dispose();
    designationController.dispose();
    contactPerson2Controller.dispose();
    descriptionController.dispose();
    fieldSpecializationController.dispose();
    super.dispose();
  }

  Future<void> fetchColleges() async {
    setState(() {
      _isLoadingColleges = true;
    });

    try {
      final response = await CollegeFetching().fetchColleges();
      setState(() {
        collegeList = response;
        _isLoadingColleges = false;
      });
      return;
    } catch (e) {
      log('Error fetching colleges: $e');
      setState(() {
        _isLoadingColleges = false;
      });
    }
  }

  Future<void> fetchInitialCollege() async {
    try {
      final response =
          await CollegeFetching().fetchCollegeById(widget.company.collegeId);

      setState(() {
        selectedCollege = collegeList.firstWhere(
            (college) => college.id == response.id,
            orElse: () => response);
      });
    } catch (e) {
      log('Error fetching initial college: $e');
    }
  }

  //fetch individual college
  Future<void> fetchCollege(String collegeName) async {
    final response = await CollegeFetching().fetchCollegeByName(collegeName);
    setState(() {
      college = response;
    });
  }

  Future<void> fetchCourses(String collegeId) async {
    try {
      setState(() {
        _isLoadingCourses = true;
      });
      final response = await CoursesFetching().fetchCourses(collegeId);

      setState(() {
        _courses = response;
        _isLoadingCourses = false;
      });
    } catch (e) {
      log('Error fetching courses: $e');
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

  Future<void> fetchImage() async {
    try {
      setState(() {
        _isUploadingImage = true;
      });

      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      final pickedFile = result?.files.first;
      final filePath = pickedFile?.path;

      setState(() {
        //set display img
        selectedImage = result;
        companyImg = File(filePath!);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select an image'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  Future<void> addCompanyToAdmin(AdminCompanies company) async {
    try {
      await InsertCompany().addCompanyToAdmin(company);
    } catch (e) {
      throw Exception('Error adding company: $e');
    }
  }

  Future<void> uploadImage(FilePickerResult result) async {
    if (user == null) throw Exception("User not authenticated");

    if (result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      final bytes = pickedFile.bytes;
      if (bytes == null) throw Exception("File is empty");

      final storageRef = supabase.storage.from('images');

      final fileName = (_companyImageUrl != null &&
              _companyImageUrl!.isNotEmpty)
          ? _companyImageUrl! // Edit mode: overwrite existing image
          : '${user!.id}/${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}'; // New upload

      final response = await storageRef.uploadBinary(
        fileName,
        bytes,
        fileOptions: const FileOptions(upsert: true),
      );

      if (response.isEmpty) throw Exception("Upload failed");

      setState(() {
        _companyImageUrl = fileName;
      });
    }
  }

  Future<void> updateCompany() async {
    await fetchCollege(selectedCollege!.college);

    if (companyNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Company name is required')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    if (selectedImage != null) {
      try {
        await uploadImage(selectedImage!);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading image: $e')),
          );
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }
    }

    try {
      final applicableCourses = _selectedCourseNames.toList();
      log(applicableCourses.length.toString());
      await supabase
          .from('companies')
          .update({
            'companyName': companyNameController.text,
            'companyImage': _companyImageUrl,
            'website': websiteController.text,
            'location': locationController.text,
            'address': addressController.text,
            'mode': selectedMode,
            'contactPerson': contactPerson1Controller.text,
            'contactPerson2': contactPerson2Controller.text,
            'contactDetails': contactDetailsController.text,
            'designation': designationController.text,
            'collegeId': college!.id,
            'applicableCourses': applicableCourses,
            'updated_at': DateTime.now().toIso8601String(),
            'created_at': DateTime.now().toIso8601String(),
            'description': descriptionController.text,
            'fieldSpecialization': fieldSpecializationController.text,
          })
          .eq('companyId', widget.company.companyId)
          .maybeSingle();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Company updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating company: $e')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Edit Company",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: updateCompany,
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
                            onTap: _isUploadingImage ? null : fetchImage,
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
                                          if (companyImg != null)
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.file(
                                                companyImg!,
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          else if (_companyImageUrl != null &&
                                              _companyImageUrl!.isNotEmpty)
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                supabase.storage
                                                    .from('images')
                                                    .getPublicUrl(
                                                        _companyImageUrl!),
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Icon(
                                                    Icons.image_not_supported,
                                                    size: 40,
                                                  );
                                                },
                                              ),
                                            )
                                          else
                                            const Icon(
                                              Icons.add_a_photo_rounded,
                                              size: 40,
                                            ),
                                          const SizedBox(height: 12),
                                          Text(
                                            companyImg != null ||
                                                    (_companyImageUrl != null &&
                                                        _companyImageUrl!
                                                            .isNotEmpty)
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
                          maxLines: 3,
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
                          maxLines: 3,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Internship Mode",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: internshipModes.map((mode) {
                                return FilterChip(
                                  label: Text(mode),
                                  selected: selectedMode == mode,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedMode = mode;
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
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "College",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _isLoadingColleges
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: collegeList.map((college) {
                                      return FilterChip(
                                        label: Text(college.college),
                                        selected:
                                            selectedCollege?.id == college.id,
                                        onSelected: (bool selected) {
                                          setState(() {
                                            if (selected) {
                                              selectedCollege = college;
                                              fetchCourses(college.id);
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
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Courses Applicable",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (_isLoadingCourses)
                              const Center(child: CircularProgressIndicator())
                            else if (_courses.isEmpty)
                              const Text("Select a college department")
                            else
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: _courses.map((course) {
                                  return FilterChip(
                                    label: Text(course.courseName),
                                    selected: _selectedCourseNames
                                        .contains(course.courseName),
                                    onSelected: (bool selected) {
                                      setState(() {
                                        if (selected) {
                                          _selectedCourseNames
                                              .add(course.courseName);
                                        } else {
                                          _selectedCourseNames
                                              .remove(course.courseName);
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
                          minLines: 1,
                          maxLines: 8,
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
