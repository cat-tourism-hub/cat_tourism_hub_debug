import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BusinessDataCard extends StatelessWidget {
  const BusinessDataCard({super.key, this.onTap, this.data});

  final void Function()? onTap;
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate card width based on screen width
        final double cardWidth = constraints.maxWidth;

        return GestureDetector(
          onTap: onTap,
          child: Card(
            shape: ContinuousRectangleBorder(
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
                  data.photos?.length > 0
                      ? SizedBox(
                          height: constraints.maxHeight * 0.45,
                          width: cardWidth,
                          child: Image.network(
                            data.photos?.first,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Text('Failed to load image'),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.blue,
                                  color: Colors.blue,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
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
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          overflow: TextOverflow.ellipsis,
                          data.name,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 5),
                        if (data.desc.isNotEmpty && constraints.maxHeight > 250)
                          Text(
                            maxLines: constraints.maxHeight < 260 ? 1 : 2,
                            overflow: TextOverflow.ellipsis,
                            data.desc,
                            style: const TextStyle(fontSize: 14),
                          ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisSize: MainAxisSize.min,
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
                            Flexible(
                              child: Text(
                                data.pricePer,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                            'Availability: ${data.availabilityStatus.toString()}',
                            style: Theme.of(context).textTheme.labelMedium)
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
