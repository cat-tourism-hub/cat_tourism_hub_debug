import 'package:cat_tourism_hub/business/data/product.dart';
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
              imagesLink: images ?? [],
              isAssets: false,
              autoPlay: false,
              sliderHeight: 500,
              imageFitMode: BoxFit.contain,
              currentItemShadow: const [],
              sliderDuration: const Duration(milliseconds: 200),
              imageRadius: 0,
              slideViewportFraction: 1.2,
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
                const Gap(8),
                const Wrap(
                  spacing: 8.0,
                  children: [
                    Icon(Icons.location_city, size: 18),
                    Text('City view'),
                    Icon(Icons.ac_unit, size: 18),
                    Text('Air conditioning'),
                    Icon(Icons.bathtub, size: 18),
                    Text('Private Bathroom'),
                    Icon(Icons.tv, size: 18),
                    Text('Flat-screen TV'),
                    Icon(Icons.wifi, size: 18),
                    Text('Free Wifi'),
                  ],
                ),
                const Gap(16),

                // Room Size and Rating
                Text(
                  'Room Size: 11 m²',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const Gap(16),

                // Room Description
                Text(
                  product.desc ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Gap(16),

                // Amenities Section
                Text(
                  'Included in your room:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Gap(8),
                _buildAmenityList(product.included ?? []),
                const Gap(16),

                Text(
                  'Room Facilities:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Gap(8),
                _buildAmenityList([
                  'Laptop safe',
                  'TV',
                  'Refrigerator',
                  'Linens',
                  'Safe',
                  'Wake-up service',
                  'Telephone',
                  'Air conditioning',
                  'Cable channels',
                  'Socket near the bed',
                ]),
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
