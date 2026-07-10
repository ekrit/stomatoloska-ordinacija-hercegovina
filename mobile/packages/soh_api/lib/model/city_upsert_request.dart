//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CityUpsertRequest {
  /// Returns a new [CityUpsertRequest] instance.
  CityUpsertRequest({
    required this.name,
    this.address,
    this.contactPhone,
    this.contactEmail,
    this.workingHours,
  });

  String name;

  String? address;

  String? contactPhone;

  String? contactEmail;

  String? workingHours;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CityUpsertRequest &&
    other.name == name &&
    other.address == address &&
    other.contactPhone == contactPhone &&
    other.contactEmail == contactEmail &&
    other.workingHours == workingHours;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (address == null ? 0 : address!.hashCode) +
    (contactPhone == null ? 0 : contactPhone!.hashCode) +
    (contactEmail == null ? 0 : contactEmail!.hashCode) +
    (workingHours == null ? 0 : workingHours!.hashCode);

  @override
  String toString() => 'CityUpsertRequest[name=$name, address=$address, contactPhone=$contactPhone, contactEmail=$contactEmail, workingHours=$workingHours]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
    if (this.address != null) {
      json[r'address'] = this.address;
    } else {
      json[r'address'] = null;
    }
    if (this.contactPhone != null) {
      json[r'contactPhone'] = this.contactPhone;
    } else {
      json[r'contactPhone'] = null;
    }
    if (this.contactEmail != null) {
      json[r'contactEmail'] = this.contactEmail;
    } else {
      json[r'contactEmail'] = null;
    }
    if (this.workingHours != null) {
      json[r'workingHours'] = this.workingHours;
    } else {
      json[r'workingHours'] = null;
    }
    return json;
  }

  /// Returns a new [CityUpsertRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CityUpsertRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CityUpsertRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CityUpsertRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CityUpsertRequest(
        name: mapValueOfType<String>(json, r'name')!,
        address: mapValueOfType<String>(json, r'address'),
        contactPhone: mapValueOfType<String>(json, r'contactPhone'),
        contactEmail: mapValueOfType<String>(json, r'contactEmail'),
        workingHours: mapValueOfType<String>(json, r'workingHours'),
      );
    }
    return null;
  }

  static List<CityUpsertRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CityUpsertRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CityUpsertRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CityUpsertRequest> mapFromJson(dynamic json) {
    final map = <String, CityUpsertRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CityUpsertRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CityUpsertRequest-objects as value to a dart map
  static Map<String, List<CityUpsertRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CityUpsertRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CityUpsertRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
  };
}

