import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar(
      {super.key,
      required this.page,
      required this.controller,
      required this.tabs,
      required this.mainAxisAlignment});
  final String page;
  final TabController controller;
  final List<Widget> tabs;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        SizedBox(
            width: screenWidth < 1000 ? screenWidth * 0.9 : screenWidth * 0.6,
            child: TabBar(
              controller: controller,
              tabs: tabs,
              onTap: (index) {
                if (page == AppStrings.homepage && index == tabs.length - 1) {
                  // Redirect to the sign-in page if the last tab (Login) is selected
                  context.go('/sign-in');
                }
              },
            )),
      ],
    );
  }
}
