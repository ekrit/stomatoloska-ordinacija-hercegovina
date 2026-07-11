//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ProductCategoryResponsePagedResult {
  /// Returns a new [ProductCategoryResponsePagedResult] instance.
  ProductCategoryResponsePagedResult({
    this.items = const [],
    this.totalCount,
  });

  List<ProductCategoryResponse>? items;

  int? totalCount;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProductCategoryResponsePagedResult &&
    _deepEquality.equals(other.items, items) &&
    other.totalCount == totalCount;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (items == null ? 0 : items!.hashCode) +
    (totalCount == null ? 0 : totalCount!.hashCode);

  @override
  String toString() => 'ProductCategoryResponsePagedResult[items=$items, totalCount=$totalCount]';

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

  /// Returns a new [ProductCategoryResponsePagedResult] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProductCategoryResponsePagedResult? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ProductCategoryResponsePagedResult[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ProductCategoryResponsePagedResult[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ProductCategoryResponsePagedResult(
        items: ProductCategoryResponse.listFromJson(json[r'items']),
        totalCount: mapValueOfType<int>(json, r'totalCount'),
      );
    }
    return null;
  }

  static List<ProductCategoryResponsePagedResult> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProductCategoryResponsePagedResult>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProductCategoryResponsePagedResult.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProductCategoryResponsePagedResult> mapFromJson(dynamic json) {
    final map = <String, ProductCategoryResponsePagedResult>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProductCategoryResponsePagedResult.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProductCategoryResponsePagedResult-objects as value to a dart map
  static Map<String, List<ProductCategoryResponsePagedResult>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProductCategoryResponsePagedResult>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProductCategoryResponsePagedResult.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

