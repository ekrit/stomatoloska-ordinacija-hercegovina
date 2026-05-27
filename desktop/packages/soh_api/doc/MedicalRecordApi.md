# soh_api.api.MedicalRecordApi

## Load the API package
```dart
import 'package:soh_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**medicalRecordGet**](MedicalRecordApi.md#medicalrecordget) | **GET** /MedicalRecord | 
[**medicalRecordIdDelete**](MedicalRecordApi.md#medicalrecordiddelete) | **DELETE** /MedicalRecord/{id} | 
[**medicalRecordIdGet**](MedicalRecordApi.md#medicalrecordidget) | **GET** /MedicalRecord/{id} | 
[**medicalRecordIdPut**](MedicalRecordApi.md#medicalrecordidput) | **PUT** /MedicalRecord/{id} | 
[**medicalRecordPost**](MedicalRecordApi.md#medicalrecordpost) | **POST** /MedicalRecord | 


# **medicalRecordGet**
> MedicalRecordResponsePagedResult medicalRecordGet(appointmentId, FTS, page, pageSize, includeTotalCount, retrieveAll)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = MedicalRecordApi();
final appointmentId = 56; // int | 
final FTS = FTS_example; // String | 
final page = 56; // int | 
final pageSize = 56; // int | 
final includeTotalCount = true; // bool | 
final retrieveAll = true; // bool | 

try {
    final result = api_instance.medicalRecordGet(appointmentId, FTS, page, pageSize, includeTotalCount, retrieveAll);
    print(result);
} catch (e) {
    print('Exception when calling MedicalRecordApi->medicalRecordGet: $e\n');
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

[**MedicalRecordResponsePagedResult**](MedicalRecordResponsePagedResult.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **medicalRecordIdDelete**
> bool medicalRecordIdDelete(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = MedicalRecordApi();
final id = 56; // int | 

try {
    final result = api_instance.medicalRecordIdDelete(id);
    print(result);
} catch (e) {
    print('Exception when calling MedicalRecordApi->medicalRecordIdDelete: $e\n');
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

# **medicalRecordIdGet**
> MedicalRecordResponse medicalRecordIdGet(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = MedicalRecordApi();
final id = 56; // int | 

try {
    final result = api_instance.medicalRecordIdGet(id);
    print(result);
} catch (e) {
    print('Exception when calling MedicalRecordApi->medicalRecordIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**MedicalRecordResponse**](MedicalRecordResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **medicalRecordIdPut**
> MedicalRecordResponse medicalRecordIdPut(id, medicalRecordUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = MedicalRecordApi();
final id = 56; // int | 
final medicalRecordUpsertRequest = MedicalRecordUpsertRequest(); // MedicalRecordUpsertRequest | 

try {
    final result = api_instance.medicalRecordIdPut(id, medicalRecordUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling MedicalRecordApi->medicalRecordIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **medicalRecordUpsertRequest** | [**MedicalRecordUpsertRequest**](MedicalRecordUpsertRequest.md)|  | [optional] 

### Return type

[**MedicalRecordResponse**](MedicalRecordResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **medicalRecordPost**
> MedicalRecordResponse medicalRecordPost(medicalRecordUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = MedicalRecordApi();
final medicalRecordUpsertRequest = MedicalRecordUpsertRequest(); // MedicalRecordUpsertRequest | 

try {
    final result = api_instance.medicalRecordPost(medicalRecordUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling MedicalRecordApi->medicalRecordPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **medicalRecordUpsertRequest** | [**MedicalRecordUpsertRequest**](MedicalRecordUpsertRequest.md)|  | [optional] 

### Return type

[**MedicalRecordResponse**](MedicalRecordResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

