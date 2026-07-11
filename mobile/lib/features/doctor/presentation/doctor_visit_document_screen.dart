import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../core/utils/api_errors.dart';
import '../../patient/presentation/providers/patient_repository_providers.dart';

/// Unos nalaza i stručnog mišljenja za završeni termin (proposal:
/// "Dodavanje nalaza i stručnog mišljenja ljekara").
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
    final id = widget.appointment.id;
    if (id == null) {
      return const Scaffold(body: Center(child: Text('Nevažeći termin.')));
    }

    final existingAsync = ref.watch(_recordsForAppointmentProvider(id));

    return Scaffold(
      appBar: AppBar(title: const Text('Nalazi i mišljenje')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: existingAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(extractApiErrorMessage(e))),
          data: (records) {
            if (records.isNotEmpty) {
              return _ExistingRecordsView(records: records);
            }

            return ListView(
              children: [
                Text(
                  'Dodaj nalaz i stručno mišljenje',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _findingsController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Nalaz',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _opinionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Stručno mišljenje (opcionalno)',
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
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _saving ? null : () => _save(id),
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Spasi nalaz'),
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
      setState(() => _error = 'Nalaz je obavezan.');
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nalaz je spašen i vidljiv pacijentu.')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = extractApiErrorMessage(e,
            fallback: 'Nalaz nije moguće spasiti. Pokušajte ponovo.'));
      }
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

class _ExistingRecordsView extends StatelessWidget {
  const _ExistingRecordsView({required this.records});

  final List<MedicalRecordResponse> records;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final record in records)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nalaz', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  Text(record.diagnosis ?? '—'),
                  const SizedBox(height: 16),
                  Text('Stručno mišljenje',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  Text((record.treatment ?? '').trim().isEmpty
                      ? '—'
                      : record.treatment!),
                ],
              ),
            ),
          ),
        const SizedBox(height: 4),
        Text(
          'Za ovaj termin nalaz već postoji.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
