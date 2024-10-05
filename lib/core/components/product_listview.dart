import 'package:cat_tourism_hub/business/presentation/sections/products_services/components/card.dart';
import 'package:cat_tourism_hub/core/product.dart';
import 'package:cat_tourism_hub/users/presentation/components/product_card.dart';
import 'package:flutter/material.dart';

class ProductListView extends StatelessWidget {
  final List<Product> products;
  final int maxItems;
  final String caller;
  final ScrollController controller;
  final Function(Product) onTapProduct;
  final Function(Product) onEdit;

  const ProductListView(
      {super.key,
      required this.products,
      this.maxItems = 5,
      required this.caller,
      required this.onTapProduct,
      required this.onEdit,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480,
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: products.length > maxItems ? maxItems : products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return InkWell(
            onTap: () => onTapProduct(product),
            child: Container(
              width: 350,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: caller == 'Business'
                  ? BusinessProductCard(
                      product: product,
                      onEdit: onEdit,
                    )
                  : ProductCard(
                      product: product,
                    ),
            ),
          );
        },
      ),
    );
  }
}
