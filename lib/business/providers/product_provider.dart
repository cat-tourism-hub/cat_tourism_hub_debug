import 'dart:async';
import 'dart:convert';

import 'package:cat_tourism_hub/business/data/establishment.dart';
import 'package:cat_tourism_hub/core/product.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Product> products = [];
  bool isFetching = false;
  String? _error;
  String? get error => _error;

  Future<void> fetchProducts(String uid) async {
    try {
      isFetching = true;

      final response = await http
          .get(
            Uri.parse('${AppStrings.baseApiUrl}/business/services/$uid'),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        products = data.map<Product>((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      isFetching = false;
      notifyListeners();
    }
  }

  Future addEditProduct(String action, String? itemId, String token, String uid,
      Establishment establishment, Product product) async {
    Uri? uri;
    if (action == AppStrings.add) {
      uri = Uri.parse('${AppStrings.baseApiUrl}/business/$uid/services/add');
    } else {
      uri = Uri.parse(
          '${AppStrings.baseApiUrl}/business/$uid/services/edit/$itemId');
    }

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': token,
      };
      var formData = {
        ...product.toJson(),
      };
      final response = await http
          .post(uri, headers: headers, body: jsonEncode(formData))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        return 'Product/Service $action successful.';
      } else {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String errorMessage = responseBody['Error'] ?? 'Unknown error';

        return 'Failed to add product/service: $errorMessage';
      }
    } on TimeoutException catch (_) {
      _error = 'Timeout error. Please check internet connection.';
    } finally {
      fetchProducts(uid);
      notifyListeners();
    }
  }

  Future editProduct(String action, String? itemId, String token, String uid,
      Establishment establishment, Product product) async {
    Uri? uri;
    if (action == AppStrings.add) {
      uri = Uri.parse('${AppStrings.baseApiUrl}/business/$uid/services/add');
    } else {
      uri = Uri.parse(
          '${AppStrings.baseApiUrl}/business/$uid/services/edit/$itemId');
    }

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': token,
      };
      var formData = {
        ...product.toJson(),
      };
      final response = await http
          .post(uri, headers: headers, body: jsonEncode(formData))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        return 'Product/Service $action successful.';
      } else {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String errorMessage = responseBody['Error'] ?? 'Unknown error';

        return 'Failed to edit product/service: $errorMessage';
      }
    } on TimeoutException catch (_) {
      _error = 'Timeout error. Please check internet connection.';
    } finally {
      fetchProducts(uid);
      notifyListeners();
    }
  }
}
