import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/models/colleges.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:inturn/view_models/college_fetching.dart';

class CollegeProfile extends StatefulWidget {
  final Function(String, String) onContinue;
  const CollegeProfile({super.key, required this.onContinue});

  @override
  _CollegeProfileState createState() => _CollegeProfileState();
}

class _CollegeProfileState extends State<CollegeProfile> {
  void loadDepartments() async {
    try {
      final fetched = await CollegeFetching().fetchColleges();
      setState(() {
        departments = fetched;
      });
      log("Colleges: ${departments.length}");
    } catch (e) {
      log("Error fetching colleges: $e");
    }
  }

  List<Colleges> departments = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDepartments();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: const TextSpan(children: [
                TextSpan(
                    text: "Do you",
                    style:
                        TextStyle(color: AppColors.primaryGrey, fontSize: 60)),
                TextSpan(
                    text: "\nbelong to.",
                    style:
                        TextStyle(color: AppColors.primaryGrey, fontSize: 60)),
              ])),
              Column(
                children: departments
                    .map((department) => Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Material(
                            // color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                widget.onContinue(
                                    department.id, department.college);
                              },
                              child: Ink(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: AppColors.shadow),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Center(
                                  child: Text(
                                    department.college,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryGrey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: AppColors.secondaryGrey,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Back to Main",
                      style: TextStyle(
                        color: AppColors.secondaryGrey,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
