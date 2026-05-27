import 'package:soh_api/api.dart';

import '../config/booking_config.dart';

/// Builds start times for free slots on [day], excluding overlaps with [busy] appointments.
List<DateTime> computeFreeSlotStarts({
  required DateTime day,
  required List<AppointmentResponse> busy,
  int slotMinutes = BookingConfig.slotMinutes,
}) {
  final start = DateTime(day.year, day.month, day.day, BookingConfig.workdayStartHour);
  final end = DateTime(day.year, day.month, day.day, BookingConfig.workdayEndHour);

  final busyRanges = <({DateTime a, DateTime b})>[];
  for (final a in busy) {
    final s = a.startTime;
    final e = a.endTime;
    if (s != null && e != null) {
      busyRanges.add((a: s, b: e));
    }
  }

  final free = <DateTime>[];
  for (var t = start; t.isBefore(end); t = t.add(Duration(minutes: slotMinutes))) {
    final slotEnd = t.add(Duration(minutes: slotMinutes));
    if (slotEnd.isAfter(end)) break;

    var overlaps = false;
    for (final r in busyRanges) {
      if (t.isBefore(r.b) && slotEnd.isAfter(r.a)) {
        overlaps = true;
        break;
      }
    }
    if (!overlaps) {
      free.add(t);
    }
  }
  return free;
}
