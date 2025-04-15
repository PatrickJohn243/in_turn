import 'package:flutter/material.dart';
import 'package:inturn/utils/constants/app_colors.dart';

class AddCompany extends StatefulWidget {
  const AddCompany({Key? key}) : super(key: key);

  @override
  _AddCompanyState createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  String? _internshipMode;
  final List<String> internshipModes = ['Virtual', 'F2F', 'Combined'];
  late TextEditingController companyNameController;

  @override
  void initState() {
    super.initState();
    companyNameController = TextEditingController();
  }

  @override
  void dispose() {
    companyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late FocusNode companyNameFocusNode;
    @override
    void initState() {
      super.initState();
      companyNameController = TextEditingController();
      companyNameFocusNode = FocusNode();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        companyNameFocusNode.requestFocus();
      });
    }

    @override
    void dispose() {
      companyNameController.dispose();
      companyNameFocusNode.dispose();
      super.dispose();
    }

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
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
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
                          child: const SizedBox(
                            height: 150,
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo_rounded,
                                  size: 40,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "Upload Company Photo",
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
                    padding: const EdgeInsets.only(
                      top: 24.0,
                    ),
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
