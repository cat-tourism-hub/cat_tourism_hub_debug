import 'package:cat_tourism_hub/auth/auth_provider.dart';
import 'package:cat_tourism_hub/business/components/card.dart';
import 'package:cat_tourism_hub/business/sections/subsections/add_product.dart';
import 'package:cat_tourism_hub/models/product.dart';
import 'package:cat_tourism_hub/providers/product_provider.dart';
import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class ProductsServices extends StatefulWidget {
  const ProductsServices({super.key});

  @override
  State<ProductsServices> createState() => _ProductsServicesState();
}

class _ProductsServicesState extends State<ProductsServices> {
  bool showAddProduct = false;
  late String token;
  late String uid;
  String searchQuery = '';

  void toggleAddProduct() {
    setState(() {
      showAddProduct = !showAddProduct;
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

  List<Widget> _buildProductsList(
      Map<String, List<Product>> products, int crossAxisCount) {
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
              LayoutBuilder(builder: (context, constraints) {
                return GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  itemCount: productListByCategory.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: constraints.maxWidth < 580 &&
                              constraints.maxWidth > 420
                          ? 4 / 3
                          : 4 / 4),
                  itemBuilder: (BuildContext context, int index) {
                    final product = productListByCategory[index];
                    return BusinessDataCard(data: product);
                  },
                );
              }),
            ],
          ),
        );
      }
    });

    return productList;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double gridItemWidth = screenWidth < 1000 ? 300 : 400;
    int crossAxisCount =
        (MediaQuery.of(context).size.width / gridItemWidth).floor();
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

        return showAddProduct
            ? AddProduct(
                toggleAddRoom: toggleAddProduct,
              )
            : Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (value.isFetching && value.products.isEmpty)
                          SizedBox(
                              width: screenWidth,
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(AppStrings.fetchingData),
                                  LoadingAnimationWidget.waveDots(
                                    color: Colors.black,
                                    size: 50,
                                  ),
                                ],
                              )),
                        SizedBox(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: searchQuery.isEmpty
                                ? _buildProductsList(
                                    groupedProducts, crossAxisCount)
                                : _buildProductsList(
                                    filteredProducts, crossAxisCount),
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                        width: screenWidth < 1000
                            ? screenWidth * 0.9
                            : screenWidth * 0.5,
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
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: toggleAddProduct,
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
