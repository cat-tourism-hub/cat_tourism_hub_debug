import 'package:cat_tourism_hub/dot/components/drawer.dart';
import 'package:flutter/material.dart';

class DotDashboard extends StatefulWidget {
  const DotDashboard({super.key});

  @override
  State<DotDashboard> createState() => _DotDashboardState();
}

class _DotDashboardState extends State<DotDashboard> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        drawer: const DotDrawer(),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 1000) {
              return mobileView();
            } else {
              return desktopView();
            }
          },
        ));
  }

  Widget desktopView() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scaffoldKey.currentState?.openDrawer();
    });
    return const Text('NEW TEXT');
  }

  Widget mobileView() {
    return Container();
  }
}
