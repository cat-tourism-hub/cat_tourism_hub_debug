import 'package:cat_tourism_hub/business/data/photo.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

Future<List<Photo>> pickMultipleImages(ImagePicker picker) async {
  final List<XFile> pickedFiles = await picker.pickMultiImage();
  List<Photo> photos = [];

  if (pickedFiles.isNotEmpty) {
    for (var file in pickedFiles) {
      Uint8List bytes = await file.readAsBytes();
      photos.add(Photo(image: bytes, title: file.name));
    }
  }
  return photos;
}

Future<Photo?> pickSingleImage(ImagePicker picker) async {
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    Uint8List bytes = await pickedFile.readAsBytes();
    return Photo(image: bytes, title: pickedFile.name);
  }
  return null;
}
