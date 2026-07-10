# soh_api.api.RecommendationApi

## Load the API package
```dart
import 'package:soh_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**recommendationProductsGet**](RecommendationApi.md#recommendationproductsget) | **GET** /Recommendation/products | 
[**recommendationTrackPost**](RecommendationApi.md#recommendationtrackpost) | **POST** /Recommendation/track | 


# **recommendationProductsGet**
> List<RecommendedProductResponse> recommendationProductsGet(take)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RecommendationApi();
final take = 56; // int | 

try {
    final result = api_instance.recommendationProductsGet(take);
    print(result);
} catch (e) {
    print('Exception when calling RecommendationApi->recommendationProductsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **take** | **int**|  | [optional] [default to 8]

### Return type

[**List<RecommendedProductResponse>**](RecommendedProductResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recommendationTrackPost**
> recommendationTrackPost(productInteractionTrackRequest)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RecommendationApi();
final productInteractionTrackRequest = ProductInteractionTrackRequest(); // ProductInteractionTrackRequest | 

try {
    api_instance.recommendationTrackPost(productInteractionTrackRequest);
} catch (e) {
    print('Exception when calling RecommendationApi->recommendationTrackPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productInteractionTrackRequest** | [**ProductInteractionTrackRequest**](ProductInteractionTrackRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

