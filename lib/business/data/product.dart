class Product {
  final String? id;
  final String name;
  final String category;
  final String? desc;
  final double price;
  final List? photos;
  final List? included;
  final String pricePer;
  final Map<String, dynamic>? otherServices;
  final bool? availabilityStatus;

  Product(
      {this.id,
      required this.name,
      required this.category,
      this.desc,
      required this.price,
      required this.photos,
      this.included,
      this.availabilityStatus,
      required this.pricePer,
      this.otherServices});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        desc: json['desc'] ?? '',
        price: json['price'].toDouble(),
        pricePer: json['pricePer'] ?? '',
        photos: json['photos'],
        availabilityStatus: json['availabilityStatus'],
        included: json['included'] ?? [],
        otherServices: json['otherServices']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'desc': desc ?? '',
      'price': price,
      'pricePer': pricePer,
      'included': included,
      'photos': photos,
      'otherServices': otherServices
    };
  }
}
