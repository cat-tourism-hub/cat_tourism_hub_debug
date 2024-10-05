import 'package:cat_tourism_hub/core/components/base_product_card.dart';
import 'package:cat_tourism_hub/core/product.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, this.onTap, required this.product});

  final void Function()? onTap;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return BaseProductCard(
      product: product,
      onTap: onTap,
      showBookButton: true,
    );
  }
}
