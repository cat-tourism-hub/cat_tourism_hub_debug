import 'dart:convert';

import 'package:cat_tourism_hub/models/partner.dart';
import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PartnersProvider extends ChangeNotifier {
  List<Partner> _partners = [];
  bool _isLoading = false;
  String _error = '';

  List<Partner> get partners => _partners;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchPartners() async {
    _isLoading = true;

    try {
      final response = await http.get(Uri.parse('${AppStrings.baseApiUrl}/'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        _partners =
            jsonResponse.map((partner) => Partner.fromJson(partner)).toList();
      } else {
        _error = 'Failed to load partners';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
