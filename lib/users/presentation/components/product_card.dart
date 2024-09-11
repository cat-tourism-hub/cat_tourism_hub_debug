import 'package:cat_tourism_hub/business/data/establishment.dart';
import 'package:cat_tourism_hub/business/data/product.dart';
import 'package:cat_tourism_hub/core/utils/path_to_image_convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {super.key,
      this.onTap,
      required this.establishment,
      required this.product});

  final void Function()? onTap;
  final Product product;
  final Establishment establishment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double imageHeight = constraints.maxHeight * 0.45;
        const double contentPadding = 16.0;
        return GestureDetector(
          onTap: onTap,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.photos!.isNotEmpty)
                  SizedBox(
                    height: imageHeight,
                    width: constraints.maxWidth,
                    child: FutureBuilder(
                      future: getDownloadUrl(product.photos![0]),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.network(
                            snapshot.data!,
                            fit: BoxFit.cover,
                            width: constraints.maxWidth,
                            height: imageHeight,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(child: Icon(Icons.broken_image)),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: LoadingAnimationWidget.inkDrop(
                                color: Theme.of(context).indicatorColor,
                                size: 30),
                          );
                        } else {
                          return const Center(child: Text('No Image'));
                        }
                      },
                    ),
                  )
                else
                  SizedBox(
                    height: imageHeight,
                    width: constraints.maxWidth,
                    child: const Center(
                      child: Text('No Image'),
                    ),
                  ),

                // Content below the image
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(contentPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Gap(12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/philippines-peso.svg',
                              height: 20,
                              width: 20,
                            ),
                            const Gap(4),
                            Text(
                              '${product.price}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            if (product.pricePer != 'none')
                              Text(
                                '/${product.pricePer}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            const Gap(10),
                            const Text('|'),
                            const Gap(10),
                            _buildCapacity(product.capacity)
                          ],
                        ),
                        const Gap(8),
                        if (product.desc != null && product.desc!.isNotEmpty)
                          Flexible(
                            child: Text(
                              product.desc ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        const Gap(14),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Book Now'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCapacity(capacity) {
    return Row(
        children: List.generate(capacity, (_) => const Icon(Icons.person)));
  }
}
