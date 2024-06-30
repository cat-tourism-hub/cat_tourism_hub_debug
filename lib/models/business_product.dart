class BusinessProduct {
  final String? id;
  final String name;
  final String? desc;
  final double price;
  final List? photos;
  final List? amenities;

  BusinessProduct(
      {this.id,
      required this.name,
      this.desc,
      required this.price,
      required this.photos,
      this.amenities});

  factory BusinessProduct.fromJson(Map<String, dynamic> json) {
    return BusinessProduct(
      id: json['id'] ?? '',
      name: json['name'],
      desc: json['desc'] ?? '',
      price: json['price'],
      photos: json['photos'] ?? [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'desc': desc,
      'price': price,
      'photos': photos,
    };
  }
}
