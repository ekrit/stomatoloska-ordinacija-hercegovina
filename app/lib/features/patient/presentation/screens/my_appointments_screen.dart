import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soh_api/api.dart';

import '../../../../core/utils/appointment_labels.dart';
import '../providers/patient_data_providers.dart';
import '../providers/patient_repository_providers.dart';
import 'appointment_review_screen.dart';
import 'patient_findings_screen.dart';

final _hasReviewProvider = FutureProvider.autoDispose.family<bool, int>(
  (ref, appointmentId) async {
    final list =
        await ref.watch(patientCareRepositoryProvider).listReviewsForAppointment(appointmentId);
    return list.isNotEmpty;
  },
);

class MyAppointmentsScreen extends ConsumerStatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  ConsumerState<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends ConsumerState<MyAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appts = ref.watch(myAppointmentsProvider);
    final doctors = ref.watch(doctorsProvider);
    final services = ref.watch(servicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My appointments'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _AppointmentListView(
            async: appts,
            doctors: doctors,
            services: services,
            mode: _PatientListMode.upcoming,
            onRefresh: () async {
              ref.invalidate(myAppointmentsProvider);
              await ref.read(myAppointmentsProvider.future);
            },
          ),
          _AppointmentListView(
            async: appts,
            doctors: doctors,
            services: services,
            mode: _PatientListMode.completed,
            onRefresh: () async {
              ref.invalidate(myAppointmentsProvider);
              await ref.read(myAppointmentsProvider.future);
            },
          ),
          _AppointmentListView(
            async: appts,
            doctors: doctors,
            services: services,
            mode: _PatientListMode.cancelled,
            onRefresh: () async {
              ref.invalidate(myAppointmentsProvider);
              await ref.read(myAppointmentsProvider.future);
            },
          ),
        ],
      ),
    );
  }
}

enum _PatientListMode { upcoming, completed, cancelled }

class _AppointmentListView extends ConsumerWidget {
  const _AppointmentListView({
    required this.async,
    required this.doctors,
    required this.services,
    required this.mode,
    required this.onRefresh,
  });

  final AsyncValue<List<AppointmentResponse>> async;
  final AsyncValue<List<DoctorResponse>> doctors;
  final AsyncValue<List<ServiceResponse>> services;
  final _PatientListMode mode;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (all) {
        final now = DateTime.now();
        final filtered = _filter(all, now);
        if (filtered.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.5,
                child: Center(
                  child: Text(
                    mode == _PatientListMode.upcoming
                        ? 'No upcoming appointments.'
                        : mode == _PatientListMode.completed
                            ? 'No completed visits yet.'
                            : 'No cancelled or declined appointments.',
                  ),
                ),
              ),
            ],
          );
        }
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, i) {
              final a = filtered[i];
              return _AppointmentPatientCard(
                appointment: a,
                doctors: doctors,
                services: services,
                mode: mode,
              );
            },
          ),
        );
      },
    );
  }

  List<AppointmentResponse> _filter(List<AppointmentResponse> all, DateTime now) {
    bool upcoming(AppointmentResponse a) {
      final s = a.status;
      final et = a.endTime;
      if (s != AppointmentStatus.number1 && s != AppointmentStatus.number2) return false;
      if (et != null && et.isBefore(now)) return false;
      return true;
    }

    bool completed(AppointmentResponse a) => a.status == AppointmentStatus.number4;

    bool cancelled(AppointmentResponse a) =>
        a.status == AppointmentStatus.number5 || a.status == AppointmentStatus.number3;

    switch (mode) {
      case _PatientListMode.upcoming:
        final u = all.where(upcoming).toList();
        u.sort((a, b) => (a.startTime ?? DateTime(0)).compareTo(b.startTime ?? DateTime(0)));
        return u;
      case _PatientListMode.completed:
        final c = all.where(completed).toList();
        c.sort((a, b) => (b.startTime ?? DateTime(0)).compareTo(a.startTime ?? DateTime(0)));
        return c;
      case _PatientListMode.cancelled:
        final x = all.where(cancelled).toList();
        x.sort((a, b) => (b.startTime ?? DateTime(0)).compareTo(a.startTime ?? DateTime(0)));
        return x;
    }
  }
}

