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
    // productProv.migrateServices();
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

  List<Widget> _buildProductsList(List<Product> products, int crossAxisCount) {
    Map<String, List<Product>> groupedProducts =
        _groupProductsByCategory(products);
    List<Widget> productList = [];

    groupedProducts.forEach((category, productListByCategory) {
      if (productListByCategory.isNotEmpty) {
        productList.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                itemCount: productListByCategory.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 4 / 3.5),
                itemBuilder: (BuildContext context, int index) {
                  final product = productListByCategory[index];
                  return BusinessDataCard(data: product);
                },
              ),
            ],
          ),
        );
      }
    });

    return productList;
  }

  @override
  Widget build(BuildContext context) {
    double gridItemWidth = MediaQuery.of(context).size.width < 1000 ? 300 : 400;
    int crossAxisCount =
        (MediaQuery.of(context).size.width / gridItemWidth).floor();

    return Consumer<ProductProvider>(
      builder: (context, value, child) {
        return showAddProduct
            ? AddProduct(
                toggleAddRoom: toggleAddProduct,
              )
            : Stack(
                children: [
                  Column(
                    children: [
                      if (value.isFetching && value.products.isEmpty)
                        Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(AppStrings.fetchingData),
                            LoadingAnimationWidget.waveDots(
                              color: Colors.black,
                              size: 50,
                            ),
                          ],
                        )),
                      ..._buildProductsList(value.products, crossAxisCount),
                    ],
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
