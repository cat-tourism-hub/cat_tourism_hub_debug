import 'package:cat_tourism_hub/business/components/dynamic_fields/dynamic_field.dart';
import 'package:cat_tourism_hub/business/components/dynamic_fields/image_sub_field.dart';
import 'package:flutter/material.dart';

class DynamicFieldWithImage extends DynamicField {
  List<ImageSubField> imageSubFields;

  DynamicFieldWithImage(
      {required super.textController,
      super.selectedIcon,
      required super.subFields,
      required this.imageSubFields});

  DynamicFieldWithImage clone() {
    return DynamicFieldWithImage(
      textController: TextEditingController(text: textController.text),
      selectedIcon: selectedIcon,
      subFields: subFields.map((subField) => subField.clone()).toList(),
      imageSubFields:
          imageSubFields.map((imageSubField) => imageSubField.clone()).toList(),
    );
  }

  bool equals(DynamicFieldWithImage other) {
    if (textController.text != other.textController.text ||
        selectedIcon != other.selectedIcon ||
        subFields.length != other.subFields.length ||
        imageSubFields.length != other.imageSubFields.length) {
      return false;
    }

    for (int i = 0; i < subFields.length; i++) {
      if (!subFields[i].equals(other.subFields[i])) {
        return false;
      }
    }

    for (int i = 0; i < imageSubFields.length; i++) {
      if (!imageSubFields[i].equals(other.imageSubFields[i])) {
        return false;
      }
    }

    return true;
  }
}
