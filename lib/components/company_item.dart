import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/models/companies.dart';
import 'package:inturn/utils/constants/app_colors.dart';
import 'package:inturn/utils/constants/fetch_public_image_url.dart';
import 'package:inturn/view_models/companies_delete.dart';
import 'package:inturn/views/admin/edit_company.dart';
import 'package:inturn/views/company_details/company_info.dart';

class CompanyItem extends StatefulWidget {
  final Companies company;
  final bool canEdit;
  final bool canDelete;
  const CompanyItem(
      {super.key,
      required this.company,
      this.canEdit = false,
      this.canDelete = false});

  @override
  _CompanyItemState createState() => _CompanyItemState();
}

class _CompanyItemState extends State<CompanyItem> {
  String imageUrl = '';
  List<String> applicableCourses = [];

  Future<void> getAllApplicableCourses() async {
    applicableCourses = widget.company.applicableCourse.toList();
    // log(applicableCourses.length.toString());
  }

  void getImageUrl() async {
    final url = getPublicImageUrl(widget.company.companyImage);
    setState(() {
      imageUrl = url;
      // log(url);
    });
  }

  @override
  void didUpdateWidget(covariant CompanyItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.company != widget.company) {
      getImageUrl();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllApplicableCourses();
    getImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (widget.canEdit) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCompany(company: widget.company),
                ),
              );
            } else if (widget.canDelete) {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                builder: (context) {
                  return Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(0)),
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.delete, color: Colors.white),
                      label: Text('Delete Company'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        CompaniesDelete()
                            .DeleteCompany(widget.company.companyId);
                        Navigator.pop(context); // Close the bottom sheet
                      },
                    ),
                  );
                },
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompanyInfo(
                    company: widget.company,
                    imageUrl: imageUrl,
                  ),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.shadow)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              // widget.company.companyImage,
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
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
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.company.companyName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 4,
                            runSpacing: 4,
                            children: () {
                              final List<Widget> chips = [];
                              final courses = widget.company.applicableCourse;

                              for (int i = 0; i < courses.length; i++) {
                                chips.add(
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Text(
                                      courses[i],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                                if (i < courses.length - 1) {
                                  chips.add(
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2),
                                      child: Text(
                                        '/',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }

                              return chips;
                            }(),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 4, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 12, 0),
                                  child: Text(
                                    widget.company.location,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 1,
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsetsDirectional.fromSTEB(
                                //       0, 0, 4, 0),
                                //   child: Icon(
                                //     Icons.chat_bubble_outline_rounded,
                                //     color: Theme.of(context)
                                //         .textTheme
                                //         .bodySmall
                                //         ?.color,
                                //     size: 16,
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 16, 0),
                                  child: Text(
                                    '24',
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(height: 4),
                          // Align(
                          //   alignment: const AlignmentDirectional(0, 0),
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.max,
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       const Row(
                          //         mainAxisSize: MainAxisSize.max,
                          //         children: [
                          //           Text(
                          //             '4',
                          //             style: TextStyle(
                          //               color: Colors.black,
                          //               fontSize: 16,
                          //             ),
                          //           ),
                          //           Icon(
                          //             Icons.star_rounded,
                          //             color: Colors.amber,
                          //             size: 20,
                          //           ),
                          //         ],
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.only(left: 24),
                          //         child: Icon(
                          //           Icons.keyboard_control_rounded,
                          //           color: Theme.of(context)
                          //               .textTheme
                          //               .bodySmall
                          //               ?.color,
                          //           size: 24,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
