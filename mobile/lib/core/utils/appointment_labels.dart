import 'package:soh_api/api.dart';

/// Friendly aliases for the generated `AppointmentStatus.numberN` enum values.
///
/// The OpenAPI generator names integer enums `number1`, `number2`, ... which
/// is correct but unreadable at every call site. These constants keep the
/// generated values as the source of truth while letting feature code read
/// like the backend C# enum (Requested / Accepted / ... / Cancelled).
class AppointmentStatuses {
  AppointmentStatuses._();

  static const requested = AppointmentStatus.number1;
  static const accepted = AppointmentStatus.number2;
  static const declined = AppointmentStatus.number3;
  static const completed = AppointmentStatus.number4;
  static const cancelled = AppointmentStatus.number5;
}

String appointmentStatusLabel(AppointmentStatus? status) {
  if (status == null) return 'Unknown';
  if (status == AppointmentStatuses.requested) return 'Requested';
  if (status == AppointmentStatuses.accepted) return 'Accepted';
  if (status == AppointmentStatuses.declined) return 'Declined';
  if (status == AppointmentStatuses.completed) return 'Completed';
  if (status == AppointmentStatuses.cancelled) return 'Cancelled';
  return 'Unknown';
}
