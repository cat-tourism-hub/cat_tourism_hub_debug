import 'package:cat_tourism_hub/business/data/establishment.dart';
import 'package:cat_tourism_hub/business/data/product.dart';
import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/components/content_view.dart';
import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/components/custom_tab.dart';
import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/components/custom_tab_bar.dart';
import 'package:cat_tourism_hub/business/providers/product_provider.dart';
import 'package:cat_tourism_hub/core/components/loading_widget.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:cat_tourism_hub/core/utils/path_to_image_convert.dart';
import 'package:cat_tourism_hub/users/presentation/accommodations_page.dart';
import 'package:cat_tourism_hub/users/presentation/components/image_collage.dart';
import 'package:cat_tourism_hub/users/presentation/components/product_card.dart';
import 'package:cat_tourism_hub/users/presentation/components/topbar.dart';
import 'package:cat_tourism_hub/users/presentation/restaurants_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_collage/image_collage.dart';
import 'package:provider/provider.dart';

class PartnerDetails extends StatefulWidget {
  const PartnerDetails({super.key, required this.partner});
  final Establishment partner;

  @override
  State<PartnerDetails> createState() => _PartnerDetailsState();
}

class _PartnerDetailsState extends State<PartnerDetails>
    with SingleTickerProviderStateMixin {
  double _screenWidth = 0;
  final List<Img> _images = [];
  final List<String> _captions = [];
  List<ContentView> contentViews = [];
  bool _isLoading = true;

  // late Establishment? _partner;
  // late PartnersProvider _partnersProvider;
  late ProductProvider _productProvider;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    // _partnersProvider = Provider.of<PartnersProvider>(context, listen: false);
    // _partner = _partnersProvider.partner;
    _loadImages();

    if (widget.partner.type == AppStrings.hotelAndResto) {
      contentViews = [
        ContentView(
          tab: const CustomTab(title: AppStrings.accommodations),
          content: AccommodationsPage(partner: widget.partner),
        ),
        ContentView(
          tab: const CustomTab(title: AppStrings.restaurants),
          content: const RestaurantsPage(),
        )
      ];
    }

    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _productProvider.fetchProducts(widget.partner.id ?? '');
    _tabController = TabController(length: contentViews.length, vsync: this);
  }

  Future<void> _loadImages() async {
    if (widget.partner.facilities != null) {
      for (var field in widget.partner.facilities!.entries) {
        String url = await getDownloadUrl(field.value);
        setState(() {
          _images.add(Img(image: url));
          _captions.add(field.key);
        });
      }
      _setLoadingState(false);
    }
  }

  void _setLoadingState(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  Widget _imageBuilder() {
    if (_isLoading) {
      return LoadingWidget(screenWidth: _screenWidth);
    }
    return ImageCollageWidget(
      images: _images,
      captions: _captions,
    );
  }

  Widget _mobileView(ProductProvider value) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text(appName)),
            body: const SingleChildScrollView(child: Column())));
  }

  _showProductPopup(Product product) {
    print(product.name);
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: Column(
            children: [
              Text(product.name),
              Text(product.desc ?? ''),
              ListView.builder(itemBuilder: (context, index) {
                return ListTile(title: product.included?[index]);
              })
            ],
          ));
        });
  }

  Widget _desktopView(ProductProvider value) {
    double childrenWidth =
        _screenWidth < 1200 ? _screenWidth * 0.8 : _screenWidth * 0.7;
    return Scaffold(
      appBar: const Topbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: SizedBox(
              width: childrenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.partner.name ?? '',
                      style: Theme.of(context).textTheme.headlineLarge),
                  const Gap(10),
                  ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      iconColor: Theme.of(context).indicatorColor,
                      title: Text(
                        widget.partner.locationString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      )),
                  const Gap(20),
                  Row(
                    children: [
                      Expanded(flex: 3, child: _imageBuilder()),
                      const Gap(10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Reviews Panel
                            SizedBox(
                              height: 130,
                              child: Container(
                                  color: Colors.grey,
                                  child: const Text('Reviews Panel')),
                            ),
                            const Gap(10),
                            // Google Maps API Panel
                            SizedBox(
                              height: 310,
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
                  SizedBox(
                      width: _screenWidth < 1300
                          ? _screenWidth * 0.6
                          : _screenWidth * 0.4,
                      child: Text(widget.partner.about ?? '')),
                  const Gap(30),
                  const Divider(thickness: 1),
                  (widget.partner.type == AppStrings.hotelAndResto)
                      ? SizedBox(
                          height: 1300,
                          child: _buildTabBarContent(childrenWidth),
                        )
                      : SizedBox(
                          height: 480,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: value.products.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () =>
                                    _showProductPopup(value.products[index]),
                                child: Container(
                                  width: 350,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: ProductCard(
                                    establishment: widget.partner,
                                    product: value.products[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  const Gap(30),
                  const Divider(thickness: 1),
                  const Gap(30),
                  if (widget.partner.policies != null) _buildPolicy()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
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

  Widget _buildTabBarContent(double width) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTabBar(
            page: '',
            mainAxisAlignment: MainAxisAlignment.center,
            controller: _tabController!,
            width: width,
            tabs: [
              ...contentViews.map((e) => e.tab),
            ]),
        Expanded(
          child: SizedBox(
              child: TabBarView(controller: _tabController, children: [
            ...contentViews.map((e) => e.content),
          ])),
        ),
      ],
    );
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
          Text(widget.partner.policies ?? '')
        ]);
  }
}
