//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminDashboardApi {
  AdminDashboardApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /admin-dashboard/activity/recent' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] take:
  Future<Response> adminDashboardActivityRecentGetWithHttpInfo({ int? take, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin-dashboard/activity/recent';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (take != null) {
      queryParams.addAll(_queryParams('', 'take', take));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [int] take:
  Future<RecentActivityResponse?> adminDashboardActivityRecentGet({ int? take, }) async {
    final response = await adminDashboardActivityRecentGetWithHttpInfo( take: take, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RecentActivityResponse',) as RecentActivityResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /admin-dashboard/appointments/monthly' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] months:
  Future<Response> adminDashboardAppointmentsMonthlyGetWithHttpInfo({ int? months, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin-dashboard/appointments/monthly';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (months != null) {
      queryParams.addAll(_queryParams('', 'months', months));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [int] months:
  Future<AppointmentStatsResponse?> adminDashboardAppointmentsMonthlyGet({ int? months, }) async {
    final response = await adminDashboardAppointmentsMonthlyGetWithHttpInfo( months: months, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AppointmentStatsResponse',) as AppointmentStatsResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /admin-dashboard/doctors/spotlight' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] limit:
  Future<Response> adminDashboardDoctorsSpotlightGetWithHttpInfo({ int? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin-dashboard/doctors/spotlight';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [int] limit:
  Future<List<DoctorSpotlightResponse>?> adminDashboardDoctorsSpotlightGet({ int? limit, }) async {
    final response = await adminDashboardDoctorsSpotlightGetWithHttpInfo( limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<DoctorSpotlightResponse>') as List)
        .cast<DoctorSpotlightResponse>()
        .toList(growable: false);

    }
    return null;
  }

  /// Performs an HTTP 'GET /admin-dashboard/patients/monthly' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] months:
  Future<Response> adminDashboardPatientsMonthlyGetWithHttpInfo({ int? months, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin-dashboard/patients/monthly';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (months != null) {
      queryParams.addAll(_queryParams('', 'months', months));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [int] months:
  Future<PatientStatsResponse?> adminDashboardPatientsMonthlyGet({ int? months, }) async {
    final response = await adminDashboardPatientsMonthlyGetWithHttpInfo( months: months, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PatientStatsResponse',) as PatientStatsResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /admin-dashboard/revenue/breakdown' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] months:
  Future<Response> adminDashboardRevenueBreakdownGetWithHttpInfo({ int? months, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin-dashboard/revenue/breakdown';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (months != null) {
      queryParams.addAll(_queryParams('', 'months', months));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [int] months:
  Future<RevenueStatsResponse?> adminDashboardRevenueBreakdownGet({ int? months, }) async {
    final response = await adminDashboardRevenueBreakdownGetWithHttpInfo( months: months, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RevenueStatsResponse',) as RevenueStatsResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /admin-dashboard/stats' operation and returns the [Response].
  Future<Response> adminDashboardStatsGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/admin-dashboard/stats';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  Future<DashboardStatsResponse?> adminDashboardStatsGet() async {
    final response = await adminDashboardStatsGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'DashboardStatsResponse',) as DashboardStatsResponse;
    
    }
    return null;
  }
}
