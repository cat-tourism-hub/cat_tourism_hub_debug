import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/components/dynamic_fields/dynamic_sub_field.dart';
import 'package:flutter/material.dart';

class DynamicField {
  TextEditingController textController;
  IconData? selectedIcon;
  List<SubField> subFields;

  DynamicField({
    required this.textController,
    this.selectedIcon,
    required this.subFields,
  });

  DynamicField clone() {
    return DynamicField(
      textController: TextEditingController(text: textController.text),
      selectedIcon: selectedIcon,
      subFields: subFields.map((subField) => subField.clone()).toList(),
    );
  }

  bool equals(DynamicField other) {
    if (textController.text != other.textController.text ||
        selectedIcon != other.selectedIcon ||
        subFields.length != other.subFields.length) {
      return false;
    }

    for (int i = 0; i < subFields.length; i++) {
      if (!subFields[i].equals(other.subFields[i])) {
        return false;
      }
    }

    return true;
  }
}
