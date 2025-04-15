import 'package:flutter/material.dart';
import 'package:inturn/components/info_container.dart';
import 'package:inturn/services/google_auth.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Profile",
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    "Account",
                    style:
                        TextStyle(fontSize: 16, color: AppColors.secondaryGrey),
                  ),
                ),
                const InfoContainer(
                  type: "Name",
                  data: "Patrick John H. Flores",
                ),
                const InfoContainer(
                  type: "Email",
                  data: "florespatrickjohn243@gmail.com",
                ),
                const InfoContainer(
                  type: "Mobile Number",
                  data: "+639205788651",
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    "General",
                    style:
                        TextStyle(fontSize: 20, color: AppColors.secondaryGrey),
                  ),
                ),
                //Google Login----//
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        await googleAuthLogin();
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color.fromARGB(255, 229, 229, 229),
                            )),
                        child: SizedBox(
                          width: double.infinity,
                          height: 80,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            alignment: Alignment.centerLeft,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 12.0),
                                      child: Icon(FontAwesomeIcons.google),
                                    ),
                                    Text(
                                      "Continue with Google",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
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
                //Delete Account----//
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {},
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                //Terms and Services----//
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
                            )),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
