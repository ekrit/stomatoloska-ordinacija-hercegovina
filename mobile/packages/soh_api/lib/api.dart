//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

library openapi.api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'api_client.dart';
part 'api_helper.dart';
part 'api_exception.dart';
part 'auth/authentication.dart';
part 'auth/api_key_auth.dart';
part 'auth/oauth.dart';
part 'auth/http_basic_auth.dart';
part 'auth/http_bearer_auth.dart';

part 'api/activity_log_api.dart';
part 'api/admin_api.dart';
part 'api/appointment_api.dart';
part 'api/city_api.dart';
part 'api/doctor_api.dart';
part 'api/doctor_note_api.dart';
part 'api/gender_api.dart';
part 'api/hygiene_tracker_api.dart';
part 'api/medical_record_api.dart';
part 'api/order_api.dart';
part 'api/order_item_api.dart';
part 'api/patient_api.dart';
part 'api/payment_api.dart';
part 'api/product_api.dart';
part 'api/reminder_api.dart';
part 'api/report_api.dart';
part 'api/review_api.dart';
part 'api/role_api.dart';
part 'api/room_api.dart';
part 'api/service_api.dart';
part 'api/users_api.dart';

part 'model/activity_log_response.dart';
part 'model/activity_log_response_paged_result.dart';
part 'model/activity_log_upsert_request.dart';
part 'model/admin_response.dart';
part 'model/admin_response_paged_result.dart';
part 'model/admin_upsert_request.dart';
part 'model/appointment_response.dart';
part 'model/appointment_response_paged_result.dart';
part 'model/appointment_status.dart';
part 'model/appointment_upsert_request.dart';
part 'model/auth_response.dart';
part 'model/city_response.dart';
part 'model/city_response_paged_result.dart';
part 'model/city_upsert_request.dart';
part 'model/doctor_note_response.dart';
part 'model/doctor_note_response_paged_result.dart';
part 'model/doctor_note_upsert_request.dart';
part 'model/doctor_response.dart';
part 'model/doctor_response_paged_result.dart';
part 'model/doctor_upsert_request.dart';
part 'model/gender_response.dart';
part 'model/gender_response_paged_result.dart';
part 'model/gender_upsert_request.dart';
part 'model/hygiene_tracker_response.dart';
part 'model/hygiene_tracker_response_paged_result.dart';
part 'model/hygiene_tracker_upsert_request.dart';
part 'model/medical_record_response.dart';
part 'model/medical_record_response_paged_result.dart';
part 'model/medical_record_upsert_request.dart';
part 'model/order_item_response.dart';
part 'model/order_item_response_paged_result.dart';
part 'model/order_item_upsert_request.dart';
part 'model/order_response.dart';
part 'model/order_response_paged_result.dart';
part 'model/order_upsert_request.dart';
part 'model/patient_response.dart';
part 'model/patient_response_paged_result.dart';
part 'model/patient_upsert_request.dart';
part 'model/payment_response.dart';
part 'model/payment_response_paged_result.dart';
part 'model/payment_status.dart';
part 'model/payment_upsert_request.dart';
part 'model/product_response.dart';
part 'model/product_response_paged_result.dart';
part 'model/product_upsert_request.dart';
part 'model/reminder_response.dart';
part 'model/reminder_response_paged_result.dart';
part 'model/reminder_upsert_request.dart';
part 'model/report_response.dart';
part 'model/report_response_paged_result.dart';
part 'model/report_upsert_request.dart';
part 'model/review_response.dart';
part 'model/review_response_paged_result.dart';
part 'model/review_upsert_request.dart';
part 'model/role_response.dart';
part 'model/role_response_paged_result.dart';
part 'model/role_upsert_request.dart';
part 'model/room_response.dart';
part 'model/room_response_paged_result.dart';
part 'model/room_upsert_request.dart';
part 'model/service_response.dart';
part 'model/service_response_paged_result.dart';
part 'model/service_upsert_request.dart';
part 'model/user_login_request.dart';
part 'model/user_register_request.dart';
part 'model/user_response.dart';
part 'model/user_response_paged_result.dart';
part 'model/user_upsert_request.dart';


/// An [ApiClient] instance that uses the default values obtained from
/// the OpenAPI specification file.
var defaultApiClient = ApiClient();

const _delimiters = {'csv': ',', 'ssv': ' ', 'tsv': '\t', 'pipes': '|'};
const _dateEpochMarker = 'epoch';
const _deepEquality = DeepCollectionEquality();
final _dateFormatter = DateFormat('yyyy-MM-dd');
final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

bool _isEpochMarker(String? pattern) => pattern == _dateEpochMarker || pattern == '/$_dateEpochMarker/';
