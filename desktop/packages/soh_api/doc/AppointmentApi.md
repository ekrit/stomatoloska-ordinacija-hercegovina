# soh_api.api.AppointmentApi

## Load the API package
```dart
import 'package:soh_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**appointmentGet**](AppointmentApi.md#appointmentget) | **GET** /Appointment | 
[**appointmentIdCancelPost**](AppointmentApi.md#appointmentidcancelpost) | **POST** /Appointment/{id}/cancel | 
[**appointmentIdDelete**](AppointmentApi.md#appointmentiddelete) | **DELETE** /Appointment/{id} | 
[**appointmentIdGet**](AppointmentApi.md#appointmentidget) | **GET** /Appointment/{id} | 
[**appointmentIdPut**](AppointmentApi.md#appointmentidput) | **PUT** /Appointment/{id} | 
[**appointmentPost**](AppointmentApi.md#appointmentpost) | **POST** /Appointment | 


# **appointmentGet**
> AppointmentResponsePagedResult appointmentGet(patientId, doctorId, serviceId, roomId, status, startFrom, startTo, FTS, page, pageSize, includeTotalCount)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AppointmentApi();
final patientId = 56; // int | 
final doctorId = 56; // int | 
final serviceId = 56; // int | 
final roomId = 56; // int | 
final status = ; // AppointmentStatus | 
final startFrom = 2013-10-20T19:20:30+01:00; // DateTime | 
final startTo = 2013-10-20T19:20:30+01:00; // DateTime | 
final FTS = FTS_example; // String | 
final page = 56; // int | 
final pageSize = 56; // int | 
final includeTotalCount = true; // bool | 

try {
    final result = api_instance.appointmentGet(patientId, doctorId, serviceId, roomId, status, startFrom, startTo, FTS, page, pageSize, includeTotalCount);
    print(result);
} catch (e) {
    print('Exception when calling AppointmentApi->appointmentGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **patientId** | **int**|  | [optional] 
 **doctorId** | **int**|  | [optional] 
 **serviceId** | **int**|  | [optional] 
 **roomId** | **int**|  | [optional] 
 **status** | [**AppointmentStatus**](.md)|  | [optional] 
 **startFrom** | **DateTime**|  | [optional] 
 **startTo** | **DateTime**|  | [optional] 
 **FTS** | **String**|  | [optional] 
 **page** | **int**|  | [optional] 
 **pageSize** | **int**|  | [optional] 
 **includeTotalCount** | **bool**|  | [optional] 

### Return type

[**AppointmentResponsePagedResult**](AppointmentResponsePagedResult.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **appointmentIdCancelPost**
> AppointmentResponse appointmentIdCancelPost(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AppointmentApi();
final id = 56; // int | 

try {
    final result = api_instance.appointmentIdCancelPost(id);
    print(result);
} catch (e) {
    print('Exception when calling AppointmentApi->appointmentIdCancelPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**AppointmentResponse**](AppointmentResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **appointmentIdDelete**
> bool appointmentIdDelete(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AppointmentApi();
final id = 56; // int | 

try {
    final result = api_instance.appointmentIdDelete(id);
    print(result);
} catch (e) {
    print('Exception when calling AppointmentApi->appointmentIdDelete: $e\n');
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

# **appointmentIdGet**
> AppointmentResponse appointmentIdGet(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AppointmentApi();
final id = 56; // int | 

try {
    final result = api_instance.appointmentIdGet(id);
    print(result);
} catch (e) {
    print('Exception when calling AppointmentApi->appointmentIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**AppointmentResponse**](AppointmentResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **appointmentIdPut**
> AppointmentResponse appointmentIdPut(id, appointmentUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AppointmentApi();
final id = 56; // int | 
final appointmentUpsertRequest = AppointmentUpsertRequest(); // AppointmentUpsertRequest | 

try {
    final result = api_instance.appointmentIdPut(id, appointmentUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling AppointmentApi->appointmentIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **appointmentUpsertRequest** | [**AppointmentUpsertRequest**](AppointmentUpsertRequest.md)|  | [optional] 

### Return type

[**AppointmentResponse**](AppointmentResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **appointmentPost**
> AppointmentResponse appointmentPost(appointmentUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AppointmentApi();
final appointmentUpsertRequest = AppointmentUpsertRequest(); // AppointmentUpsertRequest | 

try {
    final result = api_instance.appointmentPost(appointmentUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling AppointmentApi->appointmentPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **appointmentUpsertRequest** | [**AppointmentUpsertRequest**](AppointmentUpsertRequest.md)|  | [optional] 

### Return type

[**AppointmentResponse**](AppointmentResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

