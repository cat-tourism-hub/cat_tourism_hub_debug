import 'package:flutter/material.dart';

class VehicleRentalsPage extends StatelessWidget {
  const VehicleRentalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 40),
      children: const [
        Center(
          child: Text(
            "Car Rentals",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        // Add your car rental widgets here
      ],
    );
  }
}
