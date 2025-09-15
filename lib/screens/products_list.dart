import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/provider_model.dart';
import '../state/providers.dart';
import '../core/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductsListScreen extends ConsumerStatefulWidget {
  final ProviderModel provider;
  const ProductsListScreen({required this.provider, super.key});

  @override
  ConsumerState<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends ConsumerState<ProductsListScreen> {
  double? _distanceMeters;

  @override
  void initState() {
    super.initState();
    _calcDistance();
  }

  Future<void> _calcDistance() async {
    try {
      final pos = await getCurrentLocation();
      final meters = distanceBetween(
        pos.latitude,
        pos.longitude,
        widget.provider.latitude,
        widget.provider.longitude,
      );
      setState(() => _distanceMeters = meters);
    } catch (e) {
      // ignore, location not available
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(
      productsForProviderProvider(widget.provider.id),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Produits — ${widget.provider.name}'),
        bottom: _distanceMeters != null
            ? PreferredSize(
                preferredSize: Size.fromHeight(24),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Distance: ${formatDistanceMeters(_distanceMeters!)}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              )
            : null,
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('Aucun produit'));
          }
          return ListView.separated(
            itemCount: products.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (c, i) {
              final prod = products[i];

              // Déterminer l'URL valide pour l'image
              String? imageUrl;
              if (prod.imageUrl != null && prod.imageUrl!.isNotEmpty) {
                imageUrl = prod.imageUrl!;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : const SizedBox(width: 60, height: 60),
                    title: Text(prod.name),
                    subtitle: Text('${prod.price.toStringAsFixed(2)} €'),
                  ),
                  if (imageUrl != null)
                    SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error, size: 60),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 8),
                  Image.asset(
                    'lib/images/salle2f.jpg',
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  Image.network(
                    "http://127.0.0.1:8000/storage/products/HDczfBnhNczEIybqJNQrqEJ16ofBtmA9V0QLkgM8.png",
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Erreur: $e')),
      ),
    );
  }
}
