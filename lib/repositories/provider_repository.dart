import '../models/provider_model.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProviderRepository {
  final ApiService api;
  ProviderRepository(this.api);

  Future<List<ProviderModel>> fetchProviders() async {
    final raw = await api.getList('/providers');
    return raw.map((m) => ProviderModel.fromJson(m)).toList();
  }

  Future<List<ProductModel>> fetchProductsForProvider(int providerId) async {
    final raw = await api.getList('/providers/$providerId/products');
    return raw.map((m) => ProductModel.fromJson(m)).toList();
  }

  Future<ProductModel> fetchProduct(int productId) async {
    final raw = await api.getItem('/products/$productId');
    return ProductModel.fromJson(raw);
  }

  Future<List<ProductModel>> fetchAllProducts() async {
    final list = await api.getList('/products');
    return list.map((e) => ProductModel.fromJson(e)).toList();
  }
}
