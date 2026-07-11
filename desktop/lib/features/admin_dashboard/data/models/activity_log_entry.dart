class ActivityLogEntry {
  const ActivityLogEntry({
    required this.id,
    required this.action,
    required this.entityName,
    this.entityId,
    this.username,
    required this.createdAt,
  });

  final int id;
  final String action;
  final String entityName;
  final String? entityId;
  final String? username;
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
      username: json['username'] as String?,
      createdAt: createdAt,
    );
  }
}

/// Recent slice of the activity log plus the true total number of logged
/// actions (the server counts beyond the returned page).
class RecentActivity {
  const RecentActivity({required this.items, required this.totalCount});

  final List<ActivityLogEntry> items;
  final int totalCount;

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(ActivityLogEntry.fromJson)
            .toList()
        : <ActivityLogEntry>[];
    return RecentActivity(
      items: items,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? items.length,
    );
  }
}
