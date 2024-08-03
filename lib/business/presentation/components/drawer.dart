import 'package:cat_tourism_hub/business/data/establishment.dart';
import 'package:cat_tourism_hub/core/utils/auth_provider.dart';
import 'package:cat_tourism_hub/core/utils/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidebarx/sidebarx.dart';

class BusinessDrawer extends StatelessWidget {
  const BusinessDrawer(
      {super.key, required this.establishment, required this.controller});

  final Establishment establishment;
  final SidebarXController controller;

  List<SidebarXItem> getSidebarItems(SidebarXController controller) {
    return [
      SidebarXItem(
        icon: Icons.dashboard_outlined,
        label: 'Dashboard',
        onTap: () => controller.selectIndex(0),
      ),
      SidebarXItem(
        icon: Icons.admin_panel_settings_outlined,
        label: 'Admin Panel',
        onTap: () => controller.selectIndex(1),
      ),
      SidebarXItem(
        icon: Icons.category_outlined,
        label: 'Products/Services',
        onTap: () => controller.selectIndex(2),
      ),
      SidebarXItem(
        icon: Icons.confirmation_num_outlined,
        label: 'Bookings',
        onTap: () => controller.selectIndex(3),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: controller,
      extendedTheme: const SidebarXTheme(width: 300),
      headerBuilder: (context, extended) {
        return extended
            ? SafeArea(
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Center(
                    child: CachedImage(
                      imageUrl: establishment.banner ?? '',
                      imageFit: BoxFit.cover,
                      imageWidth: double.maxFinite,
                    ),
                    // child: FutureBuilder<String>(
                    //   future: getDownloadUrl(establishment.banner ?? ''),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState == ConnectionState.done) {
                    //       if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    //         return CachedNetworkImage(
                    //           fit: BoxFit.cover,
                    //           width: double.maxFinite,
                    //           imageUrl: snapshot.data!,
                    //           errorWidget: (context, url, error) =>
                    //               const Icon(Icons.error),
                    //         );
                    //       } else {
                    //         return const Text('Failed to load image');
                    //       }
                    //     }
                    //     return Center(
                    //       child: LoadingAnimationWidget.waveDots(
                    //           color: Colors.blue, size: 30),
                    //     );
                    //   },
                    // ),
                  ),
                ),
              )
            : const SizedBox(height: 150);
      },
      items: getSidebarItems(controller),
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
                    child: CachedImage(
                      imageUrl: establishment.logo ?? '',
                    ),
                    // child: FutureBuilder<String>(
                    //   future: getDownloadUrl(establishment.logo ?? ''),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState == ConnectionState.done) {
                    //       if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    //         return CachedNetworkImage(
                    //           fit: BoxFit.cover,
                    //           imageUrl: snapshot.data!,
                    //           errorWidget: (context, url, error) =>
                    //               const Icon(Icons.error),
                    //         );
                    //       } else {
                    //         return const Icon(Icons.error, color: Colors.red);
                    //       }
                    //     }
                    //     return Center(
                    //       child: LoadingAnimationWidget.waveDots(
                    //           color: Colors.blue, size: 30),
                    //     );
                    //   },
                    // ),
                  ),
                ),
              ),
              extended
                  ? Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(establishment.name ?? ''),
                          Text(establishment.contact?['email'] ?? ''),
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
                        context.go('/homepage');
                      },
                      child: const Text('Logout'),
                    ),
                  ),
                )
              : IconButton(
                  onPressed: () {
                    AuthenticationProvider().signOut();
                    context.go('/');
                  },
                  icon: const Icon(Icons.logout),
                )
        ],
      ),
    );
  }
}
