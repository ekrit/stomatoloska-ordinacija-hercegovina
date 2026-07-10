import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../core/api/api_providers.dart';
import '../../../core/api/soh_extra_api.dart';
import '../../../core/utils/api_errors.dart';
import '../../../widgets/user_appbar_actions.dart' show decodeUserPictureBytes;
import '../../patient/presentation/providers/patient_data_providers.dart';

/// Detalj proizvoda sa objašnjenjem preporuke i naručivanjem (količina +
/// potvrda). Otvaranje ekrana bilježi `DetailOpened` interakciju koju server
/// boduje više od običnog pregleda (vidi dokumentaciju recommendera).
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
  int _quantity = 1;
  bool _ordering = false;

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

  Future<void> _order() async {
    final p = widget.product;
    if (p.id == null) return;
    final messenger = ScaffoldMessenger.of(context);

    final patientId = await ref.read(patientIdProvider.future);
    if (patientId == null) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Dopunite svoj pacijentski profil prije naručivanja.'),
        ),
      );
      return;
    }

    if (!mounted) return;
    final total = (p.price ?? 0) * _quantity;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Potvrda narudžbe'),
        content: Text(
          'Naručiti ${p.name ?? 'proizvod'} (količina: $_quantity) '
          'za ukupno ${total.toStringAsFixed(2)} KM?\n\n'
          'Konačnu cijenu potvrđuje ordinacija iz svog kataloga.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Odustani'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Naruči'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _ordering = true);
    try {
      await ref.read(orderApiProvider).orderPost(
            orderUpsertRequest: OrderUpsertRequest(
              patientId: patientId,
              productId: p.id!,
              quantity: _quantity,
            ),
          );
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Narudžba za "${p.name ?? 'proizvod'}" je uspješno kreirana.',
          ),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(extractApiErrorMessage(e,
              fallback: 'Narudžbu nije moguće kreirati. Pokušajte ponovo.')),
        ),
      );
    } finally {
      if (mounted) setState(() => _ordering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final theme = Theme.of(context);
    final bytes = decodeUserPictureBytes(p.picture);
    return Scaffold(
      appBar: AppBar(title: Text(p.name ?? 'Proizvod')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (bytes != null)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(bytes, height: 160, fit: BoxFit.cover),
              ),
            ),
          const SizedBox(height: 12),
          Text(p.name ?? 'Proizvod', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          if ((p.productCategoryName ?? '').isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text(p.productCategoryName!),
                visualDensity: VisualDensity.compact,
              ),
            ),
          const SizedBox(height: 12),
          if (p.price != null)
            Text(
              '${p.price!.toStringAsFixed(2)} KM',
              style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary),
            ),
          const SizedBox(height: 16),
          if ((p.description ?? '').isNotEmpty) ...[
            Text('Opis', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(p.description!),
            const SizedBox(height: 20),
          ],
          if (widget.reasons.isNotEmpty) ...[
            Text('Zašto preporučujemo ovaj proizvod', style: theme.textTheme.titleMedium),
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
            const SizedBox(height: 12),
          ],
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Količina', style: theme.textTheme.titleMedium),
              const Spacer(),
              IconButton(
                onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                icon: const Icon(Icons.remove_circle_outline),
                tooltip: _quantity > 1 ? 'Smanji' : 'Najmanja količina je 1',
              ),
              Text('$_quantity', style: theme.textTheme.titleMedium),
              IconButton(
                onPressed: _quantity < 20 ? () => setState(() => _quantity++) : null,
                icon: const Icon(Icons.add_circle_outline),
                tooltip: 'Povećaj',
              ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _ordering ? null : _order,
            icon: _ordering
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.shopping_cart_checkout),
            label: const Text('Naruči'),
          ),
        ],
      ),
    );
  }
}
