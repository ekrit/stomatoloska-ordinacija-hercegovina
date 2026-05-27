//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PaymentUpsertRequest {
  /// Returns a new [PaymentUpsertRequest] instance.
  PaymentUpsertRequest({
    required this.appointmentId,
    required this.amount,
    required this.method,
    this.status,
    this.transactionRef,
  });

  int appointmentId;

  double amount;

  String method;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  PaymentStatus? status;

  String? transactionRef;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PaymentUpsertRequest &&
    other.appointmentId == appointmentId &&
    other.amount == amount &&
    other.method == method &&
    other.status == status &&
    other.transactionRef == transactionRef;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (appointmentId.hashCode) +
    (amount.hashCode) +
    (method.hashCode) +
    (status == null ? 0 : status!.hashCode) +
    (transactionRef == null ? 0 : transactionRef!.hashCode);

  @override
  String toString() => 'PaymentUpsertRequest[appointmentId=$appointmentId, amount=$amount, method=$method, status=$status, transactionRef=$transactionRef]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'appointmentId'] = this.appointmentId;
      json[r'amount'] = this.amount;
      json[r'method'] = this.method;
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
    return json;
  }

  /// Returns a new [PaymentUpsertRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PaymentUpsertRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PaymentUpsertRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PaymentUpsertRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PaymentUpsertRequest(
        appointmentId: mapValueOfType<int>(json, r'appointmentId')!,
        amount: mapValueOfType<double>(json, r'amount')!,
        method: mapValueOfType<String>(json, r'method')!,
        status: PaymentStatus.fromJson(json[r'status']),
        transactionRef: mapValueOfType<String>(json, r'transactionRef'),
      );
    }
    return null;
  }

  static List<PaymentUpsertRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentUpsertRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentUpsertRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PaymentUpsertRequest> mapFromJson(dynamic json) {
    final map = <String, PaymentUpsertRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PaymentUpsertRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PaymentUpsertRequest-objects as value to a dart map
  static Map<String, List<PaymentUpsertRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PaymentUpsertRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PaymentUpsertRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'appointmentId',
    'amount',
    'method',
  };
}

