import 'package:auto_size_text/auto_size_text.dart';
import 'package:cat_tourism_hub/core/components/feature_unavailable.dart';
import 'package:cat_tourism_hub/core/product.dart';
import 'package:cat_tourism_hub/core/utils/path_to_image_convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BaseProductCard extends StatelessWidget {
  const BaseProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.showBookButton = false,
  });

  final Product product;
  final void Function()? onTap;
  final bool showBookButton;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double contentPadding = 10.0;

        return GestureDetector(
          onTap: onTap,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                buildImageSection(context, constraints),

                // Content Section (Customizable)
                Padding(
                  padding: const EdgeInsets.all(contentPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildContent(context), // Customizable content section

                      const Gap(20),

                      // Conditionally show "Book Now" button
                      if (showBookButton) _buildBookNowButton(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Protected method for the image section, can be overridden
  @protected
  Widget buildImageSection(BuildContext context, BoxConstraints constraints) {
    return product.photos!.isNotEmpty
        ? SizedBox(
            width: constraints.maxWidth,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: FutureBuilder(
                  future: getDownloadUrl(product.photos![0]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Image.network(
                        snapshot.data!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Icon(Icons.broken_image)),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.inkDrop(
                          color: Theme.of(context).indicatorColor,
                          size: 30,
                        ),
                      );
                    } else {
                      return const Center(child: Text('No Image'));
                    }
                  },
                ),
              ),
            ),
          )
        : const SizedBox(
            child: Center(child: Text('No Image')),
          );
  }

  // Protected method for the content section, can be overridden
  @protected
  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name
        AutoSizeText(
          product.name,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const Gap(12),
        FittedBox(
            child: Text(product.category,
                style: Theme.of(context).textTheme.bodyMedium)),
        const Gap(10),

        // Price and Capacity Row
        Row(
          children: [
            SvgPicture.asset(
              'assets/images/philippines-peso.svg',
              height: 20,
              width: 25,
            ),
            const Gap(4),
            Text(
              '${product.price} ',
              style: const TextStyle(fontSize: 20),
            ),
            if (product.pricePer != 'none')
              Text(
                product.pricePer,
                style: const TextStyle(fontSize: 14),
              ),
            const Gap(10),
            const Text('|'),
            const Gap(10),
            Flexible(child: _buildCapacity(product.capacity ?? 0)),
          ],
        ),
        const Gap(20),

        // Product Description
        if (product.desc != null && product.desc!.isNotEmpty)
          AutoSizeText(
            product.desc ?? '',
            maxLines: 1,
            minFontSize: 14,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  // Protected method for the "Book Now" button, can be overridden
  @protected
  Widget _buildBookNowButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
              context: context, builder: (_) => const FeatureUnavailable());
        },
        child: const FittedBox(child: Text('Book Now')),
      ),
    );
  }

  // Method to build capacity icons
  Widget _buildCapacity(int capacity) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: List.generate(
        capacity,
        (_) => const Icon(Icons.person, size: 16),
      ),
    );
  }
}
