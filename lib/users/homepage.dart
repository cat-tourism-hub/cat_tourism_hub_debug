import 'package:cat_tourism_hub/users/accommodations.dart';
import 'package:cat_tourism_hub/users/components/content_view.dart';
import 'package:cat_tourism_hub/users/components/custom_tab.dart';
import 'package:cat_tourism_hub/users/components/custom_tab_bar.dart';
import 'package:cat_tourism_hub/users/components/drawer.dart';
import 'package:cat_tourism_hub/users/delicacies.dart';
import 'package:cat_tourism_hub/users/events.dart';
import 'package:cat_tourism_hub/users/rentals.dart';
import 'package:cat_tourism_hub/users/restaurants.dart';
import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? controller;
  double screenHeight = 0;
  double screenWidth = 0;
  List<ContentView> contentViews = [
    ContentView(
        tab: const CustomTab(title: AppStrings.accommodations),
        content: const AccommodationPage()),
    ContentView(
        tab: const CustomTab(title: AppStrings.restaurants),
        content: const RestaurantsPage()),
    ContentView(
        tab: const CustomTab(title: AppStrings.vehicleRentals),
        content: const VehicleRentalsPage()),
    ContentView(
        tab: const CustomTab(title: AppStrings.delicacies),
        content: const DelicaciesPage()),
    ContentView(
        tab: const CustomTab(title: AppStrings.events),
        content: const EventsPage()),
  ];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: contentViews.length + 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      endDrawer: CustomDrawer(controller: controller),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 1000) {
            return mobileView();
          } else {
            return desktopView();
          }
        },
      ),
    );
  }

  Widget desktopView() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTabBar(
            page: 'Homepage',
            mainAxisAlignment: MainAxisAlignment.end,
            controller: controller!,
            tabs: [
              ...contentViews.map((e) => e.tab),
              const CustomTab(title: AppStrings.login)
            ]),
        SizedBox(
            height: screenHeight * 0.9,
            child: TabBarView(controller: controller, children: [
              ...contentViews.map((e) => e.content),
              // Login Tab content is empty as we handle navigation separately
              Container()
            ])),
      ],
    );
  }

  Widget mobileView() {
    return Padding(
      padding: EdgeInsets.only(
          left: screenWidth * 0.05, right: screenWidth * 0.05, top: 30),
      child: SizedBox(
        width: screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
                iconSize: screenWidth * 0.04,
                onPressed: () => scaffoldKey.currentState!.openEndDrawer(),
                icon: const Icon(Icons.menu_rounded)),
            Expanded(
              child: TabBarView(controller: controller!, children: [
                const AccommodationPage(),
                const RestaurantsPage(),
                const VehicleRentalsPage(),
                const DelicaciesPage(),
                const EventsPage(),
                Container(), // Login Tab content is empty as we handle navigation separately
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
