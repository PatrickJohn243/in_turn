import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/main.dart';
import 'package:inturn/models/companies.dart';
import 'package:inturn/models/users.dart';
import 'package:inturn/provider/auth_state_provider.dart';
import 'package:inturn/provider/page_provider.dart';
import 'package:inturn/routes/admin_dashboard.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:inturn/view_models/companies_fetching.dart';
import 'package:inturn/view_models/user_fetching.dart';
import 'package:inturn/views/filter_page.dart';
import 'package:inturn/views/home_page.dart';
import 'package:inturn/views/profile_page.dart';
import 'package:inturn/views/saved_page.dart';
import 'package:inturn/views/search_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // int currentPageIndex = 0;
  String userId = '';
  Users? userProfile;
  List<Companies> fetchedCompanies = [];
  String role = 'Student';
  bool isLoading = false;

  // void setCurrentPageIndex(int pageIndex) {
  //   setState(() {
  //     currentPageIndex = pageIndex;
  //   });
  // }

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
      });
    } catch (e) {
      log('Error fetching user: $e');
    }
  }

  Future<void> fetchAllCompanies() async {
    setState(() {
      isLoading = true;
    });
    final companies = await CompaniesFetching().fetchCompanies();
    setState(() {
      fetchedCompanies = companies;
      isLoading = false;
      // log(fetchedCompanies.length.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllCompanies();
    fetchUser();

    // Listen to auth state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider =
          Provider.of<AuthStateProvider>(context, listen: false);
      authProvider.addListener(() {
        if (authProvider.lastEvent == AuthChangeEvent.signedIn ||
            authProvider.lastEvent == AuthChangeEvent.initialSession) {
          fetchUser();
          context.read<PageProvider>().setIndex(0);
        }
        if (authProvider.lastEvent == AuthChangeEvent.signedOut) {
          setState(() {
            userProfile = null;
            role = 'Student';
            // currentPageIndex = 0;
          });
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<PageProvider>().currentIndex;
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Scaffold(
        body: Stack(
          children: [
            isLoading
                ? Container(
                    color: Colors.white, // Semi-transparent overlay
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : IndexedStack(
                    index: currentIndex,
                    children: [
                      if (role == "Student") ...[
                        HomePage(
                          user: userProfile,
                          companies: fetchedCompanies,
                          onTapSearch: (index) {
                            context.read<PageProvider>().setIndex(1);
                          },
                        ),
                        SearchPage(
                          companies: fetchedCompanies,
                        ),
                        SavedPage(
                          user: userProfile,
                        ),
                        const ProfilePage(),
                      ] else ...[
                        const AdminDashboard(),
                        SearchPage(
                          companies: fetchedCompanies,
                        ),
                        const ProfilePage(),
                      ]
                    ],
                  ),
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
              context.read<PageProvider>().setIndex(index);
            },
            selectedIndex: currentIndex,
            destinations: [
              if (role == "Student") ...[
                const NavigationDestination(
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
                const NavigationDestination(
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
                const NavigationDestination(
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
                const NavigationDestination(
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
                const NavigationDestination(
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
                const NavigationDestination(
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
                const NavigationDestination(
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
      )),
    );
  }
}
