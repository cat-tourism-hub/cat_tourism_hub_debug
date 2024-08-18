import 'dart:typed_data';

import 'package:cat_tourism_hub/core/utils/auth_provider.dart';
import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/components/dynamic_fields/icon_textfield.dart';
import 'package:cat_tourism_hub/business/data/photo.dart';
import 'package:cat_tourism_hub/business/providers/partner_acct_provider.dart';
import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/components/dynamic_fields/dynamic_field.dart';
import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/components/dynamic_fields/dynamic_sub_field.dart';
import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/components/dynamic_fields/icon_picker.dart';
import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/components/dynamic_fields/image_field.dart';
import 'package:cat_tourism_hub/core/utils/image_picker.dart';
import 'package:cat_tourism_hub/core/utils/snackbar_helper.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/path_to_image_convert.dart';

class ServicesAndAmenities extends StatefulWidget {
  const ServicesAndAmenities({super.key});

  @override
  State<ServicesAndAmenities> createState() => _ServicesAndAmenitiesState();
}

class _ServicesAndAmenitiesState extends State<ServicesAndAmenities> {
  final _formKey = GlobalKey<FormState>();
  final List<DynamicField> _dynamicFields = [];
  final List<DynamicField> _initialDynamicFields = [];
  final List<ImageField> _imageFiles = [];
  final List<ImageField> _initialImageFields = [];
  final ImagePicker _picker = ImagePicker();
  final List<TextEditingController> _captionController = [];
  bool _isEditMode = false;
  bool _fieldsPopulated = false;
  bool _isLoading = true;
  bool _isSaving = false;
  late AuthenticationProvider authProvider;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PartnerAcctProvider>(context, listen: false);
    authProvider = Provider.of<AuthenticationProvider>(context, listen: false);

