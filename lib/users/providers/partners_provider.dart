import 'dart:async';
import 'dart:convert';

import 'package:cat_tourism_hub/business/data/establishment.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PartnersProvider extends ChangeNotifier {
  List<Establishment> _partners = [];
  bool _isLoading = false;
  String _error = '';
  Establishment? _partner;

  Establishment? get partner => _partner;
  List<Establishment> get partners => _partners;
  bool get isLoading => _isLoading;
  String get error => _error;

  void setPartner(Establishment partner) {
    _partner = partner;
  }

  Future<void> fetchPartners() async {
    _isLoading = true;

    final url = Uri.parse(AppStrings.baseApiUrl);

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as List<dynamic>;
        _partners = jsonResponse
            .map<Establishment>((partner) => Establishment.fromJson(partner))
            .toList();
      } else {
        _error = 'Failed to load partners. Server error.';
      }
    } on TimeoutException catch (_) {
      _error = '${AppStrings.error1}\nPlease check your internet connection.';
      notifyListeners();
    } catch (e) {
      _error = 'Server Error! Please try again later.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
