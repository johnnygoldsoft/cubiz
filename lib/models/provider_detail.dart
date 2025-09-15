import 'product_model.dart';

class ProviderDetail {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final List<ProductModel> products;

  ProviderDetail({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.products,
  });

  factory ProviderDetail.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return ProviderDetail(
      id: json['id'],
      name: json['name'],
      address: json['address'] ?? '',
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
