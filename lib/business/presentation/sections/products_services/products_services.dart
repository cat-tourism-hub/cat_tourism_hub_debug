import 'package:cat_tourism_hub/core/components/loading_widget.dart';
import 'package:cat_tourism_hub/core/components/product_list_builder.dart';
import 'package:cat_tourism_hub/core/auth/auth_provider.dart';
import 'package:cat_tourism_hub/business/presentation/sections/products_services/add_edit_product.dart';
import 'package:cat_tourism_hub/core/product.dart';
import 'package:cat_tourism_hub/business/providers/product_provider.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsServices extends StatefulWidget {
  const ProductsServices({super.key});

  @override
  State<ProductsServices> createState() => _ProductsServicesState();
}

class _ProductsServicesState extends State<ProductsServices>
    with AutomaticKeepAliveClientMixin {
  late String _uid;
  String _searchQuery = '';
  List<String>? _categories;
  bool _isDisposed = false;

  @override
  bool get wantKeepAlive => true;

  // void toggleViewProduct() {
  //   setState(() {
  //     _isShowProduct = !_isShowProduct;
  //   });
  // }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final provider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final productProv = Provider.of<ProductProvider>(context, listen: false);
    _uid = provider.user!.uid;
    productProv.fetchProducts(_uid).then((_) {
      if (_isDisposed) return;
      setState(() {
        _categories = _extractCategories(productProv.products);
      });
    });
  }

  List<String> _extractCategories(List<Product> products) {
    final Set<String> categories = {};

    for (var product in products) {
      if (product.category.isNotEmpty) {
        categories.add(product.category);
      }
    }

    return categories.toList();
  }

  Map<String, List<Product>> _groupProductsByTagCategory(
      List<Product> products) {
    Map<String, List<Product>> groupedProducts = {};

    for (var product in products) {
      if (!groupedProducts.containsKey(product.tag)) {
        groupedProducts[product.tag] = [];
      }
      groupedProducts[product.tag]!.add(product);
    }
    return groupedProducts;
  }

  /// Widget for the Search Bar
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
                _searchQuery = value;
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
            _groupProductsByTagCategory(value.products);

        groupedProducts.forEach((tag, productsServices) {
          filteredProducts[tag] = productsServices
              .where((Product product) => product.name
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
              .toList();
        });

        return Stack(
          children: [
            if (value.isFetching && value.products.isEmpty)
              Center(child: LoadingWidget(screenWidth: screenWidth)),

            if (!(value.isFetching) && value.products.isEmpty)
              const Align(alignment: Alignment.center, child: Text('No item')),

            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ProductListBuilder(
                  products:
                      _searchQuery.isEmpty ? groupedProducts : filteredProducts,
                  caller: 'Business',
                  categories: _categories),
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
                          categories: _categories ?? [],
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
                  backgroundColor: Theme.of(context).indicatorColor,
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
