import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/main.dart';
import 'package:inturn/models/companies.dart';
import 'package:inturn/models/users.dart';
import 'package:inturn/routes/admin_dashboard.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:inturn/view_models/companies_fetching.dart';
import 'package:inturn/view_models/user_fetching.dart';
import 'package:inturn/views/filter_page.dart';
import 'package:inturn/views/home_page.dart';
import 'package:inturn/views/profile_page.dart';
import 'package:inturn/views/saved_page.dart';
import 'package:inturn/views/search_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentPageIndex = 0;
  String userId = '';
  Users? userProfile;
  List<Companies> fetchedCompanies = [];
  String role = '';

  void setCurrentPageIndex(int pageIndex) {
    setState(() {
      currentPageIndex = pageIndex;
    });
  }

  Future<void> fetchUser() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      log('User is not logged in');
      return;
    }

    try {
      final profile = await UserFetching().fetchUser(user.id);

      if (profile == null) {
        log('No profile found for user id: ${user.id}');
        return;
      }

      setState(() {
        userProfile = profile;
        role = profile.role;
        // log("user: ${userProfile.toString()}");
      });
    } catch (e) {
      log('Error fetching user: $e');
    }
  }

  Future<void> fetchAllCompanies() async {
    final companies = await CompaniesFetching().fetchCompanies();
    setState(() {
      fetchedCompanies = companies;
      // log(fetchedCompanies.length.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllCompanies();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    if (fetchedCompanies.isEmpty) {
      // You can show a loader or splash until the data is ready
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return SafeArea(
        child: Scaffold(
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          if (userProfile?.role == "Student") ...[
            HomePage(
              user: userProfile,
              companies: fetchedCompanies,
              onTapSearch: setCurrentPageIndex,
            ),
            SearchPage(
              companies: fetchedCompanies,
            ),
            SavedPage(),
            ProfilePage(),
          ] else ...[
            AdminDashboard(),
            SearchPage(
              companies: fetchedCompanies,
            ),
            ProfilePage(),
          ]
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
            labelTextStyle: WidgetStatePropertyAll<TextStyle>(
                TextStyle(color: AppColors.primaryGrey))),
        child: NavigationBar(
          indicatorColor: Colors.white,
          // backgroundColor: AppColors.primary,
          backgroundColor: Colors.white,
          onDestinationSelected: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: [
            if (userProfile?.role == "Student") ...[
              NavigationDestination(
                icon: Icon(
                  Icons.business_center_outlined,
                  color: AppColors.primaryGrey,
                ),
                label: 'Companies',
                selectedIcon: Icon(
                  Icons.business_center_rounded,
                  color: AppColors.primary,
                ),
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.search_rounded,
                  color: AppColors.primaryGrey,
                  size: 24,
                ),
                label: 'Search',
                selectedIcon: Icon(
                  Icons.search_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.favorite_border_rounded,
                  color: AppColors.primaryGrey,
                ),
                label: 'Saved',
                selectedIcon: Icon(
                  Icons.favorite_rounded,
                  color: AppColors.primary,
                ),
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.person_outline,
                  color: AppColors.primaryGrey,
                ),
                label: 'Profile',
                selectedIcon: Icon(
                  Icons.person,
                  color: AppColors.primary,
                ),
              ),
            ] else ...[
              NavigationDestination(
                icon: Icon(
                  Icons.business_center_outlined,
                  color: AppColors.primaryGrey,
                ),
                label: 'Companies',
                selectedIcon: Icon(
                  Icons.business_center_rounded,
                  color: AppColors.primary,
                ),
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.search_rounded,
                  color: AppColors.primaryGrey,
                  size: 24,
                ),
                label: 'Search',
                selectedIcon: Icon(
                  Icons.search_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.person_outline,
                  color: AppColors.primaryGrey,
                ),
                label: 'Profile',
                selectedIcon: Icon(
                  Icons.person,
                  color: AppColors.primary,
                ),
              ),
            ]
          ],
        ),
      ),
    ));
  }
}
