//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ActivityLogResponse {
  /// Returns a new [ActivityLogResponse] instance.
  ActivityLogResponse({
    this.id,
    this.action,
    this.entityName,
    this.entityId,
    this.userId,
    this.username,
    this.createdAt,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? id;

  String? action;

  String? entityName;

  String? entityId;

  int? userId;

  String? username;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ActivityLogResponse &&
    other.id == id &&
    other.action == action &&
    other.entityName == entityName &&
    other.entityId == entityId &&
    other.userId == userId &&
    other.username == username &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (action == null ? 0 : action!.hashCode) +
    (entityName == null ? 0 : entityName!.hashCode) +
    (entityId == null ? 0 : entityId!.hashCode) +
    (userId == null ? 0 : userId!.hashCode) +
    (username == null ? 0 : username!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode);

  @override
  String toString() => 'ActivityLogResponse[id=$id, action=$action, entityName=$entityName, entityId=$entityId, userId=$userId, username=$username, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.action != null) {
      json[r'action'] = this.action;
    } else {
      json[r'action'] = null;
    }
    if (this.entityName != null) {
      json[r'entityName'] = this.entityName;
    } else {
      json[r'entityName'] = null;
    }
    if (this.entityId != null) {
      json[r'entityId'] = this.entityId;
    } else {
      json[r'entityId'] = null;
    }
    if (this.userId != null) {
      json[r'userId'] = this.userId;
    } else {
      json[r'userId'] = null;
    }
    if (this.username != null) {
      json[r'username'] = this.username;
    } else {
      json[r'username'] = null;
    }
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt!.toUtc().toIso8601String();
    } else {
      json[r'createdAt'] = null;
    }
    return json;
  }

  /// Returns a new [ActivityLogResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ActivityLogResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ActivityLogResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ActivityLogResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ActivityLogResponse(
        id: mapValueOfType<int>(json, r'id'),
        action: mapValueOfType<String>(json, r'action'),
        entityName: mapValueOfType<String>(json, r'entityName'),
        entityId: mapValueOfType<String>(json, r'entityId'),
        userId: mapValueOfType<int>(json, r'userId'),
        username: mapValueOfType<String>(json, r'username'),
        createdAt: mapDateTime(json, r'createdAt', r''),
      );
    }
    return null;
  }

  static List<ActivityLogResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ActivityLogResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ActivityLogResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ActivityLogResponse> mapFromJson(dynamic json) {
    final map = <String, ActivityLogResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ActivityLogResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ActivityLogResponse-objects as value to a dart map
  static Map<String, List<ActivityLogResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ActivityLogResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ActivityLogResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

