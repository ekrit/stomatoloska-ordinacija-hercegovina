import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/api/soh_extra_api.dart';
import '../../../../core/utils/api_errors.dart';
import '../../../../core/utils/appointment_labels.dart';
import '../providers/patient_data_providers.dart';
import '../providers/patient_repository_providers.dart';
import 'appointment_detail_screen.dart';
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
        title: const Text('Moji termini'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Nastupajući'),
            Tab(text: 'Završeni'),
            Tab(text: 'Otkazani'),
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
      error: (e, _) => Center(child: Text(extractApiErrorMessage(e))),
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
                        ? 'Nema nastupajućih termina.'
                        : mode == _PatientListMode.completed
                            ? 'Još nema završenih posjeta.'
                            : 'Nema otkazanih ni odbijenih termina.',
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
      if (s != AppointmentStatuses.requested && s != AppointmentStatuses.accepted) return false;
      if (et != null && et.isBefore(now)) return false;
      return true;
    }

    bool completed(AppointmentResponse a) => a.status == AppointmentStatuses.completed;

    bool cancelled(AppointmentResponse a) =>
        a.status == AppointmentStatuses.cancelled || a.status == AppointmentStatuses.declined;

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
        if (id == null) return 'Stomatolog';
        for (final d in list) {
          if (d.userId == id) {
            final n = '${d.firstName ?? ''} ${d.lastName ?? ''}'.trim();
            return n.isEmpty ? 'Stomatolog' : n;
          }
        }
        return 'Stomatolog';
      },
      orElse: () => 'Stomatolog',
    );

    final serviceName = services.maybeWhen(
      data: (list) {
        final id = a.serviceId;
        if (id == null) return 'Usluga';
        for (final s in list) {
          if (s.id == id) return s.name ?? 'Usluga';
        }
        return 'Usluga';
      },
      orElse: () => 'Usluga',
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) => AppointmentDetailScreen(
              appointment: a,
              doctorName: doctorName,
              serviceName: serviceName,
            ),
          ),
        ),
        child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(when, style: Theme.of(context).textTheme.titleSmall),
                ),
                if (a.isPaid == true)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 14, color: Colors.green.shade800),
                        const SizedBox(width: 4),
                        Text(
                          'Plaćeno',
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
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
                      label: const Text('Odustani'),
                    ),
                    if (a.isPaid == true &&
                        a.paymentId != null &&
                        a.status != AppointmentStatuses.completed)
                      OutlinedButton.icon(
                        onPressed: () => _confirmRefund(context, ref, a),
                        icon: const Icon(Icons.currency_exchange),
                        label: const Text('Zatraži povrat novca'),
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
      ),
    );
  }

  Future<void> _confirmRefund(
    BuildContext context,
    WidgetRef ref,
    AppointmentResponse a,
  ) async {
    final paymentId = a.paymentId;
    if (paymentId == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Zatražiti povrat novca?'),
        content: const Text(
          'Vaša uplata će biti refundirana putem PayPal-a i termin će biti otkazan. '
          'Ova radnja se ne može poništiti.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Da, refundiraj')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await SohExtraApi(ref.read(apiClientProvider)).refundPayment(paymentId);
      ref.invalidate(myAppointmentsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Povrat novca je izvršen. Termin je otkazan.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(extractApiErrorMessage(e, fallback: 'Povrat novca nije uspio.'))),
        );
      }
    }
  }

  Future<void> _confirmCancel(
    BuildContext context,
    WidgetRef ref,
    AppointmentResponse a,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Otkazati termin?'),
        content: const Text('Vaša posjeta će biti označena kao otkazana.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Da, otkaži')),
        ],
      ),
    );
    if (ok != true) return;
    if (a.id == null) {
      return;
    }
    try {
      await SohExtraApi(ref.read(apiClientProvider)).cancelAppointment(a.id!);
      ref.invalidate(myAppointmentsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Termin je otkazan.')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(extractApiErrorMessage(e, fallback: 'Termin nije moguće otkazati.'))),
        );
      }
    }
  }
}
