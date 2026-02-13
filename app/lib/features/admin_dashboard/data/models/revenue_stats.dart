class RevenueStats {
  const RevenueStats({required this.categories});

  final List<RevenueCategory> categories;

  factory RevenueStats.fromJson(Map<String, dynamic> json) {
    final raw = json['categories'] as List<dynamic>? ?? [];
    return RevenueStats(
      categories: raw
          .map((item) => RevenueCategory.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((item) => item.toJson()).toList(),
    };
  }
}

class RevenueCategory {
  const RevenueCategory({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;

  factory RevenueCategory.fromJson(Map<String, dynamic> json) {
    return RevenueCategory(
      label: json['label'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
    };
  }
}
