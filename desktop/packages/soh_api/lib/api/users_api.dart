//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class UsersApi {
  UsersApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'POST /Users/authenticate' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [UserLoginRequest] userLoginRequest:
  Future<Response> usersAuthenticatePostWithHttpInfo({ UserLoginRequest? userLoginRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Users/authenticate';

    // ignore: prefer_final_locals
    Object? postBody = userLoginRequest;

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
  /// * [UserLoginRequest] userLoginRequest:
  Future<AuthResponse?> usersAuthenticatePost({ UserLoginRequest? userLoginRequest, }) async {
    final response = await usersAuthenticatePostWithHttpInfo( userLoginRequest: userLoginRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AuthResponse',) as AuthResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /Users' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] username:
  ///
  /// * [String] email:
  ///
  /// * [int] genderId:
  ///
  /// * [int] cityId:
  ///
  /// * [int] roleId:
  ///
  /// * [String] FTS:
  ///
  /// * [int] page:
  ///
  /// * [int] pageSize:
  ///
  /// * [bool] includeTotalCount:
  Future<Response> usersGetWithHttpInfo({ String? username, String? email, int? genderId, int? cityId, int? roleId, String? FTS, int? page, int? pageSize, bool? includeTotalCount, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Users';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (username != null) {
      queryParams.addAll(_queryParams('', 'Username', username));
    }
    if (email != null) {
      queryParams.addAll(_queryParams('', 'Email', email));
    }
    if (genderId != null) {
      queryParams.addAll(_queryParams('', 'GenderId', genderId));
    }
    if (cityId != null) {
      queryParams.addAll(_queryParams('', 'CityId', cityId));
    }
    if (roleId != null) {
      queryParams.addAll(_queryParams('', 'RoleId', roleId));
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
  /// * [String] username:
  ///
  /// * [String] email:
  ///
  /// * [int] genderId:
  ///
  /// * [int] cityId:
  ///
  /// * [int] roleId:
  ///
  /// * [String] FTS:
  ///
  /// * [int] page:
  ///
  /// * [int] pageSize:
  ///
  /// * [bool] includeTotalCount:
  Future<UserResponsePagedResult?> usersGet({ String? username, String? email, int? genderId, int? cityId, int? roleId, String? FTS, int? page, int? pageSize, bool? includeTotalCount, }) async {
    final response = await usersGetWithHttpInfo( username: username, email: email, genderId: genderId, cityId: cityId, roleId: roleId, FTS: FTS, page: page, pageSize: pageSize, includeTotalCount: includeTotalCount, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UserResponsePagedResult',) as UserResponsePagedResult;
    
    }
    return null;
  }

  /// Self-service password change. The caller must be the user in the  route and must supply the current password. Admins change other  users' passwords via PUT /Users/{id} (no old password needed).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [ChangePasswordRequest] changePasswordRequest:
  Future<Response> usersIdChangePasswordPostWithHttpInfo(int id, { ChangePasswordRequest? changePasswordRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Users/{id}/change-password'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = changePasswordRequest;

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

  /// Self-service password change. The caller must be the user in the  route and must supply the current password. Admins change other  users' passwords via PUT /Users/{id} (no old password needed).
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [ChangePasswordRequest] changePasswordRequest:
  Future<void> usersIdChangePasswordPost(int id, { ChangePasswordRequest? changePasswordRequest, }) async {
    final response = await usersIdChangePasswordPostWithHttpInfo(id,  changePasswordRequest: changePasswordRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'DELETE /Users/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> usersIdDeleteWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/Users/{id}'
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
  Future<void> usersIdDelete(int id,) async {
    final response = await usersIdDeleteWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'GET /Users/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> usersIdGetWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/Users/{id}'
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
  Future<UserResponse?> usersIdGet(int id,) async {
    final response = await usersIdGetWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UserResponse',) as UserResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'PUT /Users/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [UserUpsertRequest] userUpsertRequest:
  Future<Response> usersIdPutWithHttpInfo(int id, { UserUpsertRequest? userUpsertRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Users/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = userUpsertRequest;

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
  /// * [UserUpsertRequest] userUpsertRequest:
  Future<UserResponse?> usersIdPut(int id, { UserUpsertRequest? userUpsertRequest, }) async {
    final response = await usersIdPutWithHttpInfo(id,  userUpsertRequest: userUpsertRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UserResponse',) as UserResponse;
    
    }
    return null;
  }

  /// Server-side logout. Records this token's jti in the revocation store  so any subsequent request that presents the same JWT (e.g. a stolen  or shared device) is rejected even before its natural expiry.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> usersLogoutPostWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/Users/logout';

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

  /// Server-side logout. Records this token's jti in the revocation store  so any subsequent request that presents the same JWT (e.g. a stolen  or shared device) is rejected even before its natural expiry.
  Future<void> usersLogoutPost() async {
    final response = await usersLogoutPostWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'POST /Users' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [UserUpsertRequest] userUpsertRequest:
  Future<Response> usersPostWithHttpInfo({ UserUpsertRequest? userUpsertRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Users';

    // ignore: prefer_final_locals
    Object? postBody = userUpsertRequest;

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
  /// * [UserUpsertRequest] userUpsertRequest:
  Future<UserResponse?> usersPost({ UserUpsertRequest? userUpsertRequest, }) async {
    final response = await usersPostWithHttpInfo( userUpsertRequest: userUpsertRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UserResponse',) as UserResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /Users/register' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [UserRegisterRequest] userRegisterRequest:
  Future<Response> usersRegisterPostWithHttpInfo({ UserRegisterRequest? userRegisterRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/Users/register';

    // ignore: prefer_final_locals
    Object? postBody = userRegisterRequest;

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
  /// * [UserRegisterRequest] userRegisterRequest:
  Future<UserResponse?> usersRegisterPost({ UserRegisterRequest? userRegisterRequest, }) async {
    final response = await usersRegisterPostWithHttpInfo( userRegisterRequest: userRegisterRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UserResponse',) as UserResponse;
    
    }
    return null;
  }
}
