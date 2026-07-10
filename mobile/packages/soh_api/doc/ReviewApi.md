# soh_api.api.ReviewApi

## Load the API package
```dart
import 'package:soh_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**reviewGet**](ReviewApi.md#reviewget) | **GET** /Review | 
[**reviewIdDelete**](ReviewApi.md#reviewiddelete) | **DELETE** /Review/{id} | 
[**reviewIdGet**](ReviewApi.md#reviewidget) | **GET** /Review/{id} | 
[**reviewIdPut**](ReviewApi.md#reviewidput) | **PUT** /Review/{id} | 
[**reviewPost**](ReviewApi.md#reviewpost) | **POST** /Review | 


# **reviewGet**
> ReviewResponsePagedResult reviewGet(appointmentId, patientId, doctorId, rating, FTS, page, pageSize, includeTotalCount)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ReviewApi();
final appointmentId = 56; // int | 
final patientId = 56; // int | 
final doctorId = 56; // int | 
final rating = 56; // int | 
final FTS = FTS_example; // String | 
final page = 56; // int | 
final pageSize = 56; // int | 
final includeTotalCount = true; // bool | 

try {
    final result = api_instance.reviewGet(appointmentId, patientId, doctorId, rating, FTS, page, pageSize, includeTotalCount);
    print(result);
} catch (e) {
    print('Exception when calling ReviewApi->reviewGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **appointmentId** | **int**|  | [optional] 
 **patientId** | **int**|  | [optional] 
 **doctorId** | **int**|  | [optional] 
 **rating** | **int**|  | [optional] 
 **FTS** | **String**|  | [optional] 
 **page** | **int**|  | [optional] 
 **pageSize** | **int**|  | [optional] 
 **includeTotalCount** | **bool**|  | [optional] 

### Return type

[**ReviewResponsePagedResult**](ReviewResponsePagedResult.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reviewIdDelete**
> bool reviewIdDelete(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ReviewApi();
final id = 56; // int | 

try {
    final result = api_instance.reviewIdDelete(id);
    print(result);
} catch (e) {
    print('Exception when calling ReviewApi->reviewIdDelete: $e\n');
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

# **reviewIdGet**
> ReviewResponse reviewIdGet(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ReviewApi();
final id = 56; // int | 

try {
    final result = api_instance.reviewIdGet(id);
    print(result);
} catch (e) {
    print('Exception when calling ReviewApi->reviewIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ReviewResponse**](ReviewResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reviewIdPut**
> ReviewResponse reviewIdPut(id, reviewUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ReviewApi();
final id = 56; // int | 
final reviewUpsertRequest = ReviewUpsertRequest(); // ReviewUpsertRequest | 

try {
    final result = api_instance.reviewIdPut(id, reviewUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling ReviewApi->reviewIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **reviewUpsertRequest** | [**ReviewUpsertRequest**](ReviewUpsertRequest.md)|  | [optional] 

### Return type

[**ReviewResponse**](ReviewResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reviewPost**
> ReviewResponse reviewPost(reviewUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ReviewApi();
final reviewUpsertRequest = ReviewUpsertRequest(); // ReviewUpsertRequest | 

try {
    final result = api_instance.reviewPost(reviewUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling ReviewApi->reviewPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reviewUpsertRequest** | [**ReviewUpsertRequest**](ReviewUpsertRequest.md)|  | [optional] 

### Return type

[**ReviewResponse**](ReviewResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

