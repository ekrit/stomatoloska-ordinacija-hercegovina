import '../models/appointment_stats.dart';
import '../models/revenue_stats.dart';

abstract class AppointmentApiService {
  Future<AppointmentStats> fetchAppointmentStats();
  Future<RevenueStats> fetchRevenueStats();
}
