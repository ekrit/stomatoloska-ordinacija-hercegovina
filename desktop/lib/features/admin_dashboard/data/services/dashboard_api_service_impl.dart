import 'dart:convert';

import 'package:soh_api/api.dart';

import '../models/activity_log_entry.dart';
import '../models/appointment_stats.dart';
import '../models/dashboard_stats.dart';
import 'dashboard_api_service.dart';

class DashboardApiServiceImpl implements DashboardApiService {
  DashboardApiServiceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<DashboardStats> fetchDashboardStats() async {
    final response = await _apiClient.invokeAPI(
      '/admin-dashboard/stats',
      'GET',
      [],
      null,
      {},
      {},
      null,
    );

    if (response.statusCode >= 400) {
      throw ApiException(response.statusCode, response.body);
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return DashboardStats.fromJson(data);
  }

  @override
  Future<RecentActivity> fetchRecentActivity({int take = 30}) async {
    final response = await _apiClient.invokeAPI(
      '/admin-dashboard/activity/recent',
      'GET',
      [QueryParam('take', take.toString())],
      null,
      {},
      {},
      null,
    );

    if (response.statusCode >= 400) {
      throw ApiException(response.statusCode, response.body);
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return const RecentActivity(items: [], totalCount: 0);
    }
    return RecentActivity.fromJson(decoded);
  }

  @override
  Future<AppointmentStats> fetchMonthlyNewPatients({int months = 6}) async {
    final response = await _apiClient.invokeAPI(
      '/admin-dashboard/patients/monthly',
      'GET',
      [QueryParam('months', months.toString())],
      null,
      {},
      {},
      null,
    );

    if (response.statusCode >= 400) {
      throw ApiException(response.statusCode, response.body);
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return AppointmentStats.fromJson(data);
  }
}
