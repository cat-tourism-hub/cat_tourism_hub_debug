import 'package:cat_tourism_hub/auth/auth_provider.dart';
import 'package:cat_tourism_hub/business/components/dynamic_fields/icon_textfield.dart';
import 'package:cat_tourism_hub/models/photo.dart';
import 'package:cat_tourism_hub/providers/partner_acct_provider.dart';
import 'package:cat_tourism_hub/business/components/dynamic_fields/dynamic_field.dart';
import 'package:cat_tourism_hub/business/components/dynamic_fields/dynamic_field_with_image.dart';
import 'package:cat_tourism_hub/business/components/dynamic_fields/dynamic_sub_field.dart';
import 'package:cat_tourism_hub/business/components/dynamic_fields/icon_picker.dart';
import 'package:cat_tourism_hub/business/components/dynamic_fields/image_sub_field.dart';
import 'package:cat_tourism_hub/utils/image_picker.dart';
import 'package:cat_tourism_hub/utils/snackbar_helper.dart';
import 'package:cat_tourism_hub/values/strings.dart';
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
  final List<DynamicFieldWithImage> _initialDynamicFields = [];
  final ImagePicker _picker = ImagePicker();
  bool _isEditMode = false;
  bool _fieldsPopulated = false;

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

  // Image picker from [utils/image_picker.dart]
  Future<void> _pickSingleImage(ImageSubField imageSubField) async {
    Photo? photo = await pickSingleImage(_picker);
    if (photo != null) {
      setState(() {
        imageSubField.image = photo;
      });
    }
  }

  bool get _hasDataChanged {
    if (_dynamicFields.length != _initialDynamicFields.length) {
      print('DYN LENGHT');
      return true;
    }

    for (int i = 0; i < _dynamicFields.length; i++) {
      if (!_dynamicFields[i].equals(_initialDynamicFields[i])) {
        print('DYN EQ');
        return true;
      }
    }

    return false;
  }

  void _deleteImageSubField(
      DynamicFieldWithImage parentField, ImageSubField imageSubField) {
    setState(() {
      parentField.imageSubFields.remove(imageSubField);
    });
  }

  void _deleteSubField(DynamicFieldWithImage parentField, SubField subField) {
    setState(() {
      parentField.subFields.remove(subField);
    });
  }

  Future<void> _saveData(
    dynamic value,
  ) async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    try {
      if (_formKey.currentState?.validate() ?? false) {
        _formKey.currentState?.save();

        if (!_hasDataChanged) {
          setState(() {
            _isEditMode = false;
          });
          return; // No data changes, do not call backend
        }

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
                  title: imageSubField.image?.title,
                  image: imageSubField.image?.image))
              .toList();

          dynamicFieldsData.add({
            'heading': text,
            'icon': icon,
            'subFields': subFields,
            'imageSubFields': imageSubFields,
          });
        }

        String result = await value.saveServiceAndAmenities(
            dynamicFieldsData, authProvider.user!.uid, authProvider.token);

        /// Save the current state as initial state after successful save
        _initialDynamicFields.clear();
        for (var field in _dynamicFields) {
          _initialDynamicFields.add(field.clone());
        }

        setState(() {
          _isEditMode = false;
        });
        SnackbarHelper.showSnackBar(result);
      }
    } catch (e) {
      debugPrint('ERRROR: ${e.toString()}');
    }
  }

  List<Widget> _buildFields(List<dynamic>? value) {
    var fieldSize = _isEditMode ? 90 : 50; // used for sub field height

    if (!_fieldsPopulated && value != null && value.isNotEmpty) {
      _populateFields(value);
      _fieldsPopulated = true; // Mark fields as populated
    }

    return _dynamicFields.map((field) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _isEditMode
              ? IconField(
                  labelText: AppStrings.headingText,
                  selectedIcon: field.selectedIcon,
                  textController: field.textController,
                  onIconPicker: () async {
                    IconData icon = await pickIcon(context);
                    setState(() {
                      field.selectedIcon = icon;
                    });
                  },
                )
              : Row(
                  children: [
                    Icon(field.selectedIcon ?? Icons.check),
                    const SizedBox(width: 10),
                    Text(
                      field.textController.text,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 2, // Space between columns
              mainAxisSpacing: 10, // Space between rows
              childAspectRatio:
                  (MediaQuery.of(context).size.width / 2 - 30) / fieldSize,
            ),
            itemCount: field.subFields.length,
            itemBuilder: (context, index) {
              final subField = field.subFields[index];
              return Padding(
                padding: const EdgeInsets.only(left: 20),
                child: _isEditMode
                    ? Stack(
                        children: [
                          IconField(
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
                          Positioned(
                            right: 0,
                            child: IconButton(
                              onPressed: () => _deleteSubField(field, subField),
                              icon: const Icon(Icons.close, color: Colors.red),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Icon(subField.selectedIcon ?? Icons.check),
                          const SizedBox(width: 10),
                          Text(subField.textController.text),
                        ],
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
                    padding: const EdgeInsets.only(left: 20),
                    child: ImageSubFieldWidget(
                      imageSubField: imageSubField,
                      onTap: () => _pickSingleImage(imageSubField),
                      isEditMode: _isEditMode,
                      onDelete: () =>
                          _deleteImageSubField(field, imageSubField),
                    ),
                  );
                })
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (_isEditMode)
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
        ],
      );
    }).toList();
  }

  void _populateFields(List<dynamic> facilitiesAmenities) {
    // Clear existing fields to prevent duplication
    _dynamicFields.clear();

    for (var facility in facilitiesAmenities) {
      List<SubField> subFields =
          (facility['subFields'] as List<dynamic>).map((subField) {
        return SubField(
          textController: TextEditingController(text: subField['text']),
          selectedIcon:
              deserializeIcon(subField['icon'], iconPack: IconPack.allMaterial),
        );
      }).toList();

      List<ImageSubField> imageSubFields =
          (facility['imageSubFields'] as List<dynamic>).map((imageSubField) {
        if (imageSubField is String && Uri.parse(imageSubField).isAbsolute) {
          return ImageSubField(image: Photo(link: imageSubField));
        } else {
          return ImageSubField(image: Photo.fromJson(imageSubField));
        }
      }).toList();

      _dynamicFields.add(
        DynamicFieldWithImage(
          textController: TextEditingController(text: facility['heading']),
          selectedIcon:
              deserializeIcon(facility['icon'], iconPack: IconPack.allMaterial),
          subFields: subFields,
          imageSubFields: imageSubFields,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartnerAcctProvider>(
      builder: (context, value, child) => Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                          'Facilities and Amenities of ${value.establishment!.name}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge)),
                  const SizedBox(width: 10),
                  Card(
                    child: TextButton.icon(
                        icon: Icon(
                            _isEditMode ? Icons.save : Icons.edit_outlined),
                        onPressed: () {
                          if (_isEditMode) {
                            _saveData(value);
                          } else {
                            setState(() {
                              _isEditMode = true;
                            });
                          }
                        },
                        label: Text(
                          _isEditMode ? 'Save' : 'Edit',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ..._buildFields(value.establishment?.facilitiesAmenities),
              const SizedBox(height: 20),
              if (_isEditMode)
                ElevatedButton(
                  onPressed: _addNewField,
                  child: const Text('Add Field'),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageSubFieldWidget extends StatelessWidget {
  final ImageSubField imageSubField;
  final VoidCallback onTap;
  final bool isEditMode;
  final VoidCallback onDelete;

  const ImageSubFieldWidget(
      {super.key,
      required this.imageSubField,
      required this.onTap,
      required this.isEditMode,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return GestureDetector(
      onTap: isEditMode ? onTap : null,
      child: Stack(
        children: [
          Container(
            height: isMobile ? 200 : 300,
            width: isMobile ? 300 : 500,
            color: imageSubField.image == null ? Colors.grey[300] : null,
            child: imageSubField.image == null
                ? const Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                : imageSubField.image!.link != null
                    ? Image.network(
                        imageSubField.image!.link!,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text('Failed to load image'),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.blue,
                              color: Colors.blue,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      )
                    : Image.memory(imageSubField.image!.image!),
          ),
          if (isEditMode && imageSubField.image != null)
            Positioned(
              right: 30,
              child: IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.close, color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
