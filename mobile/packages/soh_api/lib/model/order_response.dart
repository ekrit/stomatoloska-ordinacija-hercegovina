//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OrderResponse {
  /// Returns a new [OrderResponse] instance.
  OrderResponse({
    this.id,
    this.patientId,
    this.patientFirstName,
    this.patientLastName,
    this.productId,
    this.productName,
    this.productPicture,
    this.quantity,
    this.totalAmount,
    this.createdAt,
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
  int? patientId;

  String? patientFirstName;

  String? patientLastName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? productId;

  String? productName;

  String? productPicture;

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
  double? totalAmount;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OrderResponse &&
    other.id == id &&
    other.patientId == patientId &&
    other.patientFirstName == patientFirstName &&
    other.patientLastName == patientLastName &&
    other.productId == productId &&
    other.productName == productName &&
    other.productPicture == productPicture &&
    other.quantity == quantity &&
    other.totalAmount == totalAmount &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (patientId == null ? 0 : patientId!.hashCode) +
    (patientFirstName == null ? 0 : patientFirstName!.hashCode) +
    (patientLastName == null ? 0 : patientLastName!.hashCode) +
    (productId == null ? 0 : productId!.hashCode) +
    (productName == null ? 0 : productName!.hashCode) +
    (productPicture == null ? 0 : productPicture!.hashCode) +
    (quantity == null ? 0 : quantity!.hashCode) +
    (totalAmount == null ? 0 : totalAmount!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode);

  @override
  String toString() => 'OrderResponse[id=$id, patientId=$patientId, patientFirstName=$patientFirstName, patientLastName=$patientLastName, productId=$productId, productName=$productName, productPicture=$productPicture, quantity=$quantity, totalAmount=$totalAmount, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.patientId != null) {
      json[r'patientId'] = this.patientId;
    } else {
      json[r'patientId'] = null;
    }
    if (this.patientFirstName != null) {
      json[r'patientFirstName'] = this.patientFirstName;
    } else {
      json[r'patientFirstName'] = null;
    }
    if (this.patientLastName != null) {
      json[r'patientLastName'] = this.patientLastName;
    } else {
      json[r'patientLastName'] = null;
    }
    if (this.productId != null) {
      json[r'productId'] = this.productId;
    } else {
      json[r'productId'] = null;
    }
    if (this.productName != null) {
      json[r'productName'] = this.productName;
    } else {
      json[r'productName'] = null;
    }
    if (this.productPicture != null) {
      json[r'productPicture'] = this.productPicture;
    } else {
      json[r'productPicture'] = null;
    }
    if (this.quantity != null) {
      json[r'quantity'] = this.quantity;
    } else {
      json[r'quantity'] = null;
    }
    if (this.totalAmount != null) {
      json[r'totalAmount'] = this.totalAmount;
    } else {
      json[r'totalAmount'] = null;
    }
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt!.toUtc().toIso8601String();
    } else {
      json[r'createdAt'] = null;
    }
    return json;
  }

  /// Returns a new [OrderResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OrderResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "OrderResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "OrderResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return OrderResponse(
        id: mapValueOfType<int>(json, r'id'),
        patientId: mapValueOfType<int>(json, r'patientId'),
        patientFirstName: mapValueOfType<String>(json, r'patientFirstName'),
        patientLastName: mapValueOfType<String>(json, r'patientLastName'),
        productId: mapValueOfType<int>(json, r'productId'),
        productName: mapValueOfType<String>(json, r'productName'),
        productPicture: mapValueOfType<String>(json, r'productPicture'),
        quantity: mapValueOfType<int>(json, r'quantity'),
        totalAmount: mapValueOfType<double>(json, r'totalAmount'),
        createdAt: mapDateTime(json, r'createdAt', r''),
      );
    }
    return null;
  }

  static List<OrderResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OrderResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OrderResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OrderResponse> mapFromJson(dynamic json) {
    final map = <String, OrderResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OrderResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OrderResponse-objects as value to a dart map
  static Map<String, List<OrderResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OrderResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OrderResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

