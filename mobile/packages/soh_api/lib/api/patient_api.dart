//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PatientApi {
  PatientApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /Patient' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] userId:
  ///
  /// * [String] firstName:
  ///
  /// * [String] lastName:
  ///
  /// * [String] phone:
  ///
  /// * [String] FTS:
  ///
  /// * [int] page:
  ///
  /// * [int] pageSize:
  ///
  /// * [bool] includeTotalCount:
  Future<Response> patientGetWithHttpInfo({ int? userId, String? firstName, String? lastName, String? phone, String? FTS, int? page, int? pageSize, bool? includeTotalCount, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Patient';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (userId != null) {
      queryParams.addAll(_queryParams('', 'UserId', userId));
    }
    if (firstName != null) {
      queryParams.addAll(_queryParams('', 'FirstName', firstName));
    }
    if (lastName != null) {
      queryParams.addAll(_queryParams('', 'LastName', lastName));
    }
    if (phone != null) {
      queryParams.addAll(_queryParams('', 'Phone', phone));
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
  /// * [int] userId:
  ///
  /// * [String] firstName:
  ///
  /// * [String] lastName:
  ///
  /// * [String] phone:
  ///
  /// * [String] FTS:
  ///
  /// * [int] page:
  ///
  /// * [int] pageSize:
  ///
  /// * [bool] includeTotalCount:
  Future<PatientResponsePagedResult?> patientGet({ int? userId, String? firstName, String? lastName, String? phone, String? FTS, int? page, int? pageSize, bool? includeTotalCount, }) async {
    final response = await patientGetWithHttpInfo( userId: userId, firstName: firstName, lastName: lastName, phone: phone, FTS: FTS, page: page, pageSize: pageSize, includeTotalCount: includeTotalCount, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PatientResponsePagedResult',) as PatientResponsePagedResult;
    
    }
    return null;
  }

  /// Performs an HTTP 'DELETE /Patient/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> patientIdDeleteWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/Patient/{id}'
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
  Future<bool?> patientIdDelete(int id,) async {
    final response = await patientIdDeleteWithHttpInfo(id,);
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

  /// Performs an HTTP 'GET /Patient/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> patientIdGetWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/Patient/{id}'
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
  Future<PatientResponse?> patientIdGet(int id,) async {
    final response = await patientIdGetWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PatientResponse',) as PatientResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'PUT /Patient/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [PatientUpsertRequest] patientUpsertRequest:
  Future<Response> patientIdPutWithHttpInfo(int id, { PatientUpsertRequest? patientUpsertRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Patient/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = patientUpsertRequest;

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
  /// * [PatientUpsertRequest] patientUpsertRequest:
  Future<PatientResponse?> patientIdPut(int id, { PatientUpsertRequest? patientUpsertRequest, }) async {
    final response = await patientIdPutWithHttpInfo(id,  patientUpsertRequest: patientUpsertRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PatientResponse',) as PatientResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /Patient' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [PatientUpsertRequest] patientUpsertRequest:
  Future<Response> patientPostWithHttpInfo({ PatientUpsertRequest? patientUpsertRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Patient';

    // ignore: prefer_final_locals
    Object? postBody = patientUpsertRequest;

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
  /// * [PatientUpsertRequest] patientUpsertRequest:
  Future<PatientResponse?> patientPost({ PatientUpsertRequest? patientUpsertRequest, }) async {
    final response = await patientPostWithHttpInfo( patientUpsertRequest: patientUpsertRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PatientResponse',) as PatientResponse;
    
    }
    return null;
  }
}
