import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

/// Fetches image data from the given URL.
Future<Uint8List?> getImageData(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

/// Retrieves the download URL for a file stored in Firebase Storage.
Future<String> getDownloadUrl(String? filePath) async {
  final FirebaseStorage storage = FirebaseStorage.instance;
  try {
    return await storage
        .ref(filePath ?? '')
        .getDownloadURL()
        .timeout(const Duration(seconds: 30));
  } catch (e) {
    return 'Error loading image';
  }
}
