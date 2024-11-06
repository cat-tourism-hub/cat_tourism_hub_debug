import 'package:cat_tourism_hub/core/auth/auth_provider.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Topbar extends StatelessWidget implements PreferredSizeWidget {
  const Topbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(AppStrings.appName,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.bold)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 40),
          child: ValueListenableBuilder<User?>(
            valueListenable:
                context.watch<AuthenticationProvider>().currentUser,
            builder: (context, user, child) {
              // Check if user is logged in
              if (user != null) {
                return Text(
                  user.email ?? '',
                  style: Theme.of(context).textTheme.labelMedium,
                );
              } else {
                return TextButton(
                  onPressed: () {
                    (kIsWeb || kIsWasm)
                        ? context.go('/sign-in')
                        : context.push('/sign-in');
                  },
                  child: Text(
                    AppStrings.loginRegister,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 60);
}
