import 'dart:convert';
import 'package:cat_tourism_hub/models/establishment.dart';
import 'package:cat_tourism_hub/models/photo.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

Future<List<Establishment>> fetchEstablishmentsFromSqlServer() async {
  try {
    // print('Sending request to the server...');
    // final response = await http.get(Uri.parse('http://127.0.0.1:5000/'));
    // print('Response received with status code: ${response.statusCode}');

    // if (response.statusCode == 200) {
    //   List<dynamic> data = json.decode(response.body);
    //   return data.map((item) => Establishment.fromJson(item)).toList();
    // } else {
    //   throw Exception('Failed to load data');
    // }
    return [];
  } catch (e) {
    print('An error occurred: $e');
    rethrow;
  }
}

Future<void> submitForm(Establishment establishment, List<Photo> files) async {
  var uri = Uri.parse('http://127.0.0.1:5000/business/register');
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
      print('Form submitted successfully');
    } else {
      print('Failed to submit form');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
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
      print('Form submitted successfully');
    } else {
      print('Failed to submit form');
      print('Status code: ${response.statusCode}');
    }
  }
}
