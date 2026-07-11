import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/api/soh_extra_api.dart';
import '../../../../core/utils/api_errors.dart';

final _paymentStatusFilterProvider = StateProvider<PaymentStatus?>((ref) => null);

final _paymentsProvider = FutureProvider.autoDispose<List<PaymentResponse>>((ref) async {
  final status = ref.watch(_paymentStatusFilterProvider);
  final r = await ref
      .watch(paymentApiProvider)
      .paymentGet(status: status, pageSize: 100);
  final items = r?.items ?? [];
  items.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
  return items;
});

String _statusLabel(PaymentStatus? s) {
  if (s == PaymentStatus.number1) return 'Pending';
  if (s == PaymentStatus.number2) return 'Paid';
  if (s == PaymentStatus.number3) return 'Failed';
  if (s == PaymentStatus.number4) return 'Refunded';
  return 'Unknown';
}

class AdminPaymentsListScreen extends ConsumerWidget {
  const AdminPaymentsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_paymentsProvider);
    final filter = ref.watch(_paymentStatusFilterProvider);
    final df = DateFormat.yMMMd().add_Hm();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_paymentsProvider),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Wrap(
              spacing: 8,
              children: [
                _filterChip(ref, null, 'All', filter),
                _filterChip(ref, PaymentStatus.number2, 'Paid', filter),
                _filterChip(ref, PaymentStatus.number1, 'Pending', filter),
                _filterChip(ref, PaymentStatus.number4, 'Refunded', filter),
                _filterChip(ref, PaymentStatus.number3, 'Failed', filter),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(extractApiErrorMessage(e))),
              data: (items) {
                if (items.isEmpty) {
                  return const Center(child: Text('No payments found.'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final p = items[i];
                    final canRefund = p.status == PaymentStatus.number2 && p.id != null;
                    return ListTile(
                      title: Text(
                        '${(p.amount ?? 0).toStringAsFixed(2)} ${p.method ?? ''} · ${_statusLabel(p.status)}',
                      ),
                      subtitle: Text(
                        '${p.createdAt != null ? df.format(p.createdAt!) : '—'}'
                        '${(p.transactionRef ?? '').isNotEmpty ? '\nRef: ${p.transactionRef}' : ''}',
                      ),
                      isThreeLine: (p.transactionRef ?? '').isNotEmpty,
                      trailing: Tooltip(
                        message: canRefund
                            ? 'Refund this payment via PayPal'
                            : 'Refund is only available for paid payments.',
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.currency_exchange, size: 18),
                          label: const Text('Refund'),
                          onPressed:
                              canRefund ? () => _confirmRefund(context, ref, p.id!) : null,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(WidgetRef ref, PaymentStatus? value, String label, PaymentStatus? current) {
    return ChoiceChip(
      label: Text(label),
      selected: current == value,
      onSelected: (_) => ref.read(_paymentStatusFilterProvider.notifier).state = value,
    );
  }

  Future<void> _confirmRefund(BuildContext context, WidgetRef ref, int paymentId) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Refund payment?'),
        content: const Text(
          'This refunds the payment via PayPal and cancels the related appointment. '
          'Refunds are only allowed while the appointment is not completed.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Refund')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await SohExtraApi(ref.read(apiClientProvider)).refundPayment(paymentId);
      ref.invalidate(_paymentsProvider);
      messenger.showSnackBar(const SnackBar(content: Text('Refund completed.')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(extractApiErrorMessage(e, fallback: 'Refund failed.'))));
    }
  }
}
