//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class OrderApi {
  OrderApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /Order' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] patientId:
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
  Future<Response> orderGetWithHttpInfo({ int? patientId, DateTime? createdFrom, DateTime? createdTo, String? FTS, int? page, int? pageSize, bool? includeTotalCount, bool? retrieveAll, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Order';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (patientId != null) {
      queryParams.addAll(_queryParams('', 'PatientId', patientId));
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
  /// * [int] patientId:
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
  Future<OrderResponsePagedResult?> orderGet({ int? patientId, DateTime? createdFrom, DateTime? createdTo, String? FTS, int? page, int? pageSize, bool? includeTotalCount, bool? retrieveAll, }) async {
    final response = await orderGetWithHttpInfo( patientId: patientId, createdFrom: createdFrom, createdTo: createdTo, FTS: FTS, page: page, pageSize: pageSize, includeTotalCount: includeTotalCount, retrieveAll: retrieveAll, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OrderResponsePagedResult',) as OrderResponsePagedResult;
    
    }
    return null;
  }

  /// Performs an HTTP 'DELETE /Order/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> orderIdDeleteWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/Order/{id}'
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
  Future<bool?> orderIdDelete(int id,) async {
    final response = await orderIdDeleteWithHttpInfo(id,);
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

  /// Performs an HTTP 'GET /Order/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> orderIdGetWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/Order/{id}'
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
  Future<OrderResponse?> orderIdGet(int id,) async {
    final response = await orderIdGetWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OrderResponse',) as OrderResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'PUT /Order/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [OrderUpsertRequest] orderUpsertRequest:
  Future<Response> orderIdPutWithHttpInfo(int id, { OrderUpsertRequest? orderUpsertRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Order/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = orderUpsertRequest;

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
  /// * [OrderUpsertRequest] orderUpsertRequest:
  Future<OrderResponse?> orderIdPut(int id, { OrderUpsertRequest? orderUpsertRequest, }) async {
    final response = await orderIdPutWithHttpInfo(id,  orderUpsertRequest: orderUpsertRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OrderResponse',) as OrderResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /Order' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [OrderUpsertRequest] orderUpsertRequest:
  Future<Response> orderPostWithHttpInfo({ OrderUpsertRequest? orderUpsertRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Order';

    // ignore: prefer_final_locals
    Object? postBody = orderUpsertRequest;

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
  /// * [OrderUpsertRequest] orderUpsertRequest:
  Future<OrderResponse?> orderPost({ OrderUpsertRequest? orderUpsertRequest, }) async {
    final response = await orderPostWithHttpInfo( orderUpsertRequest: orderUpsertRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OrderResponse',) as OrderResponse;
    
    }
    return null;
  }
}
