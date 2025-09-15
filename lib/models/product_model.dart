class ProductModel {
  final int id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final int providerId;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    required this.providerId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      throw Exception("Invalid type for double: $value");
    }

    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: parseDouble(json['price']),
      imageUrl: json['image_url'],
      providerId: json['provider_id'],
    );
  }
}
