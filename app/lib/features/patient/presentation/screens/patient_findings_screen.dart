import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../providers/patient_repository_providers.dart';

final _recordsForAppointmentPatientProvider =
    FutureProvider.autoDispose.family<List<MedicalRecordResponse>, int>(
  (ref, appointmentId) async {
    return ref
        .watch(patientCareRepositoryProvider)
        .listMedicalRecordsForAppointment(appointmentId);
  },
);

class PatientFindingsScreen extends ConsumerWidget {
  const PatientFindingsScreen({super.key, required this.appointmentId});

  final int appointmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_recordsForAppointmentPatientProvider(appointmentId));
    return Scaffold(
      appBar: AppBar(title: const Text('Nalazi / dokumenti')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (records) {
          if (records.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No documents are available for this visit yet.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final r = records.first;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Findings', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(r.diagnosis ?? '—'),
                      const SizedBox(height: 16),
                      Text('Expert opinion',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text((r.treatment ?? '').trim().isEmpty ? '—' : r.treatment!),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
