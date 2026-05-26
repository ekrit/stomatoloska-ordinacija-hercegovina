//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class ActivityLogApi {
  ActivityLogApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /ActivityLog' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] action:
  ///
  /// * [String] entityName:
  ///
  /// * [String] entityId:
  ///
  /// * [DateTime] createdFrom:
  ///
  /// * [DateTime] createdTo:
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
  Future<Response> activityLogGetWithHttpInfo({ String? action, String? entityName, String? entityId, DateTime? createdFrom, DateTime? createdTo, String? FTS, int? page, int? pageSize, bool? includeTotalCount, bool? retrieveAll, }) async {
    // ignore: prefer_const_declarations
    final path = r'/ActivityLog';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (action != null) {
      queryParams.addAll(_queryParams('', 'Action', action));
    }
    if (entityName != null) {
      queryParams.addAll(_queryParams('', 'EntityName', entityName));
    }
    if (entityId != null) {
      queryParams.addAll(_queryParams('', 'EntityId', entityId));
    }
    if (createdFrom != null) {
      queryParams.addAll(_queryParams('', 'CreatedFrom', createdFrom));
    }
    if (createdTo != null) {
      queryParams.addAll(_queryParams('', 'CreatedTo', createdTo));
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
  /// * [String] action:
  ///
  /// * [String] entityName:
  ///
  /// * [String] entityId:
  ///
  /// * [DateTime] createdFrom:
  ///
  /// * [DateTime] createdTo:
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
  Future<ActivityLogResponsePagedResult?> activityLogGet({ String? action, String? entityName, String? entityId, DateTime? createdFrom, DateTime? createdTo, String? FTS, int? page, int? pageSize, bool? includeTotalCount, bool? retrieveAll, }) async {
    final response = await activityLogGetWithHttpInfo( action: action, entityName: entityName, entityId: entityId, createdFrom: createdFrom, createdTo: createdTo, FTS: FTS, page: page, pageSize: pageSize, includeTotalCount: includeTotalCount, retrieveAll: retrieveAll, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ActivityLogResponsePagedResult',) as ActivityLogResponsePagedResult;
    
    }
    return null;
  }

  /// Performs an HTTP 'DELETE /ActivityLog/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> activityLogIdDeleteWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/ActivityLog/{id}'
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
  Future<bool?> activityLogIdDelete(int id,) async {
    final response = await activityLogIdDeleteWithHttpInfo(id,);
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

  /// Performs an HTTP 'GET /ActivityLog/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> activityLogIdGetWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/ActivityLog/{id}'
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
  Future<ActivityLogResponse?> activityLogIdGet(int id,) async {
    final response = await activityLogIdGetWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ActivityLogResponse',) as ActivityLogResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'PUT /ActivityLog/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [ActivityLogUpsertRequest] activityLogUpsertRequest:
  Future<Response> activityLogIdPutWithHttpInfo(int id, { ActivityLogUpsertRequest? activityLogUpsertRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/ActivityLog/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = activityLogUpsertRequest;

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
  /// * [ActivityLogUpsertRequest] activityLogUpsertRequest:
  Future<ActivityLogResponse?> activityLogIdPut(int id, { ActivityLogUpsertRequest? activityLogUpsertRequest, }) async {
    final response = await activityLogIdPutWithHttpInfo(id,  activityLogUpsertRequest: activityLogUpsertRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ActivityLogResponse',) as ActivityLogResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /ActivityLog' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [ActivityLogUpsertRequest] activityLogUpsertRequest:
  Future<Response> activityLogPostWithHttpInfo({ ActivityLogUpsertRequest? activityLogUpsertRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/ActivityLog';

    // ignore: prefer_final_locals
    Object? postBody = activityLogUpsertRequest;

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
  /// * [ActivityLogUpsertRequest] activityLogUpsertRequest:
  Future<ActivityLogResponse?> activityLogPost({ ActivityLogUpsertRequest? activityLogUpsertRequest, }) async {
    final response = await activityLogPostWithHttpInfo( activityLogUpsertRequest: activityLogUpsertRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ActivityLogResponse',) as ActivityLogResponse;
    
    }
    return null;
  }
}
