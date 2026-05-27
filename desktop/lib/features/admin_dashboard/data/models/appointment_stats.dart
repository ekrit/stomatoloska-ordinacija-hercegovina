class AppointmentStats {
  const AppointmentStats({required this.monthly});

  final List<MonthlyAppointment> monthly;

  factory AppointmentStats.fromJson(Map<String, dynamic> json) {
    final raw = json['monthly'] as List<dynamic>? ?? [];
    return AppointmentStats(
      monthly: raw
          .map((item) =>
              MonthlyAppointment.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthly': monthly.map((item) => item.toJson()).toList(),
    };
  }
}

class MonthlyAppointment {
  const MonthlyAppointment({
    required this.month,
    required this.count,
  });

  final String month;
  final int count;

  factory MonthlyAppointment.fromJson(Map<String, dynamic> json) {
    return MonthlyAppointment(
      month: json['month'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'count': count,
    };
  }
}
