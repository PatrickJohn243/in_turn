import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/main.dart';
import 'package:inturn/models/colleges.dart';
import 'package:inturn/models/users.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:inturn/view_models/user_insert.dart';

class ConfirmationProfile extends StatefulWidget {
  final VoidCallback onContinue;
  final String firstName;
  final String lastName;
  final String college;
  final String collegeId;
  final String course;
  final String courseId;
  final String role;
  const ConfirmationProfile(
      {super.key,
      required this.onContinue,
      required this.firstName,
      required this.lastName,
      required this.college,
      required this.course,
      required this.role,
      required this.collegeId,
      required this.courseId});

  @override
  _ConfirmationProfileState createState() => _ConfirmationProfileState();
}

class _ConfirmationProfileState extends State<ConfirmationProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                    text: "Is",
                    style:
                        TextStyle(color: AppColors.primaryGrey, fontSize: 60)),
                TextSpan(
                    text: "\nthis you?",
                    style:
                        TextStyle(color: AppColors.primaryGrey, fontSize: 60)),
              ])),
              Column(children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "${widget.firstName} ${widget.lastName}",
                        style: const TextStyle(
                          color: AppColors.primaryGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          decoration: TextDecoration.underline,
                        )),
                    const TextSpan(
                        text: ", a ",
                        style: TextStyle(
                            color: AppColors.primaryGrey, fontSize: 30)),
                    TextSpan(
                        text: widget.role,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGrey,
                          fontSize: 30,
                          decoration: TextDecoration.underline,
                        )),
                    const TextSpan(
                        text: ", \nfrom the ",
                        style: TextStyle(
                            color: AppColors.primaryGrey, fontSize: 30)),
                    TextSpan(
                        text: widget.college,
                        style: const TextStyle(
                          color: AppColors.primaryGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          decoration: TextDecoration.underline,
                        )),
                    const TextSpan(
                        text: ",\nenrolled in ",
                        style: TextStyle(
                            color: AppColors.primaryGrey, fontSize: 30)),
                    TextSpan(
                        text: widget.course,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGrey,
                          fontSize: 30,
                          decoration: TextDecoration.underline,
                        ))
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Material(
                    // color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        final userResponse = await supabase.auth.getUser();
                        Users userData = Users(
                          userId: userResponse.user!.id,
                          firstName: widget.firstName,
                          lastName: widget.lastName,
                          role: widget.role,
                          course: widget.courseId,
                          collegeId: widget.collegeId,
                        );
                        widget.onContinue();
                        UserInsert().insertUser(userData);
                      },
                      child: Ink(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Center(
                          child: Text(
                            "Yes, this is me",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ]),
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
