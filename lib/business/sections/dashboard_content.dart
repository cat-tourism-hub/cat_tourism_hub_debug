import 'package:cat_tourism_hub/providers/establishment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EstablishmentProvider>(
      builder: (context, value, child) => const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Flexible(child: BusinessDataCard(data: 'Card 1')),
              // SizedBox(width: 8), // Optional spacing between cards
              // Flexible(child: BusinessDataCard(data: 'Card 2')),
              // SizedBox(width: 8), // Optional spacing between cards
              // Flexible(child: BusinessDataCard(data: 'Card 3')),
              // SizedBox(width: 8), // Optional spacing between cards
              // Flexible(child: BusinessDataCard(data: 'Card 4')),
            ],
          )
        ],
      ),
    );
  }
}
