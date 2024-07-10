class Partner {
  final String? name;
  final String? about;
  final String? type;
  final String? logo;
  final String? banner;
  final Map? location;
  final Map? contact;

  Partner({
    this.name,
    this.about,
    this.type,
    this.logo,
    this.banner,
    this.location,
    this.contact,
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
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'about': about,
      'type': type,
      'location': location,
      'contact': contact,
    };
  }
}
