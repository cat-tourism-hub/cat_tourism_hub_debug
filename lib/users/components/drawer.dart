import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, this.controller});

  final TabController? controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
              SizedBox(
                height: 100,
                child: Center(
                    child: Text(
                  appName,
                  style: const TextStyle(fontSize: 20),
                )),
              ),
            ] +
            [
              ListTile(
                title: const Text(AppStrings.accommodations),
                onTap: () {
                  controller!.animateTo(0);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text(AppStrings.restaurants),
                onTap: () {
                  controller!.animateTo(1);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text(AppStrings.vehicleRentals),
                onTap: () {
                  controller!.animateTo(2);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text(AppStrings.delicacies),
                onTap: () {
                  controller!.animateTo(3);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text(AppStrings.events),
                onTap: () {
                  controller!.animateTo(4);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text(AppStrings.login),
                onTap: () {
                  context.go('/sign-in');
                },
              ),
            ],
      ),
    );
  }
}
