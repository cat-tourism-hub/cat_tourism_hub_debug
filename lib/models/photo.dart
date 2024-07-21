import 'dart:convert';
import 'dart:typed_data';

class Photo {
  final String? title;
  final Uint8List? image;
  final String? link;

  Photo({this.title, this.image, this.link});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      image: json['image'] != null ? base64Decode(json['image']) : null,
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image != null ? base64Encode(image!) : null,
      'title': title,
    };
  }
}
