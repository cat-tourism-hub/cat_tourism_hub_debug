import 'package:cat_tourism_hub/core/utils/responsive.dart';
import 'package:cat_tourism_hub/users/presentation/components/drawer.dart';
import 'package:cat_tourism_hub/users/presentation/components/topnavbar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Book extends StatefulWidget {
  const Book({super.key});

  @override
  State<Book> createState() => _BookingState();
}

class _BookingState extends State<Book> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Responsive.isMobile(context)
          ? const CustomDrawer()
          : null, // Use drawer for mobile screens
      body: const Column(
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
        SizedBox(height: 20),
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
