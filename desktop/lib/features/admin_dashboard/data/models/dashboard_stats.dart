class DashboardStats {
  const DashboardStats({
    required this.activeUsers,
    required this.totalDoctors,
    required this.totalPractices,
    required this.totalRooms,
    required this.totalUsers,
    required this.completedAppointments,
    required this.cancelledAppointments,
    required this.averageEarnings,
    required this.newPatientsThisMonth,
    required this.revenueGrowth,
  });

  final int activeUsers;
  final int totalDoctors;
  final int totalPractices;
  final int totalRooms;
  final int totalUsers;
  final int completedAppointments;
  final int cancelledAppointments;
  final double averageEarnings;
  final int newPatientsThisMonth;
  final double revenueGrowth;

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    final practices = json['totalPractices'] as int? ?? 0;
    final rooms = json['totalRooms'] as int? ?? practices;
    return DashboardStats(
      activeUsers: json['activeUsers'] as int? ?? 0,
      totalDoctors: json['totalDoctors'] as int? ?? 0,
      totalPractices: practices,
      totalRooms: rooms,
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
      'activeUsers': activeUsers,
      'totalDoctors': totalDoctors,
      'totalPractices': totalPractices,
      'totalRooms': totalRooms,
      'totalUsers': totalUsers,
      'completedAppointments': completedAppointments,
      'cancelledAppointments': cancelledAppointments,
      'averageEarnings': averageEarnings,
      'newPatientsThisMonth': newPatientsThisMonth,
      'revenueGrowth': revenueGrowth,
    };
  }
}
