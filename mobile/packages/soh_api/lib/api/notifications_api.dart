//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class NotificationsApi {
  NotificationsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /notifications' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] take:
  Future<Response> notificationsGetWithHttpInfo({ int? take, }) async {
    // ignore: prefer_const_declarations
    final path = r'/notifications';

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
  Future<List<UserNotificationResponse>?> notificationsGet({ int? take, }) async {
    final response = await notificationsGetWithHttpInfo( take: take, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<UserNotificationResponse>') as List)
        .cast<UserNotificationResponse>()
        .toList(growable: false);

    }
    return null;
  }

  /// Mark one notification as read. Prefer POST (GET must not be cached by intermediaries).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> notificationsIdReadGetWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/notifications/{id}/read'
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

  /// Mark one notification as read. Prefer POST (GET must not be cached by intermediaries).
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<void> notificationsIdReadGet(int id,) async {
    final response = await notificationsIdReadGetWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Mark one notification as read. Prefer POST (GET must not be cached by intermediaries).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> notificationsIdReadPatchWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/notifications/{id}/read'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Mark one notification as read. Prefer POST (GET must not be cached by intermediaries).
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<void> notificationsIdReadPatch(int id,) async {
    final response = await notificationsIdReadPatchWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Mark one notification as read. Prefer POST (GET must not be cached by intermediaries).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> notificationsIdReadPostWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/notifications/{id}/read'
      .replaceAll('{id}', id.toString());

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

  /// Mark one notification as read. Prefer POST (GET must not be cached by intermediaries).
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<void> notificationsIdReadPost(int id,) async {
    final response = await notificationsIdReadPostWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Mark one notification as read. Prefer POST (GET must not be cached by intermediaries).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> notificationsIdReadPutWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/notifications/{id}/read'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


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

  /// Mark one notification as read. Prefer POST (GET must not be cached by intermediaries).
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<void> notificationsIdReadPut(int id,) async {
    final response = await notificationsIdReadPutWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'GET /notifications/unread-count' operation and returns the [Response].
  Future<Response> notificationsUnreadCountGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/notifications/unread-count';

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

  Future<int?> notificationsUnreadCountGet() async {
    final response = await notificationsUnreadCountGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'int',) as int;
    
    }
    return null;
  }
}
