import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soh_api/api.dart';

import '../../../core/api/api_providers.dart';
import '../../../core/api/soh_extra_api.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/storage/auth_storage.dart';
import '../../../core/utils/api_errors.dart';
import '../../../core/utils/appointment_labels.dart';
import '../../../widgets/user_appbar_actions.dart' show showLogoutConfirm;
import '../../patient/presentation/providers/patient_repository_providers.dart';
import 'doctor_visit_document_screen.dart';

/// Zahtjevi za termine dodijeljeni prijavljenom doktoru (proposal: "Odgovor
/// na zakazivanje termina"). Doktor prihvata ili odbija zahtjeve (odbijanje
/// traži razlog), označava termine kao završene i unosi nalaze.
final _doctorAppointmentsProvider =
    FutureProvider.autoDispose<List<AppointmentResponse>>((ref) async {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return [];

  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 60));
  final end = start.add(const Duration(days: 425));

  return ref.watch(patientCareRepositoryProvider).listAppointmentsForDoctorBetween(
        doctorId: userId,
        startInclusive: start,
        endExclusive: end,
      );
});

/// Imena pacijenata za prikaz umjesto sirovih ID vrijednosti.
final _patientNamesProvider = FutureProvider.autoDispose<Map<int, String>>((ref) async {
  final r = await ref.watch(patientApiProvider).patientGet(pageSize: 100);
  return {
    for (final p in r?.items ?? <PatientResponse>[])
      if (p.userId != null)
        p.userId!: '${p.firstName ?? ''} ${p.lastName ?? ''}'.trim(),
  };
});

final _serviceNamesProvider = FutureProvider.autoDispose<Map<int, String>>((ref) async {
  final services = await ref.watch(patientCatalogRepositoryProvider).listServices();
  return {
    for (final s in services)
      if (s.id != null) s.id!: s.name ?? '',
  };
});

