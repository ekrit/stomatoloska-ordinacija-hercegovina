import 'dart:convert';

import 'package:soh_api/api.dart';

import '../models/activity_log_entry.dart';
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
  Future<List<ActivityLogEntry>> fetchRecentActivity({int take = 30}) async {
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
    if (decoded is! List<dynamic>) {
      return const [];
    }
    return decoded
        .map((e) => ActivityLogEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
