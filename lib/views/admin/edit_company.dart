import 'package:flutter/material.dart';
import 'package:inturn/utils/constants/app_colors.dart';

class EditCompany extends StatefulWidget {
  final Map<String, dynamic> companyData;

  const EditCompany({
    Key? key,
    required this.companyData,
  }) : super(key: key);

  @override
  _EditCompanyState createState() => _EditCompanyState();
}

class _EditCompanyState extends State<EditCompany> {
  String? _internshipMode;
  final List<String> internshipModes = ['Virtual', 'F2F', 'Combined'];
  late TextEditingController companyNameController;
  late TextEditingController websiteController;
  late TextEditingController locationController;
  late TextEditingController addressController;
  late TextEditingController moaDurationController;
  late TextEditingController primaryContactNameController;
  late TextEditingController primaryContactDetailsController;
  late TextEditingController primaryContactDesignationController;
  late TextEditingController secondaryContactNameController;

  @override
  void initState() {
    super.initState();
    companyNameController =
        TextEditingController(text: widget.companyData['companyName']);
    websiteController =
        TextEditingController(text: widget.companyData['website']);
    locationController =
        TextEditingController(text: widget.companyData['location']);
    addressController =
        TextEditingController(text: widget.companyData['address']);
    moaDurationController =
        TextEditingController(text: widget.companyData['moaDuration']);
    primaryContactNameController =
        TextEditingController(text: widget.companyData['primaryContactName']);
    primaryContactDetailsController = TextEditingController(
        text: widget.companyData['primaryContactDetails']);
    primaryContactDesignationController = TextEditingController(
        text: widget.companyData['primaryContactDesignation']);
    secondaryContactNameController =
        TextEditingController(text: widget.companyData['secondaryContactName']);
    _internshipMode = widget.companyData['mode'];
  }

  @override
  void dispose() {
    companyNameController.dispose();
    websiteController.dispose();
    locationController.dispose();
    addressController.dispose();
    moaDurationController.dispose();
    primaryContactNameController.dispose();
    primaryContactDetailsController.dispose();
    primaryContactDesignationController.dispose();
    secondaryContactNameController.dispose();
    super.dispose();
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
              "Edit Company",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          body: Padding(
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
                        onTap: () {},
                        child: Ink(
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.shadow),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white),
                          child: SizedBox(
                            height: 150,
                            width: 150,
                            child: widget.companyData['imageUrl'] != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      widget.companyData['imageUrl'],
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo_rounded,
                                        size: 40,
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        "Change Company Photo",
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    "Ageement Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Divider(),
                  ),
                  const Text(
                    "Primary Contact",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: TextField(
                      controller: primaryContactNameController,
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
                      controller: primaryContactDetailsController,
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
                      controller: primaryContactDesignationController,
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: TextField(
                      controller: secondaryContactNameController,
                      decoration: InputDecoration(
                          hintText: "Contact Person 2",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          labelText: "Enter Contact Person 2 Name"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement save functionality
                      },
                      child: const Text('Save Changes'),
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
