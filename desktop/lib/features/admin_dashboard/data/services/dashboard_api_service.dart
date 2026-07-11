import '../models/activity_log_entry.dart';
import '../models/appointment_stats.dart';
import '../models/dashboard_stats.dart';

abstract class DashboardApiService {
  Future<DashboardStats> fetchDashboardStats();
  Future<RecentActivity> fetchRecentActivity({int take = 30});

  /// New patient registrations per month (same monthly-count shape as
  /// appointments, so the chart widget is reused).
  Future<AppointmentStats> fetchMonthlyNewPatients({int months = 6});
}
