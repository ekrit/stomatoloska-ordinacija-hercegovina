//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PatientStatsResponse {
  /// Returns a new [PatientStatsResponse] instance.
  PatientStatsResponse({
    this.monthly = const [],
  });

  List<MonthlyAppointmentResponse>? monthly;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PatientStatsResponse &&
    _deepEquality.equals(other.monthly, monthly);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (monthly == null ? 0 : monthly!.hashCode);

  @override
  String toString() => 'PatientStatsResponse[monthly=$monthly]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.monthly != null) {
      json[r'monthly'] = this.monthly;
    } else {
      json[r'monthly'] = null;
    }
    return json;
  }

  /// Returns a new [PatientStatsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PatientStatsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PatientStatsResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PatientStatsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PatientStatsResponse(
        monthly: MonthlyAppointmentResponse.listFromJson(json[r'monthly']),
      );
    }
    return null;
  }

  static List<PatientStatsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PatientStatsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PatientStatsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PatientStatsResponse> mapFromJson(dynamic json) {
    final map = <String, PatientStatsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PatientStatsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PatientStatsResponse-objects as value to a dart map
  static Map<String, List<PatientStatsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PatientStatsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PatientStatsResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

