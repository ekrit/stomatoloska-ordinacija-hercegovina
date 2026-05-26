import 'package:soh_api/api.dart';

String appointmentStatusLabel(AppointmentStatus? status) {
  if (status == null) return 'Unknown';
  if (status == AppointmentStatus.number1) return 'Requested';
  if (status == AppointmentStatus.number2) return 'Accepted';
  if (status == AppointmentStatus.number3) return 'Declined';
  if (status == AppointmentStatus.number4) return 'Completed';
  if (status == AppointmentStatus.number5) return 'Cancelled';
  return 'Unknown';
}
