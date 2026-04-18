import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../data/models/appointment_stats.dart';

class MonthlyAppointmentsChart extends StatelessWidget {
  const MonthlyAppointmentsChart({
    super.key,
    required this.stats,
  });

  final AppointmentStats stats;

  @override
  Widget build(BuildContext context) {
    if (stats.monthly.isEmpty) {
      return const Center(child: Text('No appointment data.'));
    }

    final spots = <FlSpot>[
      for (var i = 0; i < stats.monthly.length; i++)
        FlSpot(i.toDouble(), stats.monthly[i].count.toDouble()),
    ];

    final maxCount = spots.isEmpty
        ? 0.0
        : spots.map((s) => s.y).reduce(math.max);
    final chartMaxY = maxCount <= 0 ? 4.0 : math.max(4.0, (maxCount * 1.15).ceilToDouble());
    final tickInterval = chartMaxY <= 5
        ? 1.0
        : chartMaxY <= 12
            ? 2.0
            : chartMaxY <= 30
                ? 5.0
                : (chartMaxY / 5).ceilToDouble();

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: chartMaxY,
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              interval: tickInterval,
              getTitlesWidget: (value, meta) {
                final v = value.round();
                if (v < 0 || v > meta.max) {
                  return const SizedBox.shrink();
                }
                if ((value - v).abs() > 0.01) {
                  return const SizedBox.shrink();
                }
                return Text(v.toString());
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= stats.monthly.length) {
                  return const SizedBox.shrink();
                }
                return Text(stats.monthly[index].month);
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            ),
            spots: spots,
          ),
        ],
      ),
    );
  }
}
