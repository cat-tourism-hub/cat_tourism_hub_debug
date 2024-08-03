import 'package:flutter/material.dart';

import '../constants/strings/strings.dart';
import 'path_to_image_convert.dart';

class CachedImage extends StatefulWidget {
  final String imageUrl;
  final double? imageWidth;
  final BoxFit? imageFit;
  const CachedImage(
      {super.key, required this.imageUrl, this.imageWidth, this.imageFit});

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  ImageProvider? _imageProvider;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (widget.imageUrl.isNotEmpty) {
      String? downloadUrl = await getDownloadUrl(widget.imageUrl);
      if (mounted) {
        setState(() {
          _imageProvider = NetworkImage(downloadUrl);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _imageProvider != null
        ? Image(
            image: _imageProvider!,
            width: widget.imageWidth,
            fit: widget.imageFit ?? BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Text(AppStrings.errorImage));
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          )
        : const Center(child: CircularProgressIndicator());
  }
}
