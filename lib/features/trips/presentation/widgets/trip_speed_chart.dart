import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../domain/trip_models.dart';

/// Speed vs. elapsed time telemetry chart for a recorded motorcycle trip.
class TripSpeedChart extends StatelessWidget {
  const TripSpeedChart({
    super.key,
    required this.waypoints,
    this.avgSpeedKmh,
    this.maxSpeedKmh,
  });

  final List<TripWaypointItem> waypoints;
  final double? avgSpeedKmh;
  final double? maxSpeedKmh;

  @override
  Widget build(BuildContext context) {
    final validWaypoints = waypoints.where((w) => w.speedKmh != null).toList();

    if (validWaypoints.length < 2) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Speed Telemetry Profile',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Not enough GPS speed data recorded to plot profile.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    final startTime = validWaypoints.first.recordedAt;

    final spots = <FlSpot>[];
    double peakSpeed = maxSpeedKmh ?? 0.0;

    for (int i = 0; i < validWaypoints.length; i++) {
      final wp = validWaypoints[i];
      final elapsedMinutes =
          wp.recordedAt.difference(startTime).inSeconds / 60.0;
      final speed = wp.speedKmh ?? 0.0;
      if (speed > peakSpeed) {
        peakSpeed = speed;
      }
      spots.add(FlSpot(elapsedMinutes, speed));
    }

    final maxMinutes = spots.last.x.clamp(1.0, double.infinity);
    final yMax = (peakSpeed * 1.15).clamp(20.0, 160.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.speed, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Speed Profile (km/h vs Time)',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (peakSpeed > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                      border:
                          Border.all(color: Colors.amber.shade700, width: 1),
                    ),
                    child: Text(
                      'Max: ${peakSpeed.toStringAsFixed(1)} km/h',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 190,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: maxMinutes,
                  minY: 0,
                  maxY: yMax,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: (maxMinutes / 4).clamp(1.0, double.infinity),
                        getTitlesWidget: (val, meta) {
                          if (val < 0 || val > maxMinutes) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            '${val.toStringAsFixed(0)}m',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 20,
                        getTitlesWidget: (val, meta) {
                          return Text(
                            val.toInt().toString(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      if (avgSpeedKmh != null && avgSpeedKmh! > 0)
                        HorizontalLine(
                          y: avgSpeedKmh!,
                          color: theme.colorScheme.secondary,
                          strokeWidth: 1.5,
                          dashArray: [6, 4],
                          label: HorizontalLineLabel(
                            show: true,
                            alignment: Alignment.topRight,
                            padding: const EdgeInsets.only(right: 6, bottom: 2),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.secondary,
                            ),
                            labelResolver: (line) =>
                                'Avg: ${line.y.toStringAsFixed(0)} km/h',
                          ),
                        ),
                    ],
                  ),
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final idx = spot.spotIndex;
                          final wp = validWaypoints[idx];
                          final timeStr =
                              '${wp.recordedAt.hour.toString().padLeft(2, '0')}:${wp.recordedAt.minute.toString().padLeft(2, '0')}:${wp.recordedAt.second.toString().padLeft(2, '0')}';
                          return LineTooltipItem(
                            '${spot.y.toStringAsFixed(1)} km/h\n$timeStr',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.2,
                      color: theme.colorScheme.primary,
                      barWidth: 2.5,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.35),
                            theme.colorScheme.primary.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
