import 'package:flutter/material.dart';

class SubField {
  TextEditingController textController;
  IconData? selectedIcon;

  SubField({
    required this.textController,
    this.selectedIcon,
  });

  SubField clone() {
    return SubField(
      textController: TextEditingController(text: textController.text),
      selectedIcon: selectedIcon,
    );
  }

  bool equals(SubField other) {
    return textController.text == other.textController.text &&
        selectedIcon == other.selectedIcon;
  }
}
