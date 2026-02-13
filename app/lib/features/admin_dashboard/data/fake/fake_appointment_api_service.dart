import '../models/appointment_stats.dart';
import '../models/revenue_stats.dart';
import '../services/appointment_api_service.dart';

class FakeAppointmentApiService implements AppointmentApiService {
  @override
  Future<AppointmentStats> fetchAppointmentStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const AppointmentStats(
      monthly: [
        MonthlyAppointment(month: 'Jan', count: 120),
        MonthlyAppointment(month: 'Feb', count: 145),
        MonthlyAppointment(month: 'Mar', count: 160),
        MonthlyAppointment(month: 'Apr', count: 175),
        MonthlyAppointment(month: 'May', count: 205),
        MonthlyAppointment(month: 'Jun', count: 230),
      ],
    );
  }

  @override
  Future<RevenueStats> fetchRevenueStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const RevenueStats(
      categories: [
        RevenueCategory(label: 'Orthodontics', value: 40),
        RevenueCategory(label: 'Implants', value: 25),
        RevenueCategory(label: 'Cleaning', value: 20),
        RevenueCategory(label: 'Whitening', value: 15),
      ],
    );
  }
}
