import 'package:cat_tourism_hub/business/components/dynamic_fields/dynamic_field.dart';
import 'package:cat_tourism_hub/business/components/dynamic_fields/image_sub_field.dart';

class DynamicFieldWithImage extends DynamicField {
  List<ImageSubField> imageSubFields;

  DynamicFieldWithImage(
      {required super.textController,
      required super.selectedIcon,
      required super.subFields,
      required this.imageSubFields});
}
