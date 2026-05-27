import 'dart:convert';

import 'package:soh_api/api.dart';

import '../models/appointment_stats.dart';
import '../models/revenue_stats.dart';
import 'appointment_api_service.dart';

class AppointmentApiServiceImpl implements AppointmentApiService {
  AppointmentApiServiceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<AppointmentStats> fetchAppointmentStats() async {
    final response = await _apiClient.invokeAPI(
      '/admin-dashboard/appointments/monthly',
      'GET',
      [const QueryParam('months', '6')],
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

  @override
  Future<RevenueStats> fetchRevenueStats() async {
    final response = await _apiClient.invokeAPI(
      '/admin-dashboard/revenue/breakdown',
      'GET',
      [const QueryParam('months', '6')],
      null,
      {},
      {},
      null,
    );

    if (response.statusCode >= 400) {
      throw ApiException(response.statusCode, response.body);
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return RevenueStats.fromJson(data);
  }
}
