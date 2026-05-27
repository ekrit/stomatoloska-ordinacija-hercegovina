//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OrderItemUpsertRequest {
  /// Returns a new [OrderItemUpsertRequest] instance.
  OrderItemUpsertRequest({
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
  });

  int orderId;

  int productId;

  int quantity;

  double unitPrice;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OrderItemUpsertRequest &&
    other.orderId == orderId &&
    other.productId == productId &&
    other.quantity == quantity &&
    other.unitPrice == unitPrice;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (orderId.hashCode) +
    (productId.hashCode) +
    (quantity.hashCode) +
    (unitPrice.hashCode);

  @override
  String toString() => 'OrderItemUpsertRequest[orderId=$orderId, productId=$productId, quantity=$quantity, unitPrice=$unitPrice]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'orderId'] = this.orderId;
      json[r'productId'] = this.productId;
      json[r'quantity'] = this.quantity;
      json[r'unitPrice'] = this.unitPrice;
    return json;
  }

  /// Returns a new [OrderItemUpsertRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OrderItemUpsertRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "OrderItemUpsertRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "OrderItemUpsertRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return OrderItemUpsertRequest(
        orderId: mapValueOfType<int>(json, r'orderId')!,
        productId: mapValueOfType<int>(json, r'productId')!,
        quantity: mapValueOfType<int>(json, r'quantity')!,
        unitPrice: mapValueOfType<double>(json, r'unitPrice')!,
      );
    }
    return null;
  }

  static List<OrderItemUpsertRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OrderItemUpsertRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OrderItemUpsertRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OrderItemUpsertRequest> mapFromJson(dynamic json) {
    final map = <String, OrderItemUpsertRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OrderItemUpsertRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OrderItemUpsertRequest-objects as value to a dart map
  static Map<String, List<OrderItemUpsertRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OrderItemUpsertRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OrderItemUpsertRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'orderId',
    'productId',
    'quantity',
    'unitPrice',
  };
}

