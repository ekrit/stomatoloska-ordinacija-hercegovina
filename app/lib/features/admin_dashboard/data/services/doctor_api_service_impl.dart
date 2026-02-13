import 'dart:convert';

import 'package:soh_api/api.dart';

import '../models/doctor.dart';
import 'doctor_api_service.dart';

class DoctorApiServiceImpl implements DoctorApiService {
  DoctorApiServiceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<Doctor>> fetchDoctors() async {
    final response = await _apiClient.invokeAPI(
      '/admin-dashboard/doctors/spotlight',
      'GET',
      [const QueryParam('limit', '4')],
      null,
      {},
      {},
      null,
    );

    if (response.statusCode >= 400) {
      throw ApiException(response.statusCode, response.body);
    }

    final raw = jsonDecode(response.body) as List<dynamic>;
    return raw
        .map((item) => Doctor.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
