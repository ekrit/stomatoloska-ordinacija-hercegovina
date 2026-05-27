import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import 'admin_product_edit_screen.dart';

final _productsAdminProvider = FutureProvider.autoDispose<List<ProductResponse>>((ref) async {
  final r = await ref.watch(productApiProvider).productGet(retrieveAll: true);
  return r?.items ?? [];
});

class AdminProductsListScreen extends ConsumerWidget {
  const AdminProductsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_productsAdminProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_productsAdminProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final changed = await Navigator.of(context).push<bool>(
            MaterialPageRoute<bool>(builder: (_) => const AdminProductEditScreen()),
          );
          if (changed == true) ref.invalidate(_productsAdminProvider);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No products found.'));
          }
          items.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final p = items[i];
              return ListTile(
                title: Text(p.name ?? 'Product #${p.id ?? ''}'),
                subtitle: Text(
                  '${p.category ?? 'General'} - ${p.price?.toStringAsFixed(2) ?? '0.00'} KM',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete',
                  onPressed: p.id == null
                      ? null
                      : () async {
                          await ref.read(productApiProvider).productIdDelete(p.id!);
                          ref.invalidate(_productsAdminProvider);
                        },
                ),
                onTap: () async {
                  final changed = await Navigator.of(context).push<bool>(
                    MaterialPageRoute<bool>(
                      builder: (_) => AdminProductEditScreen(product: p),
                    ),
                  );
                  if (changed == true) ref.invalidate(_productsAdminProvider);
                },
              );
            },
          );
        },
      ),
    );
  }
}
