import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class Photo {
  final String? path;
  final String? title;
  final File? image;
  final Uint8List? webImage;

  Photo({this.path, this.title, this.image, this.webImage});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      webImage:
          json['webImage'] != null ? base64Decode(json['webImage']) : null,
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'webImage': webImage != null ? base64Encode(webImage!) : null,
      'title': title,
    };
  }
}
