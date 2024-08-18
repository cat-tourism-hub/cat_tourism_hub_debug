import 'package:cat_tourism_hub/core/utils/auth_provider.dart';
import 'package:cat_tourism_hub/business/presentation/sections/products_services/components/card.dart';
import 'package:cat_tourism_hub/business/presentation/sections/products_services/add_edit_product.dart';
import 'package:cat_tourism_hub/business/data/product.dart';
import 'package:cat_tourism_hub/business/providers/product_provider.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class ProductsServices extends StatefulWidget {
  const ProductsServices({super.key});

  @override
  State<ProductsServices> createState() => _ProductsServicesState();
}

class _ProductsServicesState extends State<ProductsServices>
    with AutomaticKeepAliveClientMixin {
  bool _isShowProduct = false;
  Product? productItem;
  late String token;
  late String uid;
  String searchQuery = '';
  @override
  bool get wantKeepAlive => true;

  void toggleViewProduct() {
    setState(() {
      _isShowProduct = !_isShowProduct;
    });
  }

  @override
  void initState() {
    super.initState();

    final provider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final productProv = Provider.of<ProductProvider>(context, listen: false);
    uid = provider.user!.uid;
    productProv.fetchProducts(uid);
  }

  Map<String, List<Product>> _groupProductsByCategory(List<Product> products) {
    Map<String, List<Product>> groupedProducts = {};

    for (var product in products) {
      if (!groupedProducts.containsKey(product.category)) {
        groupedProducts[product.category] = [];
      }
      groupedProducts[product.category]!.add(product);
    }
    return groupedProducts;
  }

  List<Widget> _buildProductsList(Map<String, List<Product>> products) {
    List<Widget> productList = [];

    products.forEach((category, productListByCategory) {
      if (searchQuery.isEmpty || productListByCategory.isNotEmpty) {
        productList.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    itemCount: productListByCategory.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisExtent: 250,
                      maxCrossAxisExtent: 300,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final product = productListByCategory[index];
                      return GestureDetector(
                          onTap: () {
                            toggleViewProduct();
                            productItem = product;
                          },
                          child: BusinessDataCard(data: product));
                    },
                  );
                },
              )
            ],
          ),
        );
      }
    });

    return productList;
  }

  Widget _showLoadingAnim(double screenWidth) {
    return SizedBox(
        width: screenWidth,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(AppStrings.fetchingData),
            const Gap(10),
            LoadingAnimationWidget.inkDrop(
              color: Theme.of(context).indicatorColor,
              size: 40,
            ),
          ],
        ));
  }

  Widget _searchBar(double screenWidth) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
          width: screenWidth < 1000 ? screenWidth * 0.9 : screenWidth * 0.5,
          height: 40,
          child: SearchBar(
            hintText: 'Search',
            leading: const Icon(Icons.search_outlined),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenWidth = MediaQuery.sizeOf(context).width;
    Map<String, List<Product>> filteredProducts = {};

    return Consumer<ProductProvider>(
      builder: (context, value, child) {
        Map<String, List<Product>> groupedProducts =
            _groupProductsByCategory(value.products);

        groupedProducts.forEach((type, productsServices) {
          filteredProducts[type] = productsServices
              .where((Product product) => product.name
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
              .toList();
        });

        return _isShowProduct
            ? AddProduct(
                action: AppStrings.edit,
                product: productItem!,
                toggleReturn: toggleViewProduct,
              )
            : Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (value.isFetching && value.products.isEmpty)
                          _showLoadingAnim(screenWidth),

                        if (value.products.isEmpty)
                          const Align(
                              alignment: Alignment.center,
                              child: Text('No item')),
                        // Show the products list
                        SizedBox(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: searchQuery.isEmpty
                                ? _buildProductsList(groupedProducts)
                                : _buildProductsList(filteredProducts),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Search bar
                  _searchBar(screenWidth),

                  // FAB
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                  child: AddProduct(
                                action: AppStrings.add,
                                toggleReturn: () {
                                  setState(() {
                                    Navigator.of(context).pop();
                                  });
                                },
                              ));
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.cyan,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  )
                ],
              );
      },
    );
  }
}
