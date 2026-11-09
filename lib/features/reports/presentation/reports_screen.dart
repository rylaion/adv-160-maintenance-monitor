import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/expense_service.dart';
import '../../../shared/widgets/measurement_trend_chart.dart';
import '../../components/domain/component_models.dart';
import '../../components/presentation/components_view_model.dart';
import '../../maintenance/presentation/status_text.dart';
import 'reports_view_model.dart';

/// Expenses and Reports screen (Module I):
/// - Monthly maintenance expenses (bar chart + table)
/// - Annual maintenance expenses (bar chart + table)
/// - Expenses by category
/// - Parts replacement vs. labor expenses
/// - Maintenance cost per kilometer
/// - Component measurement trends
class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(expenseReportProvider);
    final measurementsAsync = ref.watch(componentMeasurementsProvider(null));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Expenses & Reports'),
          actions: [
            IconButton(
              tooltip: 'Reminders & notifications',
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => context.push('/reminders'),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Expenses & Cost/km'),
              Tab(text: 'Component Trends'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            reportAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Could not load report: $e')),
              data: (summary) => _ExpenseReportTab(summary: summary),
            ),
            measurementsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (list) => _ComponentTrendsTab(measurements: list),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseReportTab extends StatelessWidget {
  const _ExpenseReportTab({required this.summary});
  final ExpenseReportSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = summary;
    final costPerKmText = s.costPerKmCentavos == null
        ? '— (record at least two odometer readings with distance > 0)'
        : '${StatusText.pesos(s.costPerKmCentavos!.round())} / km';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Expense Summary', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                _StatRow('Total maintenance expenses',
                    StatusText.pesos(s.totalExpensesCentavos)),
                _StatRow('Parts replacement expenses',
                    StatusText.pesos(s.partsReplacementCentavos)),
                _StatRow('Labor expenses',
                    StatusText.pesos(s.laborExpensesCentavos)),
                const Divider(height: 20),
                _StatRow(
                  'Tracked distance',
                  s.trackedDistanceKm == null
                      ? '—'
                      : StatusText.km(s.trackedDistanceKm!),
                ),
                _StatRow('Maintenance cost per km', costPerKmText),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Monthly Maintenance Expenses',
            style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (s.monthly.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No monthly expense records yet.'),
            ),
          )
        else ...[
          _BarChartCard(
            labels: [for (final m in s.monthly) m.label],
            valuesPesos: [for (final m in s.monthly) m.totalCentavos / 100.0],
          ),
          Card(
            child: Column(
              children: [
                for (final m in s.monthly)
                  ListTile(
                    dense: true,
                    title: Text(m.label),
                    trailing: Text(StatusText.pesos(m.totalCentavos)),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        Text('Annual Maintenance Expenses', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (s.annual.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No annual expense records yet.'),
            ),
          )
        else ...[
          _BarChartCard(
            labels: [for (final a in s.annual) '${a.year}'],
            valuesPesos: [for (final a in s.annual) a.totalCentavos / 100.0],
          ),
          Card(
            child: Column(
              children: [
                for (final a in s.annual)
                  ListTile(
                    dense: true,
                    title: Text('${a.year}'),
                    trailing: Text(StatusText.pesos(a.totalCentavos)),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        Text('Expenses by Category', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (s.byCategory.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No category expenses recorded yet.'),
            ),
          )
        else
          Card(
            child: Column(
              children: [
                for (final c in s.byCategory)
                  ListTile(
                    dense: true,
                    title: Text(c.categoryName),
                    trailing: Text(StatusText.pesos(c.totalCentavos)),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}

class _BarChartCard extends StatelessWidget {
  const _BarChartCard({
    required this.labels,
    required this.valuesPesos,
  });

  final List<String> labels;
  final List<double> valuesPesos;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxV = valuesPesos.fold<double>(0, (a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              maxY: maxV <= 0 ? 100 : maxV * 1.2,
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, _) {
                      final idx = v.round();
                      if (idx < 0 || idx >= labels.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          labels[idx],
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                for (var i = 0; i < valuesPesos.length; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: valuesPesos[i],
                        color: scheme.primary,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ComponentTrendsTab extends StatelessWidget {
  const _ComponentTrendsTab({required this.measurements});
  final List<ComponentMeasurement> measurements;

  @override
  Widget build(BuildContext context) {
    final cvt = measurements
        .where((m) =>
            m.measurementType == MeasurementType.thicknessMm &&
            m.position == null)
        .toList();
    final frontPads = measurements
        .where((m) =>
            m.measurementType == MeasurementType.thicknessMm &&
            m.position == 'FRONT')
        .toList();
    final rearPads = measurements
        .where((m) =>
            m.measurementType == MeasurementType.thicknessMm &&
            m.position == 'REAR')
        .toList();
    final voltage = measurements
        .where((m) => m.measurementType == MeasurementType.voltageV)
        .toList();
    final pressure = measurements
        .where((m) => m.measurementType == MeasurementType.pressureKpa)
        .toList();
    final tread = measurements
        .where((m) => m.measurementType == MeasurementType.treadDepthMm)
        .toList();

    final hasAnyNumeric = cvt.isNotEmpty ||
        frontPads.isNotEmpty ||
        rearPads.isNotEmpty ||
        voltage.isNotEmpty ||
        pressure.isNotEmpty ||
        tread.isNotEmpty;

    if (!hasAnyNumeric) {
      return const Center(
        child: Text('No numeric component measurements recorded yet.'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (cvt.isNotEmpty)
          MeasurementTrendChart(
              measurements: cvt, unit: 'mm', title: 'CVT Belt Thickness'),
        if (frontPads.isNotEmpty)
          MeasurementTrendChart(
              measurements: frontPads,
              unit: 'mm',
              title: 'Front Brake Pad Thickness'),
        if (rearPads.isNotEmpty)
          MeasurementTrendChart(
              measurements: rearPads,
              unit: 'mm',
              title: 'Rear Brake Pad Thickness'),
        if (voltage.isNotEmpty)
          MeasurementTrendChart(
              measurements: voltage, unit: 'V', title: 'Battery Voltage'),
        if (pressure.isNotEmpty)
          MeasurementTrendChart(
              measurements: pressure, unit: 'kPa', title: 'Tire Pressure'),
        if (tread.isNotEmpty)
          MeasurementTrendChart(
              measurements: tread, unit: 'mm', title: 'Tire Tread Depth'),
      ],
    );
  }
}
