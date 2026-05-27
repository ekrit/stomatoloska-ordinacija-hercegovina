//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OrderResponsePagedResult {
  /// Returns a new [OrderResponsePagedResult] instance.
  OrderResponsePagedResult({
    this.items = const [],
    this.totalCount,
  });

  List<OrderResponse>? items;

  int? totalCount;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OrderResponsePagedResult &&
    _deepEquality.equals(other.items, items) &&
    other.totalCount == totalCount;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (items == null ? 0 : items!.hashCode) +
    (totalCount == null ? 0 : totalCount!.hashCode);

  @override
  String toString() => 'OrderResponsePagedResult[items=$items, totalCount=$totalCount]';

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

  /// Returns a new [OrderResponsePagedResult] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OrderResponsePagedResult? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "OrderResponsePagedResult[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "OrderResponsePagedResult[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return OrderResponsePagedResult(
        items: OrderResponse.listFromJson(json[r'items']),
        totalCount: mapValueOfType<int>(json, r'totalCount'),
      );
    }
    return null;
  }

  static List<OrderResponsePagedResult> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OrderResponsePagedResult>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OrderResponsePagedResult.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OrderResponsePagedResult> mapFromJson(dynamic json) {
    final map = <String, OrderResponsePagedResult>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OrderResponsePagedResult.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OrderResponsePagedResult-objects as value to a dart map
  static Map<String, List<OrderResponsePagedResult>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OrderResponsePagedResult>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OrderResponsePagedResult.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

