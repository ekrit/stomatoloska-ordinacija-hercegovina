# soh_api.api.PaymentApi

## Load the API package
```dart
import 'package:soh_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**paymentGet**](PaymentApi.md#paymentget) | **GET** /Payment | 
[**paymentIdDelete**](PaymentApi.md#paymentiddelete) | **DELETE** /Payment/{id} | 
[**paymentIdGet**](PaymentApi.md#paymentidget) | **GET** /Payment/{id} | 
[**paymentIdPut**](PaymentApi.md#paymentidput) | **PUT** /Payment/{id} | 
[**paymentPost**](PaymentApi.md#paymentpost) | **POST** /Payment | 


# **paymentGet**
> PaymentResponsePagedResult paymentGet(appointmentId, status, method, FTS, page, pageSize, includeTotalCount, retrieveAll)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PaymentApi();
final appointmentId = 56; // int | 
final status = ; // PaymentStatus | 
final method = method_example; // String | 
final FTS = FTS_example; // String | 
final page = 56; // int | 
final pageSize = 56; // int | 
final includeTotalCount = true; // bool | 
final retrieveAll = true; // bool | 

try {
    final result = api_instance.paymentGet(appointmentId, status, method, FTS, page, pageSize, includeTotalCount, retrieveAll);
    print(result);
} catch (e) {
    print('Exception when calling PaymentApi->paymentGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **appointmentId** | **int**|  | [optional] 
 **status** | [**PaymentStatus**](.md)|  | [optional] 
 **method** | **String**|  | [optional] 
 **FTS** | **String**|  | [optional] 
 **page** | **int**|  | [optional] 
 **pageSize** | **int**|  | [optional] 
 **includeTotalCount** | **bool**|  | [optional] 
 **retrieveAll** | **bool**|  | [optional] 

### Return type

[**PaymentResponsePagedResult**](PaymentResponsePagedResult.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **paymentIdDelete**
> bool paymentIdDelete(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PaymentApi();
final id = 56; // int | 

try {
    final result = api_instance.paymentIdDelete(id);
    print(result);
} catch (e) {
    print('Exception when calling PaymentApi->paymentIdDelete: $e\n');
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

# **paymentIdGet**
> PaymentResponse paymentIdGet(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PaymentApi();
final id = 56; // int | 

try {
    final result = api_instance.paymentIdGet(id);
    print(result);
} catch (e) {
    print('Exception when calling PaymentApi->paymentIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**PaymentResponse**](PaymentResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **paymentIdPut**
> PaymentResponse paymentIdPut(id, paymentUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PaymentApi();
final id = 56; // int | 
final paymentUpsertRequest = PaymentUpsertRequest(); // PaymentUpsertRequest | 

try {
    final result = api_instance.paymentIdPut(id, paymentUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling PaymentApi->paymentIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **paymentUpsertRequest** | [**PaymentUpsertRequest**](PaymentUpsertRequest.md)|  | [optional] 

### Return type

[**PaymentResponse**](PaymentResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **paymentPost**
> PaymentResponse paymentPost(paymentUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PaymentApi();
final paymentUpsertRequest = PaymentUpsertRequest(); // PaymentUpsertRequest | 

try {
    final result = api_instance.paymentPost(paymentUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling PaymentApi->paymentPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentUpsertRequest** | [**PaymentUpsertRequest**](PaymentUpsertRequest.md)|  | [optional] 

### Return type

[**PaymentResponse**](PaymentResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

