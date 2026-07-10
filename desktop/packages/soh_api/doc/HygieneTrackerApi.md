# soh_api.api.HygieneTrackerApi

## Load the API package
```dart
import 'package:soh_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**hygieneTrackerGet**](HygieneTrackerApi.md#hygienetrackerget) | **GET** /HygieneTracker | 
[**hygieneTrackerIdDelete**](HygieneTrackerApi.md#hygienetrackeriddelete) | **DELETE** /HygieneTracker/{id} | 
[**hygieneTrackerIdGet**](HygieneTrackerApi.md#hygienetrackeridget) | **GET** /HygieneTracker/{id} | 
[**hygieneTrackerIdPut**](HygieneTrackerApi.md#hygienetrackeridput) | **PUT** /HygieneTracker/{id} | 
[**hygieneTrackerPost**](HygieneTrackerApi.md#hygienetrackerpost) | **POST** /HygieneTracker | 


# **hygieneTrackerGet**
> HygieneTrackerResponsePagedResult hygieneTrackerGet(patientId, dateFrom, dateTo, FTS, page, pageSize, includeTotalCount)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = HygieneTrackerApi();
final patientId = 56; // int | 
final dateFrom = 2013-10-20T19:20:30+01:00; // DateTime | 
final dateTo = 2013-10-20T19:20:30+01:00; // DateTime | 
final FTS = FTS_example; // String | 
final page = 56; // int | 
final pageSize = 56; // int | 
final includeTotalCount = true; // bool | 

try {
    final result = api_instance.hygieneTrackerGet(patientId, dateFrom, dateTo, FTS, page, pageSize, includeTotalCount);
    print(result);
} catch (e) {
    print('Exception when calling HygieneTrackerApi->hygieneTrackerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **patientId** | **int**|  | [optional] 
 **dateFrom** | **DateTime**|  | [optional] 
 **dateTo** | **DateTime**|  | [optional] 
 **FTS** | **String**|  | [optional] 
 **page** | **int**|  | [optional] 
 **pageSize** | **int**|  | [optional] 
 **includeTotalCount** | **bool**|  | [optional] 

### Return type

[**HygieneTrackerResponsePagedResult**](HygieneTrackerResponsePagedResult.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **hygieneTrackerIdDelete**
> bool hygieneTrackerIdDelete(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = HygieneTrackerApi();
final id = 56; // int | 

try {
    final result = api_instance.hygieneTrackerIdDelete(id);
    print(result);
} catch (e) {
    print('Exception when calling HygieneTrackerApi->hygieneTrackerIdDelete: $e\n');
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

# **hygieneTrackerIdGet**
> HygieneTrackerResponse hygieneTrackerIdGet(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = HygieneTrackerApi();
final id = 56; // int | 

try {
    final result = api_instance.hygieneTrackerIdGet(id);
    print(result);
} catch (e) {
    print('Exception when calling HygieneTrackerApi->hygieneTrackerIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**HygieneTrackerResponse**](HygieneTrackerResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **hygieneTrackerIdPut**
> HygieneTrackerResponse hygieneTrackerIdPut(id, hygieneTrackerUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = HygieneTrackerApi();
final id = 56; // int | 
final hygieneTrackerUpsertRequest = HygieneTrackerUpsertRequest(); // HygieneTrackerUpsertRequest | 

try {
    final result = api_instance.hygieneTrackerIdPut(id, hygieneTrackerUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling HygieneTrackerApi->hygieneTrackerIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **hygieneTrackerUpsertRequest** | [**HygieneTrackerUpsertRequest**](HygieneTrackerUpsertRequest.md)|  | [optional] 

### Return type

[**HygieneTrackerResponse**](HygieneTrackerResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **hygieneTrackerPost**
> HygieneTrackerResponse hygieneTrackerPost(hygieneTrackerUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = HygieneTrackerApi();
final hygieneTrackerUpsertRequest = HygieneTrackerUpsertRequest(); // HygieneTrackerUpsertRequest | 

try {
    final result = api_instance.hygieneTrackerPost(hygieneTrackerUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling HygieneTrackerApi->hygieneTrackerPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **hygieneTrackerUpsertRequest** | [**HygieneTrackerUpsertRequest**](HygieneTrackerUpsertRequest.md)|  | [optional] 

### Return type

[**HygieneTrackerResponse**](HygieneTrackerResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

