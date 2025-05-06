import 'package:flutter/material.dart';
import 'package:inturn/services/google_auth.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:inturn/views/auth/info_onboarding.dart';

class RoleSelection extends StatelessWidget {
  final Function(String) onContinue;
  const RoleSelection({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {},
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                      text: "Hello",
                      style: TextStyle(
                          color: AppColors.primaryGrey, fontSize: 60)),
                  TextSpan(
                      text: "\nare you a?",
                      style: TextStyle(
                          color: AppColors.primaryGrey, fontSize: 60)),
                ])),
                // const SizedBox(
                //   height: 100,
                // ),
                Column(
                  children: [
                    Center(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            onContinue("Student");
                          },
                          borderRadius: BorderRadius.circular(
                              12), // Set the border radius
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 140, 139, 139)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 12.0),
                                  child: Icon(
                                    Icons.school_rounded,
                                    size: 60,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  "Student",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryGrey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const AdminProfile()));
                            onContinue("Admin");
                          },
                          borderRadius: BorderRadius.circular(
                              12), // Set the border radius
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 140, 139, 139)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 12.0),
                                  child: Icon(
                                    Icons.admin_panel_settings_rounded,
                                    size: 60,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  "Administrator",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryGrey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     const Icon(
                //       Icons.arrow_back_ios_rounded,
                //       color: AppColors.secondaryGrey,
                //     ),
                // TextButton(
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                //   child: const Text(
                //     "Back to Main",
                //     style: TextStyle(
                //       color: AppColors.secondaryGrey,
                //       decoration: TextDecoration.underline,
                //     ),
                //   ),
                // ),
                // ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
