import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/components/company_item.dart';
import 'package:inturn/main.dart';
import 'package:inturn/models/companies.dart';
import 'package:inturn/models/courses.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:inturn/view_models/companies_fetching.dart';
// import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  final List<Companies> companies;
  const SearchPage({super.key, required this.companies});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Companies> filteredCompanies = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? textController;
  FocusNode? textFieldFocusNode;
  // List<String> choiceChips = [];
  List<Courses> coursesChipsSelected = [];
  List<Courses> coursesChips = [];
  Timer? _debounce;
  int resultCount = 0;
  String searchQuery = '';

  get response => null;

  void onTapFavorite() {}
  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textFieldFocusNode = FocusNode();
    fetchCourses();
    setInitialCompanyList();
    // fetchAllCompanies();
    setState(() {
      resultCount = widget.companies.length;
    });
  }

  void setInitialCompanyList() async {
    setState(() {
      filteredCompanies = widget.companies;
    });
  }

  void fetchCourses() async {
    try {
      final response = await supabase.from("courses").select();
      setState(() {
        coursesChips = response.map((json) => Courses.fromJson(json)).toList();
      });
    } catch (e) {
      log("$e");
    }
  }

  void sendSearchQueryByInterval(String value) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      // log('Search query: $value');
      searchFetching(value, coursesChips);
    });
  }

  void searchFetching(String value, List<Courses> coursesChipsSelected) async {
    final fetchedFilteredCompanies = await CompaniesFetching()
        .fetchBySearchAndCourse(value, coursesChipsSelected);
    setState(() {
      filteredCompanies = fetchedFilteredCompanies;
      resultCount = filteredCompanies.length;
    });
  }

  @override
  void dispose() {
    textController?.dispose();
    textFieldFocusNode?.dispose();
    _debounce?.cancel();
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
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
                  child: TextFormField(
                    controller: textController,
                    onChanged: (value) =>
                        {sendSearchQueryByInterval(value), searchQuery = value},
                    focusNode: textFieldFocusNode,
                    autofocus: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Find your next opportunity...',
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      hintStyle: Theme.of(context).textTheme.labelMedium,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                      suffixIcon: Icon(
                        Icons.search_rounded,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                    cursorColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(width: 16),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 12.0,
                          children: coursesChips.map((chip) {
                            return ChoiceChip(
                              label: Text(chip.courseName),
                              selected: coursesChipsSelected.any((selected) =>
                                  selected.courseName == chip.courseName),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    coursesChipsSelected.add(chip);
                                  } else {
                                    coursesChipsSelected.removeWhere(
                                        (c) => c.courseName == chip.courseName);
                                  }
                                  searchFetching(
                                      searchQuery, coursesChipsSelected);
                                });
                              },
                              checkmarkColor: Colors.white,
                              selectedColor: AppColors.primary,
                              backgroundColor: AppColors.primary,
                              labelStyle: TextStyle(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16, top: 12),
                  child: Text(
                    '$resultCount results for you',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 44),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: filteredCompanies
                        .map((company) => CompanyItem(company: company))
                        .toList(),
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
