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
        builder: (context, value, child) =>
            Container(color: Colors.blue, child: const Text('Dashboard')));
  }
}
