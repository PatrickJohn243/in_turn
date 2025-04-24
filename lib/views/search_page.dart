import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/components/company_item.dart';
import 'package:inturn/models/companies.dart';
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
  // List<Companies> companies = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? textController;
  FocusNode? textFieldFocusNode;
  String? choiceChipsValue;
  List<String> choiceChips = ['For You'];
  // int resultCount = 0;

  void onTapFavorite() {}
  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textFieldFocusNode = FocusNode();
    // fetchAllCompanies();
  }

  // void fetchAllCompanies() async {
  //   companies = await CompaniesFetching().fetchCompanies();
  //   setState(() {
  //     resultCount = companies.length.toInt();
  //   });
  // }

  @override
  void dispose() {
    textController?.dispose();
    textFieldFocusNode?.dispose();
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
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
                  child: TextFormField(
                    controller: textController,
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
                          EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
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
                      SizedBox(width: 16),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 12.0,
                          children: [
                            'For You',
                            'Engineering',
                            'Hotel and Restaurant',
                            'Technology',
                            'Ai News',
                            'Startups'
                          ].map((chipName) {
                            return ChoiceChip(
                              label: Text(chipName),
                              selected: choiceChipsValue == chipName,
                              onSelected: (selected) {
                                setState(() {
                                  choiceChipsValue = selected ? chipName : null;
                                });
                              },
                              checkmarkColor: Colors.white,
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color: choiceChipsValue == chipName
                                    ? Colors.white
                                    : Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                              ),
                              // backgroundColor:
                              //     Appco,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 16, top: 12),
                  child: Text(
                    '${widget.companies.length} results for you',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 44),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: widget.companies
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
