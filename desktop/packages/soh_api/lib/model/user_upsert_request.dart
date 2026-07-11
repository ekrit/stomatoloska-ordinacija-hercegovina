//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserUpsertRequest {
  /// Returns a new [UserUpsertRequest] instance.
  UserUpsertRequest({
    required this.firstName,
    required this.lastName,
    this.picture,
    required this.email,
    required this.username,
    this.phoneNumber,
    required this.genderId,
    required this.cityId,
    this.isActive,
    this.password,
    this.oldPassword,
    this.roleIds = const [],
  });

  String firstName;

  String lastName;

  String? picture;

  String email;

  String username;

  String? phoneNumber;

  int genderId;

  int cityId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isActive;

  String? password;

  String? oldPassword;

  List<int>? roleIds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserUpsertRequest &&
    other.firstName == firstName &&
    other.lastName == lastName &&
    other.picture == picture &&
    other.email == email &&
    other.username == username &&
    other.phoneNumber == phoneNumber &&
    other.genderId == genderId &&
    other.cityId == cityId &&
    other.isActive == isActive &&
    other.password == password &&
    other.oldPassword == oldPassword &&
    _deepEquality.equals(other.roleIds, roleIds);

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
    (isActive == null ? 0 : isActive!.hashCode) +
    (password == null ? 0 : password!.hashCode) +
    (oldPassword == null ? 0 : oldPassword!.hashCode) +
    (roleIds == null ? 0 : roleIds!.hashCode);

  @override
  String toString() => 'UserUpsertRequest[firstName=$firstName, lastName=$lastName, picture=$picture, email=$email, username=$username, phoneNumber=$phoneNumber, genderId=$genderId, cityId=$cityId, isActive=$isActive, password=$password, oldPassword=$oldPassword, roleIds=$roleIds]';

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
    if (this.isActive != null) {
      json[r'isActive'] = this.isActive;
    } else {
      json[r'isActive'] = null;
    }
    if (this.password != null) {
      json[r'password'] = this.password;
    } else {
      json[r'password'] = null;
    }
    if (this.oldPassword != null) {
      json[r'oldPassword'] = this.oldPassword;
    } else {
      json[r'oldPassword'] = null;
    }
    if (this.roleIds != null) {
      json[r'roleIds'] = this.roleIds;
    } else {
      json[r'roleIds'] = null;
    }
    return json;
  }

  /// Returns a new [UserUpsertRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserUpsertRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserUpsertRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserUpsertRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserUpsertRequest(
        firstName: mapValueOfType<String>(json, r'firstName')!,
        lastName: mapValueOfType<String>(json, r'lastName')!,
        picture: mapValueOfType<String>(json, r'picture'),
        email: mapValueOfType<String>(json, r'email')!,
        username: mapValueOfType<String>(json, r'username')!,
        phoneNumber: mapValueOfType<String>(json, r'phoneNumber'),
        genderId: mapValueOfType<int>(json, r'genderId')!,
        cityId: mapValueOfType<int>(json, r'cityId')!,
        isActive: mapValueOfType<bool>(json, r'isActive'),
        password: mapValueOfType<String>(json, r'password'),
        oldPassword: mapValueOfType<String>(json, r'oldPassword'),
        roleIds: json[r'roleIds'] is Iterable
            ? (json[r'roleIds'] as Iterable).cast<int>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<UserUpsertRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserUpsertRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserUpsertRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserUpsertRequest> mapFromJson(dynamic json) {
    final map = <String, UserUpsertRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserUpsertRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserUpsertRequest-objects as value to a dart map
  static Map<String, List<UserUpsertRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserUpsertRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserUpsertRequest.listFromJson(entry.value, growable: growable,);
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
  };
}

