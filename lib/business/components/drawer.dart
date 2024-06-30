import 'package:cat_tourism_hub/models/establishment.dart';
import 'package:cat_tourism_hub/auth/auth_provider.dart';
import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidebarx/sidebarx.dart';

class BusinessDrawer extends StatelessWidget {
  const BusinessDrawer(
      {super.key, required this.establishment, required this.controller});

  final Establishment establishment;
  final SidebarXController controller;

  List<SidebarXItem> getSidebarItems(
      Establishment establishment, SidebarXController controller) {
    return [
      SidebarXItem(
        icon: Icons.dashboard_rounded,
        label: 'Dashboard',
        onTap: () => controller.selectIndex(0),
      ),
      SidebarXItem(
        icon: Icons.admin_panel_settings,
        label: 'Admin Panel',
        onTap: () => controller.selectIndex(1),
      ),
      if (establishment.type == AppStrings.restaurants ||
          establishment.type == AppStrings.hotelAndResto)
        SidebarXItem(
          icon: Icons.menu_book_rounded,
          label: 'Menu',
          onTap: () => controller.selectIndex(2),
        ),
      if (establishment.type == AppStrings.accommodations ||
          establishment.type == AppStrings.hotelAndResto)
        SidebarXItem(
          icon: Icons.blur_linear,
          label: 'Rooms',
          onTap: () => controller.selectIndex(3),
        ),
      if (establishment.type == AppStrings.vehicleRentals)
        SidebarXItem(
          icon: Icons.car_rental,
          label: 'Vehicles',
          onTap: () => controller.selectIndex(4),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: controller,
      extendedTheme: const SidebarXTheme(width: 300),
      headerBuilder: (context, extended) => SizedBox(
        height: 150,
        child: Center(
          child: Image.network(
            establishment.banner!,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Text('Failed to load image'));
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
      ),
      items: getSidebarItems(establishment, controller),
      footerDivider: const Divider(),
      footerBuilder: (context, extended) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: extended ? 30 : 20,
                  child: ClipOval(
                    child: Image.network(
                      establishment.logo!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                            child: Text('Failed to load image'));
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                            color: Colors.blue,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              extended
                  ? Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(establishment.name ?? ''),
                          Text(establishment.contact?['email']),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
          extended
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        AuthenticationProvider().signOut();
                      },
                      child: const Text('Logout'),
                    ),
                  ),
                )
              : IconButton(
                  onPressed: () async {
                    await AuthenticationProvider().signOut();
                    if (!context.mounted) return;
                    context.go('/');
                  },
                  icon: const Icon(Icons.logout))
        ],
      ),
    );
  }
}
