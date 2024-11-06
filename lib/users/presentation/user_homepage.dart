import 'package:cat_tourism_hub/core/auth/auth_provider.dart';
import 'package:cat_tourism_hub/core/utils/responsive.dart';
import 'package:cat_tourism_hub/users/presentation/components/topnavbar.dart';
import 'package:cat_tourism_hub/users/presentation/components/user_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';

class UserHomepage extends StatefulWidget {
  const UserHomepage({super.key});

  @override
  State<UserHomepage> createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> {
  User? user;
  final _key = GlobalKey<ScaffoldState>();
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final auth = Provider.of<AuthenticationProvider>(context, listen: false);
    user = auth.user;
    super.initState();
    // Listen for changes in the controller
    _controller.addListener(() {
      if (_key.currentState?.isDrawerOpen == true) {
        _key.currentState?.closeDrawer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Responsive.isMobile(context)
          ? UserDrawer(
              user: user!,
              controller: _controller,
            )
          : null, // Use drawer for mobile screens
      body: Row(
        children: [
          // Show the Sidebar for desktop and tablet
          if (!Responsive.isMobile(context))
            UserDrawer(
              user: user!,
              controller: _controller,
            ),
          // Main Content
          const Expanded(
            child: Column(
              children: [
                TopNavbar(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Responsive(
                      mobile: MobileLayout(),
                      tablet: TabletLayout(),
                      desktop: DesktopLayout(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // FileCardsRow(), // Row of cards at the top
        Gap(20),
        Expanded(
          child: Row(
            children: [
              // Expanded(flex: 3, child: RecentFilesWidget()),
              Gap(20),
              // Expanded(flex: 2, child: StorageDetailsWidget()),
            ],
          ),
        ),
      ],
    );
  }
}

class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // FileCardsRow(), // Display cards in a row
        SizedBox(height: 20),
        Expanded(
          child: Row(
            children: [
              // Expanded(flex: 2, child: RecentFilesWidget()),
              Gap(20),
              // Expanded(flex: 1, child: StorageDetailsWidget()),
            ],
          ),
        ),
      ],
    );
  }
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          // FileCardsColumn(), // Stack cards vertically for mobile
          Gap(20),
          // RecentFilesWidget(),
          Gap(20),
          // StorageDetailsWidget(),
        ],
      ),
    );
  }
}
