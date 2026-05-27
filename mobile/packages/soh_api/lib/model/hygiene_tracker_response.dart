//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class HygieneTrackerResponse {
  /// Returns a new [HygieneTrackerResponse] instance.
  HygieneTrackerResponse({
    this.id,
    this.patientId,
    this.date,
    this.brushesCount,
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

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? date;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? brushesCount;

  @override
  bool operator ==(Object other) => identical(this, other) || other is HygieneTrackerResponse &&
    other.id == id &&
    other.patientId == patientId &&
    other.date == date &&
    other.brushesCount == brushesCount;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (patientId == null ? 0 : patientId!.hashCode) +
    (date == null ? 0 : date!.hashCode) +
    (brushesCount == null ? 0 : brushesCount!.hashCode);

  @override
  String toString() => 'HygieneTrackerResponse[id=$id, patientId=$patientId, date=$date, brushesCount=$brushesCount]';

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
    if (this.date != null) {
      json[r'date'] = this.date!.toUtc().toIso8601String();
    } else {
      json[r'date'] = null;
    }
    if (this.brushesCount != null) {
      json[r'brushesCount'] = this.brushesCount;
    } else {
      json[r'brushesCount'] = null;
    }
    return json;
  }

  /// Returns a new [HygieneTrackerResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static HygieneTrackerResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "HygieneTrackerResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "HygieneTrackerResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return HygieneTrackerResponse(
        id: mapValueOfType<int>(json, r'id'),
        patientId: mapValueOfType<int>(json, r'patientId'),
        date: mapDateTime(json, r'date', r''),
        brushesCount: mapValueOfType<int>(json, r'brushesCount'),
      );
    }
    return null;
  }

  static List<HygieneTrackerResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <HygieneTrackerResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = HygieneTrackerResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, HygieneTrackerResponse> mapFromJson(dynamic json) {
    final map = <String, HygieneTrackerResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = HygieneTrackerResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of HygieneTrackerResponse-objects as value to a dart map
  static Map<String, List<HygieneTrackerResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<HygieneTrackerResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = HygieneTrackerResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

