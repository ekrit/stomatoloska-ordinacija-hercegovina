import '../models/activity_log_entry.dart';
import '../models/dashboard_stats.dart';

abstract class DashboardApiService {
  Future<DashboardStats> fetchDashboardStats();
  Future<RecentActivity> fetchRecentActivity({int take = 30});
}
