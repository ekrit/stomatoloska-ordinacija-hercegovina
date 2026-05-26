class ActivityLogEntry {
  const ActivityLogEntry({
    required this.id,
    required this.action,
    required this.entityName,
    this.entityId,
    required this.createdAt,
  });

  final int id;
  final String action;
  final String entityName;
  final String? entityId;
  final DateTime createdAt;

  factory ActivityLogEntry.fromJson(Map<String, dynamic> json) {
    final createdRaw = json['createdAt'];
    DateTime createdAt;
    if (createdRaw is String) {
      createdAt = DateTime.tryParse(createdRaw)?.toLocal() ?? DateTime.fromMillisecondsSinceEpoch(0);
    } else {
      createdAt = DateTime.fromMillisecondsSinceEpoch(0);
    }

    return ActivityLogEntry(
      id: (json['id'] as num?)?.toInt() ?? 0,
      action: json['action'] as String? ?? '',
      entityName: json['entityName'] as String? ?? '',
      entityId: json['entityId'] as String?,
      createdAt: createdAt,
    );
  }
}
