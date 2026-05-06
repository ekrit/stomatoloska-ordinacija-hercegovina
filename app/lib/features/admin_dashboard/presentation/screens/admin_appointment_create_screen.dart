import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';

int? parseIdInput(String value) => int.tryParse(value.trim());

class AdminAppointmentCreateScreen extends ConsumerStatefulWidget {
  const AdminAppointmentCreateScreen({super.key});

  @override
  ConsumerState<AdminAppointmentCreateScreen> createState() => _AdminAppointmentCreateScreenState();
}

class _AdminAppointmentCreateScreenState extends ConsumerState<AdminAppointmentCreateScreen> {
  final _patientId = TextEditingController();
  final _doctorId = TextEditingController();
  final _serviceId = TextEditingController();
  final _roomId = TextEditingController();
  final _note = TextEditingController();
  DateTime _start = DateTime.now().add(const Duration(hours: 1));
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _patientId.dispose();
    _doctorId.dispose();
    _serviceId.dispose();
    _roomId.dispose();
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
    final pid = parseIdInput(_patientId.text);
    final did = parseIdInput(_doctorId.text);
    final sid = parseIdInput(_serviceId.text);
    final rid = parseIdInput(_roomId.text);
    if (pid == null || did == null || sid == null || rid == null) {
      setState(() => _error = 'Patient, doctor, service and room IDs are required.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(appointmentApiProvider).appointmentPost(
            appointmentUpsertRequest: AppointmentUpsertRequest(
              patientId: pid,
              doctorId: did,
              serviceId: sid,
              roomId: rid,
              startTime: _start,
              endTime: _start.add(const Duration(minutes: 30)),
              status: AppointmentStatus.number1,
              doctorNote: _note.text.trim().isEmpty ? null : _note.text.trim(),
            ),
          );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create appointment')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _patientId,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Patient (user) ID',
              helperText: 'Same as the patient account user id (Patients.UserId), not a row number.',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _doctorId,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Doctor ID', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _serviceId,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Service ID', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _roomId,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Room ID', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Start time'),
            subtitle: Text(_start.toString()),
            trailing: OutlinedButton(
              onPressed: _pickStart,
              child: const Text('Pick'),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _note,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Doctor note (optional)',
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
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Create'),
          ),
        ],
      ),
    );
  }
}
