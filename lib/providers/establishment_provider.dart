import 'dart:async';
import 'dart:convert';
import 'package:cat_tourism_hub/models/establishment.dart';
import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/material.dart';
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
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('ERROR: $e');
      return e;
    }
  }
}
