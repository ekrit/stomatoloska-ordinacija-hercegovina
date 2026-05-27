import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../data/models/revenue_stats.dart';

class RevenueBreakdownChart extends StatelessWidget {
  const RevenueBreakdownChart({
    super.key,
    required this.stats,
  });

  final RevenueStats stats;

  @override
  Widget build(BuildContext context) {
    if (stats.categories.isEmpty) {
      return const Center(child: Text('No revenue data.'));
    }

    final colors = [
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.purple,
    ];

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: [
          for (var i = 0; i < stats.categories.length; i++)
            PieChartSectionData(
              color: colors[i % colors.length],
              value: stats.categories[i].value,
              title: '${stats.categories[i].value.toStringAsFixed(0)}%',
              radius: 70,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
