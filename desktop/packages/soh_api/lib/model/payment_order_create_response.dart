//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PaymentOrderCreateResponse {
  /// Returns a new [PaymentOrderCreateResponse] instance.
  PaymentOrderCreateResponse({
    this.paymentId,
    this.orderId,
    this.approvalUrl,
    this.amount,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? paymentId;

  String? orderId;

  String? approvalUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? amount;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PaymentOrderCreateResponse &&
    other.paymentId == paymentId &&
    other.orderId == orderId &&
    other.approvalUrl == approvalUrl &&
    other.amount == amount;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (paymentId == null ? 0 : paymentId!.hashCode) +
    (orderId == null ? 0 : orderId!.hashCode) +
    (approvalUrl == null ? 0 : approvalUrl!.hashCode) +
    (amount == null ? 0 : amount!.hashCode);

  @override
  String toString() => 'PaymentOrderCreateResponse[paymentId=$paymentId, orderId=$orderId, approvalUrl=$approvalUrl, amount=$amount]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.paymentId != null) {
      json[r'paymentId'] = this.paymentId;
    } else {
      json[r'paymentId'] = null;
    }
    if (this.orderId != null) {
      json[r'orderId'] = this.orderId;
    } else {
      json[r'orderId'] = null;
    }
    if (this.approvalUrl != null) {
      json[r'approvalUrl'] = this.approvalUrl;
    } else {
      json[r'approvalUrl'] = null;
    }
    if (this.amount != null) {
      json[r'amount'] = this.amount;
    } else {
      json[r'amount'] = null;
    }
    return json;
  }

  /// Returns a new [PaymentOrderCreateResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PaymentOrderCreateResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PaymentOrderCreateResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PaymentOrderCreateResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PaymentOrderCreateResponse(
        paymentId: mapValueOfType<int>(json, r'paymentId'),
        orderId: mapValueOfType<String>(json, r'orderId'),
        approvalUrl: mapValueOfType<String>(json, r'approvalUrl'),
        amount: mapValueOfType<double>(json, r'amount'),
      );
    }
    return null;
  }

  static List<PaymentOrderCreateResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentOrderCreateResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentOrderCreateResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PaymentOrderCreateResponse> mapFromJson(dynamic json) {
    final map = <String, PaymentOrderCreateResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PaymentOrderCreateResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PaymentOrderCreateResponse-objects as value to a dart map
  static Map<String, List<PaymentOrderCreateResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PaymentOrderCreateResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PaymentOrderCreateResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

