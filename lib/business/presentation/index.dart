import 'package:cat_tourism_hub/business/presentation/components/drawer.dart';
import 'package:cat_tourism_hub/business/presentation/sections/bookings.dart';
import 'package:cat_tourism_hub/business/presentation/sections/dashboard_content.dart';
import 'package:cat_tourism_hub/business/presentation/sections/products_services/products_services.dart';
import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/admin_panel.dart';
import 'package:cat_tourism_hub/business/data/establishment.dart';
import 'package:cat_tourism_hub/business/providers/partner_acct_provider.dart';
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
    final isSmallScreen = MediaQuery.sizeOf(context).width < 1000;

    return Consumer<PartnerAcctProvider>(
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
        body: SafeArea(
          child: Row(
            children: [
              if (!isSmallScreen)
                BusinessDrawer(
                  establishment: value.establishment!,
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
                          return const AdminPanel();
                        case 2:
                          return const ProductsServices();
                        case 3:
                          return const Bookings();
                        case 4:
                          return const Bookings();
                        case 5:
                          return const Bookings();
                        default:
                          return const Center(
                            child: Text(
                              'Home',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
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
      ),
    );
  }
}
// import 'package:cat_tourism_hub/business/components/sidenav.dart';
// import 'package:cat_tourism_hub/business/sections/bookings.dart';
// import 'package:cat_tourism_hub/business/sections/dashboard_content.dart';
// import 'package:cat_tourism_hub/business/sections/products_services.dart';
// import 'package:cat_tourism_hub/business/sections/admin_panel.dart';
// import 'package:cat_tourism_hub/models/establishment.dart';
// import 'package:cat_tourism_hub/providers/partner_acct_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class Index extends StatefulWidget {
//   const Index({super.key, this.establishment});
//   final Establishment? establishment;

//   @override
//   State<Index> createState() => _IndexState();
// }

// class _IndexState extends State<Index> {
//   int _selectedIndex = 0; // Add this line to manage the index

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<PartnerAcctProvider>(
//       builder: (context, value, child) => Scaffold(
//         appBar: AppBar(
//           title: Text(value.establishment!.name!),
//         ),
//         body: Row(
//           children: [
//             BusinessNavigationRail(
//               establishment: value.establishment!,
//               // Pass a callback function to update _selectedIndex
//               onDestinationChanged: (index) {
//                 setState(() {
//                   _selectedIndex = index;
//                 });
//               },
//             ),
//             const VerticalDivider(thickness: 1, width: 1),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: IndexedStack(
//                   index: _selectedIndex, // Use the updated _selectedIndex
//                   children: const [
//                     DashboardContent(),
//                     AdminPanel(),
//                     ProductsServices(),
//                     Bookings(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
