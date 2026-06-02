//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReportResponse {
  /// Returns a new [ReportResponse] instance.
  ReportResponse({
    this.id,
    this.type,
    this.generatedAt,
    this.filePath,
    this.parameters,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? id;

  String? type;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? generatedAt;

  String? filePath;

  String? parameters;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReportResponse &&
    other.id == id &&
    other.type == type &&
    other.generatedAt == generatedAt &&
    other.filePath == filePath &&
    other.parameters == parameters;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (type == null ? 0 : type!.hashCode) +
    (generatedAt == null ? 0 : generatedAt!.hashCode) +
    (filePath == null ? 0 : filePath!.hashCode) +
    (parameters == null ? 0 : parameters!.hashCode);

  @override
  String toString() => 'ReportResponse[id=$id, type=$type, generatedAt=$generatedAt, filePath=$filePath, parameters=$parameters]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.type != null) {
      json[r'type'] = this.type;
    } else {
      json[r'type'] = null;
    }
    if (this.generatedAt != null) {
      json[r'generatedAt'] = this.generatedAt!.toUtc().toIso8601String();
    } else {
      json[r'generatedAt'] = null;
    }
    if (this.filePath != null) {
      json[r'filePath'] = this.filePath;
    } else {
      json[r'filePath'] = null;
    }
    if (this.parameters != null) {
      json[r'parameters'] = this.parameters;
    } else {
      json[r'parameters'] = null;
    }
    return json;
  }

  /// Returns a new [ReportResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReportResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ReportResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ReportResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ReportResponse(
        id: mapValueOfType<int>(json, r'id'),
        type: mapValueOfType<String>(json, r'type'),
        generatedAt: mapDateTime(json, r'generatedAt', r''),
        filePath: mapValueOfType<String>(json, r'filePath'),
        parameters: mapValueOfType<String>(json, r'parameters'),
      );
    }
    return null;
  }

  static List<ReportResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReportResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReportResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReportResponse> mapFromJson(dynamic json) {
    final map = <String, ReportResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReportResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReportResponse-objects as value to a dart map
  static Map<String, List<ReportResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReportResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReportResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

