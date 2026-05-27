//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminApi {
  AdminApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /Admin' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] userId:
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
  Future<Response> adminGetWithHttpInfo({ int? userId, String? FTS, int? page, int? pageSize, bool? includeTotalCount, bool? retrieveAll, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Admin';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (userId != null) {
      queryParams.addAll(_queryParams('', 'UserId', userId));
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
  /// * [int] userId:
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
  Future<AdminResponsePagedResult?> adminGet({ int? userId, String? FTS, int? page, int? pageSize, bool? includeTotalCount, bool? retrieveAll, }) async {
    final response = await adminGetWithHttpInfo( userId: userId, FTS: FTS, page: page, pageSize: pageSize, includeTotalCount: includeTotalCount, retrieveAll: retrieveAll, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminResponsePagedResult',) as AdminResponsePagedResult;
    
    }
    return null;
  }

  /// Performs an HTTP 'DELETE /Admin/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> adminIdDeleteWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/Admin/{id}'
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
  Future<bool?> adminIdDelete(int id,) async {
    final response = await adminIdDeleteWithHttpInfo(id,);
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

  /// Performs an HTTP 'GET /Admin/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> adminIdGetWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/Admin/{id}'
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
  Future<AdminResponse?> adminIdGet(int id,) async {
    final response = await adminIdGetWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminResponse',) as AdminResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'PUT /Admin/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [AdminUpsertRequest] adminUpsertRequest:
  Future<Response> adminIdPutWithHttpInfo(int id, { AdminUpsertRequest? adminUpsertRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Admin/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = adminUpsertRequest;

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
  /// * [AdminUpsertRequest] adminUpsertRequest:
  Future<AdminResponse?> adminIdPut(int id, { AdminUpsertRequest? adminUpsertRequest, }) async {
    final response = await adminIdPutWithHttpInfo(id,  adminUpsertRequest: adminUpsertRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminResponse',) as AdminResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /Admin' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [AdminUpsertRequest] adminUpsertRequest:
  Future<Response> adminPostWithHttpInfo({ AdminUpsertRequest? adminUpsertRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Admin';

    // ignore: prefer_final_locals
    Object? postBody = adminUpsertRequest;

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
  /// * [AdminUpsertRequest] adminUpsertRequest:
  Future<AdminResponse?> adminPost({ AdminUpsertRequest? adminUpsertRequest, }) async {
    final response = await adminPostWithHttpInfo( adminUpsertRequest: adminUpsertRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminResponse',) as AdminResponse;
    
    }
    return null;
  }
}
