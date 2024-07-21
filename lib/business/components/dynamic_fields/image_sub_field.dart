import 'package:cat_tourism_hub/models/photo.dart';

class ImageSubField {
  Photo? image;

  ImageSubField({this.image});

  ImageSubField clone() {
    return ImageSubField(
      image: image != null
          ? Photo(
              title: image?.title,
              image: image?.image,
            )
          : null,
    );
  }

  bool equals(ImageSubField other) {
    return image?.title == other.image?.title &&
        image?.image == other.image?.image;
  }
}
