import 'package:cat_tourism_hub/business/data/establishment.dart';
import 'package:cat_tourism_hub/core/components/product_list_builder.dart';
import 'package:cat_tourism_hub/core/product.dart';
import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/components/content_view.dart';
import 'package:cat_tourism_hub/business/providers/product_provider.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:cat_tourism_hub/core/utils/path_to_image_convert.dart';
import 'package:cat_tourism_hub/users/presentation/components/image_collage.dart';
import 'package:cat_tourism_hub/users/presentation/components/product_info.dart';
import 'package:cat_tourism_hub/users/presentation/components/topbar.dart';
import 'package:cat_tourism_hub/users/providers/partners_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/icon_pack.dart';
import 'package:flutter_iconpicker/Serialization/icondata_serialization.dart';
import 'package:gap/gap.dart';
import 'package:image_collage/image_collage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PartnerDetails extends StatefulWidget {
  const PartnerDetails({super.key});

  @override
  State<PartnerDetails> createState() => _PartnerDetailsState();
}

class _PartnerDetailsState extends State<PartnerDetails> {
  double _screenWidth = 0;
  final List<Img> _images = [];
  final List<String> _captions = [];
  List<ContentView> contentViews = [];
  bool _isLoading = true;
  Map<String, List<Product>> groupedData = {};
  late ProductProvider _productProvider;
  TabController? _tabController;
  bool _isDisposed = false;
  Establishment? _partner;

  @override
  void initState() {
    super.initState();
    final partnerProvider =
        Provider.of<PartnersProvider>(context, listen: false);
    _partner = partnerProvider.partner;
    _loadPartnerImages();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _productProvider.fetchProducts(_partner?.id ?? '');
  }

  void _groupProductByTag(List<Product> products) {
    groupedData.clear();
    for (var product in products) {
      String tag = product.tag;
      if (!groupedData.containsKey(tag)) {
        groupedData[tag] = [];
      }
      if (!groupedData[tag]!.contains(product)) {
        groupedData[tag]!.add(product);
      }
    }
  }

  Future<void> _loadPartnerImages() async {
    if (_partner?.facilities != null) {
      for (var field in _partner!.facilities!.entries) {
        String url = await getDownloadUrl(field.value);
        if (_isDisposed) return;
        setState(() {
          _images.add(Img(image: url));
          _captions.add(field.key);
        });
      }
    }
    if (_isDisposed) return;
    setState(() {
      _isLoading = false;
    });
  }

  Widget _partnerImageBuilder() {
    if ((!_isLoading) && (_images.isEmpty)) {
      return const Center(child: Text('No Images'));
    }
    return Skeletonizer(
      enabled: _isLoading,
      ignoreContainers: true,
      child: ImageCollageWidget(
        images: _images,
        captions: _captions,
      ),
    );
  }

  Widget _mobileView(ProductProvider value) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text(appName)),
            body: const SingleChildScrollView(child: Column())));
  }

  Future<List<String>> _fetchProductImages(List photoPaths) async {
    // Parallelize the download of image URLs.
    return await Future.wait(photoPaths.map((path) => getDownloadUrl(path)));
  }

  _showProductPopup(Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<List<String>>(
          future: _fetchProductImages(product.photos ?? []),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Dialog(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  height: MediaQuery.sizeOf(context).width * 0.4,
                  child: Center(
                      child: LoadingAnimationWidget.inkDrop(
                          color: Theme.of(context).indicatorColor, size: 40)),
                ),
              );
            } else if (snapshot.hasError) {
              return Dialog(
                child: Center(
                  child: Text('Error loading ${product.name}.'),
                ),
              );
            } else {
              return Dialog(
                child:
                    ProductInfo(product: product, images: snapshot.data ?? []),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildAmenities(amenities, {BoxConstraints? boxConstraints}) {
    return Wrap(
      spacing: 20, // Space between the items horizontally
      runSpacing: 10.0, // Space between the items vertically
      children: amenities.map<Widget>((amenity) {
        return ConstrainedBox(
          constraints: boxConstraints ??
              BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width / 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main heading with an icon for the category
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    deserializeIcon(
                          amenity['icon'],
                          iconPack: IconPack.allMaterial,
                        ) ??
                        Icons.check,
                    size: 24,
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      amenity['heading'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const Gap(8),
              // Sub-items under the heading
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (amenity['subFields'] as List<dynamic>)
                      .map<Widget>((subField) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            deserializeIcon(
                                  subField['icon'],
                                  iconPack: IconPack.allMaterial,
                                ) ??
                                Icons.check,
                            size: 18,
                          ),
                          const Gap(8),
                          Expanded(
                            child: Text(
                              subField['text'],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _desktopView(ProductProvider value) {
    double childrenWidth =
        _screenWidth < 1200 ? _screenWidth * 0.8 : _screenWidth * 0.7;
    _groupProductByTag(value.products);
    final boxConstraints = _screenWidth < 1000
        ? BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width / 3)
        : BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width / 3 - 150);

    return Scaffold(
      appBar: const Topbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: SizedBox(
                width: childrenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_partner?.name ?? '',
                        style: Theme.of(context).textTheme.headlineLarge),
                    const Gap(10),
                    ListTile(
                        leading: const Icon(Icons.location_on_outlined),
                        iconColor: Theme.of(context).indicatorColor,
                        title: Text(
                          _partner?.locationString() ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                        )),
                    const Gap(20),

                    // Widget for partner images and ratings with map API
                    Row(
                      children: [
                        Expanded(flex: 3, child: _partnerImageBuilder()),
                        const Gap(10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Reviews Panel
                              SizedBox(
                                height: 310,
                                child: Container(
                                    color: Colors.grey,
                                    child: const Text('Reviews Panel')),
                              ),
                              const Gap(10),
                              // Google Maps API Panel
                              SizedBox(
                                height: 130,
                                child: Container(
                                    color: Colors.grey,
                                    child: const Text('Google Maps API')),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(30),

                    /// Widget for partner's about
                    SizedBox(
                        width: _screenWidth < 1300
                            ? _screenWidth * 0.6
                            : _screenWidth * 0.4,
                        child: Text(_partner?.about ?? '')),
                    const Gap(30),

                    // Widget builder for products with different tags
                    ProductListBuilder(
                      products: groupedData,
                      caller: 'User',
                      onTap: (product) => _showProductPopup(product),
                    ),

                    const Divider(thickness: 1),
                    // AMENITIES TITLE
                    if (_partner?.amenities != null)
                      Text(AppStrings.amenities,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                    const Gap(20),

                    /// Amenity list builder
                    _buildAmenities(_partner?.amenities ?? [],
                        boxConstraints: boxConstraints),
                    const Gap(30),

                    /// Policy builder
                    if (_partner?.policies != null) _buildPolicy()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _productProvider.products = [];
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.sizeOf(context).width;
    return Consumer<ProductProvider>(builder: (context, value, widget1) {
      return SafeArea(
          child: _screenWidth < 800 ? _mobileView(value) : _desktopView(value));
    });
  }

  Widget _buildPolicy() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppStrings.policies,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
          const Gap(20),
          Text(_partner?.policies ?? '')
        ]);
  }
}
