//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DashboardStatsResponse {
  /// Returns a new [DashboardStatsResponse] instance.
  DashboardStatsResponse({
    this.activeUsers,
    this.totalDoctors,
    this.totalPractices,
    this.totalRooms,
    this.totalUsers,
    this.completedAppointments,
    this.cancelledAppointments,
    this.averageEarnings,
    this.newPatientsThisMonth,
    this.revenueGrowth,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? activeUsers;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? totalDoctors;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? totalPractices;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? totalRooms;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? totalUsers;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? completedAppointments;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? cancelledAppointments;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? averageEarnings;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? newPatientsThisMonth;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? revenueGrowth;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DashboardStatsResponse &&
    other.activeUsers == activeUsers &&
    other.totalDoctors == totalDoctors &&
    other.totalPractices == totalPractices &&
    other.totalRooms == totalRooms &&
    other.totalUsers == totalUsers &&
    other.completedAppointments == completedAppointments &&
    other.cancelledAppointments == cancelledAppointments &&
    other.averageEarnings == averageEarnings &&
    other.newPatientsThisMonth == newPatientsThisMonth &&
    other.revenueGrowth == revenueGrowth;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (activeUsers == null ? 0 : activeUsers!.hashCode) +
    (totalDoctors == null ? 0 : totalDoctors!.hashCode) +
    (totalPractices == null ? 0 : totalPractices!.hashCode) +
    (totalRooms == null ? 0 : totalRooms!.hashCode) +
    (totalUsers == null ? 0 : totalUsers!.hashCode) +
    (completedAppointments == null ? 0 : completedAppointments!.hashCode) +
    (cancelledAppointments == null ? 0 : cancelledAppointments!.hashCode) +
    (averageEarnings == null ? 0 : averageEarnings!.hashCode) +
    (newPatientsThisMonth == null ? 0 : newPatientsThisMonth!.hashCode) +
    (revenueGrowth == null ? 0 : revenueGrowth!.hashCode);

  @override
  String toString() => 'DashboardStatsResponse[activeUsers=$activeUsers, totalDoctors=$totalDoctors, totalPractices=$totalPractices, totalRooms=$totalRooms, totalUsers=$totalUsers, completedAppointments=$completedAppointments, cancelledAppointments=$cancelledAppointments, averageEarnings=$averageEarnings, newPatientsThisMonth=$newPatientsThisMonth, revenueGrowth=$revenueGrowth]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.activeUsers != null) {
      json[r'activeUsers'] = this.activeUsers;
    } else {
      json[r'activeUsers'] = null;
    }
    if (this.totalDoctors != null) {
      json[r'totalDoctors'] = this.totalDoctors;
    } else {
      json[r'totalDoctors'] = null;
    }
    if (this.totalPractices != null) {
      json[r'totalPractices'] = this.totalPractices;
    } else {
      json[r'totalPractices'] = null;
    }
    if (this.totalRooms != null) {
      json[r'totalRooms'] = this.totalRooms;
    } else {
      json[r'totalRooms'] = null;
    }
    if (this.totalUsers != null) {
      json[r'totalUsers'] = this.totalUsers;
    } else {
      json[r'totalUsers'] = null;
    }
    if (this.completedAppointments != null) {
      json[r'completedAppointments'] = this.completedAppointments;
    } else {
      json[r'completedAppointments'] = null;
    }
    if (this.cancelledAppointments != null) {
      json[r'cancelledAppointments'] = this.cancelledAppointments;
    } else {
      json[r'cancelledAppointments'] = null;
    }
    if (this.averageEarnings != null) {
      json[r'averageEarnings'] = this.averageEarnings;
    } else {
      json[r'averageEarnings'] = null;
    }
    if (this.newPatientsThisMonth != null) {
      json[r'newPatientsThisMonth'] = this.newPatientsThisMonth;
    } else {
      json[r'newPatientsThisMonth'] = null;
    }
    if (this.revenueGrowth != null) {
      json[r'revenueGrowth'] = this.revenueGrowth;
    } else {
      json[r'revenueGrowth'] = null;
    }
    return json;
  }

  /// Returns a new [DashboardStatsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DashboardStatsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DashboardStatsResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DashboardStatsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DashboardStatsResponse(
        activeUsers: mapValueOfType<int>(json, r'activeUsers'),
        totalDoctors: mapValueOfType<int>(json, r'totalDoctors'),
        totalPractices: mapValueOfType<int>(json, r'totalPractices'),
        totalRooms: mapValueOfType<int>(json, r'totalRooms'),
        totalUsers: mapValueOfType<int>(json, r'totalUsers'),
        completedAppointments: mapValueOfType<int>(json, r'completedAppointments'),
        cancelledAppointments: mapValueOfType<int>(json, r'cancelledAppointments'),
        averageEarnings: mapValueOfType<double>(json, r'averageEarnings'),
        newPatientsThisMonth: mapValueOfType<int>(json, r'newPatientsThisMonth'),
        revenueGrowth: mapValueOfType<double>(json, r'revenueGrowth'),
      );
    }
    return null;
  }

  static List<DashboardStatsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DashboardStatsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DashboardStatsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DashboardStatsResponse> mapFromJson(dynamic json) {
    final map = <String, DashboardStatsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DashboardStatsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DashboardStatsResponse-objects as value to a dart map
  static Map<String, List<DashboardStatsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DashboardStatsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DashboardStatsResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

