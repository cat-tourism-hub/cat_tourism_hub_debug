import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar(
      {super.key,
      required this.page,
      required this.controller,
      required this.tabs,
      this.width,
      required this.mainAxisAlignment});
  final String page;
  final TabController controller;
  final List<Widget> tabs;
  final double? width;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        SizedBox(
            width: width ??
                (screenWidth < 1000 ? screenWidth * 0.9 : screenWidth * 0.6),
            child: TabBar(
              controller: controller,
              tabs: tabs,
            )),
      ],
    );
  }
}
