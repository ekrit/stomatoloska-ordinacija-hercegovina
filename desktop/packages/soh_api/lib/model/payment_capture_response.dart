//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PaymentCaptureResponse {
  /// Returns a new [PaymentCaptureResponse] instance.
  PaymentCaptureResponse({
    this.isPaid,
    this.paymentId,
    this.transactionRef,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isPaid;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? paymentId;

  String? transactionRef;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PaymentCaptureResponse &&
    other.isPaid == isPaid &&
    other.paymentId == paymentId &&
    other.transactionRef == transactionRef;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (isPaid == null ? 0 : isPaid!.hashCode) +
    (paymentId == null ? 0 : paymentId!.hashCode) +
    (transactionRef == null ? 0 : transactionRef!.hashCode);

  @override
  String toString() => 'PaymentCaptureResponse[isPaid=$isPaid, paymentId=$paymentId, transactionRef=$transactionRef]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.isPaid != null) {
      json[r'isPaid'] = this.isPaid;
    } else {
      json[r'isPaid'] = null;
    }
    if (this.paymentId != null) {
      json[r'paymentId'] = this.paymentId;
    } else {
      json[r'paymentId'] = null;
    }
    if (this.transactionRef != null) {
      json[r'transactionRef'] = this.transactionRef;
    } else {
      json[r'transactionRef'] = null;
    }
    return json;
  }

  /// Returns a new [PaymentCaptureResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PaymentCaptureResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PaymentCaptureResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PaymentCaptureResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PaymentCaptureResponse(
        isPaid: mapValueOfType<bool>(json, r'isPaid'),
        paymentId: mapValueOfType<int>(json, r'paymentId'),
        transactionRef: mapValueOfType<String>(json, r'transactionRef'),
      );
    }
    return null;
  }

  static List<PaymentCaptureResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaymentCaptureResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaymentCaptureResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PaymentCaptureResponse> mapFromJson(dynamic json) {
    final map = <String, PaymentCaptureResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PaymentCaptureResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PaymentCaptureResponse-objects as value to a dart map
  static Map<String, List<PaymentCaptureResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PaymentCaptureResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PaymentCaptureResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

