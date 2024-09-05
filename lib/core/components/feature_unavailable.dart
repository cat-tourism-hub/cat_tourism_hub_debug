import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FeatureUnavailable extends StatelessWidget {
  const FeatureUnavailable({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/delete.png', width: 50, height: 50),
          const Gap(10),
          const Text('Uh oh! This feature isn\'t quite ready yet.'),
          const Gap(10),
          const Text(
              'Our team of code wizards is working their charm to bring it to life. Check back soon!')
        ],
      ),
    );
  }
}
