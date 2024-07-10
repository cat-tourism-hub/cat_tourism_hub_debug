import 'package:cat_tourism_hub/business/components/dynamic_fields/dynamic_sub_field.dart';
import 'package:flutter/material.dart';

class DynamicField {
  TextEditingController textController;
  IconData? selectedIcon;
  List<SubField> subFields;

  DynamicField({
    required this.textController,
    required this.selectedIcon,
    required this.subFields,
  });
}
