//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ProductUpsertRequest {
  /// Returns a new [ProductUpsertRequest] instance.
  ProductUpsertRequest({
    required this.name,
    this.description,
    required this.price,
    required this.productCategoryId,
    this.picture,
  });

  String name;

  String? description;

  double price;

  int productCategoryId;

  String? picture;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProductUpsertRequest &&
    other.name == name &&
    other.description == description &&
    other.price == price &&
    other.productCategoryId == productCategoryId &&
    other.picture == picture;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (price.hashCode) +
    (productCategoryId.hashCode) +
    (picture == null ? 0 : picture!.hashCode);

  @override
  String toString() => 'ProductUpsertRequest[name=$name, description=$description, price=$price, productCategoryId=$productCategoryId, picture=$picture]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
      json[r'price'] = this.price;
      json[r'productCategoryId'] = this.productCategoryId;
    if (this.picture != null) {
      json[r'picture'] = this.picture;
    } else {
      json[r'picture'] = null;
    }
    return json;
  }

  /// Returns a new [ProductUpsertRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProductUpsertRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ProductUpsertRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ProductUpsertRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ProductUpsertRequest(
        name: mapValueOfType<String>(json, r'name')!,
        description: mapValueOfType<String>(json, r'description'),
        price: mapValueOfType<double>(json, r'price')!,
        productCategoryId: mapValueOfType<int>(json, r'productCategoryId')!,
        picture: mapValueOfType<String>(json, r'picture'),
      );
    }
    return null;
  }

  static List<ProductUpsertRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProductUpsertRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProductUpsertRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProductUpsertRequest> mapFromJson(dynamic json) {
    final map = <String, ProductUpsertRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProductUpsertRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProductUpsertRequest-objects as value to a dart map
  static Map<String, List<ProductUpsertRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProductUpsertRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProductUpsertRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'price',
    'productCategoryId',
  };
}

