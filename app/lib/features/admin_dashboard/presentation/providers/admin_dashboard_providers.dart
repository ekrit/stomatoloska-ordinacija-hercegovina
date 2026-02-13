import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/fake/fake_appointment_api_service.dart';
import '../../data/fake/fake_dashboard_api_service.dart';
import '../../data/fake/fake_doctor_api_service.dart';
import '../../data/models/appointment_stats.dart';
import '../../data/models/dashboard_stats.dart';
import '../../data/models/doctor.dart';
import '../../data/models/revenue_stats.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../data/repositories/doctor_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/repositories/doctor_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    dashboardApi: FakeDashboardApiService(),
    appointmentApi: FakeAppointmentApiService(),
  );
});

final doctorRepositoryProvider = Provider<DoctorRepository>((ref) {
  return DoctorRepositoryImpl(
    doctorApi: FakeDoctorApiService(),
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
