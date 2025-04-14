import 'package:flutter/material.dart';
import 'package:inturn/views/auth/admin_profile.dart';
import 'package:inturn/views/auth/student_profile.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 100),
                child: Text("Welcome",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
                      color: Colors.black,
                    )),
              ),
              SizedBox(
                height: 80,
              ),
              Text(
                "Log in as",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentProfile()));
                  },
                  borderRadius:
                      BorderRadius.circular(40), // Set the border radius
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 140, 139, 139)),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 12),
                    child: const Center(
                      child: Text(
                        "Student",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminProfile()));
                  },
                  borderRadius:
                      BorderRadius.circular(40), // Set the border radius
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 140, 139, 139)),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 12),
                    child: const Center(
                      child: Text(
                        "Administrator",
                        style: TextStyle(
                          fontSize: 20,
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
    );
  }
}
