//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DoctorNoteResponsePagedResult {
  /// Returns a new [DoctorNoteResponsePagedResult] instance.
  DoctorNoteResponsePagedResult({
    this.items = const [],
    this.totalCount,
  });

  List<DoctorNoteResponse>? items;

  int? totalCount;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DoctorNoteResponsePagedResult &&
    _deepEquality.equals(other.items, items) &&
    other.totalCount == totalCount;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (items == null ? 0 : items!.hashCode) +
    (totalCount == null ? 0 : totalCount!.hashCode);

  @override
  String toString() => 'DoctorNoteResponsePagedResult[items=$items, totalCount=$totalCount]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.items != null) {
      json[r'items'] = this.items;
    } else {
      json[r'items'] = null;
    }
    if (this.totalCount != null) {
      json[r'totalCount'] = this.totalCount;
    } else {
      json[r'totalCount'] = null;
    }
    return json;
  }

  /// Returns a new [DoctorNoteResponsePagedResult] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DoctorNoteResponsePagedResult? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DoctorNoteResponsePagedResult[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DoctorNoteResponsePagedResult[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DoctorNoteResponsePagedResult(
        items: DoctorNoteResponse.listFromJson(json[r'items']),
        totalCount: mapValueOfType<int>(json, r'totalCount'),
      );
    }
    return null;
  }

  static List<DoctorNoteResponsePagedResult> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DoctorNoteResponsePagedResult>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DoctorNoteResponsePagedResult.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DoctorNoteResponsePagedResult> mapFromJson(dynamic json) {
    final map = <String, DoctorNoteResponsePagedResult>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DoctorNoteResponsePagedResult.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DoctorNoteResponsePagedResult-objects as value to a dart map
  static Map<String, List<DoctorNoteResponsePagedResult>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DoctorNoteResponsePagedResult>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DoctorNoteResponsePagedResult.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

