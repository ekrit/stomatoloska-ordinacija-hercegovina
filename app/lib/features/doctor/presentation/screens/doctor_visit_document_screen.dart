import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../patient/presentation/providers/patient_repository_providers.dart';
import '../../../patient/presentation/providers/patient_data_providers.dart';

class DoctorVisitDocumentScreen extends ConsumerStatefulWidget {
  const DoctorVisitDocumentScreen({super.key, required this.appointment});

  final AppointmentResponse appointment;

  @override
  ConsumerState<DoctorVisitDocumentScreen> createState() =>
      _DoctorVisitDocumentScreenState();
}

class _DoctorVisitDocumentScreenState
    extends ConsumerState<DoctorVisitDocumentScreen> {
  final _findingsController = TextEditingController();
  final _opinionController = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _findingsController.dispose();
    _opinionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.appointment;
    final id = a.id;
    if (id == null) {
      return const Scaffold(body: Center(child: Text('Invalid appointment.')));
    }

    final existingAsync = ref.watch(_recordsForAppointmentProvider(id));

    return Scaffold(
      appBar: AppBar(title: const Text('Documents / findings')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: existingAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (records) {
            final existing = records.isNotEmpty ? records.first : null;
            if (existing != null) {
              return _ExistingRecordView(record: existing);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add findings and expert opinion',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _findingsController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Findings',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _opinionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Expert opinion (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
                const Spacer(),
                FilledButton(
                  onPressed: _saving ? null : () => _save(id),
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _save(int appointmentId) async {
    final findings = _findingsController.text.trim();
    final opinion = _opinionController.text.trim();
    if (findings.isEmpty) {
      setState(() => _error = 'Findings are required.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await ref.read(patientCareRepositoryProvider).createMedicalRecord(
            MedicalRecordUpsertRequest(
              appointmentId: appointmentId,
              diagnosis: findings,
              treatment: opinion.isEmpty ? null : opinion,
            ),
          );

      ref.invalidate(_recordsForAppointmentProvider(appointmentId));
      ref.invalidate(medicalRecordsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved.')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

final _recordsForAppointmentProvider =
    FutureProvider.autoDispose.family<List<MedicalRecordResponse>, int>(
        (ref, appointmentId) async {
  return ref
      .watch(patientCareRepositoryProvider)
      .listMedicalRecordsForAppointment(appointmentId);
});

class _ExistingRecordView extends StatelessWidget {
  const _ExistingRecordView({required this.record});

  final MedicalRecordResponse record;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Findings', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 6),
                Text(record.diagnosis ?? '—'),
                const SizedBox(height: 16),
                Text('Expert opinion',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 6),
                Text((record.treatment ?? '').trim().isEmpty
                    ? '—'
                    : record.treatment!),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'A document already exists for this appointment.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

