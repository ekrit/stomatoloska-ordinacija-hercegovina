import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/widgets/paginated_search_view.dart';
import '../../../../widgets/user_appbar_actions.dart' show decodeUserPictureBytes;

/// Pregled narudžbi proizvoda sa pretragom i detaljima.
class AdminOrdersListScreen extends ConsumerStatefulWidget {
  const AdminOrdersListScreen({super.key});

  @override
  ConsumerState<AdminOrdersListScreen> createState() => _AdminOrdersListScreenState();
}

class _AdminOrdersListScreenState extends ConsumerState<AdminOrdersListScreen> {
  static final _dateFormat = DateFormat('dd.MM.yyyy HH:mm');
  int _refresh = 0;

  void _reload() => setState(() => _refresh++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Narudžbe'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _reload, tooltip: 'Osvježi')],
      ),
      body: PaginatedSearchView<OrderResponse>(
        refreshKey: _refresh,
        searchHint: 'Pretraži po proizvodu ili pacijentu…',
        emptyLabel: 'Nema pronađenih narudžbi.',
        fetch: (query, page, pageSize) async {
          final r = await ref.read(orderApiProvider).orderGet(
                FTS: query.isEmpty ? null : query,
                page: page,
                pageSize: pageSize,
                includeTotalCount: true,
              );
          return PagedData(items: r?.items ?? [], total: r?.totalCount);
        },
        itemBuilder: (context, o) {
          final bytes = decodeUserPictureBytes(o.productPicture);
          final patient = '${o.patientFirstName ?? ''} ${o.patientLastName ?? ''}'.trim();
          final created = o.createdAt;
          return ListTile(
            leading: bytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(bytes, width: 44, height: 44, fit: BoxFit.cover),
                  )
                : const CircleAvatar(child: Icon(Icons.receipt_long_outlined)),
            title: Text(o.productName?.trim().isNotEmpty == true ? o.productName! : 'Proizvod'),
            subtitle: Text(
              [
                if (patient.isNotEmpty) patient,
                'Količina: ${o.quantity ?? 1}',
                if (created != null) _dateFormat.format(created.toLocal()),
              ].join(' · '),
            ),
            trailing: Text(
              '${(o.totalAmount ?? 0).toStringAsFixed(2)} KM',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            onTap: () => _showDetails(context, o),
          );
        },
      ),
    );
  }

  void _showDetails(BuildContext context, OrderResponse o) {
    final patient = '${o.patientFirstName ?? ''} ${o.patientLastName ?? ''}'.trim();
    final created = o.createdAt;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Detalji narudžbe'),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row('Proizvod', o.productName ?? '—'),
              _row('Pacijent', patient.isEmpty ? '—' : patient),
              _row('Količina', '${o.quantity ?? 1}'),
              _row('Ukupan iznos', '${(o.totalAmount ?? 0).toStringAsFixed(2)} KM'),
              _row('Datum', created != null ? _dateFormat.format(created.toLocal()) : '—'),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Zatvori')),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
