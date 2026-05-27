/// Clinic booking grid: length of each selectable slot in minutes.
abstract final class BookingConfig {
  static const int slotMinutes = 30;

  /// Workday window (local time) for generating free slots.
  static const int workdayStartHour = 8;
  static const int workdayEndHour = 18;
}
