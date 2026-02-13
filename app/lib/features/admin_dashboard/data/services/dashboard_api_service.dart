import '../models/dashboard_stats.dart';

abstract class DashboardApiService {
  Future<DashboardStats> fetchDashboardStats();
}
