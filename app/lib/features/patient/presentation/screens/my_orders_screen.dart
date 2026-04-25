import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../providers/patient_repository_providers.dart';

String orderAmountLabel(num value) => '${value.toStringAsFixed(2)} KM';

final _patientIdProvider = FutureProvider.autoDispose<int?>((ref) async {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return null;
  final patients = await ref.watch(patientSessionRepositoryProvider).listPatientsByUserId(userId);
  return patients.isEmpty ? null : patients.first.id;
});

final _ordersProvider = FutureProvider.autoDispose<List<OrderResponse>>((ref) async {
  final patientId = await ref.watch(_patientIdProvider.future);
  if (patientId == null) return [];
  final r = await ref.watch(orderApiProvider).orderGet(patientId: patientId, retrieveAll: true);
  return r?.items ?? [];
});

class MyOrdersScreen extends ConsumerWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_ordersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My orders')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final patientId = await ref.read(_patientIdProvider.future);
          if (patientId == null) return;
          final products = await ref.read(patientCatalogRepositoryProvider).listProducts();
          if (products.isEmpty || !context.mounted) return;
          final p = products.first;
          await ref.read(orderApiProvider).orderPost(
                orderUpsertRequest: OrderUpsertRequest(
                  patientId: patientId,
                  totalAmount: p.price ?? 0,
                ),
              );
          if (!context.mounted) return;
          ref.invalidate(_ordersProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order created.')),
          );
        },
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Quick order'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text('No orders yet. Use Quick order to create one.'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final o = items[i];
              return ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: Text('Order #${o.id ?? ''}'),
                subtitle: Text('Patient #${o.patientId ?? ''}'),
                trailing: Text(orderAmountLabel(o.totalAmount ?? 0)),
              );
            },
          );
        },
      ),
    );
  }
}
