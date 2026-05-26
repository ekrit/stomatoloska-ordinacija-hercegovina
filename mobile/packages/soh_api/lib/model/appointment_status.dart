//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AppointmentStatus {
  /// Instantiate a new enum with the provided [value].
  const AppointmentStatus._(this.value);

  /// The underlying value of this enum member.
  final int value;

  @override
  String toString() => value.toString();

  int toJson() => value;

  static const number1 = AppointmentStatus._(1);
  static const number2 = AppointmentStatus._(2);
  static const number3 = AppointmentStatus._(3);
  static const number4 = AppointmentStatus._(4);
  static const number5 = AppointmentStatus._(5);

  /// List of all possible values in this [enum][AppointmentStatus].
  static const values = <AppointmentStatus>[
    number1,
    number2,
    number3,
    number4,
    number5,
  ];

  static AppointmentStatus? fromJson(dynamic value) => AppointmentStatusTypeTransformer().decode(value);

  static List<AppointmentStatus> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AppointmentStatus>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AppointmentStatus.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AppointmentStatus] to int,
/// and [decode] dynamic data back to [AppointmentStatus].
class AppointmentStatusTypeTransformer {
  factory AppointmentStatusTypeTransformer() => _instance ??= const AppointmentStatusTypeTransformer._();

  const AppointmentStatusTypeTransformer._();

  int encode(AppointmentStatus data) => data.value;

  /// Decodes a [dynamic value][data] to a AppointmentStatus.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AppointmentStatus? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case 1: return AppointmentStatus.number1;
        case 2: return AppointmentStatus.number2;
        case 3: return AppointmentStatus.number3;
        case 4: return AppointmentStatus.number4;
        case 5: return AppointmentStatus.number5;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AppointmentStatusTypeTransformer] instance.
  static AppointmentStatusTypeTransformer? _instance;
}

