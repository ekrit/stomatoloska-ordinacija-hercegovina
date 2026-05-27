//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OrderUpsertRequest {
  /// Returns a new [OrderUpsertRequest] instance.
  OrderUpsertRequest({
    required this.patientId,
    required this.productId,
    this.quantity = 1,
    required this.totalAmount,
  });

  int patientId;

  int productId;

  int quantity;

  double totalAmount;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OrderUpsertRequest &&
    other.patientId == patientId &&
    other.productId == productId &&
    other.quantity == quantity &&
    other.totalAmount == totalAmount;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (patientId.hashCode) +
    (productId.hashCode) +
    (quantity.hashCode) +
    (totalAmount.hashCode);

  @override
  String toString() => 'OrderUpsertRequest[patientId=$patientId, productId=$productId, quantity=$quantity, totalAmount=$totalAmount]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'patientId'] = this.patientId;
      json[r'productId'] = this.productId;
      json[r'quantity'] = this.quantity;
      json[r'totalAmount'] = this.totalAmount;
    return json;
  }

  /// Returns a new [OrderUpsertRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OrderUpsertRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "OrderUpsertRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "OrderUpsertRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return OrderUpsertRequest(
        patientId: mapValueOfType<int>(json, r'patientId')!,
        productId: mapValueOfType<int>(json, r'productId')!,
        quantity: mapValueOfType<int>(json, r'quantity') ?? 1,
        totalAmount: mapValueOfType<double>(json, r'totalAmount')!,
      );
    }
    return null;
  }

  static List<OrderUpsertRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OrderUpsertRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OrderUpsertRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OrderUpsertRequest> mapFromJson(dynamic json) {
    final map = <String, OrderUpsertRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OrderUpsertRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OrderUpsertRequest-objects as value to a dart map
  static Map<String, List<OrderUpsertRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OrderUpsertRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OrderUpsertRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'patientId',
    'productId',
    'totalAmount',
  };
}
