import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soh_api/api.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/utils/appointment_labels.dart';

/// Admin: view and update an appointment (status, schedule, doctor note).
class AdminAppointmentEditScreen extends ConsumerStatefulWidget {
  const AdminAppointmentEditScreen({super.key, required this.appointment});

  final AppointmentResponse appointment;

  @override
  ConsumerState<AdminAppointmentEditScreen> createState() => _AdminAppointmentEditScreenState();
}

class _AdminAppointmentEditScreenState extends ConsumerState<AdminAppointmentEditScreen> {
  late AppointmentStatus _status;
  late DateTime _start;
  late DateTime _end;
  late final TextEditingController _note;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final a = widget.appointment;
    _status = a.status ?? AppointmentStatus.number1;
    _start = a.startTime ?? DateTime.now();
    _end = a.endTime ?? _start.add(const Duration(minutes: 30));
    _note = TextEditingController(text: a.doctorNote ?? '');
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickStart() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _start,
      firstDate: DateTime(2020),
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
      if (!_end.isAfter(_start)) {
        _end = _start.add(const Duration(minutes: 30));
      }
    });
  }

  Future<void> _pickEnd() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _end,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_end),
    );
    if (t == null || !mounted) return;
    setState(() {
      _end = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    });
  }

  Future<void> _save() async {
    final a = widget.appointment;
    if (a.id == null ||
        a.patientId == null ||
        a.doctorId == null ||
        a.serviceId == null ||
        a.roomId == null) {
      setState(() => _error = 'Missing appointment data.');
      return;
    }
    if (!_end.isAfter(_start)) {
      setState(() => _error = 'End time must be after start time.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(appointmentApiProvider).appointmentIdPut(
            a.id!,
            appointmentUpsertRequest: AppointmentUpsertRequest(
              patientId: a.patientId!,
              doctorId: a.doctorId!,
              serviceId: a.serviceId!,
              roomId: a.roomId!,
              startTime: _start,
              endTime: _end,
              status: _status,
              doctorNote: _note.text.trim().isEmpty ? null : _note.text.trim(),
            ),
          );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmDelete() async {
    final id = widget.appointment.id;
    if (id == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete appointment?'),
        content: const Text('This permanently removes the appointment from the system.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(appointmentApiProvider).appointmentIdDelete(id);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.appointment;
    final df = DateFormat.yMMMd();
    final tf = DateFormat.Hm();

    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment #${a.id ?? ''}'),
        actions: [
          if (a.id != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              onPressed: _saving ? null : _confirmDelete,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Patient ID: ${a.patientId ?? '—'} · Doctor ID: ${a.doctorId ?? '—'}'),
          Text('Service ID: ${a.serviceId ?? '—'} · Room ID: ${a.roomId ?? '—'}'),
          const SizedBox(height: 20),
          Text('Status', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<AppointmentStatus>(
            value: _status,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: AppointmentStatus.values
                .map(
                  (s) => DropdownMenuItem(
                    value: s,
                    child: Text(appointmentStatusLabel(s)),
                  ),
                )
                .toList(),
            onChanged: _saving ? null : (v) => setState(() => _status = v ?? _status),
          ),
          const SizedBox(height: 16),
          Text('Start', style: Theme.of(context).textTheme.titleMedium),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('${df.format(_start)} ${tf.format(_start)}'),
            trailing: const Icon(Icons.edit_calendar_outlined),
            onTap: _saving ? null : _pickStart,
          ),
          Text('End', style: Theme.of(context).textTheme.titleMedium),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('${df.format(_end)} ${tf.format(_end)}'),
            trailing: const Icon(Icons.edit_calendar_outlined),
            onTap: _saving ? null : _pickEnd,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _note,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Doctor note',
              border: OutlineInputBorder(),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save changes'),
          ),
        ],
      ),
    );
  }
}
