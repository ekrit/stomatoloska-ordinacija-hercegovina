import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/api_errors.dart';
import '../../../../core/utils/appointment_labels.dart';
import '../providers/lookup_providers.dart';

class AdminAppointmentCreateScreen extends ConsumerStatefulWidget {
  const AdminAppointmentCreateScreen({super.key});

  @override
  ConsumerState<AdminAppointmentCreateScreen> createState() => _AdminAppointmentCreateScreenState();
}

class _AdminAppointmentCreateScreenState extends ConsumerState<AdminAppointmentCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _patientId;
  int? _doctorId;
  int? _serviceId;
  int? _roomId;
  final _note = TextEditingController();
  DateTime _start = DateTime.now().add(const Duration(hours: 1));
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickStart() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _start,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_start),
    );
    if (t == null || !mounted) return;
    setState(() {
      _start = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(appointmentApiProvider).appointmentPost(
            appointmentUpsertRequest: AppointmentUpsertRequest(
              patientId: _patientId!,
              doctorId: _doctorId!,
              serviceId: _serviceId!,
              roomId: _roomId!,
              startTime: _start,
              endTime: _start.add(const Duration(minutes: 30)),
              status: AppointmentStatuses.requested,
              doctorNote: _note.text.trim().isEmpty ? null : _note.text.trim(),
            ),
          );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = extractApiErrorMessage(e, fallback: 'Termin nije moguće kreirati.'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMd().add_Hm();
    final patients = ref.watch(patientsLookupProvider);
    final doctors = ref.watch(doctorsLookupProvider);
    final services = ref.watch(servicesLookupProvider);
    final rooms = ref.watch(roomsLookupProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kreiraj termin')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _lookupDropdown(
              label: 'Pacijent',
              async: patients,
              value: _patientId,
              onChanged: (v) => setState(() => _patientId = v),
            ),
            const SizedBox(height: 12),
            _lookupDropdown(
              label: 'Doktor',
              async: doctors,
              value: _doctorId,
              onChanged: (v) => setState(() => _doctorId = v),
            ),
            const SizedBox(height: 12),
            _lookupDropdown(
              label: 'Usluga',
              async: services,
              value: _serviceId,
              onChanged: (v) => setState(() => _serviceId = v),
            ),
            const SizedBox(height: 12),
            _lookupDropdown(
              label: 'Prostorija',
              async: rooms,
              value: _roomId,
              onChanged: (v) => setState(() => _roomId = v),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Početak'),
              subtitle: Text(df.format(_start)),
              trailing: OutlinedButton(onPressed: _pickStart, child: const Text('Pick')),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _note,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Napomena doktora (opcionalno)',
                border: OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Kreiraj'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lookupDropdown({
    required String label,
    required AsyncValue<Map<int, String>> async,
    required int? value,
    required ValueChanged<int?> onChanged,
  }) {
    return async.when(
      loading: () => InputDecorator(
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        child: const SizedBox(
          height: 20,
          child: Center(child: LinearProgressIndicator()),
        ),
      ),
      error: (e, _) => Text(extractApiErrorMessage(e, fallback: 'Could not load $label list.')),
      data: (map) {
        final entries = map.entries.toList()
          ..sort((a, b) => a.value.toLowerCase().compareTo(b.value.toLowerCase()));
        return DropdownButtonFormField<int>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
          items: entries
              .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value, overflow: TextOverflow.ellipsis)))
              .toList(),
          validator: (v) => v == null ? '$label is required.' : null,
          onChanged: _saving ? null : onChanged,
        );
      },
    );
  }
}
