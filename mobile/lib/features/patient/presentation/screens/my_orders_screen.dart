import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/api_errors.dart';
import '../../../../widgets/user_appbar_actions.dart' show decodeUserPictureBytes;
import '../../../shop/presentation/product_catalog_screen.dart';
import '../providers/patient_data_providers.dart';
import 'order_detail_screen.dart';

String orderAmountLabel(num value) => '${value.toStringAsFixed(2)} KM';

final _ordersProvider = FutureProvider.autoDispose<List<OrderResponse>>((ref) async {
  final patientId = await ref.watch(patientIdProvider.future);
  if (patientId == null) return [];
  final r = await ref.watch(orderApiProvider).orderGet(patientId: patientId, pageSize: 100);
  return r?.items ?? [];
});

/// Historija narudžbi pacijenta (master); detalj se otvara dodirom
/// (details). Nove narudžbe se kreiraju iz kataloga proizvoda.
class MyOrdersScreen extends ConsumerWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_ordersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Moje narudžbe')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push<void>(
            MaterialPageRoute<void>(builder: (_) => const ProductCatalogScreen()),
          );
          ref.invalidate(_ordersProvider);
        },
        icon: const Icon(Icons.storefront_outlined),
        label: const Text('Katalog proizvoda'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(extractApiErrorMessage(e))),
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Još nemate narudžbi. Otvorite katalog proizvoda i naručite nešto za njegu zuba.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(_ordersProvider),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final o = items[i];
                final bytes = decodeUserPictureBytes(o.productPicture);
                final qty = o.quantity ?? 1;
                return ListTile(
                  leading: bytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(bytes, width: 48, height: 48, fit: BoxFit.cover),
                        )
                      : const CircleAvatar(child: Icon(Icons.receipt_long_outlined)),
                  title: Text(o.productName?.trim().isNotEmpty == true
                      ? o.productName!
                      : 'Proizvod'),
                  subtitle: Text('Količina: $qty'),
                  trailing: Text(orderAmountLabel(o.totalAmount ?? 0)),
                  onTap: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) => OrderDetailScreen(order: o),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
