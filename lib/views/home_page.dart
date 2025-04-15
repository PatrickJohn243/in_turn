import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 0, 6),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    'https://media.licdn.com/dms/image/v2/D5603AQEovRV8ocp-tg/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1728179878874?e=2147483647&v=beta&t=8NKFhkZH0e8fkxkFR1MmVjD6Qr_6b_jTtdoFHna9km8',
                    width: 300,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          title: Align(
            alignment: const AlignmentDirectional(-1, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hey Brent',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Welcome to InTurn',
                  style: Theme.of(context).textTheme.labelMedium,
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
                  child: TextFormField(
                    controller: textController,
                    focusNode: textFieldFocusNode,
                    autofocus: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Search all companies...',
                      labelStyle: Theme.of(context).textTheme.labelMedium,
                      hintStyle: Theme.of(context).textTheme.labelMedium,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
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
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                      suffixIcon: const Icon(
                        Icons.search_rounded,
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 290,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.2),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      0,
                    ),
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 16, 12, 16),
                        child: _buildCompanyCard(
                          context,
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKC0njLfz3XNGfVScLEz0OkkReDXJzDvhXEA&s',
                          'Holysoft Studios Philippines',
                          'Game Dev',
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
                        child: _buildCompanyCard(
                          context,
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKlsfyOooFV_pU4aWCwDobp5QksJZHWBNb1A&s',
                          'Accenture: Philippines',
                          'BPO',
                        ),
                      ),
                    ],
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
                Divider(
                  height: 8,
                  thickness: 1,
                  color: Theme.of(context).dividerColor,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 0, 0),
                  child: Text(
                    'Popular Today',
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
                  children: [
                    _buildListItem(
                      context,
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZq4dgIJBLfPGKBc7C0SgB8fr5akFvjwXRJg&s',
                      'Ubiquity Global Services',
                      'BPO',
                    ),
                    _buildListItem(
                      context,
                      'https://media.licdn.com/dms/image/v2/C5603AQFe0oWAgPnHZQ/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1617030666332?e=2147483647&v=beta&t=roFjhqpv-u9PnDdn9x--LC0QahM1iIsMecrg6RFO414',
                      'KYOCERA Document Solutions Development Philippines, Inc.',
                      'IT Services',
                    ),
                    _buildListItem(
                      context,
                      'https://scontent.fceb1-5.fna.fbcdn.net/v/t39.30808-6/305034776_514529540678628_2212971473121609761_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeGRk31q2YmQRriANXukqBgVv9tIF4nIpPG_20gXicik8SWjqYV4CUxyCtryB9Rlw77w_aQbSBFseq3t_hqNoZqH&_nc_ohc=rkzW1RcsfrQAX_RdRm0&_nc_oc=AQmxYwPDX2P3YLFDQnVGEUx_fxQs&_nc_zt=23&_nc_ht=scontent.fceb1-5.fna&oh=00_AfCPHh1tjgdLVUGwWJaFq3fKXp6jxC-4I9YrU9B3DZ2lbA&oe=6488B8A2',
                      'Green Module Systems',
                      'App Development',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, String imageUrl,
      String companyName, String category) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      imageUrl,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 4, 4),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    companyName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                    child: Wrap(
                      spacing: 0,
                      runSpacing: 0,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      runAlignment: WrapAlignment.start,
                      verticalDirection: VerticalDirection.down,
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                          child: Text(
                            category,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                          child: Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                            size: 16,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                          child: Text(
                            '24',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                        Text(
                          '12h',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                          child: Icon(
                            Icons.keyboard_control_rounded,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceChips() {
    final chips = ['BSCS', 'BSIT', 'BSEMC', 'ENCE', 'BSFT', 'EE'];

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
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          selectedColor: Theme.of(context).colorScheme.primary,
          labelStyle: TextStyle(
            color: choiceChipsValue == name
                ? Colors.white
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
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

  Widget _buildListItem(BuildContext context, String imageUrl,
      String companyName, String category) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 12, 0),
                            child: Text(
                              category,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 4, 0),
                            child: Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                              size: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 16, 0),
                            child: Text(
                              '24',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '12h',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 4, 0),
                            child: Icon(
                              Icons.keyboard_control_rounded,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 8, 12, 0),
                      child: Text(
                        'See Profile',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
