# soh_api.api.ProductApi

## Load the API package
```dart
import 'package:soh_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**productGet**](ProductApi.md#productget) | **GET** /Product | 
[**productIdDelete**](ProductApi.md#productiddelete) | **DELETE** /Product/{id} | 
[**productIdGet**](ProductApi.md#productidget) | **GET** /Product/{id} | 
[**productIdPut**](ProductApi.md#productidput) | **PUT** /Product/{id} | 
[**productPost**](ProductApi.md#productpost) | **POST** /Product | 


# **productGet**
> ProductResponsePagedResult productGet(name, category, FTS, page, pageSize, includeTotalCount, retrieveAll)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ProductApi();
final name = name_example; // String | 
final category = category_example; // String | 
final FTS = FTS_example; // String | 
final page = 56; // int | 
final pageSize = 56; // int | 
final includeTotalCount = true; // bool | 
final retrieveAll = true; // bool | 

try {
    final result = api_instance.productGet(name, category, FTS, page, pageSize, includeTotalCount, retrieveAll);
    print(result);
} catch (e) {
    print('Exception when calling ProductApi->productGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**|  | [optional] 
 **category** | **String**|  | [optional] 
 **FTS** | **String**|  | [optional] 
 **page** | **int**|  | [optional] 
 **pageSize** | **int**|  | [optional] 
 **includeTotalCount** | **bool**|  | [optional] 
 **retrieveAll** | **bool**|  | [optional] 

### Return type

[**ProductResponsePagedResult**](ProductResponsePagedResult.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **productIdDelete**
> bool productIdDelete(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ProductApi();
final id = 56; // int | 

try {
    final result = api_instance.productIdDelete(id);
    print(result);
} catch (e) {
    print('Exception when calling ProductApi->productIdDelete: $e\n');
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

# **productIdGet**
> ProductResponse productIdGet(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ProductApi();
final id = 56; // int | 

try {
    final result = api_instance.productIdGet(id);
    print(result);
} catch (e) {
    print('Exception when calling ProductApi->productIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ProductResponse**](ProductResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **productIdPut**
> ProductResponse productIdPut(id, productUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ProductApi();
final id = 56; // int | 
final productUpsertRequest = ProductUpsertRequest(); // ProductUpsertRequest | 

try {
    final result = api_instance.productIdPut(id, productUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling ProductApi->productIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **productUpsertRequest** | [**ProductUpsertRequest**](ProductUpsertRequest.md)|  | [optional] 

### Return type

[**ProductResponse**](ProductResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **productPost**
> ProductResponse productPost(productUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ProductApi();
final productUpsertRequest = ProductUpsertRequest(); // ProductUpsertRequest | 

try {
    final result = api_instance.productPost(productUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling ProductApi->productPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productUpsertRequest** | [**ProductUpsertRequest**](ProductUpsertRequest.md)|  | [optional] 

### Return type

[**ProductResponse**](ProductResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

