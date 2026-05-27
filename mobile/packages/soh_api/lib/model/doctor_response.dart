//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DoctorResponse {
  /// Returns a new [DoctorResponse] instance.
  DoctorResponse({
    this.userId,
    this.firstName,
    this.lastName,
    this.specialization,
    this.rating,
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

  String? specialization;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? rating;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DoctorResponse &&
    other.userId == userId &&
    other.firstName == firstName &&
    other.lastName == lastName &&
    other.specialization == specialization &&
    other.rating == rating;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (userId == null ? 0 : userId!.hashCode) +
    (firstName == null ? 0 : firstName!.hashCode) +
    (lastName == null ? 0 : lastName!.hashCode) +
    (specialization == null ? 0 : specialization!.hashCode) +
    (rating == null ? 0 : rating!.hashCode);

  @override
  String toString() => 'DoctorResponse[userId=$userId, firstName=$firstName, lastName=$lastName, specialization=$specialization, rating=$rating]';

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
    if (this.specialization != null) {
      json[r'specialization'] = this.specialization;
    } else {
      json[r'specialization'] = null;
    }
    if (this.rating != null) {
      json[r'rating'] = this.rating;
    } else {
      json[r'rating'] = null;
    }
    return json;
  }

  /// Returns a new [DoctorResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DoctorResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DoctorResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DoctorResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DoctorResponse(
        userId: mapValueOfType<int>(json, r'userId'),
        firstName: mapValueOfType<String>(json, r'firstName'),
        lastName: mapValueOfType<String>(json, r'lastName'),
        specialization: mapValueOfType<String>(json, r'specialization'),
        rating: mapValueOfType<double>(json, r'rating'),
      );
    }
    return null;
  }

  static List<DoctorResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DoctorResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DoctorResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DoctorResponse> mapFromJson(dynamic json) {
    final map = <String, DoctorResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DoctorResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DoctorResponse-objects as value to a dart map
  static Map<String, List<DoctorResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DoctorResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DoctorResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

