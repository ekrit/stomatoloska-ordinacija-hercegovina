# soh_api.api.OrderItemApi

## Load the API package
```dart
import 'package:soh_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**orderItemGet**](OrderItemApi.md#orderitemget) | **GET** /OrderItem | 
[**orderItemIdDelete**](OrderItemApi.md#orderitemiddelete) | **DELETE** /OrderItem/{id} | 
[**orderItemIdGet**](OrderItemApi.md#orderitemidget) | **GET** /OrderItem/{id} | 
[**orderItemIdPut**](OrderItemApi.md#orderitemidput) | **PUT** /OrderItem/{id} | 
[**orderItemPost**](OrderItemApi.md#orderitempost) | **POST** /OrderItem | 


# **orderItemGet**
> OrderItemResponsePagedResult orderItemGet(orderId, productId, FTS, page, pageSize, includeTotalCount, retrieveAll)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = OrderItemApi();
final orderId = 56; // int | 
final productId = 56; // int | 
final FTS = FTS_example; // String | 
final page = 56; // int | 
final pageSize = 56; // int | 
final includeTotalCount = true; // bool | 
final retrieveAll = true; // bool | 

try {
    final result = api_instance.orderItemGet(orderId, productId, FTS, page, pageSize, includeTotalCount, retrieveAll);
    print(result);
} catch (e) {
    print('Exception when calling OrderItemApi->orderItemGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **int**|  | [optional] 
 **productId** | **int**|  | [optional] 
 **FTS** | **String**|  | [optional] 
 **page** | **int**|  | [optional] 
 **pageSize** | **int**|  | [optional] 
 **includeTotalCount** | **bool**|  | [optional] 
 **retrieveAll** | **bool**|  | [optional] 

### Return type

[**OrderItemResponsePagedResult**](OrderItemResponsePagedResult.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **orderItemIdDelete**
> bool orderItemIdDelete(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = OrderItemApi();
final id = 56; // int | 

try {
    final result = api_instance.orderItemIdDelete(id);
    print(result);
} catch (e) {
    print('Exception when calling OrderItemApi->orderItemIdDelete: $e\n');
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

# **orderItemIdGet**
> OrderItemResponse orderItemIdGet(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = OrderItemApi();
final id = 56; // int | 

try {
    final result = api_instance.orderItemIdGet(id);
    print(result);
} catch (e) {
    print('Exception when calling OrderItemApi->orderItemIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**OrderItemResponse**](OrderItemResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **orderItemIdPut**
> OrderItemResponse orderItemIdPut(id, orderItemUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = OrderItemApi();
final id = 56; // int | 
final orderItemUpsertRequest = OrderItemUpsertRequest(); // OrderItemUpsertRequest | 

try {
    final result = api_instance.orderItemIdPut(id, orderItemUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling OrderItemApi->orderItemIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **orderItemUpsertRequest** | [**OrderItemUpsertRequest**](OrderItemUpsertRequest.md)|  | [optional] 

### Return type

[**OrderItemResponse**](OrderItemResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **orderItemPost**
> OrderItemResponse orderItemPost(orderItemUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = OrderItemApi();
final orderItemUpsertRequest = OrderItemUpsertRequest(); // OrderItemUpsertRequest | 

try {
    final result = api_instance.orderItemPost(orderItemUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling OrderItemApi->orderItemPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderItemUpsertRequest** | [**OrderItemUpsertRequest**](OrderItemUpsertRequest.md)|  | [optional] 

### Return type

[**OrderItemResponse**](OrderItemResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

