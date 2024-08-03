import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:flutter/material.dart';

class DotDrawer extends StatelessWidget {
  const DotDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
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
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text(AppStrings.restaurants),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text(AppStrings.vehicleRentals),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text(AppStrings.delicacies),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text(AppStrings.events),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text(AppStrings.login),
                onTap: () {
                  Navigator.pushNamed(context, '/sign-in');
                },
              ),
            ],
      ),
    );
  }
}
