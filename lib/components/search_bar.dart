import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/utils/constants/app_colors.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({Key? key}) : super(key: key);

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.secondaryGrey,
          borderRadius: BorderRadius.circular(40)),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  log(value);
                },
                decoration: const InputDecoration(
                  hintText: "Search for companies",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
