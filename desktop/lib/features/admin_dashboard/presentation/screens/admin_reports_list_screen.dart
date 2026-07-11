import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/api/soh_extra_api.dart';
import '../../../../core/widgets/paginated_search_view.dart';

class AdminReportsListScreen extends ConsumerStatefulWidget {
  const AdminReportsListScreen({super.key});

  @override
  ConsumerState<AdminReportsListScreen> createState() => _AdminReportsListScreenState();
}

class _AdminReportsListScreenState extends ConsumerState<AdminReportsListScreen> {
  int _refresh = 0;

  void _reload() => setState(() => _refresh++);

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
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMd().add_Hm();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Izvještaji'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
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
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: const Text('PDF: Pregled termina'),
                  onPressed: () => _downloadPdf(
                    () => SohExtraApi(ref.read(apiClientProvider)).downloadAppointmentsSummaryPdf(),
                    'appointments-summary',
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.print_outlined),
                  label: const Text('Štampaj: Pregled termina'),
                  onPressed: () => _printPdf(
                    () => SohExtraApi(ref.read(apiClientProvider)).downloadAppointmentsSummaryPdf(),
                    'Pregled termina',
                  ),
                ),
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.pie_chart_outline),
                  label: const Text('PDF: Prihod po uslugama'),
                  onPressed: () => _downloadPdf(
                    () => SohExtraApi(ref.read(apiClientProvider)).downloadRevenueByServicePdf(months: 6),
                    'revenue-by-service',
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.print_outlined),
                  label: const Text('Štampaj: Prihod po uslugama'),
                  onPressed: () => _printPdf(
                    () => SohExtraApi(ref.read(apiClientProvider)).downloadRevenueByServicePdf(months: 6),
                    'Prihod po uslugama',
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.content_copy),
                  label: const Text('Izvezi termine (CSV)'),
                  onPressed: _exportCsv,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: PaginatedSearchView<ReportResponse>(
              refreshKey: _refresh,
              searchHint: 'Pretraži izvještaje po tipu ili parametrima…',
              emptyLabel: 'Još nema zapisa o izvještajima. Preuzmite PDF iznad da kreirate zapis.',
              fetch: (query, page, pageSize) async {
                final r = await ref.read(reportApiProvider).reportGet(
                      FTS: query.isEmpty ? null : query,
                      page: page,
                      pageSize: pageSize,
                      includeTotalCount: true,
                    );
                final items = r?.items ?? [];
                // Newest first.
                items.sort((a, b) => (b.generatedAt ?? DateTime(0)).compareTo(a.generatedAt ?? DateTime(0)));
                return PagedData(items: items, total: r?.totalCount);
              },
              itemBuilder: (context, r) => ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(r.type ?? 'Report #${r.id ?? ''}'),
                subtitle: Text(
                  '${r.parameters ?? '—'}'
                  '${r.generatedAt != null ? '\n${df.format(r.generatedAt!)}' : ''}',
                ),
                isThreeLine: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadPdf(Future<List<int>> Function() download, String prefix) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final bytes = await download();
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/$prefix-${DateTime.now().millisecondsSinceEpoch}.pdf';
      await File(path).writeAsBytes(bytes);
      _reload();
      messenger.showSnackBar(SnackBar(content: Text('PDF saved: $path')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _printPdf(Future<List<int>> Function() download, String label) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final bytes = await download();
      await Printing.layoutPdf(
        name: label,
        onLayout: (_) async => Uint8List.fromList(bytes),
      );
      _reload();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _exportCsv() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final r = await ref.read(appointmentApiProvider).appointmentGet(pageSize: 100);
      final items = r?.items ?? [];
      final csv = _buildAppointmentsCsv(items);
      await Clipboard.setData(ClipboardData(text: csv));
      messenger.showSnackBar(
        SnackBar(content: Text('Copied ${items.length} row(s) to clipboard.')),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    }
  }
}
