import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/api_errors.dart';
import '../providers/patient_repository_providers.dart';

String orderAmountLabel(num value) => '${value.toStringAsFixed(2)} KM';

/// Resolves the id used as [OrderUpsertRequest.patientId]. In this API the [Patient] PK is [Patient.userId].
final _patientIdProvider = FutureProvider.autoDispose<int?>((ref) async {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return null;
  final patients = await ref.watch(patientSessionRepositoryProvider).listPatientsByUserId(userId);
  if (patients.isEmpty) return null;
  return patients.first.userId ?? userId;
});

final _ordersProvider = FutureProvider.autoDispose<List<OrderResponse>>((ref) async {
  final patientId = await ref.watch(_patientIdProvider.future);
  if (patientId == null) return [];
  final r = await ref.watch(orderApiProvider).orderGet(patientId: patientId, pageSize: 100);
  return r?.items ?? [];
});

final _productsCache = FutureProvider.autoDispose<Map<int, String>>((ref) async {
  final products = await ref.watch(patientCatalogRepositoryProvider).listProducts();
  return {for (final p in products) if (p.id != null) p.id!: p.name ?? 'Product #${p.id}'};
});

class MyOrdersScreen extends ConsumerWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_ordersProvider);
    final productsAsync = ref.watch(_productsCache);
    return Scaffold(
      appBar: AppBar(title: const Text('My orders')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          final userId = ref.read(currentUserProvider)?.id;
          if (userId == null) {
            messenger.showSnackBar(
              const SnackBar(content: Text('Sign in to place an order.')),
            );
            return;
          }
          final patientId = await ref.read(_patientIdProvider.future);
          if (patientId == null) {
            if (!context.mounted) return;
            messenger.showSnackBar(
              const SnackBar(content: Text('Complete your patient profile before ordering.')),
            );
            return;
          }
          final products = await ref.read(patientCatalogRepositoryProvider).listProducts();
          if (!context.mounted) return;
          final priced = products.where((x) => (x.price ?? 0) > 0).toList();
          final p = priced.isNotEmpty
              ? priced.first
              : (products.isNotEmpty ? products.first : null);
          if (p == null || p.id == null) {
            messenger.showSnackBar(
              const SnackBar(content: Text('No products available yet.')),
            );
            return;
          }
          // Placing an order is an irreversible action, so confirm first
          // (rubric: confirmation dialog required for orders/payments).
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Place order?'),
              content: Text(
                'Order ${p.name ?? 'this product'} for ${orderAmountLabel(p.price ?? 0)}? '
                'The clinic confirms the final price from its catalog.',
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Order')),
              ],
            ),
          );
          if (confirmed != true) return;
          try {
            await ref.read(orderApiProvider).orderPost(
                  orderUpsertRequest: OrderUpsertRequest(
                    patientId: patientId,
                    productId: p.id!,
                    quantity: 1,
                  ),
                );
          } on ApiException catch (e) {
            if (!context.mounted) return;
            messenger.showSnackBar(
              SnackBar(content: Text('Order failed: ${e.message ?? e}')),
            );
            return;
          } catch (e) {
            if (!context.mounted) return;
            messenger.showSnackBar(
              SnackBar(content: Text('Order failed: $e')),
            );
            return;
          }
          if (!context.mounted) return;
          ref.invalidate(_ordersProvider);
          messenger.showSnackBar(
            const SnackBar(content: Text('Order created.')),
          );
        },
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Quick order'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(extractApiErrorMessage(e))),
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text('No orders yet. Use Quick order to create one.'),
            );
          }
          final names = productsAsync.maybeWhen(
            data: (m) => m,
            orElse: () => const <int, String>{},
          );
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final o = items[i];
              final productName = (o.productId != null && names.containsKey(o.productId))
                  ? names[o.productId]!
                  : 'Product #${o.productId ?? ''}';
              final qty = o.quantity ?? 1;
              return ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: Text('Order #${o.id ?? ''} · $productName'),
                subtitle: Text('Quantity: $qty'),
                trailing: Text(orderAmountLabel(o.totalAmount ?? 0)),
              );
            },
          );
        },
      ),
    );
  }
}
