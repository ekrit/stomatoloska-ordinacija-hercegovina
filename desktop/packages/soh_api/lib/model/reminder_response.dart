//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReminderResponse {
  /// Returns a new [ReminderResponse] instance.
  ReminderResponse({
    this.id,
    this.patientId,
    this.type,
    this.message,
    this.scheduledFor,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? id;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? patientId;

  String? type;

  String? message;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? scheduledFor;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReminderResponse &&
    other.id == id &&
    other.patientId == patientId &&
    other.type == type &&
    other.message == message &&
    other.scheduledFor == scheduledFor;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (patientId == null ? 0 : patientId!.hashCode) +
    (type == null ? 0 : type!.hashCode) +
    (message == null ? 0 : message!.hashCode) +
    (scheduledFor == null ? 0 : scheduledFor!.hashCode);

  @override
  String toString() => 'ReminderResponse[id=$id, patientId=$patientId, type=$type, message=$message, scheduledFor=$scheduledFor]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.patientId != null) {
      json[r'patientId'] = this.patientId;
    } else {
      json[r'patientId'] = null;
    }
    if (this.type != null) {
      json[r'type'] = this.type;
    } else {
      json[r'type'] = null;
    }
    if (this.message != null) {
      json[r'message'] = this.message;
    } else {
      json[r'message'] = null;
    }
    if (this.scheduledFor != null) {
      json[r'scheduledFor'] = this.scheduledFor!.toUtc().toIso8601String();
    } else {
      json[r'scheduledFor'] = null;
    }
    return json;
  }

  /// Returns a new [ReminderResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReminderResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ReminderResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ReminderResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ReminderResponse(
        id: mapValueOfType<int>(json, r'id'),
        patientId: mapValueOfType<int>(json, r'patientId'),
        type: mapValueOfType<String>(json, r'type'),
        message: mapValueOfType<String>(json, r'message'),
        scheduledFor: mapDateTime(json, r'scheduledFor', r''),
      );
    }
    return null;
  }

  static List<ReminderResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReminderResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReminderResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReminderResponse> mapFromJson(dynamic json) {
    final map = <String, ReminderResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReminderResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReminderResponse-objects as value to a dart map
  static Map<String, List<ReminderResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReminderResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReminderResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

