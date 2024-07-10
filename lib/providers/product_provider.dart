import 'dart:convert';

import 'package:cat_tourism_hub/models/establishment.dart';
import 'package:cat_tourism_hub/models/product.dart';
import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Product> products = [];
  bool isFetching = false;

  // void addHotel(HotelRoom hotel) {
  //   rooms.add(hotel);
  //   notifyListeners();
  // }

  // void removeHotel(String id) {
  //   rooms.removeWhere((hotel) => hotel.id == id);
  //   notifyListeners();
  // }

  Future<void> migrateServices() async {
    try {
      isFetching = true;

      final response = await http.post(
        Uri.parse('${AppStrings.baseApiUrl}/business/migrate-services'),
      );

      if (response.statusCode == 200) {
        debugPrint('Services migrated');
      } else {
        throw Exception('Failed to migrate services');
      }
    } catch (e) {
      print(e);
    } finally {
      isFetching = false;
      notifyListeners();
    }
  }

  Future<void> fetchProducts(String uid) async {
    try {
      isFetching = true;

      final response = await http.get(
        Uri.parse('${AppStrings.baseApiUrl}/business/services/$uid'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        products = data.map<Product>((item) => Product.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load hotels');
      }
    } catch (e) {
      print(e);
    } finally {
      isFetching = false;
      notifyListeners();
    }
  }

  Future uploadNewProduct(String token, String uid, Establishment establishment,
      Product room) async {
    var uri = Uri.parse('${AppStrings.baseApiUrl}/business/$uid/services/add');
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': token,
      };
      var formData = {
        ...room.toJson(),
      };
      final response =
          await http.post(uri, headers: headers, body: jsonEncode(formData));

      if (response.statusCode == 201) {
        products.add(
            room); // Add to the hotel room list without fetching from db again

        notifyListeners();
        return 'Room added successfully';
      } else {
        return 'Failed to add room: ${response.body}';
      }
    } catch (e) {
      print(e);
    }
  }
}
