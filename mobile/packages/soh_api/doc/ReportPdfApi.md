# soh_api.api.ReportPdfApi

## Load the API package
```dart
import 'package:soh_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**reportPdfAppointmentsSummaryGet**](ReportPdfApi.md#reportpdfappointmentssummaryget) | **GET** /report/pdf/appointments-summary | 
[**reportPdfRevenueByServiceGet**](ReportPdfApi.md#reportpdfrevenuebyserviceget) | **GET** /report/pdf/revenue-by-service | 


# **reportPdfAppointmentsSummaryGet**
> reportPdfAppointmentsSummaryGet(fromUtc, toUtc)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ReportPdfApi();
final fromUtc = 2013-10-20T19:20:30+01:00; // DateTime | 
final toUtc = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    api_instance.reportPdfAppointmentsSummaryGet(fromUtc, toUtc);
} catch (e) {
    print('Exception when calling ReportPdfApi->reportPdfAppointmentsSummaryGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fromUtc** | **DateTime**|  | [optional] 
 **toUtc** | **DateTime**|  | [optional] 

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reportPdfRevenueByServiceGet**
> reportPdfRevenueByServiceGet(months)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ReportPdfApi();
final months = 56; // int | 

try {
    api_instance.reportPdfRevenueByServiceGet(months);
} catch (e) {
    print('Exception when calling ReportPdfApi->reportPdfRevenueByServiceGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **months** | **int**|  | [optional] [default to 6]

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

