class DashboardStats {
  const DashboardStats({
    required this.totalDoctors,
    required this.totalPractices,
    required this.totalUsers,
    required this.completedAppointments,
    required this.cancelledAppointments,
    required this.averageEarnings,
    required this.newPatientsThisMonth,
    required this.revenueGrowth,
  });

  final int totalDoctors;
  final int totalPractices;
  final int totalUsers;
  final int completedAppointments;
  final int cancelledAppointments;
  final double averageEarnings;
  final int newPatientsThisMonth;
  final double revenueGrowth;

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalDoctors: json['totalDoctors'] as int? ?? 0,
      totalPractices: json['totalPractices'] as int? ?? 0,
      totalUsers: json['totalUsers'] as int? ?? 0,
      completedAppointments: json['completedAppointments'] as int? ?? 0,
      cancelledAppointments: json['cancelledAppointments'] as int? ?? 0,
      averageEarnings: (json['averageEarnings'] as num?)?.toDouble() ?? 0,
      newPatientsThisMonth: json['newPatientsThisMonth'] as int? ?? 0,
      revenueGrowth: (json['revenueGrowth'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalDoctors': totalDoctors,
      'totalPractices': totalPractices,
      'totalUsers': totalUsers,
      'completedAppointments': completedAppointments,
      'cancelledAppointments': cancelledAppointments,
      'averageEarnings': averageEarnings,
      'newPatientsThisMonth': newPatientsThisMonth,
      'revenueGrowth': revenueGrowth,
    };
  }
}
