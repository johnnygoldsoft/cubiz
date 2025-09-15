class ProviderModel {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  ProviderModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      throw Exception("Invalid type for double: $value");
    }

    return ProviderModel(
      id: json['id'],
      name: json['name'],
      address: json['address'] ?? '',
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
    );
  }
}
