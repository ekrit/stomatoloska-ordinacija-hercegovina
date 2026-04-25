import 'package:app/core/domain/booking_slots.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soh_api/api.dart';

void main() {
  test('computeFreeSlotStarts excludes busy range', () {
    final day = DateTime(2026, 4, 10);
    final busy = [
      AppointmentResponse(
        startTime: DateTime(2026, 4, 10, 9, 0),
        endTime: DateTime(2026, 4, 10, 10, 0),
      ),
    ];
    final free = computeFreeSlotStarts(day: day, busy: busy, slotMinutes: 30);
    expect(free.any((t) => t.hour == 9 && t.minute == 0), false);
    expect(free.any((t) => t.hour == 9 && t.minute == 30), false);
    expect(free.any((t) => t.hour == 8 && t.minute == 0), true);
    expect(free.any((t) => t.hour == 10 && t.minute == 0), true);
  });
}
