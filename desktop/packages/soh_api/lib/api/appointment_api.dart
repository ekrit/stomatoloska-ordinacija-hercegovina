//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AppointmentApi {
  AppointmentApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /Appointment' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] patientId:
  ///
  /// * [int] doctorId:
  ///
  /// * [int] serviceId:
  ///
  /// * [int] roomId:
  ///
  /// * [AppointmentStatus] status:
  ///
  /// * [DateTime] startFrom:
  ///
  /// * [DateTime] startTo:
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
  Future<Response> appointmentGetWithHttpInfo({ int? patientId, int? doctorId, int? serviceId, int? roomId, AppointmentStatus? status, DateTime? startFrom, DateTime? startTo, String? FTS, int? page, int? pageSize, bool? includeTotalCount, bool? retrieveAll, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Appointment';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (patientId != null) {
      queryParams.addAll(_queryParams('', 'PatientId', patientId));
    }
    if (doctorId != null) {
      queryParams.addAll(_queryParams('', 'DoctorId', doctorId));
    }
    if (serviceId != null) {
      queryParams.addAll(_queryParams('', 'ServiceId', serviceId));
    }
    if (roomId != null) {
      queryParams.addAll(_queryParams('', 'RoomId', roomId));
    }
    if (status != null) {
      queryParams.addAll(_queryParams('', 'Status', status));
    }
    if (startFrom != null) {
      queryParams.addAll(_queryParams('', 'StartFrom', startFrom));
    }
    if (startTo != null) {
      queryParams.addAll(_queryParams('', 'StartTo', startTo));
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
  /// * [int] doctorId:
  ///
  /// * [int] serviceId:
  ///
  /// * [int] roomId:
  ///
  /// * [AppointmentStatus] status:
  ///
  /// * [DateTime] startFrom:
  ///
  /// * [DateTime] startTo:
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
  Future<AppointmentResponsePagedResult?> appointmentGet({ int? patientId, int? doctorId, int? serviceId, int? roomId, AppointmentStatus? status, DateTime? startFrom, DateTime? startTo, String? FTS, int? page, int? pageSize, bool? includeTotalCount, bool? retrieveAll, }) async {
    final response = await appointmentGetWithHttpInfo( patientId: patientId, doctorId: doctorId, serviceId: serviceId, roomId: roomId, status: status, startFrom: startFrom, startTo: startTo, FTS: FTS, page: page, pageSize: pageSize, includeTotalCount: includeTotalCount, retrieveAll: retrieveAll, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AppointmentResponsePagedResult',) as AppointmentResponsePagedResult;
    
    }
    return null;
  }

  /// Performs an HTTP 'DELETE /Appointment/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> appointmentIdDeleteWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/Appointment/{id}'
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
  Future<bool?> appointmentIdDelete(int id,) async {
    final response = await appointmentIdDeleteWithHttpInfo(id,);
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

  /// Performs an HTTP 'GET /Appointment/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> appointmentIdGetWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/Appointment/{id}'
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
  Future<AppointmentResponse?> appointmentIdGet(int id,) async {
    final response = await appointmentIdGetWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AppointmentResponse',) as AppointmentResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'PUT /Appointment/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [AppointmentUpsertRequest] appointmentUpsertRequest:
  Future<Response> appointmentIdPutWithHttpInfo(int id, { AppointmentUpsertRequest? appointmentUpsertRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Appointment/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = appointmentUpsertRequest;

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
  /// * [AppointmentUpsertRequest] appointmentUpsertRequest:
  Future<AppointmentResponse?> appointmentIdPut(int id, { AppointmentUpsertRequest? appointmentUpsertRequest, }) async {
    final response = await appointmentIdPutWithHttpInfo(id,  appointmentUpsertRequest: appointmentUpsertRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AppointmentResponse',) as AppointmentResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /Appointment' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [AppointmentUpsertRequest] appointmentUpsertRequest:
  Future<Response> appointmentPostWithHttpInfo({ AppointmentUpsertRequest? appointmentUpsertRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Appointment';

    // ignore: prefer_final_locals
    Object? postBody = appointmentUpsertRequest;

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
  /// * [AppointmentUpsertRequest] appointmentUpsertRequest:
  Future<AppointmentResponse?> appointmentPost({ AppointmentUpsertRequest? appointmentUpsertRequest, }) async {
    final response = await appointmentPostWithHttpInfo( appointmentUpsertRequest: appointmentUpsertRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AppointmentResponse',) as AppointmentResponse;
    
    }
    return null;
  }
}
