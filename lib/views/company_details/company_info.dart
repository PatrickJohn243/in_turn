import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/models/companies.dart';
import 'package:inturn/provider/favorites_provider.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CompanyInfo extends StatefulWidget {
  final Companies company;
  final String imageUrl;
  const CompanyInfo({
    super.key,
    required this.company,
    required this.imageUrl,
  });

  @override
  _CompanyInfoState createState() => _CompanyInfoState();
}

class _CompanyInfoState extends State<CompanyInfo> {
  bool isFavorite = false;
  bool isProcessing = false;

  void toggleFavorite() async {
    if (isProcessing) return;
    setState(() {
      isProcessing = true;
    });

    try {
      final favoritesProvider =
          Provider.of<FavoritesProvider>(context, listen: false);
      final isFavorite = favoritesProvider.isFavorite(widget.company.companyId);

      // Toggle the favorite status
      await favoritesProvider.toggleFavorite(widget.company, !isFavorite);
    } catch (e) {
      log("$e");
    } finally {
      await Future.delayed(const Duration(milliseconds: 600));
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<dynamic, List<String>> companyDetails = {
      FontAwesomeIcons.building: [widget.company.location, "Location"],
      FontAwesomeIcons.locationDot: [
        widget.company.address,
        "Complete Address"
      ],
      FontAwesomeIcons.globe: [widget.company.website, "Website"],
      FontAwesomeIcons.layerGroup: [widget.company.mode, "Mode"],
    };
    Map<dynamic, String> contactDetails = {
      // Icons.person_outline: widget.company.contactPerson2,
      FontAwesomeIcons.envelope: widget.company.contactDetails,
    };
    FocusManager.instance.primaryFocus?.unfocus();
    return Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
      final isFavorite = favoritesProvider.isFavorite(widget.company.companyId);

      return DefaultTabController(
        length: 3,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Colors.white,
            ),
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 56,
                        width: 56,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            widget.imageUrl,
                            width: 24,
                            height: 24,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () {
                                toggleFavorite();
                                // SaveCompany().addToSaves(widget.company.companyId);
                                // setState(() {
                                //   isFavorite = !isFavorite;
                                // });
                              },
                              child: Ink(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: AppColors.shadow),
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: isFavorite
                                        ? const Icon(
                                            Icons.favorite_rounded,
                                            color: Colors.red,
                                          )
                                        : const Icon(
                                            Icons.favorite_border_rounded),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  widget.company.mode,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    widget.company.companyName,
                    maxLines: 3,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGrey),
                  ),
                  Row(
                    children: [
                      const Text(
                        "Applicability / ",
                        style: TextStyle(
                            color: AppColors.primaryGrey,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      Text(
                        widget.company.applicableCourse.join(' · '),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const TabBar(
                    labelColor: AppColors.primary,
                    indicatorColor: AppColors.primary,
                    tabs: [
                      Tab(text: "About"),
                      Tab(text: "Company"),
                      Tab(text: "Contact"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        //About View
                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.shadow),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.company.companyName,
                                              maxLines: 3,
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              widget
                                                  .company.fieldSpecialization,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      AppColors.secondaryGrey,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      SizedBox(
                                        height: 72,
                                        width: 72,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            widget.imageUrl,
                                            width: 24,
                                            height: 24,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: AppColors.lighterPrimary),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        widget.company.description,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //Company View
                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.shadow),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.company.companyName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32),
                                  ),
                                  Text(
                                    widget.company.fieldSpecialization,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: AppColors.secondaryGrey),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        companyDetails.entries.map((detail) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 18),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: AppColors.shadow),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                detail.key,
                                                size: 28,
                                                color: AppColors.primary,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      detail.value[1],
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    // const SizedBox(height: 4),
                                                    Text(
                                                      detail.value[0],
                                                      style: const TextStyle(
                                                        color: AppColors
                                                            .secondaryGrey,
                                                        fontSize: 18,
                                                      ),
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: true,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //Contact View
                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.shadow),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.company.contactPerson,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${widget.company.designation} - Contact Person 1",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: AppColors.secondaryGrey),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      child: Divider(),
                                    ),
                                    Text(
                                      widget.company.contactPerson2,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      "Contact Person 2",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: AppColors.secondaryGrey),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      child: Divider(),
                                    ),
                                    ...contactDetails.entries.map((entry) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              entry.key,
                                              size: 24,
                                              color: AppColors.primary,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                entry.value,
                                                style: const TextStyle(
                                                  color:
                                                      AppColors.secondaryGrey,
                                                  fontSize: 16,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
