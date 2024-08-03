import 'package:cat_tourism_hub/business/data/photo.dart';

class ImageField {
  Photo? image;
  String? caption;

  ImageField({this.image, this.caption});

  ImageField clone() {
    return ImageField(
      image: image != null
          ? Photo(
              title: caption,
              image: image?.image,
            )
          : null,
    );
  }

  bool equals(ImageField other) {
    return image?.title == other.image?.title &&
        image?.image == other.image?.image;
  }
}
