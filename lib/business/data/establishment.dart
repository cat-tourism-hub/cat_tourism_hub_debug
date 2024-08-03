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
}

// class Contact {
//   String email;
//   String phone;
//   String socialLink;
//   String website;

//   Contact({
//     required this.email,
//     required this.phone,
//     required this.socialLink,
//     required this.website,
//   });

//   factory Contact.fromJson(Map<String, dynamic> json) {
//     return Contact(
//       email: json['email'],
//       phone: json['phone'],
//       socialLink: json['social_link'],
//       website: json['website'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'email': email,
//       'phone': phone,
//       'social_link': socialLink,
//       'website': website,
//     };
//   }
// }

// class Legals {
//   String bussPerm;
//   String dotCert;
//   String sanitPerm;

//   Legals({
//     required this.bussPerm,
//     required this.dotCert,
//     required this.sanitPerm,
//   });

//   factory Legals.fromJson(Map<String, dynamic> json) {
//     return Legals(
//       bussPerm: json['buss_perm'],
//       dotCert: json['dot_cert'],
//       sanitPerm: json['sanit_perm'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'buss_perm': bussPerm,
//       'dot_cert': dotCert,
//       'sanit_perm': sanitPerm,
//     };
//   }
// }

// class Location {
//   String barangay;
//   String bldg;
//   String municipality;
//   String street;

//   Location({
//     required this.barangay,
//     required this.bldg,
//     required this.municipality,
//     required this.street,
//   });

//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       barangay: json['barangay'],
//       bldg: json['bldg'],
//       municipality: json['municipality'],
//       street: json['street'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'barangay': barangay,
//       'bldg': bldg,
//       'municipality': municipality,
//       'street': street,
//     };
//   }
// }
