import '../models/dashboard_stats.dart';
import '../services/dashboard_api_service.dart';

class FakeDashboardApiService implements DashboardApiService {
  @override
  Future<DashboardStats> fetchDashboardStats() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const DashboardStats(
      totalDoctors: 12,
      totalPractices: 5,
      totalUsers: 58,
      completedAppointments: 789,
      cancelledAppointments: 45,
      averageEarnings: 2100,
      newPatientsThisMonth: 35,
      revenueGrowth: 8.2,
    );
  }
}
