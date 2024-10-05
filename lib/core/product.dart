class Product {
  final String? id;
  final String name;
  final String category;
  final String? desc;
  final double price;
  final List? photos;
  final List? included;
  final String pricePer;
  final int? capacity;
  final String tag;
  final bool? availabilityStatus;
  final String? partnerId;

  Product(
      {this.id,
      required this.name,
      required this.category,
      this.desc,
      required this.price,
      required this.photos,
      this.included,
      required this.tag,
      this.capacity,
      this.availabilityStatus,
      required this.pricePer,
      this.partnerId});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        desc: json['desc'] ?? '',
        price: json['price'].toDouble(),
        capacity: json['capacity'],
        pricePer: json['pricePer'] ?? '',
        photos: json['photos'],
        availabilityStatus: json['availabilityStatus'],
        included: json['included'] ?? [],
        tag: json['tag']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'desc': desc ?? '',
      'price': price,
      'capacity': capacity,
      'pricePer': pricePer,
      'included': included,
      'photos': photos,
      'tag': tag,
    };
  }
}
