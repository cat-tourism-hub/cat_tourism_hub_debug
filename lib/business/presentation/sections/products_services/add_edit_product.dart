import 'package:cat_tourism_hub/core/utils/auth_provider.dart';
import 'package:cat_tourism_hub/business/presentation/sections/products_services/components/price_field.dart';
import 'package:cat_tourism_hub/business/data/photo.dart';
import 'package:cat_tourism_hub/business/data/product.dart';
import 'package:cat_tourism_hub/business/providers/partner_acct_provider.dart';
import 'package:cat_tourism_hub/business/providers/product_provider.dart';
import 'package:cat_tourism_hub/core/utils/image_picker.dart';
import 'package:cat_tourism_hub/core/utils/path_to_image_convert.dart';
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
      this.product,
      required this.action});
  final String action;
  final VoidCallback toggleReturn;
  final Product? product;
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<SimpleChipsInputState> _chipsInputKey =
      GlobalKey<SimpleChipsInputState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final Map<String, TextEditingController> _controllers = {};
  final List<Map<String, String>> _otherServices = [];
  final TextEditingController _chipInputController = TextEditingController();
  List<Photo> _imageFiles = [];
  List _included = [];

  double amount = 0;
  String duration = '';
  bool _isLoading = false;
  bool _isImageLoading = false;
  bool _isDisposed = false;

  void disposeControllers() {
    _nameController.dispose();
    _categoryController.dispose();
    _desController.dispose();
    _controllers.forEach((key, value) => value.dispose());
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
  void _onCustomFieldChanged(double newAmount, String? newDuration) {
    setState(() {
      amount = newAmount;
      duration = newDuration ?? '';
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
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
    final Map<String, String> otherServicesMap = {
      for (var field in _otherServices)
        _controllers['${field.keys.first}_name']?.text ?? '':
            _controllers['${field.keys.first}_value']?.text ?? ''
    };
    List<Photo> photos = [];

    for (var img in _imageFiles) {
      photos.add(Photo(image: img.image, title: img.title));
    }

    Product product = Product(
        name: _nameController.text,
        category: _categoryController.text,
        price: amount,
        desc: _desController.text,
        pricePer: duration,
        photos: photos,
        included: _included,
        otherServices: otherServicesMap);
    try {
      String response = await value2.addEditProduct(
          widget.action,
          widget.product?.id,
          value3.token ?? '',
          value3.user?.uid ?? '',
          value1.establishment!,
          product);

      SnackbarHelper.showSnackBar(response);
    } catch (e) {
      FirebaseCrashlytics.instance.log('IDK Error in Add/Edit Product');
    }

    setState(() {
      _isLoading = false;
      if (widget.action == AppStrings.add) {
        Navigator.pop(context);
      }
    });
  }

  // Widget builder for [addons/services]
  List<Widget> _buildAdditionalInfo() {
    return _otherServices.map((field) {
      String key = field.keys.first;
      String value = field.values.first;

      TextEditingController nameController = TextEditingController(text: key);
      TextEditingController valueController =
          TextEditingController(text: value);

      _controllers['${key}_name'] = nameController;
      _controllers['${key}_value'] = valueController;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.name,
                  border: OutlineInputBorder(),
                ),
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
                controller: valueController,
                decoration: const InputDecoration(
                  labelText: AppStrings.price,
                  border: OutlineInputBorder(),
                ),
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
    }).toList();
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
          _included.removeAt(p1);
        });
      },
      onChipAdded: (p0) {
        setState(() {
          _included.add(p0);
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
    if (widget.product != null) {
      _assignValues();
      _loadphotos();
    }
  }

  void _assignValues() async {
    _isImageLoading = true;
    _nameController.text = widget.product?.name ?? '';
    _categoryController.text = widget.product?.category ?? '';
    _desController.text = widget.product?.desc ?? '';
    _included = widget.product?.included ?? [];
    amount = widget.product!.price;
    duration = widget.product!.pricePer;

    widget.product?.otherServices?.forEach((key, value) {
      _otherServices.add({key: value});
    });

    _chipInputController.text = _included.join(',');
    if (mounted) {
      setState(() {});
    }
  }

  void _loadphotos() async {
    for (String image in widget.product?.photos ?? []) {
      var img = await getImageData(await getDownloadUrl(image));
      var title = image.split('/').last;
      _imageFiles.add(Photo(image: img, title: title));
    }

    if (_isDisposed) return;
    setState(() {
      _isImageLoading = false;
    });
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
                onTap: _getImageFiles,
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
              const Gap(20),

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
              const Gap(20),
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
              const Gap(20),

              // Text Field for pricing
              CustomTextFormField(
                  initialAmount: widget.product?.price.toString() ?? '',
                  initialCustomDuration: widget.product?.pricePer ?? '',
                  onChanged: _onCustomFieldChanged),

              const Gap(20),

              // Text field for decription (Optional)
              TextFormField(
                controller: _desController,
                decoration: InputDecoration(
                    labelText: AppStrings.description,
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    border: const OutlineInputBorder()),
              ),
              const Gap(20),

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
              const Gap(20),

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
              const Gap(20),

              //Button to [add other services]
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      _otherServices.add({'': ''});
                    });
                  },
                  child: Text(AppStrings.addOtherServices,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white)),
                ),
              ),
              const Gap(20),
              _isLoading || _isImageLoading
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
