//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OrderItemResponse {
  /// Returns a new [OrderItemResponse] instance.
  OrderItemResponse({
    this.id,
    this.orderId,
    this.productId,
    this.quantity,
    this.unitPrice,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? id;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? orderId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? productId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? quantity;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? unitPrice;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OrderItemResponse &&
    other.id == id &&
    other.orderId == orderId &&
    other.productId == productId &&
    other.quantity == quantity &&
    other.unitPrice == unitPrice;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (orderId == null ? 0 : orderId!.hashCode) +
    (productId == null ? 0 : productId!.hashCode) +
    (quantity == null ? 0 : quantity!.hashCode) +
    (unitPrice == null ? 0 : unitPrice!.hashCode);

  @override
  String toString() => 'OrderItemResponse[id=$id, orderId=$orderId, productId=$productId, quantity=$quantity, unitPrice=$unitPrice]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.orderId != null) {
      json[r'orderId'] = this.orderId;
    } else {
      json[r'orderId'] = null;
    }
    if (this.productId != null) {
      json[r'productId'] = this.productId;
    } else {
      json[r'productId'] = null;
    }
    if (this.quantity != null) {
      json[r'quantity'] = this.quantity;
    } else {
      json[r'quantity'] = null;
    }
    if (this.unitPrice != null) {
      json[r'unitPrice'] = this.unitPrice;
    } else {
      json[r'unitPrice'] = null;
    }
    return json;
  }

  /// Returns a new [OrderItemResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OrderItemResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "OrderItemResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "OrderItemResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return OrderItemResponse(
        id: mapValueOfType<int>(json, r'id'),
        orderId: mapValueOfType<int>(json, r'orderId'),
        productId: mapValueOfType<int>(json, r'productId'),
        quantity: mapValueOfType<int>(json, r'quantity'),
        unitPrice: mapValueOfType<double>(json, r'unitPrice'),
      );
    }
    return null;
  }

  static List<OrderItemResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OrderItemResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OrderItemResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OrderItemResponse> mapFromJson(dynamic json) {
    final map = <String, OrderItemResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OrderItemResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OrderItemResponse-objects as value to a dart map
  static Map<String, List<OrderItemResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OrderItemResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OrderItemResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

