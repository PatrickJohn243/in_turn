import 'package:flutter/material.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:inturn/views/admin/add_company.dart';
import 'package:inturn/views/admin/view_company.dart';
import 'package:inturn/views/admin/edit_company_list.dart';
import 'package:inturn/views/admin/delete_company.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome Admin",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Manage your school's internship!",
                style: TextStyle(fontSize: 16, color: AppColors.secondaryGrey),
              ),
              const SizedBox(
                height: 16,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      //Add Company----//
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: AppColors.splashColor,
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddCompany()));
                            },
                            child: Ink(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.shadow),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_rounded,
                                    size: 40,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Add",
                                    style: TextStyle(
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "New Companies",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.secondaryGrey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      //Delete Company----//
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: AppColors.splashColor,
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DeleteCompany(),
                                ),
                              );
                            },
                            child: Ink(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.shadow)),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete_outline_rounded,
                                    size: 40,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Delete",
                                    style: TextStyle(
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Companies",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.secondaryGrey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      //Edit Company----//
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: AppColors.splashColor,
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditCompanyList(),
                                ),
                              );
                            },
                            child: Ink(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.shadow)),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.edit_outlined,
                                    size: 40,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Edit",
                                    style: TextStyle(
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Company Info",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.secondaryGrey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      //View Companies----//
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: AppColors.splashColor,
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ViewCompanyPage(),
                                ),
                              );
                            },
                            child: Ink(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.shadow)),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_rounded,
                                    size: 40,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "View",
                                    style: TextStyle(
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Added Companies",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.secondaryGrey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
