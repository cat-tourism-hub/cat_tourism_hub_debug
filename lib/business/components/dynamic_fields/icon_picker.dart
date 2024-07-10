import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/icon_pack.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart' as iconpicker;

Future<IconData> pickIcon(BuildContext context) async {
  IconData? icon = await iconpicker
      .showIconPicker(context, iconPackModes: [IconPack.outlinedMaterial]);
  return icon ?? Icons.check;
}
