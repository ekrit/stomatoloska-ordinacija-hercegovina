//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class ReportPdfApi {
  ReportPdfApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /report/pdf/appointments-summary' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [DateTime] fromUtc:
  ///
  /// * [DateTime] toUtc:
  Future<Response> reportPdfAppointmentsSummaryGetWithHttpInfo({ DateTime? fromUtc, DateTime? toUtc, }) async {
    // ignore: prefer_const_declarations
    final path = r'/report/pdf/appointments-summary';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (fromUtc != null) {
      queryParams.addAll(_queryParams('', 'fromUtc', fromUtc));
    }
    if (toUtc != null) {
      queryParams.addAll(_queryParams('', 'toUtc', toUtc));
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
  /// * [DateTime] fromUtc:
  ///
  /// * [DateTime] toUtc:
  Future<void> reportPdfAppointmentsSummaryGet({ DateTime? fromUtc, DateTime? toUtc, }) async {
    final response = await reportPdfAppointmentsSummaryGetWithHttpInfo( fromUtc: fromUtc, toUtc: toUtc, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'GET /report/pdf/revenue-by-service' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] months:
  Future<Response> reportPdfRevenueByServiceGetWithHttpInfo({ int? months, }) async {
    // ignore: prefer_const_declarations
    final path = r'/report/pdf/revenue-by-service';

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
  Future<void> reportPdfRevenueByServiceGet({ int? months, }) async {
    final response = await reportPdfRevenueByServiceGetWithHttpInfo( months: months, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
