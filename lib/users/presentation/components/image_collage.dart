import 'package:cat_tourism_hub/business/data/photo.dart';
import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/components/dynamic_fields/image_field.dart';
import 'package:flutter/material.dart';
import 'package:image_collage/image_collage.dart';

import '../../../core/components/image_caption_widget.dart';

class ImageCollageWidget extends StatelessWidget {
  final List<Img> images;
  final List<String> captions;

  const ImageCollageWidget({
    required this.images,
    required this.captions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      width: MediaQuery.of(context).size.width * 0.45,
      child: ImageCollage(
        images: images,
        margin: const EdgeInsets.all(2),
        onClick: (clickedImg, images) {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      childAspectRatio: 1,
                    ),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: ImageCaptionWidget(
                            imageField: ImageField(
                              caption: captions[index],
                              image: Photo(link: images[index].image),
                            ),
                            isEditMode: false,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
