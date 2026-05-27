//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class OrderItemApi {
  OrderItemApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /OrderItem' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] orderId:
  ///
  /// * [int] productId:
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
  Future<Response> orderItemGetWithHttpInfo({ int? orderId, int? productId, String? FTS, int? page, int? pageSize, bool? includeTotalCount, bool? retrieveAll, }) async {
    // ignore: prefer_const_declarations
    final path = r'/OrderItem';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (orderId != null) {
      queryParams.addAll(_queryParams('', 'OrderId', orderId));
    }
    if (productId != null) {
      queryParams.addAll(_queryParams('', 'ProductId', productId));
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
  /// * [int] orderId:
  ///
  /// * [int] productId:
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
  Future<OrderItemResponsePagedResult?> orderItemGet({ int? orderId, int? productId, String? FTS, int? page, int? pageSize, bool? includeTotalCount, bool? retrieveAll, }) async {
    final response = await orderItemGetWithHttpInfo( orderId: orderId, productId: productId, FTS: FTS, page: page, pageSize: pageSize, includeTotalCount: includeTotalCount, retrieveAll: retrieveAll, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OrderItemResponsePagedResult',) as OrderItemResponsePagedResult;
    
    }
    return null;
  }

  /// Performs an HTTP 'DELETE /OrderItem/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> orderItemIdDeleteWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/OrderItem/{id}'
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
  Future<bool?> orderItemIdDelete(int id,) async {
    final response = await orderItemIdDeleteWithHttpInfo(id,);
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

  /// Performs an HTTP 'GET /OrderItem/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> orderItemIdGetWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/OrderItem/{id}'
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
  Future<OrderItemResponse?> orderItemIdGet(int id,) async {
    final response = await orderItemIdGetWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OrderItemResponse',) as OrderItemResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'PUT /OrderItem/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [OrderItemUpsertRequest] orderItemUpsertRequest:
  Future<Response> orderItemIdPutWithHttpInfo(int id, { OrderItemUpsertRequest? orderItemUpsertRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/OrderItem/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = orderItemUpsertRequest;

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
  /// * [OrderItemUpsertRequest] orderItemUpsertRequest:
  Future<OrderItemResponse?> orderItemIdPut(int id, { OrderItemUpsertRequest? orderItemUpsertRequest, }) async {
    final response = await orderItemIdPutWithHttpInfo(id,  orderItemUpsertRequest: orderItemUpsertRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OrderItemResponse',) as OrderItemResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /OrderItem' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [OrderItemUpsertRequest] orderItemUpsertRequest:
  Future<Response> orderItemPostWithHttpInfo({ OrderItemUpsertRequest? orderItemUpsertRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/OrderItem';

    // ignore: prefer_final_locals
    Object? postBody = orderItemUpsertRequest;

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
  /// * [OrderItemUpsertRequest] orderItemUpsertRequest:
  Future<OrderItemResponse?> orderItemPost({ OrderItemUpsertRequest? orderItemUpsertRequest, }) async {
    final response = await orderItemPostWithHttpInfo( orderItemUpsertRequest: orderItemUpsertRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OrderItemResponse',) as OrderItemResponse;
    
    }
    return null;
  }
}
