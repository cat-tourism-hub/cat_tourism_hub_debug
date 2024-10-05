import 'package:cat_tourism_hub/core/product.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProductInfo extends StatelessWidget {
  final Product product;
  final List<String>? images;

  const ProductInfo({super.key, required this.product, this.images});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            flex: 1,
            child: FanCarouselImageSlider.sliderType2(
              initalPageIndex: 0,
              isClickable: false,
              imagesLink: images ?? [],
              isAssets: false,
              sliderHeight: 500,
              imageFitMode: BoxFit.contain,
              slideViewportFraction: 0.9,
              currentItemShadow: const [],
              sliderDuration: const Duration(milliseconds: 200),
              imageRadius: 0,
            ),
          ),
          const Gap(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const Gap(16),
                Text('Category: ${product.category}',
                    style: Theme.of(context).textTheme.bodyMedium),

                const Gap(16),
                Text('Capacity: ${product.capacity.toString()}',
                    style: Theme.of(context).textTheme.bodyMedium),

                const Gap(16),

                // Room Description
                Text(
                  product.desc ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Gap(16),

                // Amenities Section
                Text(
                  'Amenities Included:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Gap(8),
                _buildAmenityList(product.included ?? []),
                const Gap(16),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  // Method to build the amenity list
  Widget _buildAmenityList(List amenities) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 8.0,
      children: amenities.map((amenity) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check, size: 16),
            const Gap(8),
            Text(amenity),
          ],
        );
      }).toList(),
    );
  }
}
