import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../core/api/api_providers.dart';
import '../../../core/api/soh_extra_api.dart';

/// Product detail with the full list of recommender reasons. Opening this
/// screen logs a `DetailOpened` interaction, which the server scores higher
/// than a plain view (see recommender docs).
class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
    this.reasons = const [],
  });

  final ProductResponse product;
  final List<String> reasons;

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    final id = widget.product.id;
    if (id != null) {
      // Best-effort: don't block the UI if tracking fails.
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          await SohExtraApi(ref.read(apiClientProvider))
              .trackProductInteraction(productId: id, kind: 'DetailOpened');
        } catch (_) {}
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(p.name ?? 'Product')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(p.name ?? 'Product', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          if ((p.productCategoryName ?? '').isNotEmpty)
            Chip(label: Text(p.productCategoryName!), visualDensity: VisualDensity.compact),
          const SizedBox(height: 12),
          if (p.price != null)
            Text(
              '${p.price!.toStringAsFixed(2)} KM',
              style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary),
            ),
          const SizedBox(height: 16),
          if ((p.description ?? '').isNotEmpty) ...[
            Text('Description', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(p.description!),
            const SizedBox(height: 20),
          ],
          if (widget.reasons.isNotEmpty) ...[
            Text('Why we recommend this', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ...widget.reasons.map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline, size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(child: Text(r)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
