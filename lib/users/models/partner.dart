import 'package:cat_tourism_hub/business/data/establishment.dart';

class Partner extends Establishment {
  final double? lowestPrice;

  Partner({
    super.id,
    super.name,
    super.about,
    super.type,
    super.logo,
    super.banner,
    this.lowestPrice,
    super.location,
    super.contact,
    super.amenities,
    super.facilities,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      name: json['estb']['name'],
      about: json['estb']['about'],
      logo: json['logo'],
      banner: json['banner'],
      type: json['estb']['type'],
      location: json['location'],
      contact: json['contact'],
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'about': about,
      'type': type,
      'location': location,
      'contact': contact,
    };
  }

  String locationString() {
    return '${location?['bldg']}, ${location?['street']}, ${location?['brgy']}, ${location?['municipality']}';
  }
}
