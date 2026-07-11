import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/api_errors.dart';
import '../../../../core/widgets/paginated_search_view.dart';
import '../providers/lookup_providers.dart';

/// Pregled recenzija pacijenata sa pretragom i brisanjem (moderacija).
class AdminReviewsListScreen extends ConsumerStatefulWidget {
  const AdminReviewsListScreen({super.key});

  @override
  ConsumerState<AdminReviewsListScreen> createState() => _AdminReviewsListScreenState();
}

class _AdminReviewsListScreenState extends ConsumerState<AdminReviewsListScreen> {
  static final _dateFormat = DateFormat('dd.MM.yyyy HH:mm');
  int _refresh = 0;

  void _reload() => setState(() => _refresh++);

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(patientsLookupProvider).maybeWhen(
          data: (m) => m,
          orElse: () => const <int, String>{},
        );
    final doctors = ref.watch(doctorsLookupProvider).maybeWhen(
          data: (m) => m,
          orElse: () => const <int, String>{},
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recenzije'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _reload, tooltip: 'Osvježi')],
      ),
      body: PaginatedSearchView<ReviewResponse>(
        refreshKey: _refresh,
        searchHint: 'Pretraži po komentaru, pacijentu ili doktoru…',
        emptyLabel: 'Nema pronađenih recenzija.',
        fetch: (query, page, pageSize) async {
          final r = await ref.read(reviewApiProvider).reviewGet(
                FTS: query.isEmpty ? null : query,
                page: page,
                pageSize: pageSize,
                includeTotalCount: true,
              );
          return PagedData(items: r?.items ?? [], total: r?.totalCount);
        },
        itemBuilder: (context, review) {
          final rating = review.rating ?? 0;
          final patient = patients[review.patientId] ?? 'Pacijent';
          final doctor = doctors[review.doctorId] ?? 'Doktor';
          final created = review.createdAt;
          return ListTile(
            leading: CircleAvatar(child: Text('$rating★')),
            title: Text('$patient → $doctor'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((review.comment ?? '').trim().isNotEmpty)
                  Text(review.comment!.trim(), maxLines: 2, overflow: TextOverflow.ellipsis),
                if (created != null)
                  Text(
                    _dateFormat.format(created.toLocal()),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: review.id == null ? 'Brisanje nije moguće' : 'Obriši recenziju',
              onPressed: review.id == null ? null : () => _confirmDelete(context, review),
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, ReviewResponse review) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Obrisati recenziju?'),
        content: const Text('Recenzija će biti trajno uklonjena.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Odustani')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Obriši')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(reviewApiProvider).reviewIdDelete(review.id!);
      messenger.showSnackBar(const SnackBar(content: Text('Recenzija je obrisana.')));
      _reload();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(extractApiErrorMessage(e, fallback: 'Recenziju nije moguće obrisati.'))),
      );
    }
  }
}
