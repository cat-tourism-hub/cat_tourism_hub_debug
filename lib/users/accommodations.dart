import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/material.dart';

class AccommodationPage extends StatelessWidget {
  const AccommodationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 40),
      children: const [
        Center(
          child: Text(
            AppStrings.accommodations,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        // Add your accommodation widgets here
      ],
    );
  }
}
