import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/services/user_fetching.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:inturn/components/search_bar.dart';
import 'package:inturn/view_models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> user = [] as List<dynamic>;
  List<dynamic> colleges = [] as List<dynamic>;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      text: TextSpan(
                          text: "Hello Patrick,",
                          style: TextStyle(
                              color: AppColors.primaryGrey,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                          children: [
                        TextSpan(
                            text: "\nWelcome to InTurn",
                            style: TextStyle(
                                color: AppColors.primaryGrey,
                                fontSize: 16,
                                fontWeight: FontWeight.normal))
                      ])),
                  Icon(
                    Icons.notifications,
                    size: 30,
                    color: AppColors.secondaryGrey,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              const FilterBar(),
              GestureDetector(
                onTap: () async => {
                  user =
                      (await UserFetching().fetchAllUsers()) as List<dynamic>,
                  log(user.toString()),
                  colleges = (await CollegeFetching().fetchAllColleges())
                      as List<dynamic>,
                  log(colleges.toString()),
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Text("Fetch Data"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
