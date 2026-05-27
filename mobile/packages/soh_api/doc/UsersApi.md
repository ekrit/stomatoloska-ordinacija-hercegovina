# soh_api.api.UsersApi

## Load the API package
```dart
import 'package:soh_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**usersAuthenticatePost**](UsersApi.md#usersauthenticatepost) | **POST** /Users/authenticate | 
[**usersGet**](UsersApi.md#usersget) | **GET** /Users | 
[**usersIdDelete**](UsersApi.md#usersiddelete) | **DELETE** /Users/{id} | 
[**usersIdGet**](UsersApi.md#usersidget) | **GET** /Users/{id} | 
[**usersIdPut**](UsersApi.md#usersidput) | **PUT** /Users/{id} | 
[**usersPost**](UsersApi.md#userspost) | **POST** /Users | 
[**usersRegisterPost**](UsersApi.md#usersregisterpost) | **POST** /Users/register | 


# **usersAuthenticatePost**
> AuthResponse usersAuthenticatePost(userLoginRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UsersApi();
final userLoginRequest = UserLoginRequest(); // UserLoginRequest | 

try {
    final result = api_instance.usersAuthenticatePost(userLoginRequest);
    print(result);
} catch (e) {
    print('Exception when calling UsersApi->usersAuthenticatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userLoginRequest** | [**UserLoginRequest**](UserLoginRequest.md)|  | [optional] 

### Return type

[**AuthResponse**](AuthResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersGet**
> UserResponsePagedResult usersGet(username, email, genderId, cityId, roleId, FTS, page, pageSize, includeTotalCount, retrieveAll)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UsersApi();
final username = username_example; // String | 
final email = email_example; // String | 
final genderId = 56; // int | 
final cityId = 56; // int | 
final roleId = 56; // int | 
final FTS = FTS_example; // String | 
final page = 56; // int | 
final pageSize = 56; // int | 
final includeTotalCount = true; // bool | 
final retrieveAll = true; // bool | 

try {
    final result = api_instance.usersGet(username, email, genderId, cityId, roleId, FTS, page, pageSize, includeTotalCount, retrieveAll);
    print(result);
} catch (e) {
    print('Exception when calling UsersApi->usersGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **username** | **String**|  | [optional] 
 **email** | **String**|  | [optional] 
 **genderId** | **int**|  | [optional] 
 **cityId** | **int**|  | [optional] 
 **roleId** | **int**|  | [optional] 
 **FTS** | **String**|  | [optional] 
 **page** | **int**|  | [optional] 
 **pageSize** | **int**|  | [optional] 
 **includeTotalCount** | **bool**|  | [optional] 
 **retrieveAll** | **bool**|  | [optional] 

### Return type

[**UserResponsePagedResult**](UserResponsePagedResult.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersIdDelete**
> usersIdDelete(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UsersApi();
final id = 56; // int | 

try {
    api_instance.usersIdDelete(id);
} catch (e) {
    print('Exception when calling UsersApi->usersIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersIdGet**
> UserResponse usersIdGet(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UsersApi();
final id = 56; // int | 

try {
    final result = api_instance.usersIdGet(id);
    print(result);
} catch (e) {
    print('Exception when calling UsersApi->usersIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersIdPut**
> UserResponse usersIdPut(id, userUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UsersApi();
final id = 56; // int | 
final userUpsertRequest = UserUpsertRequest(); // UserUpsertRequest | 

try {
    final result = api_instance.usersIdPut(id, userUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling UsersApi->usersIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **userUpsertRequest** | [**UserUpsertRequest**](UserUpsertRequest.md)|  | [optional] 

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersPost**
> UserResponse usersPost(userUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UsersApi();
final userUpsertRequest = UserUpsertRequest(); // UserUpsertRequest | 

try {
    final result = api_instance.usersPost(userUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling UsersApi->usersPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userUpsertRequest** | [**UserUpsertRequest**](UserUpsertRequest.md)|  | [optional] 

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersRegisterPost**
> UserResponse usersRegisterPost(userRegisterRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UsersApi();
final userRegisterRequest = UserRegisterRequest(); // UserRegisterRequest | 

try {
    final result = api_instance.usersRegisterPost(userRegisterRequest);
    print(result);
} catch (e) {
    print('Exception when calling UsersApi->usersRegisterPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userRegisterRequest** | [**UserRegisterRequest**](UserRegisterRequest.md)|  | [optional] 

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

