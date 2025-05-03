import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/models/companies.dart';
import 'package:inturn/provider/favorites_provider.dart';
import 'package:inturn/utils/constants/app_colors.dart';

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
    Map<IconData, String> details = {
      Icons.location_on: widget.company.address,
      Icons.language: widget.company.website,
    };
    Map<IconData, String> companyDetails = {
      Icons.phone: widget.company.contactDetails,
      Icons.person: widget.company.contactPerson,
      Icons.badge: widget.company.designation,
      Icons.person_outline: widget.company.contactPerson2
    };
    FocusManager.instance.primaryFocus?.unfocus();
    return Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
      final isFavorite = favoritesProvider.isFavorite(widget.company.companyId);

      return SafeArea(
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
                                    border: Border.all(color: AppColors.shadow),
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
                  height: 4,
                ),
                Column(
                  children: details.entries.map((detail) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(children: [
                        Icon(detail.key),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(detail.value),
                      ]),
                    );
                  }).toList(),
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
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      widget.company.description,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Company",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: AppColors.primaryGrey)),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.shadow),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.company.companyName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                              maxLines: 2,
                            ),
                            SizedBox(
                              height: 84,
                              width: 84,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  widget.imageUrl,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: companyDetails.entries.map((companyDetail) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Icon(companyDetail.key),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(companyDetail.value)
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
