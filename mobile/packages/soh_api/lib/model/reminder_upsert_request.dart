//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReminderUpsertRequest {
  /// Returns a new [ReminderUpsertRequest] instance.
  ReminderUpsertRequest({
    required this.patientId,
    required this.type,
    required this.message,
    required this.scheduledFor,
  });

  int patientId;

  String type;

  String message;

  DateTime scheduledFor;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReminderUpsertRequest &&
    other.patientId == patientId &&
    other.type == type &&
    other.message == message &&
    other.scheduledFor == scheduledFor;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (patientId.hashCode) +
    (type.hashCode) +
    (message.hashCode) +
    (scheduledFor.hashCode);

  @override
  String toString() => 'ReminderUpsertRequest[patientId=$patientId, type=$type, message=$message, scheduledFor=$scheduledFor]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'patientId'] = this.patientId;
      json[r'type'] = this.type;
      json[r'message'] = this.message;
      json[r'scheduledFor'] = this.scheduledFor.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [ReminderUpsertRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReminderUpsertRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ReminderUpsertRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ReminderUpsertRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ReminderUpsertRequest(
        patientId: mapValueOfType<int>(json, r'patientId')!,
        type: mapValueOfType<String>(json, r'type')!,
        message: mapValueOfType<String>(json, r'message')!,
        scheduledFor: mapDateTime(json, r'scheduledFor', r'')!,
      );
    }
    return null;
  }

  static List<ReminderUpsertRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReminderUpsertRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReminderUpsertRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReminderUpsertRequest> mapFromJson(dynamic json) {
    final map = <String, ReminderUpsertRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReminderUpsertRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReminderUpsertRequest-objects as value to a dart map
  static Map<String, List<ReminderUpsertRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReminderUpsertRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReminderUpsertRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'patientId',
    'type',
    'message',
    'scheduledFor',
  };
}

