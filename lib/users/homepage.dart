import 'package:cat_tourism_hub/models/partner.dart';
import 'package:cat_tourism_hub/providers/partners_provider.dart';
import 'package:cat_tourism_hub/users/components/drawer.dart';
import 'package:cat_tourism_hub/users/components/partner_card.dart';
import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/material.dart';
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
  Map<String, List<Partner>> _groupPartnersByType(List<Partner> partners) {
    Map<String, List<Partner>> groupedPartners = {};

    for (var partner in partners) {
      if (!groupedPartners.containsKey(partner.type)) {
        groupedPartners[partner.type!] = [];
      }
      groupedPartners[partner.type]!.add(partner);
    }
    return groupedPartners;
  }

  List<Widget> _buildPartnerList(Map<String, List<Partner>> partnersMap) {
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
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: partners.length,
                  itemBuilder: (context, index) {
                    var partner = partners[index];
                    return PartnerCard(data: partner);
                  },
                ),
              ),
            ],
          ),
        );
      }
    });
    return partnerList;
  }

  Widget desktopView(PartnersProvider value) {
    Map<String, List<Partner>> groupedPartners =
        _groupPartnersByType(value.partners);

    Map<String, List<Partner>> filteredPartners = {};
    groupedPartners.forEach((type, partners) {
      filteredPartners[type] = partners
          .where((Partner partner) =>
              partner.name!.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appName,
            style: Theme.of(context).textTheme.headlineLarge!),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: TextButton(
              onPressed: () => context.push('/sign-in'),
              child: Text(
                AppStrings.loginRegister,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
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
              if (value.error.isNotEmpty && !value.isLoading)
                Column(
                  children: [
                    const Text('Error gathering all the happy places.'),
                    TextButton(
                        onPressed: () => value.fetchPartners(),
                        child: const Text('Try again'))
                  ],
                ),
              SizedBox(
                width: screenWidth * 0.7,
                child: value.isLoading && value.partners.isEmpty
                    ? LoadingAnimationWidget.inkDrop(
                        color: Colors.blue, size: 50)
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
    );
  }

  Widget mobileView(PartnersProvider value) {
    Map<String, List<Partner>> groupedPartners =
        _groupPartnersByType(value.partners);

    Map<String, List<Partner>> filteredPartners = {};
    groupedPartners.forEach((type, partners) {
      filteredPartners[type] = partners
          .where((Partner partner) =>
              partner.name!.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });

    return Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
            title: Text(AppStrings.appName,
                style: Theme.of(context).textTheme.headlineMedium)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding: const EdgeInsets.all(10),
                  width: screenWidth < 1000
                      ? screenWidth * 0.9
                      : screenWidth * 0.5,
                  height: 50,
                  child: SearchBar(
                    hintText: 'Search the happy island.',
                    leading: const Icon(Icons.search_outlined),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  )),
            ),
            if (value.error.isNotEmpty && !value.isLoading)
              Column(
                children: [
                  const Text('Error gathering all the happy places.'),
                  TextButton(
                      onPressed: () => value.fetchPartners(),
                      child: const Text('Try again'))
                ],
              ),
            SizedBox(
              width: screenWidth * 0.9,
              child: value.isLoading && value.partners.isEmpty
                  ? LoadingAnimationWidget.inkDrop(color: Colors.blue, size: 50)
                  : Column(
                      children: searchQuery.isEmpty
                          ? _buildPartnerList(groupedPartners)
                          : _buildPartnerList(filteredPartners),
                    ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(body: Consumer<PartnersProvider>(
      builder: (BuildContext context, PartnersProvider value, Widget? child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (screenWidth < 1000) {
              return mobileView(value);
            }
            return desktopView(value);
          },
        );
      },
    ));
  }
}
