# soh_api.api.ProductCategoryApi

## Load the API package
```dart
import 'package:soh_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**productCategoryGet**](ProductCategoryApi.md#productcategoryget) | **GET** /ProductCategory | 
[**productCategoryIdDelete**](ProductCategoryApi.md#productcategoryiddelete) | **DELETE** /ProductCategory/{id} | 
[**productCategoryIdGet**](ProductCategoryApi.md#productcategoryidget) | **GET** /ProductCategory/{id} | 
[**productCategoryIdPut**](ProductCategoryApi.md#productcategoryidput) | **PUT** /ProductCategory/{id} | 
[**productCategoryPost**](ProductCategoryApi.md#productcategorypost) | **POST** /ProductCategory | 


# **productCategoryGet**
> ProductCategoryResponsePagedResult productCategoryGet(name, isActive, FTS, page, pageSize, includeTotalCount)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ProductCategoryApi();
final name = name_example; // String | 
final isActive = true; // bool | 
final FTS = FTS_example; // String | 
final page = 56; // int | 
final pageSize = 56; // int | 
final includeTotalCount = true; // bool | 

try {
    final result = api_instance.productCategoryGet(name, isActive, FTS, page, pageSize, includeTotalCount);
    print(result);
} catch (e) {
    print('Exception when calling ProductCategoryApi->productCategoryGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**|  | [optional] 
 **isActive** | **bool**|  | [optional] 
 **FTS** | **String**|  | [optional] 
 **page** | **int**|  | [optional] 
 **pageSize** | **int**|  | [optional] 
 **includeTotalCount** | **bool**|  | [optional] 

### Return type

[**ProductCategoryResponsePagedResult**](ProductCategoryResponsePagedResult.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **productCategoryIdDelete**
> bool productCategoryIdDelete(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ProductCategoryApi();
final id = 56; // int | 

try {
    final result = api_instance.productCategoryIdDelete(id);
    print(result);
} catch (e) {
    print('Exception when calling ProductCategoryApi->productCategoryIdDelete: $e\n');
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

# **productCategoryIdGet**
> ProductCategoryResponse productCategoryIdGet(id)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ProductCategoryApi();
final id = 56; // int | 

try {
    final result = api_instance.productCategoryIdGet(id);
    print(result);
} catch (e) {
    print('Exception when calling ProductCategoryApi->productCategoryIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ProductCategoryResponse**](ProductCategoryResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **productCategoryIdPut**
> ProductCategoryResponse productCategoryIdPut(id, productCategoryUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ProductCategoryApi();
final id = 56; // int | 
final productCategoryUpsertRequest = ProductCategoryUpsertRequest(); // ProductCategoryUpsertRequest | 

try {
    final result = api_instance.productCategoryIdPut(id, productCategoryUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling ProductCategoryApi->productCategoryIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **productCategoryUpsertRequest** | [**ProductCategoryUpsertRequest**](ProductCategoryUpsertRequest.md)|  | [optional] 

### Return type

[**ProductCategoryResponse**](ProductCategoryResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **productCategoryPost**
> ProductCategoryResponse productCategoryPost(productCategoryUpsertRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ProductCategoryApi();
final productCategoryUpsertRequest = ProductCategoryUpsertRequest(); // ProductCategoryUpsertRequest | 

try {
    final result = api_instance.productCategoryPost(productCategoryUpsertRequest);
    print(result);
} catch (e) {
    print('Exception when calling ProductCategoryApi->productCategoryPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productCategoryUpsertRequest** | [**ProductCategoryUpsertRequest**](ProductCategoryUpsertRequest.md)|  | [optional] 

### Return type

[**ProductCategoryResponse**](ProductCategoryResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

