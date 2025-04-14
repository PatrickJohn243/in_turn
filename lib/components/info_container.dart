import 'package:flutter/material.dart';
import 'package:inturn/utils/constants/app_colors.dart';

class InfoContainer extends StatefulWidget {
  final String type;
  final String data;

  const InfoContainer({
    super.key,
    required this.type,
    required this.data,
  });

  @override
  _InfoContainerState createState() => _InfoContainerState();
}

class _InfoContainerState extends State<InfoContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Ink(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color.fromARGB(255, 229, 229, 229),
                )),
            child: SizedBox(
              width: double.infinity,
              height: 100.0,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    // mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              'Department',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Icon(
                            Icons.edit,
                            color: AppColors.secondaryGrey,
                            size: 24.0,
                          ),
                        ],
                      ),
                      Text(
                        widget.data,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
