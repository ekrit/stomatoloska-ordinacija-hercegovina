//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReportUpsertRequest {
  /// Returns a new [ReportUpsertRequest] instance.
  ReportUpsertRequest({
    required this.type,
    required this.generatedAt,
    required this.filePath,
  });

  String type;

  DateTime generatedAt;

  String filePath;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReportUpsertRequest &&
    other.type == type &&
    other.generatedAt == generatedAt &&
    other.filePath == filePath;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (type.hashCode) +
    (generatedAt.hashCode) +
    (filePath.hashCode);

  @override
  String toString() => 'ReportUpsertRequest[type=$type, generatedAt=$generatedAt, filePath=$filePath]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'type'] = this.type;
      json[r'generatedAt'] = this.generatedAt.toUtc().toIso8601String();
      json[r'filePath'] = this.filePath;
    return json;
  }

  /// Returns a new [ReportUpsertRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReportUpsertRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ReportUpsertRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ReportUpsertRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ReportUpsertRequest(
        type: mapValueOfType<String>(json, r'type')!,
        generatedAt: mapDateTime(json, r'generatedAt', r'')!,
        filePath: mapValueOfType<String>(json, r'filePath')!,
      );
    }
    return null;
  }

  static List<ReportUpsertRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReportUpsertRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReportUpsertRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReportUpsertRequest> mapFromJson(dynamic json) {
    final map = <String, ReportUpsertRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReportUpsertRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReportUpsertRequest-objects as value to a dart map
  static Map<String, List<ReportUpsertRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReportUpsertRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReportUpsertRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'type',
    'generatedAt',
    'filePath',
  };
}

