import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/components/partner_details/partner_info.dart';
import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/policies.dart';
import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/facilities_amenities.dart';
import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/components/content_view.dart';
import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/components/custom_tab.dart';
import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/components/custom_tab_bar.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel>
    with SingleTickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? controller;

  List<ContentView> contentViews = [
    ContentView(
        tab: const CustomTab(title: AppStrings.partnerDetails),
        content: const PartnerInfo()),
    ContentView(
        tab: const CustomTab(title: AppStrings.facilitiesAndAmenities),
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
