import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/models/appointment_stats.dart';
import '../../data/models/dashboard_stats.dart';
import '../../data/models/doctor.dart';
import '../../data/models/revenue_stats.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../data/repositories/doctor_repository_impl.dart';
import '../../data/services/appointment_api_service_impl.dart';
import '../../data/services/dashboard_api_service_impl.dart';
import '../../data/services/doctor_api_service_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/repositories/doctor_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DashboardRepositoryImpl(
    dashboardApi: DashboardApiServiceImpl(apiClient),
    appointmentApi: AppointmentApiServiceImpl(apiClient),
  );
});

final doctorRepositoryProvider = Provider<DoctorRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DoctorRepositoryImpl(
    doctorApi: DoctorApiServiceImpl(apiClient),
  );
});

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) {
  return ref.watch(dashboardRepositoryProvider).fetchDashboardStats();
});

final appointmentStatsProvider = FutureProvider<AppointmentStats>((ref) {
  return ref.watch(dashboardRepositoryProvider).fetchAppointmentStats();
});

final revenueStatsProvider = FutureProvider<RevenueStats>((ref) {
  return ref.watch(dashboardRepositoryProvider).fetchRevenueStats();
});

final doctorsProvider = FutureProvider<List<Doctor>>((ref) {
  return ref.watch(doctorRepositoryProvider).fetchDoctors();
});
