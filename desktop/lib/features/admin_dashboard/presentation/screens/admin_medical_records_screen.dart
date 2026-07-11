import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/widgets/paginated_search_view.dart';

/// Pregled nalaza (medicinske dokumentacije) sa pretragom — samo za čitanje;
/// nalaze unosi doktor kroz svoj tok rada.
class AdminMedicalRecordsScreen extends ConsumerStatefulWidget {
  const AdminMedicalRecordsScreen({super.key});

  @override
  ConsumerState<AdminMedicalRecordsScreen> createState() =>
      _AdminMedicalRecordsScreenState();
}

class _AdminMedicalRecordsScreenState extends ConsumerState<AdminMedicalRecordsScreen> {
  static final _dateFormat = DateFormat('dd.MM.yyyy HH:mm');
  int _refresh = 0;

  void _reload() => setState(() => _refresh++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nalazi'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _reload, tooltip: 'Osvježi')],
      ),
      body: PaginatedSearchView<MedicalRecordResponse>(
        refreshKey: _refresh,
        searchHint: 'Pretraži po dijagnozi, tretmanu ili pacijentu…',
        emptyLabel: 'Nema pronađenih nalaza.',
        fetch: (query, page, pageSize) async {
          final r = await ref.read(medicalRecordApiProvider).medicalRecordGet(
                FTS: query.isEmpty ? null : query,
                page: page,
                pageSize: pageSize,
                includeTotalCount: true,
              );
          return PagedData(items: r?.items ?? [], total: r?.totalCount);
        },
        itemBuilder: (context, record) {
          final created = record.createdAt;
          return ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(record.diagnosis ?? '—', maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: Text(
              [
                if ((record.treatment ?? '').trim().isNotEmpty) record.treatment!.trim(),
                if (created != null) _dateFormat.format(created.toLocal()),
              ].join(' · '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => _showDetails(context, record),
          );
        },
      ),
    );
  }

  void _showDetails(BuildContext context, MedicalRecordResponse record) {
    final created = record.createdAt;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Detalji nalaza'),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nalaz', style: Theme.of(ctx).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(record.diagnosis ?? '—'),
                const SizedBox(height: 12),
                Text('Stručno mišljenje', style: Theme.of(ctx).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text((record.treatment ?? '').trim().isEmpty ? '—' : record.treatment!),
                if (created != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Kreirano: ${_dateFormat.format(created.toLocal())}',
                    style: Theme.of(ctx).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Zatvori')),
        ],
      ),
    );
  }
}
