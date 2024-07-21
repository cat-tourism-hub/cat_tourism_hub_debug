import 'package:cat_tourism_hub/models/partner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PartnerCard extends StatelessWidget {
  const PartnerCard({super.key, this.onTap, required this.data});

  final void Function()? onTap;
  final Partner data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate card width based on screen width
        final double cardWidth =
            constraints.maxWidth < 300 ? constraints.maxWidth : 300;

        // Utility function to determine device type based on screen width
        int determineMaxLines(double screenWidth) {
          if (screenWidth < 1000) {
            return 2; // Mobile & Tablet
          } else {
            return 3; // Desktop
          }
        }

        final double screenWidth = MediaQuery.of(context).size.width;
        final int maxLines = determineMaxLines(screenWidth);
        return GestureDetector(
          onTap: onTap,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: SizedBox(
              width: cardWidth,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      data.banner != null
                          ? SizedBox(
                              height: constraints.maxHeight * 0.45,
                              width: cardWidth,
                              child: Image.network(
                                data.banner!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Text('Failed to load image'),
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.blue,
                                      color: Colors.blue,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
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
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              data.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                            ),
                            const SizedBox(height: 12),
                            if (data.about != null &&
                                constraints.maxHeight > 250)
                              Text(
                                data.locationString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: maxLines,
                                style: const TextStyle(fontSize: 14),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('From ',
                            style: Theme.of(context).textTheme.bodySmall),
                        SvgPicture.asset(
                          'assets/images/philippines-peso.svg',
                          height: 20,
                          width: 20,
                        ),
                        Text('${data.lowestPrice ?? 1299} ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 28)),
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
