import 'package:cat_tourism_hub/business/data/product.dart';
import 'package:cat_tourism_hub/core/utils/path_to_image_convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BusinessDataCard extends StatelessWidget {
  const BusinessDataCard({super.key, this.onTap, required this.data});

  final void Function()? onTap;
  final Product data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate card width based on screen width
        final double cardWidth = constraints.maxWidth;

        return GestureDetector(
          onTap: onTap,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: SizedBox(
              width: cardWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  data.photos!.isNotEmpty
                      ? SizedBox(
                          height: constraints.maxHeight * 0.45,
                          width: cardWidth,
                          child: FutureBuilder(
                            future: getDownloadUrl(data.photos![0]),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Image.network(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                          child: Icon(Icons
                                              .broken_image)), // Error placeholder
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return const Center(
                                    child: Text('No Image')); // Placeholder
                              }
                            },
                          ),
                        )
                      : SizedBox(
                          height: constraints.maxHeight * 0.45,
                          width: cardWidth,
                          child: const Center(
                            child: Text('No Image'),
                          ),
                        ),

                  // Data below the Image
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Text(
                          data.name,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        if (data.desc != null &&
                            data.desc!.isNotEmpty &&
                            constraints.maxHeight < 250)
                          Text(
                            data.desc ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: constraints.maxHeight < 344
                                ? 1
                                : constraints.maxWidth < 600
                                    ? 3
                                    : 2,
                            style: const TextStyle(fontSize: 14),
                          ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: SvgPicture.asset(
                                'assets/images/philippines-peso.svg',
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '${data.price} ',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            if (data.pricePer != 'none')
                              Expanded(
                                flex: 2,
                                child: Text(
                                  data.pricePer,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Availability: ${data.availabilityStatus.toString()}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
