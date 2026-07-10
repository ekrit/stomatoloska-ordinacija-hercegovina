//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PaymentApi {
  PaymentApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /Payment' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] appointmentId:
  ///
  /// * [PaymentStatus] status:
  ///
  /// * [String] method:
  ///
  /// * [String] FTS:
  ///
  /// * [int] page:
  ///
  /// * [int] pageSize:
  ///
  /// * [bool] includeTotalCount:
  Future<Response> paymentGetWithHttpInfo({ int? appointmentId, PaymentStatus? status, String? method, String? FTS, int? page, int? pageSize, bool? includeTotalCount, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Payment';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (appointmentId != null) {
      queryParams.addAll(_queryParams('', 'AppointmentId', appointmentId));
    }
    if (status != null) {
      queryParams.addAll(_queryParams('', 'Status', status));
    }
    if (method != null) {
      queryParams.addAll(_queryParams('', 'Method', method));
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
  /// * [int] appointmentId:
  ///
  /// * [PaymentStatus] status:
  ///
  /// * [String] method:
  ///
  /// * [String] FTS:
  ///
  /// * [int] page:
  ///
  /// * [int] pageSize:
  ///
  /// * [bool] includeTotalCount:
  Future<PaymentResponsePagedResult?> paymentGet({ int? appointmentId, PaymentStatus? status, String? method, String? FTS, int? page, int? pageSize, bool? includeTotalCount, }) async {
    final response = await paymentGetWithHttpInfo( appointmentId: appointmentId, status: status, method: method, FTS: FTS, page: page, pageSize: pageSize, includeTotalCount: includeTotalCount, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PaymentResponsePagedResult',) as PaymentResponsePagedResult;
    
    }
    return null;
  }

  /// Performs an HTTP 'DELETE /Payment/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> paymentIdDeleteWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/Payment/{id}'
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
  Future<bool?> paymentIdDelete(int id,) async {
    final response = await paymentIdDeleteWithHttpInfo(id,);
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

  /// Performs an HTTP 'GET /Payment/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> paymentIdGetWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/Payment/{id}'
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
  Future<PaymentResponse?> paymentIdGet(int id,) async {
    final response = await paymentIdGetWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PaymentResponse',) as PaymentResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'PUT /Payment/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [PaymentUpsertRequest] paymentUpsertRequest:
  Future<Response> paymentIdPutWithHttpInfo(int id, { PaymentUpsertRequest? paymentUpsertRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Payment/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = paymentUpsertRequest;

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
  /// * [PaymentUpsertRequest] paymentUpsertRequest:
  Future<PaymentResponse?> paymentIdPut(int id, { PaymentUpsertRequest? paymentUpsertRequest, }) async {
    final response = await paymentIdPutWithHttpInfo(id,  paymentUpsertRequest: paymentUpsertRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PaymentResponse',) as PaymentResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /Payment/orders/{paymentId}/capture' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] paymentId (required):
  Future<Response> paymentOrdersPaymentIdCapturePostWithHttpInfo(int paymentId,) async {
    // ignore: prefer_const_declarations
    final path = r'/Payment/orders/{paymentId}/capture'
      .replaceAll('{paymentId}', paymentId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


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
  /// * [int] paymentId (required):
  Future<PaymentCaptureResponse?> paymentOrdersPaymentIdCapturePost(int paymentId,) async {
    final response = await paymentOrdersPaymentIdCapturePostWithHttpInfo(paymentId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PaymentCaptureResponse',) as PaymentCaptureResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /Payment/orders' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [PaymentOrderCreateRequest] paymentOrderCreateRequest:
  Future<Response> paymentOrdersPostWithHttpInfo({ PaymentOrderCreateRequest? paymentOrderCreateRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Payment/orders';

    // ignore: prefer_final_locals
    Object? postBody = paymentOrderCreateRequest;

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
  /// * [PaymentOrderCreateRequest] paymentOrderCreateRequest:
  Future<PaymentOrderCreateResponse?> paymentOrdersPost({ PaymentOrderCreateRequest? paymentOrderCreateRequest, }) async {
    final response = await paymentOrdersPostWithHttpInfo( paymentOrderCreateRequest: paymentOrderCreateRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PaymentOrderCreateResponse',) as PaymentOrderCreateResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /Payment/{paymentId}/refund' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] paymentId (required):
  Future<Response> paymentPaymentIdRefundPostWithHttpInfo(int paymentId,) async {
    // ignore: prefer_const_declarations
    final path = r'/Payment/{paymentId}/refund'
      .replaceAll('{paymentId}', paymentId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


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
  /// * [int] paymentId (required):
  Future<void> paymentPaymentIdRefundPost(int paymentId,) async {
    final response = await paymentPaymentIdRefundPostWithHttpInfo(paymentId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'POST /Payment' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [PaymentUpsertRequest] paymentUpsertRequest:
  Future<Response> paymentPostWithHttpInfo({ PaymentUpsertRequest? paymentUpsertRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Payment';

    // ignore: prefer_final_locals
    Object? postBody = paymentUpsertRequest;

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
  /// * [PaymentUpsertRequest] paymentUpsertRequest:
  Future<PaymentResponse?> paymentPost({ PaymentUpsertRequest? paymentUpsertRequest, }) async {
    final response = await paymentPostWithHttpInfo( paymentUpsertRequest: paymentUpsertRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PaymentResponse',) as PaymentResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /Payment/webhook' operation and returns the [Response].
  Future<Response> paymentWebhookPostWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/Payment/webhook';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


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

  Future<void> paymentWebhookPost() async {
    final response = await paymentWebhookPostWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
