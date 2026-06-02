import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/appointment_labels.dart';
import '../../../../core/widgets/paginated_search_view.dart';
import 'admin_appointment_create_screen.dart';
import 'admin_appointment_edit_screen.dart';

class AdminAppointmentsListScreen extends ConsumerStatefulWidget {
  const AdminAppointmentsListScreen({super.key});

  @override
  ConsumerState<AdminAppointmentsListScreen> createState() =>
      _AdminAppointmentsListScreenState();
}

class _AdminAppointmentsListScreenState extends ConsumerState<AdminAppointmentsListScreen> {
  int _refresh = 0;

  void _reload() => setState(() => _refresh++);

  @override
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMd();
    final tf = DateFormat.Hm();
    return Scaffold(
      appBar: AppBar(
        title: const Text('All appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create',
            onPressed: () async {
              final changed = await Navigator.of(context).push<bool>(
                MaterialPageRoute<bool>(
                  builder: (_) => const AdminAppointmentCreateScreen(),
                ),
              );
              if (changed == true) _reload();
            },
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
        ],
      ),
      body: PaginatedSearchView<AppointmentResponse>(
        refreshKey: _refresh,
        searchHint: 'Search by patient, doctor, or service…',
        emptyLabel: 'No appointments in the system.',
        fetch: (query, page, pageSize) async {
          // Newest first: server has no created column, so order by start desc.
          final r = await ref.read(appointmentApiProvider).appointmentGet(
                FTS: query.isEmpty ? null : query,
                page: page,
                pageSize: pageSize,
                includeTotalCount: true,
              );
          final items = r?.items ?? [];
          items.sort((a, b) => (b.startTime ?? DateTime(0)).compareTo(a.startTime ?? DateTime(0)));
          return PagedData(items: items, total: r?.totalCount);
        },
        itemBuilder: (context, a) {
          final st = a.startTime;
          final when = st != null ? '${df.format(st)} ${tf.format(st)}' : '—';
          return _AppointmentTile(
            appointment: a,
            when: when,
            onEdited: _reload,
          );
        },
      ),
    );
  }
}

/// Resolves patient/doctor/service names (T5.2) instead of raw IDs.
class _AppointmentTile extends ConsumerWidget {
  const _AppointmentTile({
    required this.appointment,
    required this.when,
    required this.onEdited,
  });

  final AppointmentResponse appointment;
  final String when;
  final VoidCallback onEdited;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = appointment;
    final doctors = ref.watch(_doctorsLookupProvider);
    final services = ref.watch(_servicesLookupProvider);

    final doctorName = doctors.maybeWhen(
      data: (m) => m[a.doctorId] ?? 'Doctor #${a.doctorId ?? '—'}',
      orElse: () => 'Doctor #${a.doctorId ?? '—'}',
    );
    final serviceName = services.maybeWhen(
      data: (m) => m[a.serviceId] ?? 'Service #${a.serviceId ?? '—'}',
      orElse: () => 'Service #${a.serviceId ?? '—'}',
    );

    return ListTile(
      title: Text(when),
      subtitle: Text(
        '$doctorName · $serviceName\n${appointmentStatusLabel(a.status)}'
        '${a.isPaid == true ? ' · Paid' : ''}',
      ),
      isThreeLine: true,
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final changed = await Navigator.of(context).push<bool>(
          MaterialPageRoute<bool>(
            builder: (_) => AdminAppointmentEditScreen(appointment: a),
          ),
        );
        if (changed == true) onEdited();
      },
    );
  }
}

final _doctorsLookupProvider = FutureProvider.autoDispose<Map<int, String>>((ref) async {
  final r = await ref.watch(doctorApiProvider).doctorGet(retrieveAll: true);
  final map = <int, String>{};
  for (final d in r?.items ?? <DoctorResponse>[]) {
    if (d.userId != null) {
      map[d.userId!] = '${d.firstName ?? ''} ${d.lastName ?? ''}'.trim();
    }
  }
  return map;
});

final _servicesLookupProvider = FutureProvider.autoDispose<Map<int, String>>((ref) async {
  final r = await ref.watch(serviceApiProvider).serviceGet(retrieveAll: true);
  final map = <int, String>{};
  for (final s in r?.items ?? <ServiceResponse>[]) {
    if (s.id != null) map[s.id!] = s.name ?? 'Service #${s.id}';
  }
  return map;
});
