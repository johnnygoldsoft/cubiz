import 'package:carousel_slider/carousel_slider.dart';
import 'package:cubiz/screens/providerDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../state/providers.dart';
import '../models/provider_model.dart';
import '../models/product_model.dart';
import 'product_detail_screen.dart';
import 'dart:math';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  // Ajoute cette fonction en dehors de la classe Widget
  Color _getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(200) + 55, // Evite les couleurs trop sombres
      random.nextInt(200) + 55,
      random.nextInt(200) + 55,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providersAsync = ref.watch(providersListFuture);
    final productsAsync = ref.watch(allProductsProvider);

    // Liste d'images pour le carrousel de promotion
    final List<String> promoImages = [
      'https://media.istockphoto.com/id/1314479726/fr/photo/cubes-de-bouillon-et-autres-ingr%C3%A9dients-pour-la-soupe-sur-la-table-en-bois-plats.jpg?s=612x612&w=0&k=20&c=kUMZkasc2pl7ziGEbTBjTleD3edUl7l9Vv9r5vB07AE=',
      'https://media.istockphoto.com/id/1365537599/fr/photo/bouillon-de-cube.jpg?s=612x612&w=0&k=20&c=X1Po2qSk4Bq1A8fmRK1V6AqI3EsikRDMrBXfdsicIJA=',
      'https://media.istockphoto.com/id/1917224991/fr/photo/vegetable-bouillon-broth-cubes-on-wooden-table.jpg?s=612x612&w=0&k=20&c=8Dn7ZDGQZQ10eAw9GBCCzFOkIS6GrFnp0E-NSyz3rPk=',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("CubiZ - Market"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher un produit...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (query) {
                ref.read(productSearchProvider.notifier).state = query;
              },
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Force le rechargement des providers & produits
          ref.refresh(providersListFuture);
          ref.refresh(allProductsProvider);
        },
        child: ListView(
          children: [
            // 🖼️ Carrousel de promotion
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                ),
                items: promoImages.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: item,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            // 🏪 Carrousel fournisseurs
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Nos Point de vente",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 120,
              child: providersAsync.when(
                data: (providers) {
                  if (providers.isEmpty) {
                    return const Center(child: Text("Aucun fournisseur"));
                  }
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: providers.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final p = providers[index];
                      return _buildProviderCard(context, p);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Erreur: $e")),
              ),
            ),

            // 🛒 Produits
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Nos Produits",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text("Aucun produit"));
                }

                // Récupérer le texte de recherche
                final searchQuery = ref
                    .watch(productSearchProvider)
                    .toLowerCase();

                // Filtrer les produits
                final filteredProducts = products.where((p) {
                  return p.name.toLowerCase().contains(searchQuery);
                }).toList();

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 colonnes
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return _buildProductCard(context, product);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Erreur: $e")),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Widget fournisseur (carrousel)
  /// 🔹 Widget fournisseur (carrousel)
  Widget _buildProviderCard(BuildContext context, ProviderModel provider) {
    // Génère une couleur aléatoire pour la carte
    final randomColor = _getRandomColor();

    return GestureDetector(
      onTap: () {
        // Redirection vers la page détail fournisseur
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProviderDetailScreen(providerId: provider.id),
          ),
        );
      },
      child: Container(
        width: 150, // Taille de la carte plus large
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // Coins plus arrondis
          color: randomColor,
          boxShadow: [
            BoxShadow(
              color: randomColor.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône ou image du fournisseur (optionnel, à ajouter si disponible)
            const Icon(Icons.storefront, color: Colors.white, size: 40),
            const SizedBox(height: 8),
            Text(
              provider.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white, // Texte blanc pour un meilleur contraste
                fontSize: 16,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Widget produit (grille)
  Widget _buildProductCard(BuildContext context, ProductModel product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.pinkAccent.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: product.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: product.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.image_not_supported,
                              color: Colors.grey.shade400,
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    "${product.price.toStringAsFixed(2)} Cfa",
                    style: TextStyle(
                      color: Colors.deepPurple.shade700,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  color: Colors.redAccent,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
