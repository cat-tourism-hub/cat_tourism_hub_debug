import 'package:cat_tourism_hub/core/components/product_listview.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:cat_tourism_hub/core/product.dart';
import 'package:cat_tourism_hub/users/presentation/components/scroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

/// A stateless widget to generate the product list on both client
/// and business account

class ProductListBuilder extends StatelessWidget {
  final Map<String, List<Product>> products;
  final List<String>? categories;
  final String caller;
  final void Function(Product product)? onTap;
  const ProductListBuilder(
      {super.key,
      required this.products,
      required this.caller,
      this.onTap,
      this.categories});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: products.entries.map((entry) {
        ScrollController scrollController = ScrollController();
        String tag = entry.key;
        List<Product> products = entry.value;
        // Define the minimum number of items that trigger scroll buttons
        int minItemsForScrolling = 3; // Change based on your layout needs

        return Column(
            key: ValueKey(tag),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Render the tag as a section header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        tag,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                  if (products.length > minItemsForScrolling)
                    TextButton(
                        onPressed: () {}, child: const Text(AppStrings.seeAll))
                ],
              ),
              // const Divider(thickness: 1),
              const Gap(8),
              // Render products horizontally under this tag
              Stack(alignment: Alignment.center, children: [
                SizedBox(
                    height: 450,
                    child: ProductListView(
                        products: products,
                        controller: scrollController,
                        caller: caller,
                        onEdit: (product) {
                          if (kIsWeb || kIsWasm) {
                            context.go('/edit/${product.name}', extra: {
                              'product': product,
                              'categories': categories ?? [],
                            });
                          } else {
                            context.push('/edit/${product.name}', extra: {
                              'product': product,
                              'categories': categories ?? [],
                            });
                          }
                        },
                        onTapProduct: (product) {
                          if (onTap != null) {
                            onTap!(
                                product); // Pass the product to onTap callback
                          }
                        })),
                if (kIsWasm || kIsWeb)
                  if (products.length > minItemsForScrolling) ...[
                    // Left Scroll Button
                    Positioned(
                      left: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white60,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          iconSize: 30,
                          color: Colors.red,
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => scrollLeft(scrollController),
                        ),
                      ),
                    ),

                    // Right Scroll Button
                    Positioned(
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white60,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          iconSize: 30,
                          icon: const Icon(Icons.arrow_forward),
                          color: Colors.red,
                          onPressed: () => scrollRight(scrollController),
                        ),
                      ),
                    ),
                    const Gap(30),
                  ]
              ]),
              const Gap(30),
            ]);
      }).toList(),
    );
  }
}
