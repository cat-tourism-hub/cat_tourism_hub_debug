import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, this.onTap, this.headingData, this.subData});

  final void Function()? onTap;
  final String? headingData;
  final String? subData;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: onTap,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(headingData ?? '',
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(subData ?? '',
                        style: Theme.of(context).textTheme.labelLarge),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
