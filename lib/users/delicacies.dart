import 'package:flutter/material.dart';

class DelicaciesPage extends StatelessWidget {
  const DelicaciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 40),
      children: const [
        Center(
          child: Text(
            "Delicacies",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        // Add your event widgets here
      ],
    );
  }
}
