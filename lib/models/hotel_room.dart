import 'package:cat_tourism_hub/models/business_product.dart';
import 'package:flutter/foundation.dart';

class HotelRoom extends BusinessProduct {
  final String pricePer;
  final Map<String, dynamic>? otherServices;
  final bool? availabilityStatus;

  HotelRoom(
      {super.id,
      required super.name,
      super.desc,
      required super.price,
      required super.photos,
      super.amenities,
      this.availabilityStatus,
      required this.pricePer,
      this.otherServices});

  factory HotelRoom.fromJson(Map<String, dynamic> json) {
    return HotelRoom(
        id: json['id'] ?? '',
        name: json['name'],
        desc: json['desc'],
        price: json['price'],
        pricePer: json['pricePer'] ?? '',
        photos: json['photos'],
        availabilityStatus: json['availabilityStatus'],
        amenities: json['amenities'] ?? [],
        otherServices: json['otherServices']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'desc': desc ?? '',
      'price': price,
      'pricePer': pricePer,
      'amenities': amenities,
      'photos': kIsWeb ? photos?.map((e) => e.toJson()).toList() : photos,
      'otherServices': otherServices
    };
  }
}
