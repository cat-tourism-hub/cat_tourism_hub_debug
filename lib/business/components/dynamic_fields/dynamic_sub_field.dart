import 'package:flutter/material.dart';

class SubField {
  TextEditingController textController;
  IconData? selectedIcon;

  SubField({
    required this.textController,
    this.selectedIcon,
  });
}
