import 'package:cat_tourism_hub/business/sections/subsections/partner_details.dart';
import 'package:cat_tourism_hub/business/sections/subsections/policies.dart';
import 'package:cat_tourism_hub/business/sections/subsections/services_amenities.dart';
import 'package:cat_tourism_hub/users/components/content_view.dart';
import 'package:cat_tourism_hub/users/components/custom_tab.dart';
import 'package:cat_tourism_hub/users/components/custom_tab_bar.dart';
import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/material.dart';

class Setup extends StatefulWidget {
  const Setup({super.key});

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> with SingleTickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? controller;

  List<ContentView> contentViews = [
    ContentView(
        tab: const CustomTab(title: AppStrings.partnerDetails),
        content: const PartnerDetails()),
    ContentView(
        tab: const CustomTab(title: AppStrings.servicesAndAmenities),
        content: const ServicesAndAmenities()),
    ContentView(
        tab: const CustomTab(title: AppStrings.policies),
        content: const Policies()),
  ];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: contentViews.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTabBar(
            page: '',
            mainAxisAlignment: MainAxisAlignment.center,
            controller: controller!,
            tabs: [
              ...contentViews.map((e) => e.tab),
            ]),
        Expanded(
          child: SizedBox(
              child: TabBarView(controller: controller, children: [
            ...contentViews.map((e) => e.content),
          ])),
        ),
      ],
    );
  }
}
