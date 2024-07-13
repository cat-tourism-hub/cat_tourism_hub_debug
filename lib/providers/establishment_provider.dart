import 'dart:async';
import 'dart:convert';
import 'package:cat_tourism_hub/models/establishment.dart';
import 'package:cat_tourism_hub/models/photo.dart';
import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class EstablishmentProvider with ChangeNotifier {
  Establishment? establishment;

  Future getEstablishmentDetails(String uid) async {
    try {
      final response = await http.get(
          Uri.parse('${AppStrings.baseApiUrl}/business/establishment/$uid'));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = json.decode(response.body);
        establishment = Establishment.fromJson(jsonMap);

        notifyListeners();
      } else {
        return response.body;
      }
    } catch (e) {
      debugPrint('ERROR: $e');
      return e;
    }
  }

  Future saveServiceAndAmenities(List<Map<String, dynamic>> dynamicFields,
      String uid, String token) async {
    var url =
        Uri.parse('${AppStrings.baseApiUrl}/business/update_amenities/$uid');
    http.MultipartRequest request;

    // Determine platform
    if (kIsWeb) {
      // For web, upload files directly
      var headers = {
        'Authorization': token,
        'Content-Type': 'application/json'
      };

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(dynamicFields),
      );

      if (response.statusCode == 201) {
        return 'Form submitted successfully';
      } else {
        return 'Failed to submit form: ${response.body}';
      }
    } else {
      // For mobile, use multipart request
      request = http.MultipartRequest('POST', url);

      var response = await request.send();
      if (response.statusCode == 201) {
        return 'Form submitted successfully';
      } else {
        return 'Failed to submit form: ${response.statusCode}';
      }
    }
  }
}

Future submitForm(Establishment establishment, List<Photo> files) async {
  var uri = Uri.parse('${AppStrings.baseApiUrl}/business/register');
  http.MultipartRequest request;

  // Determine platform
  if (kIsWeb) {
    // For web, upload files directly
    var headers = {'Content-Type': 'application/json'};
    var formData = {
      ...establishment.toJson(),
    };

    // Convert photo files to base64 strings
    for (var photo in files) {
      if (photo.webImage != null) {
        // Convert Uint8List to base64 string
        String base64Image = base64Encode(photo.webImage!);
        formData[photo.title!] = base64Image;
      }
    }

    var response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(formData),
    );

    if (response.statusCode == 201) {
      return 'Form submitted successfully';
    } else {
      return 'Failed to submit form: ${response.body}';
    }
  } else {
    // For mobile, use multipart request
    request = http.MultipartRequest('POST', uri);

    // Add form fields from Establishment object
    establishment.toJson().forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add photo files
    for (var photo in files) {
      if (photo.image != null) {
        request.files.add(http.MultipartFile.fromBytes(
          photo.title!,
          photo.image!.readAsBytesSync(),
          filename: photo.title,
        ));
      }
    }

    var response = await request.send();
    if (response.statusCode == 201) {
      return 'Form submitted successfully';
    } else {
      return 'Failed to submit form: ${response.statusCode}';
    }
  }
}
