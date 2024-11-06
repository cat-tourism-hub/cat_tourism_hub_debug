import 'package:cat_tourism_hub/core/utils/app_regex.dart';
import 'package:cat_tourism_hub/core/auth/auth_provider.dart';
import 'package:cat_tourism_hub/business/presentation/sections/products_services/components/price_field.dart';
import 'package:cat_tourism_hub/business/data/photo.dart';
import 'package:cat_tourism_hub/core/product.dart';
import 'package:cat_tourism_hub/business/providers/partner_acct_provider.dart';
import 'package:cat_tourism_hub/business/providers/product_provider.dart';
import 'package:cat_tourism_hub/core/utils/image_picker.dart';
import 'package:cat_tourism_hub/core/utils/snackbar_helper.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:simple_chips_input/simple_chips_input.dart';
import '../../../../core/constants/strings/strings.dart';

class AddProduct extends StatefulWidget {
  const AddProduct(
      {super.key,
      required this.toggleReturn,
      required this.categories,
      this.product,
      required this.action});
  final String action;
  final VoidCallback toggleReturn;
  final Product? product;
  final List<String> categories;
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<SimpleChipsInputState> _chipsInputKey =
      GlobalKey<SimpleChipsInputState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _capacityOrServing = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _newCategoryController = TextEditingController();
  final TextEditingController _tag = TextEditingController();

  final TextEditingController _chipInputController = TextEditingController();
  List<Photo> _imageFiles = [];
  List? _included;

  double _amount = 0;
  String _duration = '';
  String? _selectedCategory;
  bool _isLoading = false;
  final bool _isImageLoading = false;

  void disposeControllers() {
    _nameController.dispose();
    _desController.dispose();
    _newCategoryController.dispose();
    _capacityOrServing.dispose();
    _tag.dispose();
  }

  /// Function to handle getting multiple photos
  /// calls utils/image_picker.dart/pickMultiplephotos
  void _getImageFiles() async {
    final ImagePicker picker = ImagePicker();
    List<Photo> photos = await pickMultipleImages(picker);
    setState(() {
      _imageFiles = photos;
    });
  }

  // Value handler for price and duration widgets.
  void _onPriceFieldChanged(double newAmount, String? newDuration) {
    setState(() {
      _amount = newAmount;
      _duration = newDuration ?? '';
    });
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  // Function to serialize the data entered to be sent on API
  Future _saveProductData() async {
    setState(() {
      _isLoading = true;
    });

    final value1 = Provider.of<PartnerAcctProvider>(context, listen: false);
    final value3 = Provider.of<AuthenticationProvider>(context, listen: false);
    final value2 = Provider.of<ProductProvider>(context, listen: false);
    List<Photo> photos = [];

    for (var img in _imageFiles) {
      photos.add(Photo(image: img.image, title: img.title));
    }

    Product product = Product(
      name: _nameController.text,
      category: _selectedCategory ?? '',
      price: _amount,
      capacity: int.tryParse(_capacityOrServing.text) ?? 0,
      desc: _desController.text,
      pricePer: _duration,
      photos: photos,
      included: _included,
      tag: _tag.text,
    );
    try {
      var response = await value2.addEditProduct(
          widget.action,
          widget.product?.id,
          value3.token ?? '',
          value3.user?.uid ?? '',
          value1.establishment!,
          product);

      SnackbarHelper.showSnackBar(response,
          isError: response.statusCode != 201);
    } catch (e) {
      FirebaseCrashlytics.instance.log('IDK Error in Add Product');
    }

    setState(() {
      _isLoading = false;
      if (widget.action == AppStrings.add) {
        Navigator.pop(context);
      }
    });
  }

  // Widget builder for [included in the price]
  Widget _buildIncludedInThePrice() {
    return SimpleChipsInput(
      key: _chipsInputKey,
      controller: _chipInputController,
      separatorCharacter: ',',
      createCharacter: ',',
      onChipDeleted: (p0, p1) {
        setState(() {
          _included?.removeAt(p1);
        });
      },
      onChipAdded: (p0) {
        setState(() {
          _included?.add(p0);
          _chipInputController.clear();
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
  void initState() {
    super.initState();
  }

  Future<String?> _showAddCategoryDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add new category'),
          content: TextField(
            controller: _newCategoryController,
            decoration: const InputDecoration(hintText: "Enter new category"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_newCategoryController.text);
              },
              child: const Text(AppStrings.add),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
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
                  onPressed: widget.toggleReturn,
                  label: const Text(AppStrings.labelReturn),
                  icon: const Icon(Icons.arrow_back)),
              const Gap(32),
              Text(
                '${widget.action} Product/Services',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: _isImageLoading ? null : _getImageFiles,
                child: SizedBox(
                  width: screenWidth,
                  height: screenHeight * 0.3,
                  child: _isImageLoading || _imageFiles.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          child: _isImageLoading
                              ? Center(
                                  child: LoadingAnimationWidget.inkDrop(
                                      color: Theme.of(context).indicatorColor,
                                      size: 30),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _imageFiles.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Image.memory(
                                          _imageFiles[index].image!,
                                          fit: BoxFit.fill),
                                    );
                                  }),
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
              const Gap(30),

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
              const Gap(30),
              // Category
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: '${AppStrings.category}*',
                            labelStyle: Theme.of(context).textTheme.labelMedium,
                            border: const OutlineInputBorder(),
                          ),
                          items: widget.categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            String? newCategory =
                                await _showAddCategoryDialog(context);
                            if (newCategory != null && newCategory.isNotEmpty) {
                              setState(() {
                                widget.categories.add(newCategory);
                                _selectedCategory = newCategory;
                              });
                            }
                          },
                          child: const Text('Add New Category'),
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _capacityOrServing,
                      decoration: InputDecoration(
                          labelText: AppRegex.categoryRegex
                                  .hasMatch(_selectedCategory ?? '')
                              ? 'Serving'
                              : 'Capacity',
                          labelStyle: Theme.of(context).textTheme.labelMedium,
                          border: const OutlineInputBorder()),
                    ),
                  )
                ],
              ),

              const Gap(30),

              // Text Field for pricing
              PriceField(
                  initialAmount: widget.product?.price.toString() ?? '',
                  initialCustomDuration: widget.product?.pricePer ?? '',
                  onChanged: _onPriceFieldChanged),

              const Gap(30),

              // Text field for decription (Optional)
              TextFormField(
                controller: _desController,
                decoration: InputDecoration(
                    labelText: AppStrings.description,
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    border: const OutlineInputBorder()),
              ),
              const Gap(30),

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
              const Gap(30),

              Tooltip(
                message:
                    'Tag is used to identify what type of product/service it is.',
                verticalOffset: -20, // Moves the tooltip above the "Tag" text
                preferBelow:
                    false, // Places the tooltip above the TextFormField
                child: TextFormField(
                  controller: _tag,
                  decoration: InputDecoration(
                    labelText: AppStrings.tag,
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),

              const Gap(30),

              _isLoading
                  ? Center(
                      child: LoadingAnimationWidget.discreteCircle(
                          color: Theme.of(context).indicatorColor, size: 30))
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            _saveProductData();
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
