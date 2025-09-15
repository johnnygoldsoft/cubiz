import 'package:cubiz/models/provider_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../services/api_service.dart';
import '../repositories/provider_repository.dart';
import '../models/provider_model.dart';
import '../models/product_model.dart';

// singleton ApiService
final apiServiceProvider = Provider((ref) => ApiService());

// repository
final providerRepo = Provider(
  (ref) => ProviderRepository(ref.read(apiServiceProvider)),
);

// providers list
final providersListFuture = FutureProvider<List<ProviderModel>>((ref) {
  return ref.read(providerRepo).fetchProviders();
});

// Texte de recherche pour filtrer les produits
final productSearchProvider = StateProvider<String>((ref) => '');

// all products (all providers)
final allProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  return ref.read(providerRepo).fetchAllProducts();
});

// products for a provider (parametrized)
final productsForProviderProvider =
    FutureProvider.family<List<ProductModel>, int>((ref, providerId) {
      return ref.read(providerRepo).fetchProductsForProvider(providerId);
    });

final providerDetailFuture = FutureProvider.family<ProviderDetail, int>((
  ref,
  providerId,
) {
  return ref.read(apiServiceProvider).fetchProviderDetail(providerId);
});
