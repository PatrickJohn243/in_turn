import 'package:flutter/material.dart';
import 'package:inturn/routes/admin_dashboard.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:inturn/views/filter_page.dart';
import 'package:inturn/views/home_page.dart';
import 'package:inturn/views/profile_page.dart';
import 'package:inturn/views/saved_page.dart';
import 'package:inturn/views/search_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          HomePage(),
          SearchPage(),
          SavedPage(),
          ProfilePage(),
          AdminDashboard()
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
          destinations: const [
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
            NavigationDestination(
              icon: Icon(
                Icons.person_outline,
                color: AppColors.primaryGrey,
              ),
              label: 'Admin',
              selectedIcon: Icon(
                Icons.person,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
