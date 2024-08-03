import 'package:flutter/material.dart';

/// Partner details
Widget infoCardLabel(BuildContext context, String text) =>
    Text(text, style: Theme.of(context).textTheme.labelMedium);

Widget cardLabel(BuildContext context, String text) =>
    Text(text, style: Theme.of(context).textTheme.bodyMedium);

Widget legalitiesLabel(BuildContext context, String text) => Text(
      text,
      style: Theme.of(context)
          .textTheme
          .headlineMedium!
          .copyWith(fontWeight: FontWeight.bold),
    );
