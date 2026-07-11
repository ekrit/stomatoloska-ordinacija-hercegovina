import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/api_errors.dart';
import '../../../../core/widgets/paginated_search_view.dart';
import '../../../../widgets/user_appbar_actions.dart' show decodeUserPictureBytes;
import 'admin_product_edit_screen.dart';

class AdminProductsListScreen extends ConsumerStatefulWidget {
  const AdminProductsListScreen({super.key});

  @override
  ConsumerState<AdminProductsListScreen> createState() => _AdminProductsListScreenState();
}

class _AdminProductsListScreenState extends ConsumerState<AdminProductsListScreen> {
  int _refresh = 0;

  void _reload() => setState(() => _refresh++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proizvodi'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final changed = await Navigator.of(context).push<bool>(
            MaterialPageRoute<bool>(builder: (_) => const AdminProductEditScreen()),
          );
          if (changed == true) _reload();
        },
        icon: const Icon(Icons.add),
        label: const Text('Dodaj'),
      ),
      body: PaginatedSearchView<ProductResponse>(
        refreshKey: _refresh,
        searchHint: 'Pretraži proizvode po nazivu ili kategoriji…',
        emptyLabel: 'Nema pronađenih proizvoda.',
        fetch: (query, page, pageSize) async {
          final r = await ref.read(productApiProvider).productGet(
                FTS: query.isEmpty ? null : query,
                page: page,
                pageSize: pageSize,
                includeTotalCount: true,
              );
          return PagedData(items: r?.items ?? [], total: r?.totalCount);
        },
        itemBuilder: (context, p) => ListTile(
          leading: _productThumb(context, p),
          title: Text(p.name ?? 'Proizvod'),
          subtitle: Text(
            '${p.productCategoryName ?? 'Opšte'} - ${p.price?.toStringAsFixed(2) ?? '0.00'} KM',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Obriši',
            onPressed: p.id == null ? null : () => _confirmDelete(context, p),
          ),
          onTap: () async {
            final changed = await Navigator.of(context).push<bool>(
              MaterialPageRoute<bool>(
                builder: (_) => AdminProductEditScreen(product: p),
              ),
            );
            if (changed == true) _reload();
          },
        ),
      ),
    );
  }

  Widget _productThumb(BuildContext context, ProductResponse p) {
    final bytes = decodeUserPictureBytes(p.picture);
    if (bytes == null) {
      return CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Icon(Icons.medical_services_outlined),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.memory(bytes, width: 44, height: 44, fit: BoxFit.cover),
    );
  }

  Future<void> _confirmDelete(BuildContext context, ProductResponse p) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Obrisati proizvod?'),
        content: Text('Remove "${p.name ?? 'this product'}" from the catalog?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Odustani')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Obriši')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(productApiProvider).productIdDelete(p.id!);
      _reload();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(extractApiErrorMessage(e, fallback: 'Proizvod nije moguće obrisati.'))),
      );
    }
  }
}
