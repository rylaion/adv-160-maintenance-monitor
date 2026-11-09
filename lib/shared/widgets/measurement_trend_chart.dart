import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/utils/date_utils.dart';
import '../../features/components/domain/component_models.dart';

/// Line chart of historical numeric component measurements (chronological).
/// Does not draw any unverified threshold line.
class MeasurementTrendChart extends StatelessWidget {
  const MeasurementTrendChart({
    super.key,
    required this.measurements,
    required this.unit,
    this.title,
  });

  final List<ComponentMeasurement> measurements;
  final String unit;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final pts =
        measurements.where((m) => m.value != null).toList().reversed.toList();
    if (pts.isEmpty) {
      return const SizedBox.shrink();
    }
    final scheme = Theme.of(context).colorScheme;
    final spots = [
      for (var i = 0; i < pts.length; i++) FlSpot(i.toDouble(), pts[i].value!),
    ];
    final values = pts.map((p) => p.value!).toList();
    final minV = values.reduce((a, b) => a < b ? a : b);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final pad = (maxV - minV).abs() < 0.01 ? 1.0 : (maxV - minV) * 0.2;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text('$title ($unit)',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
            ],
            SizedBox(
              height: 160,
              child: LineChart(
                LineChartData(
                  minY: (minV - pad).clamp(0.0, double.infinity),
                  maxY: maxV + pad,
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (v, _) {
                          final idx = v.round();
                          if (idx < 0 || idx >= pts.length) {
                            return const SizedBox.shrink();
                          }
                          final d = pts[idx].measuredDate;
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text('${d.month}/${d.day}',
                                style: Theme.of(context).textTheme.labelSmall),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: false,
                      color: scheme.primary,
                      barWidth: 2.5,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) => [
                        for (final s in touchedSpots)
                          LineTooltipItem(
                            '${pts[s.spotIndex].value!.toStringAsFixed(2)} $unit\n'
                            '${AppDates.formatDate(pts[s.spotIndex].measuredDate)}',
                            TextStyle(color: scheme.onInverseSurface),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
