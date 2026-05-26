import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../providers/patient_data_providers.dart';

final _todayHygieneProvider = FutureProvider.autoDispose<HygieneTrackerResponse?>((ref) async {
  final uid = ref.watch(currentUserProvider)?.id;
  if (uid == null) return null;
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  final end = start.add(const Duration(days: 1));
  final api = ref.watch(hygieneTrackerApiProvider);
  final r = await api.hygieneTrackerGet(
    patientId: uid,
    dateFrom: start,
    dateTo: end,
    retrieveAll: true,
  );
  final items = r?.items ?? [];
  if (items.isEmpty) return null;
  return items.first;
});

class RemindersHygieneScreen extends ConsumerWidget {
  const RemindersHygieneScreen({super.key});

  static const _avoid = [
    'Sugary drinks and frequent snacking on sweets',
    'Smoking and tobacco use',
    'Using teeth as tools (opening packages, etc.)',
    'Skipping regular dental check-ups',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final appts = ref.watch(myAppointmentsProvider);
    final hygiene = ref.watch(_todayHygieneProvider);

    final nextVisit = appts.maybeWhen(
      data: (list) {
        final now = DateTime.now();
        final upcoming = list.where((a) {
          final s = a.status;
          final st = a.startTime;
          if (st == null) return false;
          if (s != AppointmentStatus.number1 && s != AppointmentStatus.number2) return false;
          return st.isAfter(now.subtract(const Duration(minutes: 1)));
        }).toList();
        if (upcoming.isEmpty) return null;
        upcoming.sort((a, b) => (a.startTime!).compareTo(b.startTime!));
        return upcoming.first.startTime;
      },
      orElse: () => null,
    );

    int? daysUntil;
    if (nextVisit != null) {
      final d = nextVisit.difference(DateTime.now());
      daysUntil = d.inDays < 0 ? 0 : d.inDays;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Reminders & hygiene')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Next check-up',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (nextVisit == null)
            Text(
              'No upcoming appointment on file. Book a visit from Home.',
              style: Theme.of(context).textTheme.bodyLarge,
            )
          else
            Text(
              daysUntil == 0
                  ? 'You have a visit scheduled today or very soon.'
                  : 'Your next visit is in about $daysUntil day(s) (${MaterialLocalizations.of(context).formatFullDate(nextVisit)}).',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          const SizedBox(height: 28),
          Text(
            'Daily brushing goal',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Aim for two thorough brushings per day (morning and evening).',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          hygiene.when(
            data: (row) {
              final count = row?.brushesCount ?? 0;
              final goal = 2;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(value: (count.clamp(0, goal)) / goal),
                  const SizedBox(height: 8),
                  Text('Logged today: $count / $goal'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _BrushingSlotChip(
                          label: 'Morning',
                          filled: count >= 1,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _BrushingSlotChip(
                          label: 'Evening',
                          filled: count >= 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    onPressed: user?.id == null || count >= goal
                        ? null
                        : () async {
                            final uid = user!.id!;
                            final api = ref.read(hygieneTrackerApiProvider);
                            final now = DateTime.now();
                            final day = DateTime(now.year, now.month, now.day);
                            final end = day.add(const Duration(days: 1));
                            try {
                              final snap = await api.hygieneTrackerGet(
                                patientId: uid,
                                dateFrom: day,
                                dateTo: end,
                                retrieveAll: true,
                              );
                              final list = snap?.items ?? [];
                              final existing = list.isNotEmpty ? list.first : null;
                              final next = (existing?.brushesCount ?? 0) + 1;
                              if (next > goal) return;
                              final req = HygieneTrackerUpsertRequest(
                                patientId: uid,
                                date: day,
                                brushesCount: next,
                              );
                              if (existing?.id != null) {
                                await api.hygieneTrackerIdPut(
                                  existing!.id!,
                                  hygieneTrackerUpsertRequest: req,
                                );
                              } else {
                                await api.hygieneTrackerPost(hygieneTrackerUpsertRequest: req);
                              }
                              ref.invalidate(_todayHygieneProvider);
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text('$e')));
                              }
                            }
                          },
                    icon: const Icon(Icons.add),
                    label: const Text('Log a brushing'),
                  ),
                ],
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e'),
          ),
          const SizedBox(height: 28),
          Text(
            'Things to avoid for healthier teeth',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ..._avoid.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.block, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(t)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrushingSlotChip extends StatelessWidget {
  const _BrushingSlotChip({required this.label, required this.filled});

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: filled ? scheme.primary : scheme.outlineVariant,
          width: filled ? 2 : 1,
        ),
        color: filled ? scheme.primaryContainer.withOpacity(0.35) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            filled ? Icons.check_circle : Icons.circle_outlined,
            size: 22,
            color: filled ? scheme.primary : scheme.outline,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
