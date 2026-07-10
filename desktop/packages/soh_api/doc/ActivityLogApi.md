# soh_api.api.ActivityLogApi

## Load the API package
```dart
import 'package:soh_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**activityLogGet**](ActivityLogApi.md#activitylogget) | **GET** /ActivityLog | 
[**activityLogIdDelete**](ActivityLogApi.md#activitylogiddelete) | **DELETE** /ActivityLog/{id} | 
[**activityLogIdGet**](ActivityLogApi.md#activitylogidget) | **GET** /ActivityLog/{id} | 
[**activityLogIdPut**](ActivityLogApi.md#activitylogidput) | **PUT** /ActivityLog/{id} | 
[**activityLogPost**](ActivityLogApi.md#activitylogpost) | **POST** /ActivityLog | 


# **activityLogGet**
> ActivityLogResponsePagedResult activityLogGet(action, entityName, entityId, createdFrom, createdTo, FTS, page, pageSize, includeTotalCount)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ActivityLogApi();
final action = action_example; // String | 
final entityName = entityName_example; // String | 
final entityId = entityId_example; // String | 
final createdFrom = 2013-10-20T19:20:30+01:00; // DateTime | 
final createdTo = 2013-10-20T19:20:30+01:00; // DateTime | 
final FTS = FTS_example; // String | 
final page = 56; // int | 
final pageSize = 56; // int | 
final includeTotalCount = true; // bool | 

try {
    final result = api_instance.activityLogGet(action, entityName, entityId, createdFrom, createdTo, FTS, page, pageSize, includeTotalCount);
    print(result);
} catch (e) {
    print('Exception when calling ActivityLogApi->activityLogGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **action** | **String**|  | [optional] 
 **entityName** | **String**|  | [optional] 
 **entityId** | **String**|  | [optional] 
 **createdFrom** | **DateTime**|  | [optional] 
 **createdTo** | **DateTime**|  | [optional] 
 **FTS** | **String**|  | [optional] 
 **page** | **int**|  | [optional] 
 **pageSize** | **int**|  | [optional] 
 **includeTotalCount** | **bool**|  | [optional] 

### Return type

[**ActivityLogResponsePagedResult**](ActivityLogResponsePagedResult.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **activityLogIdDelete**
> bool activityLogIdDelete(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ActivityLogApi();
final id = 56; // int | 

try {
    final result = api_instance.activityLogIdDelete(id);
    print(result);
} catch (e) {
    print('Exception when calling ActivityLogApi->activityLogIdDelete: $e\n');
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

# **activityLogIdGet**
> ActivityLogResponse activityLogIdGet(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ActivityLogApi();
final id = 56; // int | 

try {
    final result = api_instance.activityLogIdGet(id);
    print(result);
} catch (e) {
    print('Exception when calling ActivityLogApi->activityLogIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ActivityLogResponse**](ActivityLogResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **activityLogIdPut**
> ActivityLogResponse activityLogIdPut(id, activityLogUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ActivityLogApi();
final id = 56; // int | 
final activityLogUpsertRequest = ActivityLogUpsertRequest(); // ActivityLogUpsertRequest | 

try {
    final result = api_instance.activityLogIdPut(id, activityLogUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling ActivityLogApi->activityLogIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **activityLogUpsertRequest** | [**ActivityLogUpsertRequest**](ActivityLogUpsertRequest.md)|  | [optional] 

### Return type

[**ActivityLogResponse**](ActivityLogResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **activityLogPost**
> ActivityLogResponse activityLogPost(activityLogUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ActivityLogApi();
final activityLogUpsertRequest = ActivityLogUpsertRequest(); // ActivityLogUpsertRequest | 

try {
    final result = api_instance.activityLogPost(activityLogUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling ActivityLogApi->activityLogPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **activityLogUpsertRequest** | [**ActivityLogUpsertRequest**](ActivityLogUpsertRequest.md)|  | [optional] 

### Return type

[**ActivityLogResponse**](ActivityLogResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

