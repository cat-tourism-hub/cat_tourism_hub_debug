import 'package:cat_tourism_hub/auth/auth_provider.dart';
import 'package:cat_tourism_hub/business/components/price_field.dart';
import 'package:cat_tourism_hub/models/photo.dart';
import 'package:cat_tourism_hub/models/product.dart';
import 'package:cat_tourism_hub/providers/partner_acct_provider.dart';
import 'package:cat_tourism_hub/providers/product_provider.dart';
import 'package:cat_tourism_hub/utils/image_picker.dart';
import 'package:cat_tourism_hub/utils/snackbar_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:simple_chips_input/simple_chips_input.dart';
import '../../../values/strings.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key, required this.toggleAddRoom});
  final VoidCallback toggleAddRoom;

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final Map<String, TextEditingController> _controllers = {};
  List<Photo> _imageFiles = [];
  String output = '';
  List<String> included = [];
  final List<Map<String, String>> _otherServices = [];
  String amount = '';
  String duration = '';
  bool _isLoading = false;

  void disposeControllers() {
    _nameController.dispose();
    _categoryController.dispose();
    _desController.dispose();
    _controllers.forEach((key, value) => value.dispose());
  }

  /// Function to handle getting multiple images
  /// calls utils/image_picker.dart/pickMultipleImages
  void _getImageFiles() async {
    final ImagePicker picker = ImagePicker();
    List<Photo> images = await pickMultipleImages(picker);
    setState(() {
      _imageFiles = images;
    });
  }

  // Value handler for price and duration widgets.
  void _onCustomFieldChanged(String newAmount, String? newDuration) {
    setState(() {
      amount = newAmount;
      duration = newDuration ?? '';
    });
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  // Function to serialize the data entered to be sent on API
  Future _submitProductData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final value1 = Provider.of<PartnerAcctProvider>(context, listen: false);
      final value3 =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final value2 = Provider.of<ProductProvider>(context, listen: false);
      Product product = Product(
        name: _nameController.text,
        category: _categoryController.text,
        price: double.tryParse(amount) ?? 0,
        desc: _desController.text,
        pricePer: duration,
        photos: _imageFiles,
        included: included,
        otherServices: {
          for (var field in _otherServices)
            _controllers['${field['key']}_name']?.text ?? '':
                _controllers['${field['key']}_value']?.text ?? ''
        },
      );

      String response = await value2.uploadNewProduct(
          value3.token ?? '', value3.user!.uid, value1.establishment!, product);

      SnackbarHelper.showSnackBar(response);
    } catch (e) {
      SnackbarHelper.showSnackBar('Failed to upload room: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Widget builder for [addons/services]
  List<Widget> _buildAdditionalInfo() {
    return _otherServices.map(
      (field) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controllers['${field['key']}_name'] =
                      TextEditingController(),
                  decoration: const InputDecoration(
                      labelText: AppStrings.name, border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a custom field name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _controllers['${field['key']}_value'] =
                      TextEditingController(),
                  decoration: const InputDecoration(
                      labelText: AppStrings.price,
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        );
      },
    ).toList();
  }

  // Widget builder for [included in the price]
  Widget _buildIncludedInThePrice() {
    return SimpleChipsInput(
      separatorCharacter: ',',
      createCharacter: ',',
      onChipDeleted: (p0, p1) {
        setState(() {
          included.removeAt(p1);
        });
      },
      onChipAdded: (p0) {
        setState(() {
          included.add(p0);
        });
      },
      chipTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      deleteIcon: const Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Icon(
          Icons.remove_circle_outline_outlined,
          size: 14.0,
          color: Colors.red,
        ),
      ),
      widgetContainerDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey),
      ),
      chipContainerDecoration: BoxDecoration(
        color: Colors.blue[100],
        border: Border.all(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      placeChipsSectionAbove: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(20),
        width: screenWidth,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                  onPressed: widget.toggleAddRoom,
                  label: const Text(AppStrings.labelReturn),
                  icon: const Icon(Icons.arrow_back)),
              const SizedBox(height: 32),
              Text('Add Product/Services',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: _getImageFiles,
                child: SizedBox(
                  width: screenWidth,
                  height: screenHeight * 0.3,
                  child: _imageFiles.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _imageFiles.length,
                              itemBuilder: (context, index) => Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Image.memory(
                                        _imageFiles[index].image!,
                                        fit: BoxFit.fill),
                                  )),
                        )
                      : DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [6, 3],
                          color: Colors.grey,
                          child: const Center(
                            child: Text(
                              AppStrings.addThumbnail,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Text field for name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: '${AppStrings.name}*',
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    border: const OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Text field for category
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                    labelText: '${AppStrings.category}*',
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    border: const OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Text Field for pricing
              CustomTextFormField(onChanged: _onCustomFieldChanged),
              const SizedBox(height: 20),

              // Text field for decription (Optional)
              TextFormField(
                controller: _desController,
                decoration: InputDecoration(
                    labelText: AppStrings.description,
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 20),

              //Label for [included in the price]
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  AppStrings.included,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),

              //builder of [included in the price]
              _buildIncludedInThePrice(),
              const SizedBox(height: 20),

              if (_otherServices.isNotEmpty)
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    AppStrings.addOnsServices,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),

              //list builder of [other services]
              ..._buildAdditionalInfo(),
              const SizedBox(height: 20),

              //Button to [add other services]
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      _otherServices.add({'key': UniqueKey().toString()});
                    });
                  },
                  child: Text(AppStrings.addOtherServices,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            _submitProductData();
                          }
                        },
                        child: Text(AppStrings.save,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white)),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
