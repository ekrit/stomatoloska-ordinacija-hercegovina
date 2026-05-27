# soh_api.api.DoctorNoteApi

## Load the API package
```dart
import 'package:soh_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**doctorNoteGet**](DoctorNoteApi.md#doctornoteget) | **GET** /DoctorNote | 
[**doctorNoteIdDelete**](DoctorNoteApi.md#doctornoteiddelete) | **DELETE** /DoctorNote/{id} | 
[**doctorNoteIdGet**](DoctorNoteApi.md#doctornoteidget) | **GET** /DoctorNote/{id} | 
[**doctorNoteIdPut**](DoctorNoteApi.md#doctornoteidput) | **PUT** /DoctorNote/{id} | 
[**doctorNotePost**](DoctorNoteApi.md#doctornotepost) | **POST** /DoctorNote | 


# **doctorNoteGet**
> DoctorNoteResponsePagedResult doctorNoteGet(appointmentId, FTS, page, pageSize, includeTotalCount, retrieveAll)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DoctorNoteApi();
final appointmentId = 56; // int | 
final FTS = FTS_example; // String | 
final page = 56; // int | 
final pageSize = 56; // int | 
final includeTotalCount = true; // bool | 
final retrieveAll = true; // bool | 

try {
    final result = api_instance.doctorNoteGet(appointmentId, FTS, page, pageSize, includeTotalCount, retrieveAll);
    print(result);
} catch (e) {
    print('Exception when calling DoctorNoteApi->doctorNoteGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **appointmentId** | **int**|  | [optional] 
 **FTS** | **String**|  | [optional] 
 **page** | **int**|  | [optional] 
 **pageSize** | **int**|  | [optional] 
 **includeTotalCount** | **bool**|  | [optional] 
 **retrieveAll** | **bool**|  | [optional] 

### Return type

[**DoctorNoteResponsePagedResult**](DoctorNoteResponsePagedResult.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **doctorNoteIdDelete**
> bool doctorNoteIdDelete(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DoctorNoteApi();
final id = 56; // int | 

try {
    final result = api_instance.doctorNoteIdDelete(id);
    print(result);
} catch (e) {
    print('Exception when calling DoctorNoteApi->doctorNoteIdDelete: $e\n');
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

# **doctorNoteIdGet**
> DoctorNoteResponse doctorNoteIdGet(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DoctorNoteApi();
final id = 56; // int | 

try {
    final result = api_instance.doctorNoteIdGet(id);
    print(result);
} catch (e) {
    print('Exception when calling DoctorNoteApi->doctorNoteIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**DoctorNoteResponse**](DoctorNoteResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **doctorNoteIdPut**
> DoctorNoteResponse doctorNoteIdPut(id, doctorNoteUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DoctorNoteApi();
final id = 56; // int | 
final doctorNoteUpsertRequest = DoctorNoteUpsertRequest(); // DoctorNoteUpsertRequest | 

try {
    final result = api_instance.doctorNoteIdPut(id, doctorNoteUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling DoctorNoteApi->doctorNoteIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **doctorNoteUpsertRequest** | [**DoctorNoteUpsertRequest**](DoctorNoteUpsertRequest.md)|  | [optional] 

### Return type

[**DoctorNoteResponse**](DoctorNoteResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **doctorNotePost**
> DoctorNoteResponse doctorNotePost(doctorNoteUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DoctorNoteApi();
final doctorNoteUpsertRequest = DoctorNoteUpsertRequest(); // DoctorNoteUpsertRequest | 

try {
    final result = api_instance.doctorNotePost(doctorNoteUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling DoctorNoteApi->doctorNotePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **doctorNoteUpsertRequest** | [**DoctorNoteUpsertRequest**](DoctorNoteUpsertRequest.md)|  | [optional] 

### Return type

[**DoctorNoteResponse**](DoctorNoteResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

