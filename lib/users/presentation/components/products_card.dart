import 'package:cat_tourism_hub/business/data/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Corrected package import
import 'package:gap/gap.dart';

class ProductsCard extends StatelessWidget {
  const ProductsCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/dot_catanduanes.jpg',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const Gap(16),
            Text(
              product.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Gap(10),
            // Row(
            //   children: [
            //     SvgPicture.asset(
            //       'assets/images/philippines-peso.svg',
            //       height: 20,
            //       width: 20,
            //     ),
            //     const Gap(3),
            //     Text(
            //       product.price.toString(),
            //       overflow: TextOverflow.ellipsis,
            //     ),
            //     const Gap(3),
            //     Text(product.pricePer),
            //   ],
            // ),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}
