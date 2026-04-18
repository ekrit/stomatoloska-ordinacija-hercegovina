import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/appointment_labels.dart';
import '../../../../core/utils/role_utils.dart';
import '../../../patient/presentation/providers/patient_repository_providers.dart';
import 'doctor_visit_document_screen.dart';

final _doctorAppointmentsProvider =
    FutureProvider.autoDispose<List<AppointmentResponse>>((ref) async {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return [];

  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 30));
  final end = start.add(const Duration(days: 365));

  final items = await ref
      .watch(patientCareRepositoryProvider)
      .listAppointmentsForDoctorBetween(
        doctorId: userId,
        startInclusive: start,
        endExclusive: end,
      );

  items.sort((a, b) => (a.startTime ?? DateTime(0)).compareTo(b.startTime ?? DateTime(0)));
  return items;
});

class DoctorResponseScreen extends ConsumerWidget {
  const DoctorResponseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (!userIsDoctor(user)) {
      return Scaffold(
        appBar: AppBar(title: const Text('Doctor')),
        body: const Center(child: Text('Doctor access only.')),
      );
    }

    final async = ref.watch(_doctorAppointmentsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(_doctorAppointmentsProvider),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          final pending = items
              .where((a) => a.status == AppointmentStatus.number1)
              .toList()
            ..sort((a, b) => (a.startTime ?? DateTime(0))
                .compareTo(b.startTime ?? DateTime(0)));
          final upcoming = items
              .where((a) =>
                  a.status == AppointmentStatus.number2 ||
                  a.status == AppointmentStatus.number1)
              .toList()
            ..sort((a, b) => (a.startTime ?? DateTime(0))
                .compareTo(b.startTime ?? DateTime(0)));
          final completed = items
              .where((a) => a.status == AppointmentStatus.number4)
              .toList()
            ..sort((a, b) => (b.startTime ?? DateTime(0))
                .compareTo(a.startTime ?? DateTime(0)));

          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'Pending'),
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Completed'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _AppointmentList(
                        items: pending,
                        empty: 'No pending requests.',
                        mode: _ListMode.pending,
                      ),
                      _AppointmentList(
                        items: upcoming,
                        empty: 'No upcoming appointments.',
                        mode: _ListMode.upcoming,
                      ),
                      _AppointmentList(
                        items: completed,
                        empty: 'No completed appointments yet.',
                        mode: _ListMode.completed,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

enum _ListMode { pending, upcoming, completed }

class _AppointmentList extends ConsumerWidget {
  const _AppointmentList({
    required this.items,
    required this.empty,
    required this.mode,
  });

  final List<AppointmentResponse> items;
  final String empty;
  final _ListMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.6,
            child: Center(child: Text(empty)),
          ),
        ],
      );
    }
    final df = DateFormat.yMMMd();
    final tf = DateFormat.Hm();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final a = items[i];
        final start = a.startTime;
        final when = start != null ? '${df.format(start)} · ${tf.format(start)}' : '—';
        final note = (a.doctorNote ?? '').trim();
        return Card(
          child: ListTile(
            title: Text(when),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appointmentStatusLabel(a.status)),
                if (note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    note,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
            isThreeLine: note.isNotEmpty,
            trailing: mode == _ListMode.completed
                ? IconButton(
                    tooltip: 'Add findings',
                    icon: const Icon(Icons.description_outlined),
                    onPressed: a.id == null
                        ? null
                        : () => Navigator.of(context).push<void>(
                              MaterialPageRoute<void>(
                                builder: (_) => DoctorVisitDocumentScreen(
                                  appointment: a,
                                ),
                              ),
                            ),
                  )
                : mode == _ListMode.pending
                    ? Wrap(
                        spacing: 8,
                        children: [
                          OutlinedButton(
                            onPressed: () => _changeStatus(
                              context: context,
                              ref: ref,
                              appointment: a,
                              next: AppointmentStatus.number3,
                            ),
                            child: const Text('Reject'),
                          ),
                          FilledButton(
                            onPressed: () => _changeStatus(
                              context: context,
                              ref: ref,
                              appointment: a,
                              next: AppointmentStatus.number2,
                            ),
                            child: const Text('Accept'),
                          ),
                        ],
                      )
                    : null,
          ),
        );
      },
    );
  }

  Future<void> _changeStatus({
    required BuildContext context,
    required WidgetRef ref,
    required AppointmentResponse appointment,
    required AppointmentStatus next,
  }) async {
    if (appointment.id == null ||
        appointment.patientId == null ||
        appointment.doctorId == null ||
        appointment.serviceId == null ||
        appointment.roomId == null ||
        appointment.startTime == null ||
        appointment.endTime == null) {
      return;
    }

    final noteController = TextEditingController();
    try {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(next == AppointmentStatus.number2 ? 'Accept request?' : 'Reject request?'),
          content: TextField(
            controller: noteController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Doctor note (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );
      if (ok != true) return;

      final mergedNote = _mergeNotes(
        existing: appointment.doctorNote,
        doctorNote: noteController.text,
      );

      await ref.read(patientCareRepositoryProvider).updateAppointment(
            appointment.id!,
            AppointmentUpsertRequest(
              patientId: appointment.patientId!,
              doctorId: appointment.doctorId!,
              serviceId: appointment.serviceId!,
              roomId: appointment.roomId!,
              startTime: appointment.startTime!,
              endTime: appointment.endTime!,
              status: next,
              doctorNote: mergedNote,
            ),
          );
      ref.invalidate(_doctorAppointmentsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next == AppointmentStatus.number2 ? 'Accepted.' : 'Rejected.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      noteController.dispose();
    }
  }
}

String? _mergeNotes({String? existing, required String doctorNote}) {
  final base = (existing ?? '').trim();
  final add = doctorNote.trim();
  if (add.isEmpty) return base.isEmpty ? null : base;
  if (base.isEmpty) return 'Doctor: $add';
  return '$base\nDoctor: $add';
}

