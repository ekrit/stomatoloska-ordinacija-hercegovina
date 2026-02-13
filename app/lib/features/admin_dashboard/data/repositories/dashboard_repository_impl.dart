import '../models/appointment_stats.dart';
import '../models/dashboard_stats.dart';
import '../models/revenue_stats.dart';
import '../services/appointment_api_service.dart';
import '../services/dashboard_api_service.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({
    required DashboardApiService dashboardApi,
    required AppointmentApiService appointmentApi,
  })  : _dashboardApi = dashboardApi,
        _appointmentApi = appointmentApi;

  final DashboardApiService _dashboardApi;
  final AppointmentApiService _appointmentApi;

  @override
  Future<DashboardStats> fetchDashboardStats() {
    return _dashboardApi.fetchDashboardStats();
  }

  @override
  Future<AppointmentStats> fetchAppointmentStats() {
    return _appointmentApi.fetchAppointmentStats();
  }

  @override
  Future<RevenueStats> fetchRevenueStats() {
    return _appointmentApi.fetchRevenueStats();
  }
}
