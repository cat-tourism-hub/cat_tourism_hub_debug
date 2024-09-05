import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/components/dynamic_fields/image_field.dart';
import 'package:flutter/material.dart';

import '../constants/strings/strings.dart';

class ImageCaptionWidget extends StatelessWidget {
  final ImageField imageField;
  final VoidCallback? onTap;
  final bool isEditMode;
  final VoidCallback? onDelete;
  final TextEditingController? captionController;

  const ImageCaptionWidget(
      {super.key,
      required this.imageField,
      this.onTap,
      required this.isEditMode,
      this.onDelete,
      this.captionController});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return GestureDetector(
      onTap: isEditMode ? onTap : null,
      child: Stack(
        children: [
          Container(
            height: isMobile ? 200 : 300,
            width: isMobile ? 200 : 400,
            color:
                imageField.image == null ? Colors.grey[300] : Colors.grey[200],
            child: imageField.image == null
                ? const Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                : imageField.image!.link != null
                    ? Image.network(
                        imageField.image!.link!,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text('Failed to load image'),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).indicatorColor,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      )
                    : Image.memory(
                        fit: BoxFit.contain, imageField.image!.image!),
          ),
          if (!isEditMode && imageField.caption != null)
            Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                child: Container(
                    color: Colors.white.withOpacity(0.7),
                    child: Center(child: Text(imageField.caption ?? '')))),
          if (isEditMode && imageField.image != null)
            Positioned(
              right: 0,
              child: IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.close, color: Colors.red),
              ),
            ),
          if (isEditMode && imageField.image != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.white.withOpacity(0.7),
                child: TextFormField(
                  controller: captionController,
                  decoration: const InputDecoration(
                    hintText: AppStrings.caption,
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? AppStrings.captionPrompt
                      : null,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
