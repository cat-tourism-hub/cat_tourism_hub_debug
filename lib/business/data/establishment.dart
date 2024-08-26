class Establishment {
  String? id;
  String? name;
  String? about;
  String? type;
  String? policies;
  final String? logo;
  final String? banner;
  String? status;
  final String? userUid;
  final Map? location;
  final Map? contact;
  final Map? legals;
  final Map? facilities;
  final List? amenities;

  Establishment(
      {this.id,
      this.name,
      this.about,
      this.type,
      this.policies,
      this.logo,
      this.banner,
      this.status,
      this.userUid,
      this.location,
      this.contact,
      this.legals,
      this.facilities,
      this.amenities});

  factory Establishment.fromJson(Map<String, dynamic> json) {
    return Establishment(
        name: json['estb']['name'],
        about: json['estb']['about'],
        logo: json['logo'],
        policies: json['policies'],
        banner: json['banner'],
        type: json['estb']['type'],
        status: json['estb']['status'],
        location: json['location'],
        contact: json['contact'],
        legals: json['legals'],
        facilities: json['facilities'],
        amenities: json['amenities']);
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'about': about,
      'type': type,
      'status': status,
      'location': location,
      'contact': contact,
    };
  }

  String locationString() {
    return '${location?['bldg']}, ${location?['street']}, ${location?['brgy']}, ${location?['municipality']}';
  }
}
