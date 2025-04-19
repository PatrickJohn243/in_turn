import 'package:flutter/material.dart';
import 'package:inturn/utils/constants/app_colors.dart';

class ReturnToMain extends StatelessWidget {
  const ReturnToMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: const TextSpan(children: [
                TextSpan(
                    text: "Nice",
                    style:
                        TextStyle(color: AppColors.primaryGrey, fontSize: 60)),
                TextSpan(
                    text: "\nyou're in!",
                    style:
                        TextStyle(color: AppColors.primaryGrey, fontSize: 60)),
              ])),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Material(
                    // color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Ink(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: const Text(
                            "Return to Main",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ]),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     const Icon(
              //       Icons.arrow_back_ios_rounded,
              //       color: AppColors.secondaryGrey,
              //     ),
              //     TextButton(
              //       onPressed: () {
              //         Navigator.pop(context);
              //       },
              //       child: const Text(
              //         "Back to Main",
              //         style: TextStyle(
              //           color: AppColors.secondaryGrey,
              //           decoration: TextDecoration.underline,
              //         ),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
