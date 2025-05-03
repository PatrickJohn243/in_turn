import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/components/company_card.dart';
import 'package:inturn/components/company_small_card.dart';
import 'package:inturn/models/companies.dart';
import 'package:inturn/models/courses.dart';
import 'package:inturn/models/users.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:inturn/view_models/companies_fetching.dart';
import 'package:inturn/view_models/courses_fetching.dart';
// import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  final Function(int) onTapSearch;
  final List<Companies> companies;
  final Users? user;
  const HomePage(
      {super.key,
      required this.onTapSearch,
      required this.companies,
      this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController? textController;
  FocusNode? textFieldFocusNode;
  String? choiceChipsValue;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Courses> courses = [];
  List<Courses> selectedCourses = [];
  List<Companies> filteredCompanies = [];

  void fetchCourses(String collegeId) async {
    final fetchedCourses = await CoursesFetching().fetchCourses(collegeId);

    setState(() {
      courses = fetchedCourses;
    });
  }

  void searchFetching(List<Courses> coursesChipsSelected) async {
    final fetchedFilteredCompanies = await CompaniesFetching()
        .fetchBySearchAndCourse('', coursesChipsSelected);
    setState(() {
      filteredCompanies = fetchedFilteredCompanies;
    });
  }

  void setInitialCompanies(List<Companies> companies) {
    setState(() {
      filteredCompanies = companies;
    });
  }

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textFieldFocusNode = FocusNode();
    if (widget.user != null) {
      fetchCourses(widget.user!.collegeId);
    }
    setInitialCompanies(widget.companies);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (widget.user != null) {
      fetchCourses(widget.user!.collegeId);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 0, 6),
            child: SizedBox(
              width: 44,
              height: 44,
              child: Image.asset("img/logo.png"),
            ),
          ),
          backgroundColor: Colors.white,
          title: Align(
            alignment: const AlignmentDirectional(-1, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user == null
                      ? 'Hey User'
                      : 'Hey ${widget.user!.firstName}',
                  style: const TextStyle(fontSize: 24),
                ),
                const Text(
                  'Welcome to InTurn',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
              child: IconButton(
                iconSize: 40,
                icon: Icon(
                  Icons.notifications_none,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                onPressed: () {
                  log('IconButton pressed ...');
                },
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onTapSearch(1);
                  }, //
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.primary, width: 2),
                          borderRadius: BorderRadius.circular(24)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Find your company..."),
                          Icon(
                            Icons.search_rounded,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 290,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      0,
                    ),
                    scrollDirection: Axis.horizontal,
                    children: widget.companies.map((company) {
                      return Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 16, 12, 16),
                        child: CompanyCard(
                          company: company,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                  child: widget.user != null
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const SizedBox(width: 16),
                              Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 8, 0, 8),
                                  child: _buildChoiceChips()),
                              const SizedBox(width: 16),
                            ],
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Center(
                            child: Text(
                              "Log in to filter by your department",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                ),
                const Divider(
                  height: 8,
                  thickness: 1,
                  color: AppColors.shadow,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 0, 0),
                  child: Text(
                    'Related to you',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                ListView(
                  padding: const EdgeInsets.fromLTRB(
                    0,
                    8,
                    0,
                    44,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: filteredCompanies.map((company) {
                    return CompanySmallCard(
                      company: company,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceChips() {
    final List<Courses> courseChips = courses.map((course) => course).toList();

    return Wrap(
      spacing: 8.0,
      children: courseChips.map((chip) {
        return ChoiceChip(
          label: Text(chip.courseName),
          selected: selectedCourses
              .any((selected) => selected.courseName == chip.courseName),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                selectedCourses.add(chip);
              } else {
                selectedCourses
                    .removeWhere((c) => c.courseName == chip.courseName);
              }
              searchFetching(selectedCourses);
            });
          },
          backgroundColor: AppColors.primary,
          selectedColor: AppColors.primary,
          checkmarkColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      }).toList(),
    );
  }
}
