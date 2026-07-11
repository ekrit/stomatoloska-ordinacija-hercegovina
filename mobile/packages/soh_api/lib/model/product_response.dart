//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ProductResponse {
  /// Returns a new [ProductResponse] instance.
  ProductResponse({
    this.id,
    this.name,
    this.description,
    this.price,
    this.productCategoryId,
    this.productCategoryName,
    this.picture,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? id;

  String? name;

  String? description;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? price;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? productCategoryId;

  String? productCategoryName;

  String? picture;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProductResponse &&
    other.id == id &&
    other.name == name &&
    other.description == description &&
    other.price == price &&
    other.productCategoryId == productCategoryId &&
    other.productCategoryName == productCategoryName &&
    other.picture == picture;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (name == null ? 0 : name!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (price == null ? 0 : price!.hashCode) +
    (productCategoryId == null ? 0 : productCategoryId!.hashCode) +
    (productCategoryName == null ? 0 : productCategoryName!.hashCode) +
    (picture == null ? 0 : picture!.hashCode);

  @override
  String toString() => 'ProductResponse[id=$id, name=$name, description=$description, price=$price, productCategoryId=$productCategoryId, productCategoryName=$productCategoryName, picture=$picture]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.price != null) {
      json[r'price'] = this.price;
    } else {
      json[r'price'] = null;
    }
    if (this.productCategoryId != null) {
      json[r'productCategoryId'] = this.productCategoryId;
    } else {
      json[r'productCategoryId'] = null;
    }
    if (this.productCategoryName != null) {
      json[r'productCategoryName'] = this.productCategoryName;
    } else {
      json[r'productCategoryName'] = null;
    }
    if (this.picture != null) {
      json[r'picture'] = this.picture;
    } else {
      json[r'picture'] = null;
    }
    return json;
  }

  /// Returns a new [ProductResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProductResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ProductResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ProductResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ProductResponse(
        id: mapValueOfType<int>(json, r'id'),
        name: mapValueOfType<String>(json, r'name'),
        description: mapValueOfType<String>(json, r'description'),
        price: mapValueOfType<double>(json, r'price'),
        productCategoryId: mapValueOfType<int>(json, r'productCategoryId'),
        productCategoryName: mapValueOfType<String>(json, r'productCategoryName'),
        picture: mapValueOfType<String>(json, r'picture'),
      );
    }
    return null;
  }

  static List<ProductResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProductResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProductResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProductResponse> mapFromJson(dynamic json) {
    final map = <String, ProductResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProductResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProductResponse-objects as value to a dart map
  static Map<String, List<ProductResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProductResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProductResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

