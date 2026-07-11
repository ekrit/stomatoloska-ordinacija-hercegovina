//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RecommendedProductResponse {
  /// Returns a new [RecommendedProductResponse] instance.
  RecommendedProductResponse({
    this.product,
    this.reasons = const [],
    this.score,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ProductResponse? product;

  List<String>? reasons;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? score;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RecommendedProductResponse &&
    other.product == product &&
    _deepEquality.equals(other.reasons, reasons) &&
    other.score == score;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (product == null ? 0 : product!.hashCode) +
    (reasons == null ? 0 : reasons!.hashCode) +
    (score == null ? 0 : score!.hashCode);

  @override
  String toString() => 'RecommendedProductResponse[product=$product, reasons=$reasons, score=$score]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.product != null) {
      json[r'product'] = this.product;
    } else {
      json[r'product'] = null;
    }
    if (this.reasons != null) {
      json[r'reasons'] = this.reasons;
    } else {
      json[r'reasons'] = null;
    }
    if (this.score != null) {
      json[r'score'] = this.score;
    } else {
      json[r'score'] = null;
    }
    return json;
  }

  /// Returns a new [RecommendedProductResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RecommendedProductResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RecommendedProductResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RecommendedProductResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RecommendedProductResponse(
        product: ProductResponse.fromJson(json[r'product']),
        reasons: json[r'reasons'] is Iterable
            ? (json[r'reasons'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        score: mapValueOfType<double>(json, r'score'),
      );
    }
    return null;
  }

  static List<RecommendedProductResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RecommendedProductResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RecommendedProductResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RecommendedProductResponse> mapFromJson(dynamic json) {
    final map = <String, RecommendedProductResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RecommendedProductResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RecommendedProductResponse-objects as value to a dart map
  static Map<String, List<RecommendedProductResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RecommendedProductResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RecommendedProductResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

