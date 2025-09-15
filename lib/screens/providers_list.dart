import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/providers.dart';
import 'products_list.dart';
import '../widgets/provider_tile.dart';

class ProvidersListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProviders = ref.watch(providersListFuture);

    return Scaffold(
      appBar: AppBar(title: Text('Fournisseurs')),
      body: asyncProviders.when(
        data: (providers) {
          if (providers.isEmpty)
            return Center(child: Text('Aucun fournisseur'));
          return ListView.builder(
            itemCount: providers.length,
            itemBuilder: (c, i) {
              final p = providers[i];
              return ProviderTile(
                providerModel: p,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductsListScreen(provider: p),
                  ),
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Erreur: $e')),
      ),
    );
  }
}
