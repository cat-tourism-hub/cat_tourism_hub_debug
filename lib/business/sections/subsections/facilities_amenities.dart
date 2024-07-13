import 'dart:io';

import 'package:cat_tourism_hub/auth/auth_provider.dart';
import 'package:cat_tourism_hub/business/components/dynamic_fields/icon_textfield.dart';
import 'package:cat_tourism_hub/models/photo.dart';
import 'package:cat_tourism_hub/providers/establishment_provider.dart';
import 'package:cat_tourism_hub/business/components/dynamic_fields/dynamic_field.dart';
import 'package:cat_tourism_hub/business/components/dynamic_fields/dynamic_field_with_image.dart';
import 'package:cat_tourism_hub/business/components/dynamic_fields/dynamic_sub_field.dart';
import 'package:cat_tourism_hub/business/components/dynamic_fields/icon_picker.dart';
import 'package:cat_tourism_hub/business/components/dynamic_fields/image_sub_field.dart';
import 'package:cat_tourism_hub/utils/image_picker.dart';
import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ServicesAndAmenities extends StatefulWidget {
  const ServicesAndAmenities({super.key});

  @override
  State<ServicesAndAmenities> createState() => _ServicesAndAmenitiesState();
}

class _ServicesAndAmenitiesState extends State<ServicesAndAmenities> {
  final _formKey = GlobalKey<FormState>();
  final List<DynamicFieldWithImage> _dynamicFields = [];
  final ImagePicker _picker = ImagePicker();

  void _addNewField() {
    setState(() {
      _dynamicFields.add(
        DynamicFieldWithImage(
          textController: TextEditingController(),
          selectedIcon: null,
          subFields: [],
          imageSubFields: [],
        ),
      );
    });
  }

  void _addNewSubField(DynamicField parentField) {
    setState(() {
      parentField.subFields.add(
        SubField(
          textController: TextEditingController(),
          selectedIcon: null,
        ),
      );
    });
  }

  void _addImageSubField(DynamicFieldWithImage parentField) {
    setState(() {
      parentField.imageSubFields.add(ImageSubField());
    });
  }

  Future<void> _pickSingleImage(ImageSubField imageSubField) async {
    Photo? photo = await pickSingleImage(_picker);
    if (photo != null) {
      setState(() {
        imageSubField.image = photo;
      });
    }
  }

  Future<void> _saveData(
    String uid,
    dynamic value2,
    String token,
  ) async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        _formKey.currentState?.save();

        List<Map<String, dynamic>> dynamicFieldsData = [];

        for (var field in _dynamicFields) {
          final text = field.textController.text;
          final icon = serializeIcon(field.selectedIcon ?? Icons.check,
              iconPack: IconPack.allMaterial);

          final subFields = field.subFields.map((subField) {
            final subFieldIconData = serializeIcon(
                subField.selectedIcon ?? Icons.check,
                iconPack: IconPack.allMaterial);
            return {
              'text': subField.textController.text,
              'icon': subFieldIconData,
            };
          }).toList();

          final imageSubFields = field.imageSubFields
              .where((imageSubField) => imageSubField.image != null)
              .map((imageSubField) => Photo(
                  path: imageSubField.image!.path,
                  title: imageSubField.image?.title,
                  webImage: imageSubField.image?.webImage))
              .toList();

          dynamicFieldsData.add({
            'heading': text,
            'icon': icon,
            'subFields': subFields,
            'imageSubFields': imageSubFields,
          });
        }

        await value2.saveServiceAndAmenities(dynamicFieldsData, uid, token);
      }
    } catch (e) {
      debugPrint('ERRROR: ${e.toString()}');
    }
  }

  List<Widget> _buildFields() {
    return _dynamicFields.map((field) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconField(
            labelText: AppStrings.headingText,
            selectedIcon: field.selectedIcon,
            textController: field.textController,
            onIconPicker: () async {
              IconData icon = await pickIcon(context);
              setState(() {
                field.selectedIcon = icon;
              });
            },
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 2, // Space between columns
              mainAxisSpacing: 10, // Space between rows
              childAspectRatio: (MediaQuery.of(context).size.width / 2 - 30) /
                  50, // Adjust the height as needed
            ),
            itemCount: field.subFields.length,
            itemBuilder: (context, index) {
              final subField = field.subFields[index];
              return Padding(
                padding: const EdgeInsets.only(left: 20),
                child: IconField(
                  labelText: AppStrings.subText,
                  textController: subField.textController,
                  selectedIcon: subField.selectedIcon,
                  onIconPicker: () async {
                    IconData icon = await pickIcon(context);
                    setState(() {
                      subField.selectedIcon = icon;
                    });
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ...field.imageSubFields.map((imageSubField) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: ImageSubFieldWidget(
                      imageSubField: imageSubField,
                      onTap: () => _pickSingleImage(imageSubField),
                    ),
                  );
                })
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: ElevatedButton(
                  onPressed: () => _addNewSubField(field),
                  child: const Text('Add Sub Field'),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: ElevatedButton(
                  onPressed: () => _addImageSubField(field),
                  child: const Text('Add Image'),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthenticationProvider, EstablishmentProvider>(
      builder: (context, value, value2, child) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ..._buildFields(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addNewField,
                  child: const Text('Add Field'),
                ),
                const SizedBox(height: 20),
                if (_dynamicFields.isNotEmpty)
                  ElevatedButton(
                    onPressed: () async {
                      await _saveData(value.user!.uid, value2, value.token!);
                    },
                    child: const Text(AppStrings.save),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageSubFieldWidget extends StatelessWidget {
  final ImageSubField imageSubField;
  final VoidCallback onTap;

  const ImageSubFieldWidget({
    super.key,
    required this.imageSubField,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        width: 200,
        color: imageSubField.image == null ? Colors.grey[300] : null,
        child: imageSubField.image == null
            ? const Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
            : (kIsWeb
                ? Image.memory(imageSubField.image!.webImage!)
                : Image.file(File(imageSubField.image!.path!))),
      ),
    );
  }
}
