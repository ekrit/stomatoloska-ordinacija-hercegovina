import '../../data/models/activity_log_entry.dart';
import '../../data/models/appointment_stats.dart';
import '../../data/models/dashboard_stats.dart';
import '../../data/models/revenue_stats.dart';

abstract class DashboardRepository {
  Future<DashboardStats> fetchDashboardStats();
  Future<AppointmentStats> fetchAppointmentStats();
  Future<RevenueStats> fetchRevenueStats();
  Future<List<ActivityLogEntry>> fetchRecentActivity({int take = 30});
}
