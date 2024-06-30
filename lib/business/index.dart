import 'package:cat_tourism_hub/business/components/drawer.dart';
import 'package:cat_tourism_hub/business/sections/dashboard_content.dart';
import 'package:cat_tourism_hub/business/sections/menu_section.dart';
import 'package:cat_tourism_hub/business/sections/not_found.dart';
import 'package:cat_tourism_hub/business/sections/rooms_section.dart';
import 'package:cat_tourism_hub/business/sections/setup.dart';
import 'package:cat_tourism_hub/business/sections/vehicle_rentals.dart';
import 'package:cat_tourism_hub/models/establishment.dart';
import 'package:cat_tourism_hub/providers/establishment_provider.dart';
import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';

class Index extends StatefulWidget {
  const Index({super.key, this.establishment});
  final Establishment? establishment;

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  final _key = GlobalKey<ScaffoldState>();
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  void initState() {
    super.initState();

    // Listen for changes in the controller
    _controller.addListener(() {
      if (_key.currentState?.isDrawerOpen == true) {
        _key.currentState?.closeDrawer();
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 1000;

    return Consumer<EstablishmentProvider>(
      builder: (context, value, child) => Scaffold(
        key: _key,
        appBar: isSmallScreen
            ? AppBar(
                title: Text(value.establishment!.name!),
                leading: IconButton(
                  onPressed: () {
                    _key.currentState?.openDrawer();
                  },
                  icon: const Icon(Icons.menu),
                ),
              )
            : null,
        drawer: BusinessDrawer(
          establishment: value.establishment!,
          controller: _controller,
        ),
        body: Row(
          children: [
            if (!isSmallScreen)
              BusinessDrawer(
                establishment: widget.establishment!,
                controller: _controller,
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    switch (_controller.selectedIndex) {
                      case 0:
                        return const DashboardContent();
                      case 1:
                        return const Setup();
                      case 2:
                        return value.establishment?.type ==
                                    AppStrings.restaurants ||
                                value.establishment?.type ==
                                    AppStrings.hotelAndResto
                            ? const MenuSection()
                            : value.establishment?.type ==
                                    AppStrings.accommodations
                                ? const RoomSection()
                                : const VehicleRentals();
                      case 3:
                        return value.establishment?.type ==
                                AppStrings.hotelAndResto
                            ? const RoomSection()
                            : const NotFound();
                      case 4:
                        return const VehicleRentals();
                      default:
                        return const Center(
                          child: Text(
                            'Home',
                            style: TextStyle(color: Colors.white, fontSize: 40),
                          ),
                        );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
