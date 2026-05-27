//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReviewUpsertRequest {
  /// Returns a new [ReviewUpsertRequest] instance.
  ReviewUpsertRequest({
    required this.appointmentId,
    required this.patientId,
    required this.doctorId,
    required this.rating,
    this.comment,
  });

  int appointmentId;

  int patientId;

  int doctorId;

  int rating;

  String? comment;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReviewUpsertRequest &&
    other.appointmentId == appointmentId &&
    other.patientId == patientId &&
    other.doctorId == doctorId &&
    other.rating == rating &&
    other.comment == comment;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (appointmentId.hashCode) +
    (patientId.hashCode) +
    (doctorId.hashCode) +
    (rating.hashCode) +
    (comment == null ? 0 : comment!.hashCode);

  @override
  String toString() => 'ReviewUpsertRequest[appointmentId=$appointmentId, patientId=$patientId, doctorId=$doctorId, rating=$rating, comment=$comment]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'appointmentId'] = this.appointmentId;
      json[r'patientId'] = this.patientId;
      json[r'doctorId'] = this.doctorId;
      json[r'rating'] = this.rating;
    if (this.comment != null) {
      json[r'comment'] = this.comment;
    } else {
      json[r'comment'] = null;
    }
    return json;
  }

  /// Returns a new [ReviewUpsertRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReviewUpsertRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ReviewUpsertRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ReviewUpsertRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ReviewUpsertRequest(
        appointmentId: mapValueOfType<int>(json, r'appointmentId')!,
        patientId: mapValueOfType<int>(json, r'patientId')!,
        doctorId: mapValueOfType<int>(json, r'doctorId')!,
        rating: mapValueOfType<int>(json, r'rating')!,
        comment: mapValueOfType<String>(json, r'comment'),
      );
    }
    return null;
  }

  static List<ReviewUpsertRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReviewUpsertRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReviewUpsertRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReviewUpsertRequest> mapFromJson(dynamic json) {
    final map = <String, ReviewUpsertRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReviewUpsertRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReviewUpsertRequest-objects as value to a dart map
  static Map<String, List<ReviewUpsertRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReviewUpsertRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReviewUpsertRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'appointmentId',
    'patientId',
    'doctorId',
    'rating',
  };
}

