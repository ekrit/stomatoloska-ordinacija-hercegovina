# soh_api.api.DoctorApi

## Load the API package
```dart
import 'package:soh_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**doctorGet**](DoctorApi.md#doctorget) | **GET** /Doctor | 
[**doctorIdDelete**](DoctorApi.md#doctoriddelete) | **DELETE** /Doctor/{id} | 
[**doctorIdGet**](DoctorApi.md#doctoridget) | **GET** /Doctor/{id} | 
[**doctorIdPut**](DoctorApi.md#doctoridput) | **PUT** /Doctor/{id} | 
[**doctorPost**](DoctorApi.md#doctorpost) | **POST** /Doctor | 


# **doctorGet**
> DoctorResponsePagedResult doctorGet(userId, firstName, lastName, specialization, FTS, page, pageSize, includeTotalCount)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DoctorApi();
final userId = 56; // int | 
final firstName = firstName_example; // String | 
final lastName = lastName_example; // String | 
final specialization = specialization_example; // String | 
final FTS = FTS_example; // String | 
final page = 56; // int | 
final pageSize = 56; // int | 
final includeTotalCount = true; // bool | 

try {
    final result = api_instance.doctorGet(userId, firstName, lastName, specialization, FTS, page, pageSize, includeTotalCount);
    print(result);
} catch (e) {
    print('Exception when calling DoctorApi->doctorGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **int**|  | [optional] 
 **firstName** | **String**|  | [optional] 
 **lastName** | **String**|  | [optional] 
 **specialization** | **String**|  | [optional] 
 **FTS** | **String**|  | [optional] 
 **page** | **int**|  | [optional] 
 **pageSize** | **int**|  | [optional] 
 **includeTotalCount** | **bool**|  | [optional] 

### Return type

[**DoctorResponsePagedResult**](DoctorResponsePagedResult.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **doctorIdDelete**
> bool doctorIdDelete(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DoctorApi();
final id = 56; // int | 

try {
    final result = api_instance.doctorIdDelete(id);
    print(result);
} catch (e) {
    print('Exception when calling DoctorApi->doctorIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

**bool**

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **doctorIdGet**
> DoctorResponse doctorIdGet(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DoctorApi();
final id = 56; // int | 

try {
    final result = api_instance.doctorIdGet(id);
    print(result);
} catch (e) {
    print('Exception when calling DoctorApi->doctorIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**DoctorResponse**](DoctorResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **doctorIdPut**
> DoctorResponse doctorIdPut(id, doctorUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DoctorApi();
final id = 56; // int | 
final doctorUpsertRequest = DoctorUpsertRequest(); // DoctorUpsertRequest | 

try {
    final result = api_instance.doctorIdPut(id, doctorUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling DoctorApi->doctorIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **doctorUpsertRequest** | [**DoctorUpsertRequest**](DoctorUpsertRequest.md)|  | [optional] 

### Return type

[**DoctorResponse**](DoctorResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **doctorPost**
> DoctorResponse doctorPost(doctorUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DoctorApi();
final doctorUpsertRequest = DoctorUpsertRequest(); // DoctorUpsertRequest | 

try {
    final result = api_instance.doctorPost(doctorUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling DoctorApi->doctorPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **doctorUpsertRequest** | [**DoctorUpsertRequest**](DoctorUpsertRequest.md)|  | [optional] 

### Return type

[**DoctorResponse**](DoctorResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

