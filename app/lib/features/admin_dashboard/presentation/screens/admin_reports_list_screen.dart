import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  static String _buildAppointmentsCsv(List<AppointmentResponse> items) {
    final buf = StringBuffer();
    buf.writeln('id,patientId,doctorId,serviceId,roomId,startTime,endTime,status');
    for (final a in items) {
      buf.writeln(
        '${a.id ?? ''},${a.patientId ?? ''},${a.doctorId ?? ''},${a.serviceId ?? ''},${a.roomId ?? ''},'
        '${a.startTime?.toIso8601String() ?? ''},${a.endTime?.toIso8601String() ?? ''},'
        '${a.status?.value ?? ''}',
      );
    }
    return buf.toString();
  }

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  icon: const Icon(Icons.add_chart),
                  label: const Text('Generate summary'),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    try {
                      await ref.read(reportApiProvider).reportPost(
                            reportUpsertRequest: ReportUpsertRequest(
                              type: 'AdminSummary',
                              generatedAt: DateTime.now().toUtc(),
                              filePath:
                                  'virtual/admin-summary-${DateTime.now().millisecondsSinceEpoch}.json',
                            ),
                          );
                      ref.invalidate(_allReportsAdminProvider);
                      messenger.showSnackBar(const SnackBar(content: Text('Report generated.')));
                    } catch (e) {
                      messenger.showSnackBar(SnackBar(content: Text('$e')));
                    }
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.content_copy),
                  label: const Text('Export appointments CSV'),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    try {
                      final r =
                          await ref.read(appointmentApiProvider).appointmentGet(retrieveAll: true);
                      final items = r?.items ?? [];
                      final csv = _buildAppointmentsCsv(items);
                      await Clipboard.setData(ClipboardData(text: csv));
                      messenger.showSnackBar(
                        SnackBar(content: Text('Copied ${items.length} row(s) to clipboard.')),
                      );
                    } catch (e) {
                      messenger.showSnackBar(SnackBar(content: Text('$e')));
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (items) {
                if (items.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No report records yet. Use Generate summary to create one.',
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
          ),
        ],
      ),
    );
  }
}
