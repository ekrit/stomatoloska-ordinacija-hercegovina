import 'package:mobile/core/utils/appointment_labels.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soh_api/api.dart';

void main() {
  test('appointmentStatusLabel maps known statuses', () {
    expect(appointmentStatusLabel(AppointmentStatus.number1), 'Na čekanju');
    expect(appointmentStatusLabel(AppointmentStatus.number2), 'Prihvaćen');
    expect(appointmentStatusLabel(AppointmentStatus.number3), 'Odbijen');
    expect(appointmentStatusLabel(AppointmentStatus.number4), 'Završen');
    expect(appointmentStatusLabel(AppointmentStatus.number5), 'Otkazan');
  });
}
