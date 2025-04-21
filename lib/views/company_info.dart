import 'package:flutter/material.dart';
import 'package:inturn/models/companies.dart';
import 'package:inturn/utils/constants/app_colors.dart';

class CompanyInfo extends StatefulWidget {
  final Companies company;
  const CompanyInfo({super.key, required this.company});

  @override
  _CompanyInfoState createState() => _CompanyInfoState();
}

class _CompanyInfoState extends State<CompanyInfo> {
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
      Icons.contact_page_rounded: widget.company.contactDetails,
      Icons.person_outline: widget.company.contactPerson2
    };

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
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.shadow),
                              borderRadius: BorderRadius.circular(40)),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      Container(
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
              // const Text("Company Info",
              //     style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         fontSize: 24,
              //         color: AppColors.primaryGrey)),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    // border: Border.all(color: AppColors.primary, width: 2),
                    // color: const Color.fromARGB(255, 157, 194, 243)),
                    color: AppColors.lighterPrimary),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore, "
                    "magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: const Text("Company",
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
                          Container(
                            padding: EdgeInsets.all(40),
                            decoration: BoxDecoration(
                                color: AppColors.secondaryGrey,
                                borderRadius: BorderRadius.circular(12)),
                          )
                        ],
                      ),
                      Column(
                        children: companyDetails.entries.map((companyDetail) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
  }
}
