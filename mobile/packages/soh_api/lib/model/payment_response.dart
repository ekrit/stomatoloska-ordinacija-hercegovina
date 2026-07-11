//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PaymentResponse {
  /// Returns a new [PaymentResponse] instance.
  PaymentResponse({
    this.id,
    this.appointmentId,
    this.amount,
    this.method,
    this.status,
    this.transactionRef,
    this.payPalOrderId,
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
  int? appointmentId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? amount;

  String? method;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  PaymentStatus? status;

  String? transactionRef;

  String? payPalOrderId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PaymentResponse &&
    other.id == id &&
    other.appointmentId == appointmentId &&
    other.amount == amount &&
    other.method == method &&
    other.status == status &&
    other.transactionRef == transactionRef &&
    other.payPalOrderId == payPalOrderId &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (appointmentId == null ? 0 : appointmentId!.hashCode) +
    (amount == null ? 0 : amount!.hashCode) +
    (method == null ? 0 : method!.hashCode) +
    (status == null ? 0 : status!.hashCode) +
    (transactionRef == null ? 0 : transactionRef!.hashCode) +
    (payPalOrderId == null ? 0 : payPalOrderId!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode);

  @override
  String toString() => 'PaymentResponse[id=$id, appointmentId=$appointmentId, amount=$amount, method=$method, status=$status, transactionRef=$transactionRef, payPalOrderId=$payPalOrderId, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.appointmentId != null) {
      json[r'appointmentId'] = this.appointmentId;
    } else {
      json[r'appointmentId'] = null;
    }
    if (this.amount != null) {
      json[r'amount'] = this.amount;
    } else {
      json[r'amount'] = null;
    }
    if (this.method != null) {
      json[r'method'] = this.method;
    } else {
      json[r'method'] = null;
    }
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
    if (this.transactionRef != null) {
      json[r'transactionRef'] = this.transactionRef;
    } else {
      json[r'transactionRef'] = null;
    }
    if (this.payPalOrderId != null) {
      json[r'payPalOrderId'] = this.payPalOrderId;
    } else {
      json[r'payPalOrderId'] = null;
    }
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt!.toUtc().toIso8601String();
    } else {
      json[r'createdAt'] = null;
    }
    return json;
  }

  /// Returns a new [PaymentResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PaymentResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PaymentResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PaymentResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PaymentResponse(
        id: mapValueOfType<int>(json, r'id'),
        appointmentId: mapValueOfType<int>(json, r'appointmentId'),
        amount: mapValueOfType<double>(json, r'amount'),
        method: mapValueOfType<String>(json, r'method'),
        status: PaymentStatus.fromJson(json[r'status']),
        transactionRef: mapValueOfType<String>(json, r'transactionRef'),
        payPalOrderId: mapValueOfType<String>(json, r'payPalOrderId'),
        createdAt: mapDateTime(json, r'createdAt', r''),
      );
    }
    return null;
  }

  static List<PaymentResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PaymentResponse> mapFromJson(dynamic json) {
    final map = <String, PaymentResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PaymentResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PaymentResponse-objects as value to a dart map
  static Map<String, List<PaymentResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PaymentResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PaymentResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

