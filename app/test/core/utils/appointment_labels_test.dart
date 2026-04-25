import 'package:app/core/utils/appointment_labels.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soh_api/api.dart';

void main() {
  test('appointmentStatusLabel maps known statuses', () {
    expect(appointmentStatusLabel(AppointmentStatus.number1), 'Requested');
    expect(appointmentStatusLabel(AppointmentStatus.number2), 'Accepted');
    expect(appointmentStatusLabel(AppointmentStatus.number3), 'Declined');
    expect(appointmentStatusLabel(AppointmentStatus.number4), 'Completed');
    expect(appointmentStatusLabel(AppointmentStatus.number5), 'Cancelled');
  });
}
