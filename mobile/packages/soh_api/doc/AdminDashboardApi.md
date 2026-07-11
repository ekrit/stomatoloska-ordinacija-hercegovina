# soh_api.api.AdminDashboardApi

## Load the API package
```dart
import 'package:soh_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminDashboardActivityRecentGet**](AdminDashboardApi.md#admindashboardactivityrecentget) | **GET** /admin-dashboard/activity/recent | 
[**adminDashboardAppointmentsMonthlyGet**](AdminDashboardApi.md#admindashboardappointmentsmonthlyget) | **GET** /admin-dashboard/appointments/monthly | 
[**adminDashboardDoctorsSpotlightGet**](AdminDashboardApi.md#admindashboarddoctorsspotlightget) | **GET** /admin-dashboard/doctors/spotlight | 
[**adminDashboardPatientsMonthlyGet**](AdminDashboardApi.md#admindashboardpatientsmonthlyget) | **GET** /admin-dashboard/patients/monthly | 
[**adminDashboardRevenueBreakdownGet**](AdminDashboardApi.md#admindashboardrevenuebreakdownget) | **GET** /admin-dashboard/revenue/breakdown | 
[**adminDashboardStatsGet**](AdminDashboardApi.md#admindashboardstatsget) | **GET** /admin-dashboard/stats | 


# **adminDashboardActivityRecentGet**
> RecentActivityResponse adminDashboardActivityRecentGet(take)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminDashboardApi();
final take = 56; // int | 

try {
    final result = api_instance.adminDashboardActivityRecentGet(take);
    print(result);
} catch (e) {
    print('Exception when calling AdminDashboardApi->adminDashboardActivityRecentGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **take** | **int**|  | [optional] [default to 30]

### Return type

[**RecentActivityResponse**](RecentActivityResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDashboardAppointmentsMonthlyGet**
> AppointmentStatsResponse adminDashboardAppointmentsMonthlyGet(months)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminDashboardApi();
final months = 56; // int | 

try {
    final result = api_instance.adminDashboardAppointmentsMonthlyGet(months);
    print(result);
} catch (e) {
    print('Exception when calling AdminDashboardApi->adminDashboardAppointmentsMonthlyGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **months** | **int**|  | [optional] [default to 6]

### Return type

[**AppointmentStatsResponse**](AppointmentStatsResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDashboardDoctorsSpotlightGet**
> List<DoctorSpotlightResponse> adminDashboardDoctorsSpotlightGet(limit)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminDashboardApi();
final limit = 56; // int | 

try {
    final result = api_instance.adminDashboardDoctorsSpotlightGet(limit);
    print(result);
} catch (e) {
    print('Exception when calling AdminDashboardApi->adminDashboardDoctorsSpotlightGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**|  | [optional] [default to 4]

### Return type

[**List<DoctorSpotlightResponse>**](DoctorSpotlightResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDashboardPatientsMonthlyGet**
> PatientStatsResponse adminDashboardPatientsMonthlyGet(months)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminDashboardApi();
final months = 56; // int | 

try {
    final result = api_instance.adminDashboardPatientsMonthlyGet(months);
    print(result);
} catch (e) {
    print('Exception when calling AdminDashboardApi->adminDashboardPatientsMonthlyGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **months** | **int**|  | [optional] [default to 6]

### Return type

[**PatientStatsResponse**](PatientStatsResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDashboardRevenueBreakdownGet**
> RevenueStatsResponse adminDashboardRevenueBreakdownGet(months)



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminDashboardApi();
final months = 56; // int | 

try {
    final result = api_instance.adminDashboardRevenueBreakdownGet(months);
    print(result);
} catch (e) {
    print('Exception when calling AdminDashboardApi->adminDashboardRevenueBreakdownGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **months** | **int**|  | [optional] [default to 6]

### Return type

[**RevenueStatsResponse**](RevenueStatsResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDashboardStatsGet**
> DashboardStatsResponse adminDashboardStatsGet()



### Example
```dart
import 'package:soh_api/api.dart';
// TODO Configure HTTP Bearer authorization: Bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('Bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminDashboardApi();

try {
    final result = api_instance.adminDashboardStatsGet();
    print(result);
} catch (e) {
    print('Exception when calling AdminDashboardApi->adminDashboardStatsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DashboardStatsResponse**](DashboardStatsResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

