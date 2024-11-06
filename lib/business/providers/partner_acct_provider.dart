import 'dart:async';
import 'dart:convert';
import 'package:cat_tourism_hub/business/data/establishment.dart';
import 'package:cat_tourism_hub/business/data/photo.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PartnerAcctProvider with ChangeNotifier {
  Establishment? establishment;
  String? _error;
  bool _isLoading = false;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future getEstablishmentDetails(String uid) async {
    _isLoading = true;
    try {
      final response = await http
          .get(
              Uri.parse('${AppStrings.baseApiUrl}/business/establishment/$uid'))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = json.decode(response.body);
        establishment = Establishment.fromJson(jsonMap);

        notifyListeners();
      } else {
        return response.body;
      }
    } on TimeoutException catch (_) {
      _error = '${AppStrings.error1} Please check your internet connection.';
    } catch (e) {
      debugPrint('ERROR: $e');
      return e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future saveServiceAndAmenities(List<Map<String, dynamic>> dynamicFields,
      String uid, String token) async {
    var url =
        Uri.parse('${AppStrings.baseApiUrl}/business/update_amenities/$uid');

    var headers = {'Authorization': token, 'Content-Type': 'application/json'};

    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(dynamicFields),
    );

    if (response.statusCode == 201) {
      return 'Changes has been saved.';
    } else {
      return 'Error saving. Please refresh page and try again.';
    }
  }

  Future savePartnerDetails(String uid, Establishment establishment) async {
    var url = Uri.parse(
        '${AppStrings.baseApiUrl}/business/establishment/update/$uid');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'estb': {
            'name': establishment.name,
            'about': establishment.about,
            'status': establishment.status,
            'type': establishment.type
          },
          'contact': establishment.contact,
          'location': establishment.location,
        }));
    if (response.statusCode == 201) {
      return 'Changes has been saved';
    } else {
      return 'Failed to save changes';
    }
  }

  Future savePolicy(String text, String uid) async {
    var url = Uri.parse('${AppStrings.baseApiUrl}/business/policies/$uid');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(text));
    if (response.statusCode == 201) {
      return 'Changes has been saved';
    } else {
      return 'Failed to save changes';
    }
  }
}

Future submitForm(Establishment establishment, List<Photo> files) async {
  var uri = Uri.parse('${AppStrings.baseApiUrl}/business/register');

  var headers = {'Content-Type': 'application/json'};
  var formData = {
    ...establishment.toJson(),
  };

  // Convert photo files to base64 strings
  for (var photo in files) {
    if (photo.image != null) {
      // Convert Uint8List to base64 string
      String base64Image = base64Encode(photo.image!);
      formData[photo.title!] = base64Image;
    }
  }

  var response = await http.post(
    uri,
    headers: headers,
    body: jsonEncode(formData),
  );

  if (response.statusCode == 201) {
    return 'Application submitted successfully';
  } else {
    final Map<String, dynamic> responseBody = json.decode(response.body);
    // Extract error message or use a default one
    final String errorMessage =
        responseBody['Error'] ?? 'Unknown error occurred';
    return errorMessage; // Return error message
  }
}
