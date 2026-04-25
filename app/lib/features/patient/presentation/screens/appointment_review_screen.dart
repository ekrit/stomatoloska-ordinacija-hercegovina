import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../providers/patient_data_providers.dart';
import '../providers/patient_repository_providers.dart';

class AppointmentReviewScreen extends ConsumerStatefulWidget {
  const AppointmentReviewScreen({super.key, required this.appointment});

  final AppointmentResponse appointment;

  @override
  ConsumerState<AppointmentReviewScreen> createState() => _AppointmentReviewScreenState();
}

class _AppointmentReviewScreenState extends ConsumerState<AppointmentReviewScreen> {
  int _rating = 5;
  final _comment = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final a = widget.appointment;
    final uid = ref.read(currentUserProvider)?.id;
    if (a.id == null || a.patientId == null || a.doctorId == null || uid == null) {
      setState(() => _error = 'Missing appointment data.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(patientCareRepositoryProvider).createReview(
            ReviewUpsertRequest(
              appointmentId: a.id!,
              patientId: a.patientId!,
              doctorId: a.doctorId!,
              rating: _rating,
              comment: _comment.text.trim().isEmpty ? null : _comment.text.trim(),
            ),
          );
      ref.invalidate(myAppointmentsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you for your review.')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.appointment;
    final start = a.startTime;
    final df = DateFormat.yMMMd();
    final tf = DateFormat.Hm();
    final when = start != null ? '${df.format(start)} · ${tf.format(start)}' : '—';

    final doctors = ref.watch(doctorsProvider);
    final services = ref.watch(servicesProvider);

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

    return Scaffold(
      appBar: AppBar(title: const Text('Rate your visit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(when, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(doctorName),
                    Text(serviceName),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Your rating', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (i) {
                final v = i + 1;
                return IconButton(
                  onPressed: () => setState(() => _rating = v),
                  icon: Icon(
                    v <= _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber.shade700,
                    size: 36,
                  ),
                );
              }),
            ),
            TextField(
              controller: _comment,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Written review (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Submit review'),
            ),
          ],
        ),
      ),
    );
  }
}
