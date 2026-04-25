import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/appointment_labels.dart';
import 'admin_appointment_edit_screen.dart';

final _allAppointmentsAdminProvider = FutureProvider.autoDispose<List<AppointmentResponse>>((ref) async {
  final r = await ref.watch(appointmentApiProvider).appointmentGet(retrieveAll: true);
  return r?.items ?? [];
});

class AdminAppointmentsListScreen extends ConsumerWidget {
  const AdminAppointmentsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_allAppointmentsAdminProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('All appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_allAppointmentsAdminProvider),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No appointments in the system.'));
          }
          items.sort((a, b) => (b.startTime ?? DateTime(0)).compareTo(a.startTime ?? DateTime(0)));
          final df = DateFormat.yMMMd();
          final tf = DateFormat.Hm();
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final a = items[i];
              final st = a.startTime;
              final when = st != null ? '${df.format(st)} ${tf.format(st)}' : '—';
              return ListTile(
                title: Text(when),
                subtitle: Text(
                  'Patient #${a.patientId ?? '—'} · Doctor #${a.doctorId ?? '—'}\n${appointmentStatusLabel(a.status)}',
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final changed = await Navigator.of(context).push<bool>(
                    MaterialPageRoute<bool>(
                      builder: (_) => AdminAppointmentEditScreen(appointment: a),
                    ),
                  );
                  if (changed == true) {
                    ref.invalidate(_allAppointmentsAdminProvider);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