class _AppointmentPatientCard extends ConsumerWidget {
  const _AppointmentPatientCard({
    required this.appointment,
    required this.doctors,
    required this.services,
    required this.mode,
  });

  final AppointmentResponse appointment;
  final AsyncValue<List<DoctorResponse>> doctors;
  final AsyncValue<List<ServiceResponse>> services;
  final _PatientListMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = appointment;
    final df = DateFormat.yMMMd();
    final tf = DateFormat.Hm();
    final start = a.startTime;
    final when = start != null ? '${df.format(start)} · ${tf.format(start)}' : '—';

    final doctorName = doctors.maybeWhen(
      data: (list) {
        final id = a.doctorId;
        if (id == null) return 'Dentist';
        for (final d in list) {
          if (d.userId == id) {
            final n = '${d.firstName ?? ''} ${d.lastName ?? ''}'.trim();
            return n.isEmpty ? 'Dentist' : n;
          }
        }
        return 'Dentist';
      },
      orElse: () => 'Dentist',
    );

    final serviceName = services.maybeWhen(
      data: (list) {
        final id = a.serviceId;
        if (id == null) return 'Service';
        for (final s in list) {
          if (s.id == id) return s.name ?? 'Service';
        }
        return 'Service';
      },
      orElse: () => 'Service',
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(when, style: Theme.of(context).textTheme.titleSmall),
            Text('$doctorName · $serviceName'),
            const SizedBox(height: 4),
            Text(appointmentStatusLabel(a.status)),
            if ((a.doctorNote ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                a.doctorNote!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (mode != _PatientListMode.cancelled) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (mode == _PatientListMode.upcoming) ...[
                    OutlinedButton.icon(
                      onPressed: a.id == null ? null : () => _confirmCancel(context, ref, a),
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text('Otkaži'),
                    ),
                    OutlinedButton.icon(
                      onPressed: a.id == null
                          ? null
                          : () => Navigator.of(context).push<void>(
                                MaterialPageRoute<void>(
                                  builder: (_) => PatientFindingsScreen(appointmentId: a.id!),
                                ),
                              ),
                      icon: const Icon(Icons.description_outlined),
                      label: const Text('Nalazi'),
                    ),
                  ],
                  if (mode == _PatientListMode.completed && a.id != null) ...[
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push<void>(
                            MaterialPageRoute<void>(
                              builder: (_) => PatientFindingsScreen(appointmentId: a.id!),
                            ),
                          ),
                      icon: const Icon(Icons.description_outlined),
                      label: const Text('Nalazi'),
                    ),
                    Consumer(
                      builder: (context, ref, _) {
                        final async = ref.watch(_hasReviewProvider(a.id!));
                        return async.when(
                          data: (has) => FilledButton.icon(
                            onPressed: has
                                ? null
                                : () => Navigator.of(context).push<void>(
                                      MaterialPageRoute<void>(
                                        builder: (_) => AppointmentReviewScreen(appointment: a),
                                      ),
                                    ),
                            icon: const Icon(Icons.star_outline),
                            label: Text(has ? 'Ocijenjeno' : 'Ocijeni'),
                          ),
                          loading: () => const Padding(
                            padding: EdgeInsets.all(8),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          error: (_, __) => const SizedBox.shrink(),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCancel(
    BuildContext context,
    WidgetRef ref,
    AppointmentResponse a,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel appointment?'),
        content: const Text('This will mark your visit as cancelled.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes, cancel')),
        ],
      ),
    );
    if (ok != true) return;
    if (a.id == null ||
        a.patientId == null ||
        a.doctorId == null ||
        a.serviceId == null ||
        a.roomId == null ||
        a.startTime == null ||
        a.endTime == null) {
      return;
    }
    try {
      await ref.read(patientCareRepositoryProvider).updateAppointment(
            a.id!,
            AppointmentUpsertRequest(
              patientId: a.patientId!,
              doctorId: a.doctorId!,
              serviceId: a.serviceId!,
              roomId: a.roomId!,
              startTime: a.startTime!,
              endTime: a.endTime!,
              status: AppointmentStatus.number5,
              doctorNote: a.doctorNote,
            ),
          );
      ref.invalidate(myAppointmentsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment cancelled.')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }
}
