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

    return LineChart(
      LineChartData(
        minY: 0,
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (value, meta) {
                if (value % 50 != 0) {
                  return const SizedBox.shrink();
                }
                return Text(value.toInt().toString());
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
