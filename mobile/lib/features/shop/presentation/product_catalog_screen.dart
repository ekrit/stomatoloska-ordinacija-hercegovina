import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../core/api/api_providers.dart';
import '../../../core/utils/api_errors.dart';
import '../../../widgets/user_appbar_actions.dart' show decodeUserPictureBytes;
import '../../home/presentation/product_detail_screen.dart';

/// Katalog preporučenih proizvoda za njegu zuba: pregled po kategorijama,
/// pretraga i naručivanje preko detalja proizvoda.
final _categoriesProvider =
    FutureProvider.autoDispose<List<ProductCategoryResponse>>((ref) async {
  final r = await ref.watch(productCategoryApiProvider).productCategoryGet(pageSize: 100);
  return r?.items ?? [];
});

final _productsProvider = FutureProvider.autoDispose
    .family<List<ProductResponse>, int?>((ref, categoryId) async {
  final r = await ref.watch(productApiProvider).productGet(
        productCategoryId: categoryId,
        pageSize: 100,
      );
  return r?.items ?? [];
});

class ProductCatalogScreen extends ConsumerStatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  ConsumerState<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends ConsumerState<ProductCatalogScreen> {
  int? _categoryId;

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(_categoriesProvider);
    final products = ref.watch(_productsProvider(_categoryId));

    return Scaffold(
      appBar: AppBar(title: const Text('Proizvodi za njegu')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: categories.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text(extractApiErrorMessage(e)),
              data: (list) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Sve'),
                      selected: _categoryId == null,
                      onSelected: (_) => setState(() => _categoryId = null),
                    ),
                    for (final c in list.where((c) => c.id != null)) ...[
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: Text(c.name ?? ''),
                        selected: _categoryId == c.id,
                        onSelected: (_) => setState(() => _categoryId = c.id),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: products.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(extractApiErrorMessage(e))),
              data: (list) {
                if (list.isEmpty) {
                  return const Center(child: Text('Nema proizvoda u ovoj kategoriji.'));
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(_productsProvider(_categoryId)),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final p = list[i];
                      final bytes = decodeUserPictureBytes(p.picture);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          leading: bytes != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(bytes,
                                      width: 52, height: 52, fit: BoxFit.cover),
                                )
                              : CircleAvatar(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                                  child: const Icon(Icons.medical_services_outlined),
                                ),
                          title: Text(p.name ?? 'Proizvod'),
                          subtitle: Text(p.productCategoryName ?? ''),
                          trailing: Text(
                            '${(p.price ?? 0).toStringAsFixed(2)} KM',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          onTap: () {
                            Navigator.of(context).push<void>(
                              MaterialPageRoute<void>(
                                builder: (_) => ProductDetailScreen(product: p),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