class DoctorShellScreen extends ConsumerWidget {
  const DoctorShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_doctorAppointmentsProvider);
    final user = ref.watch(currentUserProvider);

    Future<void> logout() async {
      final ok = await showLogoutConfirm(context);
      if (!ok) return;
      try {
        await SohExtraApi(ref.read(apiClientProvider)).logout();
      } catch (_) {}
      await AuthStorage.clear();
      ref.read(authTokenProvider.notifier).state = null;
      ref.read(currentUserProvider.notifier).state = null;
      if (!context.mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Dr. ${user?.lastName ?? ''}'.trim(),
          ),
          actions: [
            IconButton(
              onPressed: () => ref.invalidate(_doctorAppointmentsProvider),
              icon: const Icon(Icons.refresh),
              tooltip: 'Osvježi',
            ),
            IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout),
              tooltip: 'Odjava',
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Na čekanju'),
              Tab(text: 'Nadolazeći'),
              Tab(text: 'Završeni'),
            ],
          ),
        ),
        body: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(extractApiErrorMessage(e))),
          data: (items) {
            final pending = items
                .where((a) => a.status == AppointmentStatuses.requested)
                .toList()
              ..sort((a, b) => (a.startTime ?? DateTime(0))
                  .compareTo(b.startTime ?? DateTime(0)));
            final upcoming = items
                .where((a) => a.status == AppointmentStatuses.accepted)
                .toList()
              ..sort((a, b) => (a.startTime ?? DateTime(0))
                  .compareTo(b.startTime ?? DateTime(0)));
            final completed = items
                .where((a) => a.status == AppointmentStatuses.completed)
                .toList()
              ..sort((a, b) => (b.startTime ?? DateTime(0))
                  .compareTo(a.startTime ?? DateTime(0)));

            return TabBarView(
              children: [
                _AppointmentList(
                  items: pending,
                  empty: 'Nema zahtjeva na čekanju.',
                  mode: _ListMode.pending,
                ),
                _AppointmentList(
                  items: upcoming,
                  empty: 'Nema nadolazećih termina.',
                  mode: _ListMode.upcoming,
                ),
                _AppointmentList(
                  items: completed,
                  empty: 'Još nema završenih termina.',
                  mode: _ListMode.completed,
                ),
              ],
            );
          },
        ),
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
      return RefreshIndicator(
        onRefresh: () async => ref.invalidate(_doctorAppointmentsProvider),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.6,
              child: Center(child: Text(empty)),
            ),
          ],
        ),
      );
    }

    final patientNames = ref.watch(_patientNamesProvider).maybeWhen(
          data: (m) => m,
          orElse: () => const <int, String>{},
        );
    final serviceNames = ref.watch(_serviceNamesProvider).maybeWhen(
          data: (m) => m,
          orElse: () => const <int, String>{},
        );

    final df = DateFormat('dd.MM.yyyy.');
    final tf = DateFormat.Hm();

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(_doctorAppointmentsProvider),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final a = items[i];
          final start = a.startTime;
          final when = start != null
              ? '${df.format(start.toLocal())} u ${tf.format(start.toLocal())}'
              : '—';
          final patient = patientNames[a.patientId] ?? 'Pacijent';
          final service = serviceNames[a.serviceId] ?? '';
          final note = (a.doctorNote ?? '').trim();

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.event, size: 16),
                      const SizedBox(width: 6),
                      Text(when),
                    ],
                  ),
                  if (service.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.medical_services_outlined, size: 16),
                        const SizedBox(width: 6),
                        Expanded(child: Text(service)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    appointmentStatusLabel(a.status),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (note.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      note,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  _actions(context, ref, a),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _actions(BuildContext context, WidgetRef ref, AppointmentResponse a) {
    switch (mode) {
      case _ListMode.pending:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () => _changeStatus(
                context: context,
                ref: ref,
                appointment: a,
                next: AppointmentStatuses.declined,
              ),
              child: const Text('Odbij'),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: () => _changeStatus(
                context: context,
                ref: ref,
                appointment: a,
                next: AppointmentStatuses.accepted,
              ),
              child: const Text('Prihvati'),
            ),
          ],
        );
      case _ListMode.upcoming:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton.tonal(
              onPressed: () => _changeStatus(
                context: context,
                ref: ref,
                appointment: a,
                next: AppointmentStatuses.completed,
              ),
              child: const Text('Označi kao završen'),
            ),
          ],
        );
      case _ListMode.completed:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.description_outlined, size: 18),
              label: const Text('Nalazi'),
              onPressed: a.id == null
                  ? null
                  : () => Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => DoctorVisitDocumentScreen(appointment: a),
                        ),
                      ),
            ),
          ],
        );
    }
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

    final isDecline = next == AppointmentStatuses.declined;
    final isComplete = next == AppointmentStatuses.completed;
    final noteController = TextEditingController();
    try {
      final title = isDecline
          ? 'Odbiti zahtjev?'
          : isComplete
              ? 'Označiti termin kao završen?'
              : 'Prihvatiti zahtjev?';
      final formKey = GlobalKey<FormState>();
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: isDecline
                    ? 'Razlog odbijanja (obavezno)'
                    : 'Napomena doktora (opcionalno)',
                border: const OutlineInputBorder(),
              ),
              validator: isDecline
                  ? (v) => (v ?? '').trim().isEmpty
                      ? 'Razlog odbijanja je obavezan.'
                      : null
                  : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Odustani'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? true) {
                  Navigator.pop(ctx, true);
                }
              },
              child: const Text('Potvrdi'),
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
        final msg = isDecline
            ? 'Zahtjev je odbijen i pacijent je obaviješten.'
            : isComplete
                ? 'Termin je označen kao završen.'
                : 'Zahtjev je prihvaćen i pacijent je obaviješten.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(extractApiErrorMessage(e))),
        );
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
  if (base.isEmpty) return add;
  return '$base\nDoktor: $add';
}
