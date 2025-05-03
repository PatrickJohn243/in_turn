import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/components/info_container.dart';
import 'package:inturn/main.dart';
import 'package:inturn/models/colleges.dart';
import 'package:inturn/models/courses.dart';
import 'package:inturn/models/users.dart';
import 'package:inturn/services/google_auth.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inturn/view_models/college_fetching.dart';
import 'package:inturn/view_models/courses_fetching.dart';
import 'package:inturn/view_models/user_fetching.dart';
import 'package:inturn/views/auth/info_onboarding.dart';
import 'package:inturn/views/auth/info_onboarding_pages/role_selection.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = supabase.auth.currentUser;
  var userId = '';
  Users? userProfile;
  Colleges? userCollege;
  Courses? userCourse;

  @override
  void initState() {
    super.initState();
    checkIfNewUser();
  }

  Future<void> checkIfNewUser() async {
    final currentUser = supabase.auth.currentUser;
    setState(() {
      userId = currentUser!.id;
    });

    if (currentUser == null) return;

    final data = await supabase
        .from('users')
        .select()
        .eq('userId', currentUser.id)
        .maybeSingle();

    if (data == null) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InfoOnboarding()),
        );
      }
    } else {
      if (mounted) setState(() {});
      getUser();
    }
  }

  Future<void> getUser() async {
    final Users? profile = await UserFetching().fetchUser(userId);
    final Colleges collegeProfile =
        await CollegeFetching().fetchCollegeById(profile!.collegeId);
    final Courses? courseProfile =
        await CoursesFetching().fetchCourse(profile.collegeId, profile.course);
    setState(() {
      if (mounted) {
        userProfile = profile;
        userCollege = collegeProfile;
        userCourse = courseProfile;
        // log(userCollege.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userProfile?.role == "Admin" ? "Admin Profile" : "Profile",
                  style: const TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                if (user != null) ...[
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      "Account",
                      style: TextStyle(
                          fontSize: 20, color: AppColors.secondaryGrey),
                    ),
                  ),
                  InfoContainer(
                    type: "Name",
                    data: "${userProfile?.firstName} ${userProfile?.lastName}",
                  ),
                  InfoContainer(
                    type: "Email",
                    data: "${user.email}",
                  ),
                  InfoContainer(
                    type: "College",
                    data: "${userCollege?.college}",
                  ),
                  InfoContainer(
                    type: "Course",
                    data: "${userCourse?.courseName}",
                  ),
                ],
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    "General",
                    style:
                        TextStyle(fontSize: 20, color: AppColors.secondaryGrey),
                  ),
                ),

                /// Google Login/Logout
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        if (user == null) {
                          await googleAuthLogin();
                          await checkIfNewUser(); // Re-check after login
                          if (mounted) setState(() {});
                        } else {
                          await googleAuthLogout();
                          if (mounted) setState(() {});
                        }
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color.fromARGB(255, 229, 229, 229),
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 80,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 12.0),
                                      child: Icon(FontAwesomeIcons.google),
                                    ),
                                    Text(
                                      user == null
                                          ? "Continue with Google"
                                          : "Sign Out with Google",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                if (user != null) ...[
                  // Delete account button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          // handle delete account
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color.fromARGB(255, 229, 229, 229),
                              )),
                          child: SizedBox(
                            width: double.infinity,
                            height: 70,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              alignment: Alignment.centerLeft,
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Delete Account",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                // Terms
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {},
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color.fromARGB(255, 229, 229, 229),
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 80,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            alignment: Alignment.centerLeft,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Terms and Services",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
