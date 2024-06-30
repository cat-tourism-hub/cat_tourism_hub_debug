import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/material.dart';

class Policies extends StatefulWidget {
  const Policies({super.key});

  @override
  State<Policies> createState() => _PoliciesState();
}

class _PoliciesState extends State<Policies> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(AppStrings.policies),
    );
  }
}
