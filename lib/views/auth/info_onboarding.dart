import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:inturn/views/auth/info_onboarding_pages/college_profile.dart';
import 'package:inturn/views/auth/info_onboarding_pages/confirmation_profile.dart';
import 'package:inturn/views/auth/info_onboarding_pages/course_profile.dart';
import 'package:inturn/views/auth/info_onboarding_pages/return_to_main.dart';
import 'package:inturn/views/auth/info_onboarding_pages/student_profile.dart';
import 'package:inturn/views/auth/info_onboarding_pages/role_selection.dart';

class InfoOnboarding extends StatefulWidget {
  const InfoOnboarding({super.key});

  @override
  _InfoOnboardingState createState() => _InfoOnboardingState();
}

class _InfoOnboardingState extends State<InfoOnboarding> {
  final PageController _pageController = PageController();
  int currentStep = 0;
  String? role;
  String? firstName;
  String? lastName;
  String? selectedCollege;
  String? selectedCollegeId;
  String? selectedCourse;
  String? selectedCourseId;

  void nextPage() {
    if (currentStep < 6) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => currentStep++);
    }
  }

  void onRoleSelected(String selectedRole) {
    setState(() {
      role = selectedRole;
    });
    nextPage();
  }

  void onNameEntered(String enteredFirstName, String enteredLastName) {
    setState(() {
      firstName = enteredFirstName;
      lastName = enteredLastName;
    });
    nextPage();
  }

  void onCollegeSelected(String collegeId, String collegeName) {
    setState(() {
      selectedCollegeId = collegeId;
      selectedCollege = collegeName;
    });
    nextPage();
  }

  void onCourseSelected(String courseId, String courseName) {
    setState(() {
      selectedCourseId = courseId;
      selectedCourse = courseName;
    });
    nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            /// 🟦 Progress Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: LinearProgressIndicator(
                value: (currentStep + 1) / 6,
                backgroundColor: Colors.grey[300],
                color: AppColors.primary,
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  RoleSelection(onContinue: onRoleSelected),
                  StudentProfile(onContinue: onNameEntered),
                  CollegeProfile(onContinue: onCollegeSelected),
                  CourseProfile(
                    onContinue: onCourseSelected,
                    collegeId: selectedCollegeId,
                  ),
                  if (selectedCourse != null)
                    ConfirmationProfile(
                      onContinue: nextPage,
                      firstName: firstName!,
                      lastName: lastName!,
                      college: selectedCollege!,
                      collegeId: selectedCollegeId!,
                      course: selectedCourse!,
                      courseId: selectedCourseId!,
                      role: role!,
                    ),
                  const ReturnToMain(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
