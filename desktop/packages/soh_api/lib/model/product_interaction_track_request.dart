//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ProductInteractionTrackRequest {
  /// Returns a new [ProductInteractionTrackRequest] instance.
  ProductInteractionTrackRequest({
    required this.productId,
    required this.kind,
  });

  int productId;

  String kind;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProductInteractionTrackRequest &&
    other.productId == productId &&
    other.kind == kind;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (productId.hashCode) +
    (kind.hashCode);

  @override
  String toString() => 'ProductInteractionTrackRequest[productId=$productId, kind=$kind]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'productId'] = this.productId;
      json[r'kind'] = this.kind;
    return json;
  }

  /// Returns a new [ProductInteractionTrackRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProductInteractionTrackRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ProductInteractionTrackRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ProductInteractionTrackRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ProductInteractionTrackRequest(
        productId: mapValueOfType<int>(json, r'productId')!,
        kind: mapValueOfType<String>(json, r'kind')!,
      );
    }
    return null;
  }

  static List<ProductInteractionTrackRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProductInteractionTrackRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProductInteractionTrackRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProductInteractionTrackRequest> mapFromJson(dynamic json) {
    final map = <String, ProductInteractionTrackRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProductInteractionTrackRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProductInteractionTrackRequest-objects as value to a dart map
  static Map<String, List<ProductInteractionTrackRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProductInteractionTrackRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProductInteractionTrackRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'productId',
    'kind',
  };
}

