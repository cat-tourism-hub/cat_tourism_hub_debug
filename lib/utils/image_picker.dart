import 'dart:io';

import 'package:cat_tourism_hub/models/photo.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

Future<List<Photo>> pickMultipleImages(ImagePicker picker) async {
  final List<XFile> pickedFiles = await picker.pickMultiImage();
  List<Photo> photos = [];

  if (pickedFiles.isNotEmpty) {
    if (kIsWeb) {
      for (var file in pickedFiles) {
        Uint8List bytes = await file.readAsBytes();
        photos.add(Photo(path: file.path, webImage: bytes, title: file.name));
      }
    } else {
      photos = pickedFiles.map((file) {
        return Photo(path: file.path, image: File(file.path), title: file.name);
      }).toList();
    }
  }
  return photos;
}

Future<Photo?> pickSingleImage(ImagePicker picker) async {
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    if (kIsWeb) {
      Uint8List bytes = await pickedFile.readAsBytes();
      return Photo(
          path: pickedFile.path, webImage: bytes, title: pickedFile.name);
    } else {
      return Photo(
          path: pickedFile.path,
          image: File(pickedFile.path),
          title: pickedFile.name);
    }
  }
  return null;
}
