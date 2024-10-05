import 'package:cat_tourism_hub/core/components/base_product_card.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:cat_tourism_hub/core/product.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BusinessProductCard extends BaseProductCard {
  final Function(Product) onEdit;
  const BusinessProductCard({
    super.key,
    required super.product,
    required this.onEdit,
  });

  @override
  Widget buildContent(BuildContext context) {
    // Custom content for BusinessProductCard
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        super.buildContent(context), // Use base content too
        const Gap(18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () => onEdit(product),
                    child: const Text(AppStrings.edit))),
            const Gap(10),
            Expanded(
                child: ElevatedButton(
                    onPressed: () {}, child: const Text('Archive')))
          ],
        )
      ],
    );
  }
}