    _populateImages(provider.establishment!.facilities ?? {});
  }

  void _addNewField() {
    setState(() {
      _dynamicFields.add(
        DynamicField(
          textController: TextEditingController(),
          selectedIcon: null,
          subFields: [],
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

  void _deleteSubField(DynamicField parentField, SubField subField) {
    setState(() {
      parentField.subFields.remove(subField);
    });
  }

  // Image picker from [utils/image_picker.dart]
  Future<void> _pickSingleImage(ImageField imageField) async {
    Photo? photo = await pickSingleImage(_picker);
    if (photo != null) {
      setState(() {
        imageField.image = photo;
      });
    }
  }

  void _addImageTiles() async {
    setState(() {
      _imageFiles.add(ImageField());
      _captionController.add(TextEditingController());
    });
  }

  void _deleteImageTiles(ImageField imageField, TextEditingController caption) {
    setState(() {
      _imageFiles.remove(imageField);
      _captionController.remove(caption);
    });
  }

  bool get _hasDataChanged {
    /// Check if dynamic field is added
    if (_dynamicFields.length != _initialDynamicFields.length) return true;

    /// Check if values of init dynamic field is the same to the updated field
    for (int i = 0; i < _dynamicFields.length; i++) {
      if (!_dynamicFields[i].equals(_initialDynamicFields[i])) return true;
    }

    /// Check if an image field is added
    if (_imageFiles.length != _initialImageFields.length) return true;
    return false;
  }

  /// This will trigger when saving the images on facilities and amenities
  Future<List<Photo>> _getImagesWithUpdatedCaptions() async {
    // Assigns captions from the text controllers to the respective image files
    for (int i = 0; i < _imageFiles.length; i++) {
      _imageFiles[i].caption = _captionController[i].text;
    }

    // List of futures to process images concurrently
    List<Future<Photo>> futurePhotos = _imageFiles
        .where((imageField) => imageField.image != null)
        .map((imageField) async {
      Uint8List? imageData;
      // If the image link is not null, fetch the image data
      if (imageField.image!.link != null) {
        imageData = await getImageData(imageField.image!.link!);
      }

      return Photo(
        title: imageField.caption,
        link: imageField.image?.link ?? '',
        image: imageData ?? imageField.image!.image,
      );
    }).toList();

    return Future.wait(futurePhotos);
  }

  Future<void> _saveData(PartnerAcctProvider value) async {
    // Exit if no data changes
    if (!_hasDataChanged) {
      setState(() {
        _isEditMode = false;
      });
      return;
    }

    try {
      // Validate the form before proceeding
      if (_formKey.currentState?.validate() ?? false) {
        List<Map<String, dynamic>> dynamicFieldsData = [];

        // Get images with updated captions
        final images = await _getImagesWithUpdatedCaptions();

        // Serialize the dynamic fields, but only if they contain data
        for (var field in _dynamicFields) {
          if (field.textController.text.isNotEmpty) {
            final text = field.textController.text;
            final icon = serializeIcon(field.selectedIcon ?? Icons.check,
                iconPack: IconPack.allMaterial);

            // Serialize the subfields, but only if they contain data
            final subFields = field.subFields.where((subField) {
              return subField.textController.text.isNotEmpty;
            }).map((subField) {
              final subFieldIconData = serializeIcon(
                  subField.selectedIcon ?? Icons.check,
                  iconPack: IconPack.allMaterial);
              return {
                'text': subField.textController.text,
                'icon': subFieldIconData,
              };
            }).toList();

            dynamicFieldsData.add({
              'heading': text,
              'icon': icon,
              'subFields': subFields,
            });
          }
        }

        // Add images to the dynamic fields data only if images exist
        if (images.isNotEmpty) {
          dynamicFieldsData.add({'images': images});
        }

        // Save the data to the backend
        String result = await value.saveServiceAndAmenities(
          dynamicFieldsData,
          authProvider.user!.uid,
          authProvider.token!,
        );

        // Update the initial state after successful save
        _initialDynamicFields.clear();
        for (var field in _dynamicFields) {
          _initialDynamicFields.add(field.clone());
        }

        setState(() {
          _isEditMode = false;
          _isSaving = false;
        });

        SnackbarHelper.showSnackBar(result);
      }
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }
  }

  List<Widget> _buildFields(PartnerAcctProvider value) {
    var fieldSize = _isEditMode ? 90 : 50; // used for sub field height

    if (!_fieldsPopulated &&
        value.establishment!.amenities != null &&
        value.establishment!.amenities!.isNotEmpty) {
      _populateFields(value.establishment!.amenities ?? []);
      _fieldsPopulated = true;
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
                    const Gap(10),
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
                          const Gap(10),
                          Text(subField.textController.text),
                        ],
                      ),
              );
            },
          ),
          const Gap(10),
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
                const Gap(10),
              ],
            ),
          const Gap(10),
        ],
      );
    }).toList();
  }

  void _populateFields(List<dynamic> amenities) {
    // Clear existing fields to prevent duplication
    _dynamicFields.clear();

    for (var amenity in amenities) {
      List<SubField> subFields =
          (amenity['subFields'] as List<dynamic>).map((subField) {
        return SubField(
          textController: TextEditingController(text: subField['text']),
          selectedIcon:
              deserializeIcon(subField['icon'], iconPack: IconPack.allMaterial),
        );
      }).toList();

      _dynamicFields.add(
        DynamicField(
          textController: TextEditingController(text: amenity['heading']),
          selectedIcon:
              deserializeIcon(amenity['icon'], iconPack: IconPack.allMaterial),
          subFields: subFields,
        ),
      );
    }
  }

  Future<void> _populateImages(Map facilities) async {
    List<ImageField> imageFiles = [];
    List<TextEditingController> captionControllers = [];

    for (var field in facilities.entries) {
      /// Convert the images to their url
      String url = await getDownloadUrl(field.value);

      /// Add the images to the list
      imageFiles.add(ImageField(
        image: Photo(link: url),
        caption: field.key,
      ));

      captionControllers.add(TextEditingController(text: field.key));
    }

    setState(() {
      _imageFiles.addAll(imageFiles);
      _captionController.addAll(captionControllers);
      _isLoading = false;
    });
  }

  /// Widget to render the photo from firebase
  Widget photoViewer() {
    if (_isLoading) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: LoadingAnimationWidget.inkDrop(
              color: Theme.of(context).indicatorColor, size: 40),
        ),
      );
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: _imageFiles.isEmpty
          ? const Center(child: Text('No Images'))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imageFiles.length,
              itemBuilder: (context, index) {
                final imageField = _imageFiles[index];
                return Container(
                  margin: const EdgeInsets.all(10),
                  child: ImageFieldWidget(
                    imageField: imageField,
                    isEditMode: false,
                  ),
                );
              },
            ),
    );
  }

  /// Widget to modify the photos
  Widget photoModify() {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      height: 280,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: screenWidth,
            height: 250,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _imageFiles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ImageFieldWidget(
                      imageField: ImageField(
                          image: _imageFiles[index].image,
                          caption: _imageFiles[index].caption),
                      onTap: () => _pickSingleImage(_imageFiles[index]),
                      isEditMode: _isEditMode,
                      onDelete: () => _deleteImageTiles(
                          _imageFiles[index], _captionController[index]),
                      captionController: _captionController[index],
                    ),
                  );
                }),
          ),
          GestureDetector(
            onTap: _addImageTiles,
            child: const Center(
              child: Text(
                AppStrings.clickToAddPhoto,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PartnerAcctProvider value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Facilities and Amenities of ${value.establishment!.name}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        const Gap(10),
        Card(
          child: _isSaving
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Center(
                    child: LoadingAnimationWidget.discreteCircle(
                        color: Colors.blue, size: 25),
                  ),
                )
              : TextButton.icon(
                  icon: Icon(_isEditMode ? Icons.save : Icons.edit_outlined),
                  onPressed: () {
                    if (_isEditMode) {
                      _saveData(value);
                      setState(() {
                        _isSaving = true;
                      });
                    } else {
                      setState(() {
                        _isEditMode = true;
                      });
                    }
                  },
                  label: Text(
                    _isEditMode ? AppStrings.save : AppStrings.edit,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildAmenitiesSection(PartnerAcctProvider value) {
    if (value.establishment!.amenities == null ||
        value.establishment!.amenities!.isEmpty && !_isEditMode) {
      return const Center(
        child: Text('No AMENITIES ADDED'),
      );
    } else {
      return Container(); // Replace with the actual amenities display logic if needed
    }
  }

  Widget _buildAddFieldButton() {
    return ElevatedButton(
      onPressed: _addNewField,
      child: const Text(AppStrings.addField),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartnerAcctProvider>(
      builder: (context, value, child) => SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, value),
                const Gap(20),
                _isEditMode ? photoModify() : photoViewer(),
                const Gap(20),
                _buildAmenitiesSection(value),
                ..._buildFields(value),
                const Gap(20),
                if (_isEditMode) _buildAddFieldButton(),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageFieldWidget extends StatelessWidget {
  final ImageField imageField;
  final VoidCallback? onTap;
  final bool isEditMode;
  final VoidCallback? onDelete;
  final TextEditingController? captionController;

  const ImageFieldWidget(
      {super.key,
      required this.imageField,
      this.onTap,
      required this.isEditMode,
      this.onDelete,
      this.captionController});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return GestureDetector(
      onTap: isEditMode ? onTap : null,
      child: Stack(
        children: [
          Container(
            height: isMobile ? 200 : 300,
            width: isMobile ? 200 : 400,
            color:
                imageField.image == null ? Colors.grey[300] : Colors.grey[200],
            child: imageField.image == null
                ? const Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                : imageField.image!.link != null
                    ? Image.network(
                        imageField.image!.link!,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text('Failed to load image'),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).indicatorColor,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      )
                    : Image.memory(
                        fit: BoxFit.contain, imageField.image!.image!),
          ),
          if (!isEditMode && imageField.caption != null)
            Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                child: Container(
                    color: Colors.white.withOpacity(0.7),
                    child: Center(child: Text(imageField.caption ?? '')))),
          if (isEditMode && imageField.image != null)
            Positioned(
              right: 0,
              child: IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.close, color: Colors.red),
              ),
            ),
          if (isEditMode && imageField.image != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.white.withOpacity(0.7),
                child: TextFormField(
                  controller: captionController,
                  decoration: const InputDecoration(
                    hintText: AppStrings.caption,
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? AppStrings.captionPrompt
                      : null,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
