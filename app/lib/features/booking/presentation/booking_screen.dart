import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:soh_api/api.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/api/api_providers.dart';
import '../../../core/config/booking_config.dart';
import '../../../core/domain/booking_slots.dart';
import '../../patient/presentation/providers/patient_data_providers.dart';
import '../../patient/presentation/providers/patient_repository_providers.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  int _step = 0;
  DoctorResponse? _doctor;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _slotStart;
  ServiceResponse? _service;
  final _complaintController = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _complaintController.dispose();
    super.dispose();
  }

  Future<List<AppointmentResponse>> _loadDayBusy(int doctorUserId, DateTime day) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return ref.read(patientCareRepositoryProvider).listAppointmentsForDoctorBetween(
          doctorId: doctorUserId,
          startInclusive: start,
          endExclusive: end,
        );
  }

  Future<void> _submit() async {
    final user = ref.read(currentUserProvider);
    final doctor = _doctor;
    final day = _selectedDay;
    final slot = _slotStart;
    final svc = _service;
    if (user?.id == null ||
        doctor?.userId == null ||
        day == null ||
        slot == null ||
        svc?.id == null) {
      setState(() => _error = 'Please complete all steps.');
      return;
    }

    List<RoomResponse> rooms;
    try {
      rooms = await ref.read(roomsProvider.future);
    } catch (_) {
      rooms = await ref.read(patientCatalogRepositoryProvider).listRooms();
    }
    final available =
        rooms.where((r) => r.isAvailable == true).toList();
    final room = available.isNotEmpty
        ? available.first
        : (rooms.isNotEmpty ? rooms.first : null);
    if (room?.id == null) {
      setState(() => _error = 'No room available. Contact the clinic.');
      return;
    }

    final durationMin = svc!.durationMinutes ?? BookingConfig.slotMinutes;
    final end = slot.add(Duration(minutes: durationMin));

    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref.read(patientCareRepositoryProvider).createAppointment(
            AppointmentUpsertRequest(
              patientId: user!.id!,
              doctorId: doctor.userId!,
              serviceId: svc.id!,
              roomId: room!.id!,
              startTime: slot,
              endTime: end,
              status: AppointmentStatus.number1,
              doctorNote: _composeNotes(
                serviceName: svc.name,
                complaint: _complaintController.text,
              ),
            ),
          );
      if (!mounted) return;
      ref.invalidate(myAppointmentsProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment requested.')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctors = ref.watch(doctorsProvider);
    final services = ref.watch(servicesProvider);
    final timeFmt = DateFormat.Hm();

    return Scaffold(
      appBar: AppBar(title: const Text('Book appointment')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: List.generate(4, (i) {
                final active = i == _step;
                final done = i < _step;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: done || active
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_step == 0)
                    doctors.when(
                      data: (list) {
                        if (list.isEmpty) {
                          return const Text('No dentists available.');
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Choose your dentist',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            ...list.map(
                              (d) => RadioListTile<DoctorResponse>(
                                title: Text(
                                  '${d.firstName ?? ''} ${d.lastName ?? ''}'.trim(),
                                ),
                                subtitle: Text(d.specialization ?? ''),
                                value: d,
                                groupValue: _doctor,
                                onChanged: (v) => setState(() => _doctor = v),
                              ),
                            ),
                            FilledButton(
                              onPressed: _doctor == null
                                  ? null
                                  : () => setState(() => _step = 1),
                              child: const Text('Next'),
                            ),
                          ],
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('$e'),
                    ),
                  if (_step == 1) ...[
                    Text(
                      'Pick a date',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TableCalendar<void>(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (d) => isSameDay(_selectedDay, d),
                      onDaySelected: (selected, focused) {
                        setState(() {
                          _selectedDay = selected;
                          _focusedDay = focused;
                          _slotStart = null;
                        });
                      },
                      onPageChanged: (focused) => setState(() => _focusedDay = focused),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => setState(() => _step = 0),
                          child: const Text('Back'),
                        ),
                        const Spacer(),
                        FilledButton(
                          onPressed: _selectedDay == null
                              ? null
                              : () => setState(() => _step = 2),
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                  if (_step == 2 && _doctor?.userId != null && _selectedDay != null)
                    FutureBuilder<List<AppointmentResponse>>(
                      future: _loadDayBusy(_doctor!.userId!, _selectedDay!),
                      builder: (context, snap) {
                        if (!snap.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final free = computeFreeSlotStarts(
                          day: _selectedDay!,
                          busy: snap.data!,
                          slotMinutes: BookingConfig.slotMinutes,
                        );
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Available times',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            if (free.isEmpty)
                              const Text('No free slots this day. Pick another date.')
                            else
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: free.map((t) {
                                  final sel = _slotStart != null &&
                                      _slotStart!.millisecondsSinceEpoch ==
                                          t.millisecondsSinceEpoch;
                                  return ChoiceChip(
                                    label: Text(timeFmt.format(t)),
                                    selected: sel,
                                    onSelected: (_) =>
                                        setState(() => _slotStart = t),
                                  );
                                }).toList(),
                              ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () => setState(() => _step = 1),
                                  child: const Text('Back'),
                                ),
                                const Spacer(),
                                FilledButton(
                                  onPressed: _slotStart == null
                                      ? null
                                      : () => setState(() => _step = 3),
                                  child: const Text('Next'),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  if (_step == 3)
                    services.when(
                      data: (list) {
                        if (list.isEmpty) {
                          return const Text('No services configured.');
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Service type',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            ...list.map(
                              (s) => RadioListTile<ServiceResponse>(
                                title: Text(s.name ?? 'Service'),
                                subtitle: s.price != null
                                    ? Text('${s.price!.toStringAsFixed(2)} KM')
                                    : null,
                                value: s,
                                groupValue: _service,
                                onChanged: (v) => setState(() => _service = v),
                              ),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () => setState(() => _step = 2),
                                  child: const Text('Back'),
                                ),
                                const Spacer(),
                                FilledButton(
                                  onPressed: _service == null
                                      ? null
                                      : () => setState(() => _step = 4),
                                  child: const Text('Next'),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('$e'),
                    ),
                  if (_step == 4 &&
                      _doctor != null &&
                      _selectedDay != null &&
                      _slotStart != null &&
                      _service != null) ...[
                    Text(
                      'Confirm',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_doctor!.firstName} ${_doctor!.lastName}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(DateFormat.yMMMd().format(_selectedDay!)),
                            Text(timeFmt.format(_slotStart!)),
                            Text(_service!.name ?? ''),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _complaintController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Client Complaint (optional)',
                        hintText: 'Describe symptoms or what you want checked.',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.newline,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => setState(() => _step = 3),
                          child: const Text('Back'),
                        ),
                      ],
                    ),
                    FilledButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Confirm booking'),
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String? _composeNotes({String? serviceName, required String complaint}) {
  final parts = <String>[];
  final s = (serviceName ?? '').trim();
  if (s.isNotEmpty) {
    parts.add('Service: $s');
  }
  final c = complaint.trim();
  if (c.isNotEmpty) {
    parts.add('Client complaint: $c');
  }
  if (parts.isEmpty) return null;
  return parts.join('\n');
}
