//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PatientResponse {
  /// Returns a new [PatientResponse] instance.
  PatientResponse({
    this.userId,
    this.firstName,
    this.lastName,
    this.phone,
    this.dateOfBirth,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? userId;

  String? firstName;

  String? lastName;

  String? phone;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? dateOfBirth;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PatientResponse &&
    other.userId == userId &&
    other.firstName == firstName &&
    other.lastName == lastName &&
    other.phone == phone &&
    other.dateOfBirth == dateOfBirth;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (userId == null ? 0 : userId!.hashCode) +
    (firstName == null ? 0 : firstName!.hashCode) +
    (lastName == null ? 0 : lastName!.hashCode) +
    (phone == null ? 0 : phone!.hashCode) +
    (dateOfBirth == null ? 0 : dateOfBirth!.hashCode);

  @override
  String toString() => 'PatientResponse[userId=$userId, firstName=$firstName, lastName=$lastName, phone=$phone, dateOfBirth=$dateOfBirth]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.userId != null) {
      json[r'userId'] = this.userId;
    } else {
      json[r'userId'] = null;
    }
    if (this.firstName != null) {
      json[r'firstName'] = this.firstName;
    } else {
      json[r'firstName'] = null;
    }
    if (this.lastName != null) {
      json[r'lastName'] = this.lastName;
    } else {
      json[r'lastName'] = null;
    }
    if (this.phone != null) {
      json[r'phone'] = this.phone;
    } else {
      json[r'phone'] = null;
    }
    if (this.dateOfBirth != null) {
      json[r'dateOfBirth'] = this.dateOfBirth!.toUtc().toIso8601String();
    } else {
      json[r'dateOfBirth'] = null;
    }
    return json;
  }

  /// Returns a new [PatientResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PatientResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PatientResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PatientResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PatientResponse(
        userId: mapValueOfType<int>(json, r'userId'),
        firstName: mapValueOfType<String>(json, r'firstName'),
        lastName: mapValueOfType<String>(json, r'lastName'),
        phone: mapValueOfType<String>(json, r'phone'),
        dateOfBirth: mapDateTime(json, r'dateOfBirth', r''),
      );
    }
    return null;
  }

  static List<PatientResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PatientResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PatientResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PatientResponse> mapFromJson(dynamic json) {
    final map = <String, PatientResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PatientResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PatientResponse-objects as value to a dart map
  static Map<String, List<PatientResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PatientResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PatientResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

