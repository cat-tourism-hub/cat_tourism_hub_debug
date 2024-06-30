import 'dart:convert';

import 'package:cat_tourism_hub/models/establishment.dart';
import 'package:cat_tourism_hub/models/hotel_room.dart';
import 'package:cat_tourism_hub/values/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HotelProvider with ChangeNotifier {
  List<HotelRoom> rooms = [];
  bool isFetching = false;

  void addHotel(HotelRoom hotel) {
    rooms.add(hotel);
    notifyListeners();
  }

  void removeHotel(String id) {
    rooms.removeWhere((hotel) => hotel.id == id);
    notifyListeners();
  }

  Future<void> fetchHotels(String uid) async {
    try {
      isFetching = true;

      final response = await http.get(
        Uri.parse('${AppStrings.baseApiUrl}/business/services/$uid'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        rooms =
            data.map<HotelRoom>((item) => HotelRoom.fromJson(item)).toList();
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

  Future uploadNewRoom(String token, String uid, Establishment establishment,
      HotelRoom room) async {
    var uri = Uri.parse('${AppStrings.baseApiUrl}/business/services/$uid/add');
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
        rooms.add(
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
