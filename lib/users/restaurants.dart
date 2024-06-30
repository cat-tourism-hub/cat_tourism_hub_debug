import 'package:flutter/material.dart';

class RestaurantsPage extends StatelessWidget {
  const RestaurantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 40),
      children: const [
        Center(
          child: Text(
            "Restaurants to Dine!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        // Add your restaurant widgets here
      ],
    );
  }
}
