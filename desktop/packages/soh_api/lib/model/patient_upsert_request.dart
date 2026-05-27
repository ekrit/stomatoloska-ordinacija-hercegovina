//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PatientUpsertRequest {
  /// Returns a new [PatientUpsertRequest] instance.
  PatientUpsertRequest({
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.dateOfBirth,
  });

  int userId;

  String firstName;

  String lastName;

  String? phone;

  DateTime dateOfBirth;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PatientUpsertRequest &&
    other.userId == userId &&
    other.firstName == firstName &&
    other.lastName == lastName &&
    other.phone == phone &&
    other.dateOfBirth == dateOfBirth;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (userId.hashCode) +
    (firstName.hashCode) +
    (lastName.hashCode) +
    (phone == null ? 0 : phone!.hashCode) +
    (dateOfBirth.hashCode);

  @override
  String toString() => 'PatientUpsertRequest[userId=$userId, firstName=$firstName, lastName=$lastName, phone=$phone, dateOfBirth=$dateOfBirth]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'userId'] = this.userId;
      json[r'firstName'] = this.firstName;
      json[r'lastName'] = this.lastName;
    if (this.phone != null) {
      json[r'phone'] = this.phone;
    } else {
      json[r'phone'] = null;
    }
      json[r'dateOfBirth'] = this.dateOfBirth.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [PatientUpsertRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PatientUpsertRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PatientUpsertRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PatientUpsertRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PatientUpsertRequest(
        userId: mapValueOfType<int>(json, r'userId')!,
        firstName: mapValueOfType<String>(json, r'firstName')!,
        lastName: mapValueOfType<String>(json, r'lastName')!,
        phone: mapValueOfType<String>(json, r'phone'),
        dateOfBirth: mapDateTime(json, r'dateOfBirth', r'')!,
      );
    }
    return null;
  }

  static List<PatientUpsertRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PatientUpsertRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PatientUpsertRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PatientUpsertRequest> mapFromJson(dynamic json) {
    final map = <String, PatientUpsertRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PatientUpsertRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PatientUpsertRequest-objects as value to a dart map
  static Map<String, List<PatientUpsertRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PatientUpsertRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PatientUpsertRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'userId',
    'firstName',
    'lastName',
    'dateOfBirth',
  };
}

