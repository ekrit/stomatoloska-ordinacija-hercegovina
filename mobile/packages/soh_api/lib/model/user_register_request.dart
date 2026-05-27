//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserRegisterRequest {
  /// Returns a new [UserRegisterRequest] instance.
  UserRegisterRequest({
    required this.firstName,
    required this.lastName,
    this.picture,
    required this.email,
    required this.username,
    this.phoneNumber,
    required this.genderId,
    required this.cityId,
    required this.password,
  });

  String firstName;

  String lastName;

  String? picture;

  String email;

  String username;

  String? phoneNumber;

  int genderId;

  int cityId;

  String password;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserRegisterRequest &&
    other.firstName == firstName &&
    other.lastName == lastName &&
    other.picture == picture &&
    other.email == email &&
    other.username == username &&
    other.phoneNumber == phoneNumber &&
    other.genderId == genderId &&
    other.cityId == cityId &&
    other.password == password;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (firstName.hashCode) +
    (lastName.hashCode) +
    (picture == null ? 0 : picture!.hashCode) +
    (email.hashCode) +
    (username.hashCode) +
    (phoneNumber == null ? 0 : phoneNumber!.hashCode) +
    (genderId.hashCode) +
    (cityId.hashCode) +
    (password.hashCode);

  @override
  String toString() => 'UserRegisterRequest[firstName=$firstName, lastName=$lastName, picture=$picture, email=$email, username=$username, phoneNumber=$phoneNumber, genderId=$genderId, cityId=$cityId, password=$password]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'firstName'] = this.firstName;
      json[r'lastName'] = this.lastName;
    if (this.picture != null) {
      json[r'picture'] = this.picture;
    } else {
      json[r'picture'] = null;
    }
      json[r'email'] = this.email;
      json[r'username'] = this.username;
    if (this.phoneNumber != null) {
      json[r'phoneNumber'] = this.phoneNumber;
    } else {
      json[r'phoneNumber'] = null;
    }
      json[r'genderId'] = this.genderId;
      json[r'cityId'] = this.cityId;
      json[r'password'] = this.password;
    return json;
  }

  /// Returns a new [UserRegisterRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserRegisterRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserRegisterRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserRegisterRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserRegisterRequest(
        firstName: mapValueOfType<String>(json, r'firstName')!,
        lastName: mapValueOfType<String>(json, r'lastName')!,
        picture: mapValueOfType<String>(json, r'picture'),
        email: mapValueOfType<String>(json, r'email')!,
        username: mapValueOfType<String>(json, r'username')!,
        phoneNumber: mapValueOfType<String>(json, r'phoneNumber'),
        genderId: mapValueOfType<int>(json, r'genderId')!,
        cityId: mapValueOfType<int>(json, r'cityId')!,
        password: mapValueOfType<String>(json, r'password')!,
      );
    }
    return null;
  }

  static List<UserRegisterRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserRegisterRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserRegisterRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserRegisterRequest> mapFromJson(dynamic json) {
    final map = <String, UserRegisterRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserRegisterRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserRegisterRequest-objects as value to a dart map
  static Map<String, List<UserRegisterRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserRegisterRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserRegisterRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'firstName',
    'lastName',
    'email',
    'username',
    'genderId',
    'cityId',
    'password',
  };
}

