import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soh_api/api.dart';

import '../../../../widgets/user_appbar_actions.dart' show decodeUserPictureBytes;

/// Detalj pojedinačne narudžbe (details dio master-details prikaza).
class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.order});

  final OrderResponse order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bytes = decodeUserPictureBytes(order.productPicture);
    final created = order.createdAt;
    final df = DateFormat('dd.MM.yyyy. HH:mm');
    final qty = order.quantity ?? 1;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalji narudžbe')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (bytes != null)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(bytes, height: 140, fit: BoxFit.cover),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            order.productName?.trim().isNotEmpty == true
                ? order.productName!
                : 'Proizvod',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.numbers_outlined),
                  title: const Text('Količina'),
                  trailing: Text('$qty', style: theme.textTheme.titleMedium),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.payments_outlined),
                  title: const Text('Ukupan iznos'),
                  trailing: Text(
                    '${(order.totalAmount ?? 0).toStringAsFixed(2)} KM',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.event_outlined),
                  title: const Text('Datum narudžbe'),
                  trailing: Text(
                    created != null ? df.format(created.toLocal()) : '—',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Narudžbu preuzimate i plaćate u ordinaciji. Cijena je potvrđena iz kataloga ordinacije.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
