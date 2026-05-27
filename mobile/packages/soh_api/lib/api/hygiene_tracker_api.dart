//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class HygieneTrackerApi {
  HygieneTrackerApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /HygieneTracker' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] patientId:
  ///
  /// * [DateTime] dateFrom:
  ///
  /// * [DateTime] dateTo:
  ///
  /// * [String] FTS:
  ///
  /// * [int] page:
  ///
  /// * [int] pageSize:
  ///
  /// * [bool] includeTotalCount:
  ///
  /// * [bool] retrieveAll:
  Future<Response> hygieneTrackerGetWithHttpInfo({ int? patientId, DateTime? dateFrom, DateTime? dateTo, String? FTS, int? page, int? pageSize, bool? includeTotalCount, bool? retrieveAll, }) async {
    // ignore: prefer_const_declarations
    final path = r'/HygieneTracker';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (patientId != null) {
      queryParams.addAll(_queryParams('', 'PatientId', patientId));
    }
    if (dateFrom != null) {
      queryParams.addAll(_queryParams('', 'DateFrom', dateFrom));
    }
    if (dateTo != null) {
      queryParams.addAll(_queryParams('', 'DateTo', dateTo));
    }
    if (FTS != null) {
      queryParams.addAll(_queryParams('', 'FTS', FTS));
    }
    if (page != null) {
      queryParams.addAll(_queryParams('', 'Page', page));
    }
    if (pageSize != null) {
      queryParams.addAll(_queryParams('', 'PageSize', pageSize));
    }
    if (includeTotalCount != null) {
      queryParams.addAll(_queryParams('', 'IncludeTotalCount', includeTotalCount));
    }
    if (retrieveAll != null) {
      queryParams.addAll(_queryParams('', 'RetrieveAll', retrieveAll));
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
  /// * [int] patientId:
  ///
  /// * [DateTime] dateFrom:
  ///
  /// * [DateTime] dateTo:
  ///
  /// * [String] FTS:
  ///
  /// * [int] page:
  ///
  /// * [int] pageSize:
  ///
  /// * [bool] includeTotalCount:
  ///
  /// * [bool] retrieveAll:
  Future<HygieneTrackerResponsePagedResult?> hygieneTrackerGet({ int? patientId, DateTime? dateFrom, DateTime? dateTo, String? FTS, int? page, int? pageSize, bool? includeTotalCount, bool? retrieveAll, }) async {
    final response = await hygieneTrackerGetWithHttpInfo( patientId: patientId, dateFrom: dateFrom, dateTo: dateTo, FTS: FTS, page: page, pageSize: pageSize, includeTotalCount: includeTotalCount, retrieveAll: retrieveAll, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'HygieneTrackerResponsePagedResult',) as HygieneTrackerResponsePagedResult;
    
    }
    return null;
  }

  /// Performs an HTTP 'DELETE /HygieneTracker/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> hygieneTrackerIdDeleteWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/HygieneTracker/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [int] id (required):
  Future<bool?> hygieneTrackerIdDelete(int id,) async {
    final response = await hygieneTrackerIdDeleteWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'bool',) as bool;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /HygieneTracker/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> hygieneTrackerIdGetWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/HygieneTracker/{id}'
      .replaceAll('{id}', id.toString());

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

  /// Parameters:
  ///
  /// * [int] id (required):
  Future<HygieneTrackerResponse?> hygieneTrackerIdGet(int id,) async {
    final response = await hygieneTrackerIdGetWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'HygieneTrackerResponse',) as HygieneTrackerResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'PUT /HygieneTracker/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [HygieneTrackerUpsertRequest] hygieneTrackerUpsertRequest:
  Future<Response> hygieneTrackerIdPutWithHttpInfo(int id, { HygieneTrackerUpsertRequest? hygieneTrackerUpsertRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/HygieneTracker/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = hygieneTrackerUpsertRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json', 'text/json', 'application/*+json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [HygieneTrackerUpsertRequest] hygieneTrackerUpsertRequest:
  Future<HygieneTrackerResponse?> hygieneTrackerIdPut(int id, { HygieneTrackerUpsertRequest? hygieneTrackerUpsertRequest, }) async {
    final response = await hygieneTrackerIdPutWithHttpInfo(id,  hygieneTrackerUpsertRequest: hygieneTrackerUpsertRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'HygieneTrackerResponse',) as HygieneTrackerResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /HygieneTracker' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [HygieneTrackerUpsertRequest] hygieneTrackerUpsertRequest:
  Future<Response> hygieneTrackerPostWithHttpInfo({ HygieneTrackerUpsertRequest? hygieneTrackerUpsertRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/HygieneTracker';

    // ignore: prefer_final_locals
    Object? postBody = hygieneTrackerUpsertRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json', 'text/json', 'application/*+json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [HygieneTrackerUpsertRequest] hygieneTrackerUpsertRequest:
  Future<HygieneTrackerResponse?> hygieneTrackerPost({ HygieneTrackerUpsertRequest? hygieneTrackerUpsertRequest, }) async {
    final response = await hygieneTrackerPostWithHttpInfo( hygieneTrackerUpsertRequest: hygieneTrackerUpsertRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'HygieneTrackerResponse',) as HygieneTrackerResponse;
    
    }
    return null;
  }
}
