import 'package:cat_tourism_hub/business/data/product.dart';
import 'package:cat_tourism_hub/core/utils/path_to_image_convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BusinessDataCard extends StatelessWidget {
  const BusinessDataCard({super.key, this.onTap, required this.data});

  final void Function()? onTap;
  final Product data;

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
            child: Container(
              padding: const EdgeInsets.all(contentPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data.photos!.isNotEmpty)
                    SizedBox(
                      height: imageHeight,
                      width: constraints.maxWidth,
                      child: FutureBuilder(
                        future: getDownloadUrl(data.photos![0]),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Gap(12),
                        if (data.desc != null && data.desc!.isNotEmpty)
                          Flexible(
                            child: Text(
                              data.desc ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: determineMaxLines(constraints),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        const Gap(14),
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
                              '${data.price} ',
                              style: const TextStyle(fontSize: 14),
                            ),
                            if (data.pricePer != 'none')
                              Text(
                                '/${data.pricePer}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                          ],
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

  int determineMaxLines(BoxConstraints constraints) {
    if (constraints.maxHeight < 344) {
      return 1;
    } else if (constraints.maxWidth < 600) {
      return 3;
    } else {
      return 2;
    }
  }
}
