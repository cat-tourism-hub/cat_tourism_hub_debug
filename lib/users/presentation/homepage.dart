import 'package:cat_tourism_hub/business/data/establishment.dart';
import 'package:cat_tourism_hub/core/components/loading_widget.dart';
import 'package:cat_tourism_hub/users/presentation/components/topbar.dart';
import 'package:cat_tourism_hub/users/providers/partners_provider.dart';
import 'package:cat_tourism_hub/users/presentation/components/drawer.dart';
import 'package:cat_tourism_hub/users/presentation/components/partner_card.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? controller;
  double screenHeight = 0;
  double screenWidth = 0;
  String searchQuery = '';
  late PartnersProvider provider;

  @override
  void initState() {
    super.initState();
    final partnerProvider =
        Provider.of<PartnersProvider>(context, listen: false);
    partnerProvider.fetchPartners();
  }

  /// The function `_groupPartnersByType` takes a list of Partner objects and groups them by their type
  /// into a Map.
  ///
  /// Args:
  ///   partners (List<Partner>): The function `_groupPartnersByType` takes a list of `Partner` objects as
  /// input and groups them based on their type. It creates a map where the keys are the partner types and
  /// the values are lists of partners belonging to that type.
  ///
  /// Returns:
  ///   The function `_groupPartnersByType` returns a `Map` where the keys are `String` representing the
  /// type of partners, and the values are `List<Partner>` containing the partners grouped by their type.
  Map<String, List<Establishment>> _groupPartnersByType(
      List<Establishment> partners) {
    Map<String, List<Establishment>> groupedPartners = {};

    for (var partner in partners) {
      if (!groupedPartners.containsKey(partner.type)) {
        groupedPartners[partner.type!] = [];
      }
      groupedPartners[partner.type]!.add(partner);
    }
    return groupedPartners;
  }

  List<Widget> _buildPartnerList(Map<String, List<Establishment>> partnersMap) {
    List<Widget> partnerList = [];
    partnersMap.forEach((type, partners) {
      if (searchQuery.isEmpty || partners.isNotEmpty) {
        partnerList.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  type,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  scrollDirection: Axis.horizontal,
                  itemCount: partners.length,
                  itemBuilder: (context, index) {
                    var partner = partners[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: PartnerCard(
                        data: partner,
                        onTap: () {
                          context.go('/${partner.name}', extra: partner);
                        },
                      ),
                    );
                  },
                ),
              ),
              const Gap(20)
            ],
          ),
        );
      }
    });
    return partnerList;
  }

  Widget _desktopView(PartnersProvider value) {
    Map<String, List<Establishment>> groupedPartners =
        _groupPartnersByType(value.partners);

    Map<String, List<Establishment>> filteredPartners = {};
    groupedPartners.forEach((type, partners) {
      filteredPartners[type] = partners
          .where((Establishment partner) =>
              partner.name!.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });

    return Scaffold(
      appBar: const Topbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/dot_catanduanes.jpg',
                      width: screenWidth,
                      height: screenHeight * 0.6,
                      fit: BoxFit.fitHeight,
                    ),
                    Center(
                      child: SizedBox(
                          width: screenWidth < 1000
                              ? screenWidth * 0.9
                              : screenWidth * 0.5,
                          child: Opacity(
                            opacity: 0.9,
                            child: SearchBar(
                              hintText: 'Search the happy island.',
                              leading: const Icon(Icons.search_outlined),
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                            ),
                          )),
                    ),
                  ],
                ),
                if (value.error.isNotEmpty &&
                    !value.isLoading &&
                    value.partners.isEmpty)
                  _errorMsg(value),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: screenWidth * 0.7,
                  child: value.isLoading && value.partners.isEmpty
                      ? LoadingWidget(screenWidth: screenWidth)
                      : Column(
                          children: searchQuery.isEmpty
                              ? _buildPartnerList(groupedPartners)
                              : _buildPartnerList(filteredPartners),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Error message when fetching timed out.
  Widget _errorMsg(PartnersProvider value) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(value.error, textAlign: TextAlign.center),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  value.fetchPartners();
                });
              },
              child: const Text(AppStrings.tryAgain))
        ],
      ),
    );
  }

  Widget _mobileView(PartnersProvider value) {
    Map<String, List<Establishment>> groupedPartners =
        _groupPartnersByType(value.partners);

    Map<String, List<Establishment>> filteredPartners = {};
    groupedPartners.forEach((type, partners) {
      filteredPartners[type] = partners
          .where((Establishment partner) =>
              partner.name!.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => value.fetchPartners(),
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.all(10),
                width:
                    screenWidth < 1000 ? screenWidth * 0.9 : screenWidth * 0.5,
                height: 50,
                child: SearchBar(
                  hintText: AppStrings.searchTheHappyIsland,
                  leading: const Icon(Icons.search_outlined),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
            ),
            if (value.error.isNotEmpty &&
                !value.isLoading &&
                value.partners.isEmpty)
              _errorMsg(value),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: screenWidth * 0.9,
                    child: value.isLoading && value.partners.isEmpty
                        ? Align(
                            alignment: Alignment.center,
                            child: LoadingAnimationWidget.inkDrop(
                              color: Theme.of(context).indicatorColor,
                              size: 50,
                            ),
                          )
                        : Column(
                            children: searchQuery.isEmpty
                                ? _buildPartnerList(groupedPartners)
                                : _buildPartnerList(filteredPartners),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.sizeOf(context).height;
    screenWidth = MediaQuery.sizeOf(context).width;
    return Consumer<PartnersProvider>(
      builder: (BuildContext context, PartnersProvider value, Widget? child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (screenWidth < 1000) {
              return _mobileView(value);
            }
            return _desktopView(value);
          },
        );
      },
    );
  }
}
