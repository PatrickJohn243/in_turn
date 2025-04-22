import 'package:flutter/material.dart';
import 'package:inturn/components/company_card.dart';
import 'package:inturn/components/company_small_card.dart';
import 'package:inturn/models/companies.dart';
import 'package:inturn/models/users.dart';
import 'package:inturn/utils/constants/app_colors.dart';
// import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  final Function(int) onTapSearch;
  final List<Companies> companies;
  final Users? user;
  const HomePage(
      {super.key,
      required this.onTapSearch,
      required this.companies,
      this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController? textController;
  FocusNode? textFieldFocusNode;
  String? choiceChipsValue;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textFieldFocusNode = FocusNode();
    choiceChipsValue = 'BSCS';
  }

  @override
  void dispose() {
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 0, 6),
            child: Container(
              width: 44,
              height: 44,

              child: Image.asset("img/logo.png"),
              // child: Padding(
              //   padding: const EdgeInsets.all(2),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(50),
              //     child: Image.network(
              //       'https://media.licdn.com/dms/image/v2/D5603AQEovRV8ocp-tg/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1728179878874?e=2147483647&v=beta&t=8NKFhkZH0e8fkxkFR1MmVjD6Qr_6b_jTtdoFHna9km8',
              //       width: 300,
              //       height: 200,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
            ),
          ),
          backgroundColor: Colors.white,
          title: Align(
            alignment: const AlignmentDirectional(-1, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user == null
                      ? 'Hey User'
                      : 'Hey ${widget.user!.firstName}',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  'Welcome to InTurn',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
              child: IconButton(
                iconSize: 40,
                icon: Icon(
                  Icons.notifications_none,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                onPressed: () {
                  print('IconButton pressed ...');
                },
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onTapSearch(1);
                  }, //
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.primary, width: 2),
                          borderRadius: BorderRadius.circular(24)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Find your company..."),
                          Icon(
                            Icons.search_rounded,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 290,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      0,
                    ),
                    scrollDirection: Axis.horizontal,
                    children: widget.companies.map((company) {
                      return Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 16, 12, 16),
                        child: CompanyCard(
                          company: company,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(width: 16),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                          child: _buildChoiceChips(),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 8,
                  thickness: 1,
                  color: AppColors.shadow,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 0, 0),
                  child: Text(
                    'Related to you',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                ListView(
                  padding: const EdgeInsets.fromLTRB(
                    0,
                    8,
                    0,
                    44,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: widget.companies.map((company) {
                    return CompanySmallCard(
                      company: company,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceChips() {
    final chips = [
      'BS in Computer Science',
      'BS in Information Technology',
      'BS in Entertainment and Multimedia Computing',
      'ENCE',
      'BSFT',
      'EE'
    ];

    return Wrap(
      spacing: 8.0,
      children: chips.map((String name) {
        return ChoiceChip(
          label: Text(name),
          selected: choiceChipsValue == name,
          onSelected: (bool selected) {
            setState(() {
              choiceChipsValue = selected ? name : null;
            });
          },
          backgroundColor: AppColors.primary,
          selectedColor: AppColors.primary,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
              color: choiceChipsValue == name ? Colors.white : Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: choiceChipsValue == name
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceVariant,
            ),
          ),
        );
      }).toList(),
    );
  }
}
