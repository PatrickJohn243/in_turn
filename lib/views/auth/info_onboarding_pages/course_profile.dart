import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/models/courses.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:inturn/view_models/courses_fetching.dart';

class CourseProfile extends StatefulWidget {
  final String? collegeId;
  final Function(String, String) onContinue;
  final VoidCallback onBack;
  const CourseProfile(
      {super.key,
      required this.collegeId,
      required this.onContinue,
      required this.onBack});

  @override
  _CourseProfileState createState() => _CourseProfileState();
}

class _CourseProfileState extends State<CourseProfile> {
  List<Courses> courses = [];
  void loadDepartments() async {
    try {
      final fetched = await CoursesFetching().fetchCourses(widget.collegeId!);
      setState(() {
        courses = fetched;
      });
      log("Courses: ${courses.length}");
    } catch (e) {
      log("Error fetching colleges: $e");
    }
  }

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
                    text: "Just",
                    style:
                        TextStyle(color: AppColors.primaryGrey, fontSize: 60)),
                TextSpan(
                    text: "\none more.",
                    style:
                        TextStyle(color: AppColors.primaryGrey, fontSize: 60)),
              ])),
              Column(
                children: courses
                    .map((course) => Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Material(
                            // color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                widget.onContinue(course.id, course.courseName);
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
                                    course.courseName,
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
                      widget.onBack();
                    },
                    child: const Text(
                      "Back",
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
