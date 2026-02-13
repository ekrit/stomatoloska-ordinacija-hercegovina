import 'dart:convert';

import 'package:soh_api/api.dart';

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
}
