class Doctor {
  const Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.avatarUrl,
  });

  final String id;
  final String name;
  final String specialization;
  final String avatarUrl;

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      specialization: json['specialization'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'avatarUrl': avatarUrl,
    };
  }
}
