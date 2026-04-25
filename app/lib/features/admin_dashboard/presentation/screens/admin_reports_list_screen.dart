import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';

final _allReportsAdminProvider = FutureProvider.autoDispose<List<ReportResponse>>((ref) async {
  final r = await ref.watch(reportApiProvider).reportGet(retrieveAll: true);
  return r?.items ?? [];
});

class AdminReportsListScreen extends ConsumerWidget {
  const AdminReportsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_allReportsAdminProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_allReportsAdminProvider),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No report records yet. Reports created in the system will appear here.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final df = DateFormat.yMMMd();
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final r = items[i];
              return ListTile(
                title: Text(r.type ?? 'Report #${r.id ?? ''}'),
                subtitle: Text(
                  '${r.filePath ?? '—'}\n${r.generatedAt != null ? df.format(r.generatedAt!) : ''}',
                ),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}
