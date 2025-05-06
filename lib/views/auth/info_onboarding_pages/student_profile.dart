import 'package:flutter/material.dart';
import 'package:inturn/utils/constants/app_colors.dart';

class StudentProfile extends StatefulWidget {
  final Function(String, String) onContinue;
  final VoidCallback onBack;

  const StudentProfile(
      {super.key, required this.onContinue, required this.onBack});

  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile>
    with TickerProviderStateMixin {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  bool showFirstNameError = false;
  bool showLastNameError = false;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  void validateAndContinue() {
    setState(() {
      showFirstNameError = firstNameController.text.trim().isEmpty;
      showLastNameError = lastNameController.text.trim().isEmpty;
    });

    if (showFirstNameError || showLastNameError) {
      return;
    } else {
      widget.onContinue(
          firstNameController.text.trim(), lastNameController.text.trim());
    }
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
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Tell us",
                      style:
                          TextStyle(color: AppColors.primaryGrey, fontSize: 60),
                    ),
                    TextSpan(
                      text: "\nabout you.",
                      style:
                          TextStyle(color: AppColors.primaryGrey, fontSize: 60),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: TextField(
                      controller: firstNameController,
                      onChanged: (_) {
                        if (showFirstNameError &&
                            firstNameController.text.isNotEmpty) {
                          setState(() => showFirstNameError = false);
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: showFirstNameError
                            ? "First name can't be empty!"
                            : "First Name Please 😊",
                        labelStyle: TextStyle(
                          color: showFirstNameError ? Colors.red : null,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: TextField(
                      controller: lastNameController,
                      onChanged: (_) {
                        if (showLastNameError &&
                            lastNameController.text.isNotEmpty) {
                          setState(() => showLastNameError = false);
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: showLastNameError
                            ? "Last name can't be empty!"
                            : "And your last name?",
                        labelStyle: TextStyle(
                          color: showLastNameError ? Colors.red : null,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Material(
                      child: InkWell(
                        onTap: validateAndContinue,
                        child: Ink(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              "Continue",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
