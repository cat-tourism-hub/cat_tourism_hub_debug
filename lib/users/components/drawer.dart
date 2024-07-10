import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, this.controller});

  final TabController? controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          DrawerHeader(
            child: Image.asset(
              'assets/images/dot_catanduanes.jpg',
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Failed to load image'));
              },
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) {
                  return child;
                }
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: frame == null
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        )
                      : child,
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text(AppStrings.home),
            onTap: () {
              context.go('/');
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.policy_outlined),
            title: const Text(AppStrings.termsOfUse),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text(AppStrings.privacyPolicy),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.login_outlined),
            title: const Text(AppStrings.loginRegister),
            onTap: () {
              context.push('/sign-in');
            },
          ),
        ],
      ),
    );
  }
}
