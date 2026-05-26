//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AppointmentUpsertRequest {
  /// Returns a new [AppointmentUpsertRequest] instance.
  AppointmentUpsertRequest({
    required this.patientId,
    required this.doctorId,
    required this.serviceId,
    required this.roomId,
    required this.startTime,
    required this.endTime,
    this.status,
    this.doctorNote,
  });

  int patientId;

  int doctorId;

  int serviceId;

  int roomId;

  DateTime startTime;

  DateTime endTime;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  AppointmentStatus? status;

  String? doctorNote;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AppointmentUpsertRequest &&
    other.patientId == patientId &&
    other.doctorId == doctorId &&
    other.serviceId == serviceId &&
    other.roomId == roomId &&
    other.startTime == startTime &&
    other.endTime == endTime &&
    other.status == status &&
    other.doctorNote == doctorNote;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (patientId.hashCode) +
    (doctorId.hashCode) +
    (serviceId.hashCode) +
    (roomId.hashCode) +
    (startTime.hashCode) +
    (endTime.hashCode) +
    (status == null ? 0 : status!.hashCode) +
    (doctorNote == null ? 0 : doctorNote!.hashCode);

  @override
  String toString() => 'AppointmentUpsertRequest[patientId=$patientId, doctorId=$doctorId, serviceId=$serviceId, roomId=$roomId, startTime=$startTime, endTime=$endTime, status=$status, doctorNote=$doctorNote]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'patientId'] = this.patientId;
      json[r'doctorId'] = this.doctorId;
      json[r'serviceId'] = this.serviceId;
      json[r'roomId'] = this.roomId;
      json[r'startTime'] = this.startTime.toUtc().toIso8601String();
      json[r'endTime'] = this.endTime.toUtc().toIso8601String();
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
    if (this.doctorNote != null) {
      json[r'doctorNote'] = this.doctorNote;
    } else {
      json[r'doctorNote'] = null;
    }
    return json;
  }

  /// Returns a new [AppointmentUpsertRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AppointmentUpsertRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AppointmentUpsertRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AppointmentUpsertRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AppointmentUpsertRequest(
        patientId: mapValueOfType<int>(json, r'patientId')!,
        doctorId: mapValueOfType<int>(json, r'doctorId')!,
        serviceId: mapValueOfType<int>(json, r'serviceId')!,
        roomId: mapValueOfType<int>(json, r'roomId')!,
        startTime: mapDateTime(json, r'startTime', r'')!,
        endTime: mapDateTime(json, r'endTime', r'')!,
        status: AppointmentStatus.fromJson(json[r'status']),
        doctorNote: mapValueOfType<String>(json, r'doctorNote'),
      );
    }
    return null;
  }

  static List<AppointmentUpsertRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AppointmentUpsertRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AppointmentUpsertRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AppointmentUpsertRequest> mapFromJson(dynamic json) {
    final map = <String, AppointmentUpsertRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AppointmentUpsertRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AppointmentUpsertRequest-objects as value to a dart map
  static Map<String, List<AppointmentUpsertRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AppointmentUpsertRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AppointmentUpsertRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'patientId',
    'doctorId',
    'serviceId',
    'roomId',
    'startTime',
    'endTime',
  };
}

