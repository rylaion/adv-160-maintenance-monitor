import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../components/domain/component_models.dart';
import '../../components/presentation/components_view_model.dart';
import '../domain/maintenance_models.dart';
import '../domain/maintenance_overview.dart';
import '../domain/maintenance_snapshot.dart';
import 'maintenance_history_screen.dart';
import 'maintenance_view_model.dart';
import 'status_text.dart';

/// Detailed screen for a single maintenance item (reachable from Dashboard
/// Overdue / Due / Upcoming / Completed items and from the Maintenance tab).
///
/// Displays:
/// 1. Maintenance item name, category, and current status.
/// 2. Scheduled odometer interval (Honda Recommendation + User Custom Interval).
/// 3. Current odometer reading, last completed service, and recommended next
///    service odometer.
/// 4. Primary **Add Maintenance Log** button (pre-populates item, action, and
///    current odometer).
/// 5. **Component Measurement & Wear Specifications** section with verified
///    2023 Honda ADV160 limits (or "Not available in verified manual" +
///    user-definable custom limits) and **Measurement History** table.
/// 6. Service History for this item.
class MaintenanceItemDetailScreen extends ConsumerWidget {
  const MaintenanceItemDetailScreen({super.key, required this.itemId});

  final int itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(maintenanceOverviewProvider);

    return overviewAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Maintenance Details')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Maintenance Details')),
        body: Center(child: Text('Could not load item details: $e')),
      ),
      data: (overview) {
        final itemStatus =
            overview.items.where((i) => i.item.id == itemId).firstOrNull;
        if (itemStatus == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Maintenance Details')),
            body: const Center(child: Text('Maintenance item not found.')),
          );
        }
        return _DetailContent(overview: overview, status: itemStatus);
      },
    );
  }
}

class _DetailContent extends ConsumerWidget {
  const _DetailContent({required this.overview, required this.status});

  final MaintenanceOverview overview;
  final ItemStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final item = status.item;
    final eval = status.evaluation;
    final bikeId = overview.snapshot.motorcycle?.id;
    final currentKm = overview.currentKm;
    final nextEval = eval.next;
    final nextCp = nextEval?.next;
    final lastService = nextEval?.lastService ?? eval.lastService;

    final hondaRules = eval.ruleEvaluations
        .map((r) => r.rule)
        .where((r) => r.isManufacturer && r.isActive)
        .toList();
    final customRule = eval.ruleEvaluations
        .map((r) => r.rule)
        .where((r) => !r.isManufacturer && r.isActive)
        .firstOrNull;

    final defaultAction =
        (nextCp?.actionCode ?? customRule?.actionCode ?? ActionCode.inspect)
            .defaultMaintenanceAction
            .code;

    final measurements =
        ref.watch(componentMeasurementsProvider(item.id)).valueOrNull ??
            const [];
    final userSpecs =
        ref.watch(userComponentSpecsProvider).valueOrNull ?? const {};
    final historyAsync = ref.watch(itemHistoryProvider(item.id));

    final specDefs = ComponentSpecDefinition.specsForItem(
      itemId: item.id,
      itemName: item.name,
    );
    final evaluatedSpecs = [
      for (final def in specDefs)
        EvaluatedComponentSpec.evaluate(
          definition: def,
          userSpec: userSpecs[def.specKey],
          itemMeasurements: measurements,
        ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        actions: [
          if (item.isUserDefined && item.name != 'Fuel Filter')
            IconButton(
              tooltip: 'Delete custom item',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmDeleteCustomItem(context, ref, item),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Summary & Schedule Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: theme.textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              [
                                status.category.name,
                                if (item.isUserDefined)
                                  'User-defined Custom Item'
                                else
                                  'Honda ADV160 Schedule Item',
                              ].join(' · '),
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (eval.hasSchedule) StatusChip(status: eval.status),
                    ],
                  ),
                  if (item.instructions != null &&
                      item.instructions!.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(item.instructions!, style: theme.textTheme.bodySmall),
                  ],
                  const Divider(height: 24),
                  _InfoRow(
                    label: 'Current odometer reading',
                    value: currentKm == null
                        ? 'Not recorded'
                        : StatusText.km(currentKm),
                  ),
                  const SizedBox(height: 6),
                  _InfoRow(
                    label: 'Scheduled odometer interval',
                    value: customRule != null
                        ? StatusText.ruleIntervalDescription(customRule)
                        : (hondaRules.isNotEmpty
                            ? hondaRules
                                .map(StatusText.ruleIntervalDescription)
                                .join(' · ')
                            : 'No fixed interval configured'),
                  ),
                  if (hondaRules.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _InfoRow(
                      label: 'Honda Recommendation',
                      value: hondaRules
                          .map(StatusText.ruleIntervalDescription)
                          .join(' · '),
                    ),
                  ],
                  if (customRule != null) ...[
                    const SizedBox(height: 6),
                    _InfoRow(
                      label: 'Your Custom Interval',
                      value: StatusText.ruleIntervalDescription(customRule),
                      highlight: true,
                    ),
                  ],
                  const SizedBox(height: 6),
                  _InfoRow(
                    label: 'Last completed service',
                    value: lastService == null
                        ? 'Not recorded'
                        : '${StatusText.km(lastService.odometerKm)} '
                            '(${AppDates.formatDate(lastService.date)})',
                  ),
                  const SizedBox(height: 6),
                  _InfoRow(
                    label: 'Recommended next service odometer',
                    value: nextCp?.dueKm != null
                        ? '${StatusText.km(nextCp!.dueKm!)}'
                            '${nextEval?.remainingKm != null ? ' (${StatusText.remainingKm(nextEval!.remainingKm!)})' : ''}'
                        : (nextCp?.dueDate != null
                            ? 'By ${AppDates.formatDate(nextCp!.dueDate!)}'
                                '${nextEval?.remainingDays != null ? ' (${StatusText.remainingDays(nextEval!.remainingDays!)})' : ''}'
                            : '—'),
                    highlight: true,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      key: const Key('add_maintenance_log_button'),
                      onPressed: () => context.push(
                        '/maintenance/record?itemId=${item.id}'
                        '&action=$defaultAction'
                        '${currentKm != null ? '&km=$currentKm' : ''}',
                      ),
                      icon: const Icon(Icons.add_task),
                      label: const Text('Add Maintenance Log'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (bikeId != null)
                        OutlinedButton.icon(
                          key: const Key('custom_interval_button'),
                          onPressed: () => showCustomIntervalDialog(
                            context: context,
                            ref: ref,
                            motorcycleId: bikeId,
                            status: status,
                            existingCustomRule: customRule,
                          ),
                          icon: const Icon(Icons.tune, size: 18),
                          label: Text(customRule == null
                              ? 'Set Custom Interval'
                              : 'Edit Custom Interval'),
                        ),
                      if (customRule != null)
                        TextButton.icon(
                          key: const Key('delete_custom_interval_button'),
                          onPressed: () => _confirmDeleteCustomRule(
                              context, ref, customRule),
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Delete Custom Interval'),
                        ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.auto_stories_outlined, size: 18),
                        label: const Text('Find OEM Part'),
                        onPressed: () => context.push('/parts'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 2. Component Measurement and Wear Specifications Section
          Text(
            'Component Measurement & Wear Specifications',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final spec in evaluatedSpecs)
            _ComponentSpecCard(
              spec: spec,
              item: item,
              motorcycleId: bikeId,
              currentKm: currentKm,
            ),

          const SizedBox(height: 16),

          // 3. Measurement History Table
          Row(
            children: [
              Expanded(
                child: Text(
                  'Measurement History',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              if (bikeId != null)
                TextButton.icon(
                  key: const Key('record_measurement_button'),
                  onPressed: () => showRecordMeasurementDialog(
                    context: context,
                    ref: ref,
                    motorcycleId: bikeId,
                    item: item,
                    spec: evaluatedSpecs.first.definition,
                    currentKm: currentKm,
                  ),
                  icon: const Icon(Icons.straighten, size: 18),
                  label: const Text('Record Measurement'),
                ),
            ],
          ),
          const SizedBox(height: 6),
          _MeasurementHistoryCard(
            item: item,
            measurements: measurements,
          ),

          const SizedBox(height: 16),

          // 4. Service History Section
          Text(
            'Maintenance Service History',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          historyAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Could not load history: $e'),
            data: (records) => records.isEmpty
                ? const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                          'No maintenance logs recorded for this item yet.'),
                    ),
                  )
                : Column(
                    children: [
                      for (final r in records) MaintenanceRecordCard(record: r),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteCustomRule(
    BuildContext context,
    WidgetRef ref,
    RuleDef customRule,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Custom Interval?'),
        content: Text(
          'Remove your custom interval (${StatusText.ruleIntervalDescription(customRule)}) '
          'for ${status.item.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final err = await ref
        .read(maintenanceActionsProvider.notifier)
        .deleteCustomRule(customRule.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(err ?? 'Custom interval removed')),
    );
  }

  Future<void> _confirmDeleteCustomItem(
    BuildContext context,
    WidgetRef ref,
    ItemInfo item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Custom Item?'),
        content: Text(
          'Delete custom maintenance item "${item.name}"? Existing maintenance '
          'history records will be preserved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final err = await ref
        .read(maintenanceActionsProvider.notifier)
        .deleteCustomItem(item.id);
    if (!context.mounted) return;
    if (err == null) {
      if (context.canPop()) context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Text(label, style: theme.textTheme.bodySmall),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 6,
          child: Text(
            value,
            style: highlight
                ? theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  )
                : theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _ComponentSpecCard extends ConsumerWidget {
  const _ComponentSpecCard({
    required this.spec,
    required this.item,
    required this.motorcycleId,
    required this.currentKm,
  });

  final EvaluatedComponentSpec spec;
  final ItemInfo item;
  final int? motorcycleId;
  final int? currentKm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final def = spec.definition;
    final actual = spec.currentActualValue;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    def.componentName,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                _MeasurementStatusBadge(status: spec.status),
              ],
            ),
            const SizedBox(height: 8),
            _InfoRow(
              label: 'Standard measurement',
              value: spec.standardDisplay,
            ),
            const SizedBox(height: 4),
            _InfoRow(
              label: 'Service / replacement limit',
              value: spec.serviceLimitDisplay,
            ),
            const SizedBox(height: 4),
            _InfoRow(
              label: 'Current actual measurement',
              value: actual == null
                  ? 'Not recorded'
                  : '${actual.toStringAsFixed(2)} ${spec.unit}',
              highlight: actual != null,
            ),
            const SizedBox(height: 4),
            _InfoRow(
              label: 'Unit',
              value: spec.unit,
            ),
            const SizedBox(height: 4),
            _InfoRow(
              label: 'Last inspection date',
              value: spec.lastInspectionDate == null
                  ? '—'
                  : AppDates.formatDate(spec.lastInspectionDate!),
            ),
            const SizedBox(height: 4),
            _InfoRow(
              label: 'Last recorded odometer',
              value: spec.lastRecordedOdometer == null
                  ? '—'
                  : StatusText.km(spec.lastRecordedOdometer!),
            ),
            const SizedBox(height: 4),
            _InfoRow(
              label: 'Specification source',
              value: spec.sourceLabel,
            ),
            const SizedBox(height: 6),
            Text(
              def.sourceNote,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (motorcycleId != null)
                  OutlinedButton.icon(
                    onPressed: () => showRecordMeasurementDialog(
                      context: context,
                      ref: ref,
                      motorcycleId: motorcycleId!,
                      item: item,
                      spec: def,
                      currentKm: currentKm,
                    ),
                    icon: const Icon(Icons.add_chart, size: 16),
                    label: const Text('Record Measurement'),
                  ),
                TextButton.icon(
                  onPressed: () => showCustomSpecLimitDialog(
                    context: context,
                    ref: ref,
                    item: item,
                    spec: spec,
                  ),
                  icon: const Icon(Icons.edit_note, size: 16),
                  label: Text(spec.isUserDefinedLimit
                      ? 'Edit Custom Limit'
                      : 'Set Custom Limit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MeasurementStatusBadge extends StatelessWidget {
  const _MeasurementStatusBadge({required this.status});
  final ComponentSpecStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (bg, fg) = switch (status) {
      ComponentSpecStatus.good => (
          Colors.green.withOpacity(0.15),
          Colors.green.shade800
        ),
      ComponentSpecStatus.monitor => (
          Colors.amber.withOpacity(0.20),
          Colors.orange.shade900
        ),
      ComponentSpecStatus.replace => (
          scheme.errorContainer,
          scheme.onErrorContainer
        ),
      ComponentSpecStatus.notRecorded => (
          scheme.surfaceContainerHighest,
          scheme.onSurfaceVariant
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MeasurementHistoryCard extends StatelessWidget {
  const _MeasurementHistoryCard({
    required this.item,
    required this.measurements,
  });

  final ItemInfo item;
  final List<ComponentMeasurement> measurements;

  @override
  Widget build(BuildContext context) {
    final numeric = measurements.where((m) => m.value != null).toList();
    if (numeric.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No component measurements recorded yet.'),
        ),
      );
    }

    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('Date', style: theme.textTheme.labelMedium),
                ),
                Expanded(
                  flex: 3,
                  child: Text('Odometer', style: theme.textTheme.labelMedium),
                ),
                Expanded(
                  flex: 4,
                  child: Text('Component', style: theme.textTheme.labelMedium),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Measurement',
                    textAlign: TextAlign.right,
                    style: theme.textTheme.labelMedium,
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            for (final m in numeric)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        AppDates.formatDate(m.measuredDate),
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        m.odometerKm == null
                            ? '—'
                            : StatusText.km(m.odometerKm!),
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        '${item.name}${m.position != null ? ' (${m.position})' : ''}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '${m.value!.toStringAsFixed(2)} ${m.unit}',
                        textAlign: TextAlign.right,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Dialog to record a component measurement directly from the Maintenance
/// Details screen.
Future<void> showRecordMeasurementDialog({
  required BuildContext context,
  required WidgetRef ref,
  required int motorcycleId,
  required ItemInfo item,
  required ComponentSpecDefinition spec,
  int? currentKm,
}) async {
  final formKey = GlobalKey<FormState>();
  final valCtl = TextEditingController();
  final unitCtl = TextEditingController(text: spec.unit);
  final kmCtl =
      TextEditingController(text: currentKm == null ? '' : '$currentKm');
  final notesCtl = TextEditingController();
  var date = AppDates.todayManila(ref.read(clockProvider)());
  var position = spec.position;

  final saved = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text('Record Measurement · ${spec.componentName}'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Inspection date'),
                  subtitle: Text(AppDates.formatDate(date)),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: () async {
                    final today =
                        AppDates.todayManila(ref.read(clockProvider)());
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: date,
                      firstDate: DateTime(2000),
                      lastDate: today,
                    );
                    if (picked != null) {
                      setState(() => date = AppDates.dateOnly(picked));
                    }
                  },
                ),
                TextFormField(
                  controller: kmCtl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Odometer (km)'),
                  validator: (v) {
                    final raw = (v ?? '').replaceAll(',', '').trim();
                    final n = int.tryParse(raw);
                    if (n == null || n < 0) {
                      return 'Enter a valid non-negative odometer';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                if (spec.position != null) ...[
                  DropdownButtonFormField<String>(
                    value: position,
                    decoration: const InputDecoration(labelText: 'Position'),
                    items: [
                      for (final p in ComponentPosition.values)
                        DropdownMenuItem(value: p.code, child: Text(p.label)),
                    ],
                    onChanged: (v) => setState(() => position = v),
                  ),
                  const SizedBox(height: 8),
                ],
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: valCtl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'Actual measurement'),
                        validator: (v) {
                          final d = double.tryParse((v ?? '').trim());
                          if (d == null || d <= 0) {
                            return 'Enter a value > 0';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: unitCtl,
                        decoration: const InputDecoration(labelText: 'Unit'),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: notesCtl,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, true);
              }
            },
            child: const Text('Save Measurement'),
          ),
        ],
      ),
    ),
  );

  if (saved != true) return;
  final km = int.parse(kmCtl.text.replaceAll(',', '').trim());
  final val = double.parse(valCtl.text.trim());
  final err = await ref.read(componentsActionsProvider.notifier).addMeasurement(
        NewComponentMeasurement(
          motorcycleId: motorcycleId,
          itemId: item.id,
          measuredDate: date,
          odometerKm: km,
          measurementType: spec.measurementType,
          value: val,
          unitOverride: unitCtl.text.trim(),
          position: position,
          notes: notesCtl.text,
        ),
      );
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(err ?? 'Measurement saved')),
  );
}

/// Dialog allowing the user to configure a user-defined custom standard
/// measurement and/or service replacement limit when a specification is not
/// in the verified manual (or when they want a custom threshold).
Future<void> showCustomSpecLimitDialog({
  required BuildContext context,
  required WidgetRef ref,
  required ItemInfo item,
  required EvaluatedComponentSpec spec,
}) async {
  final formKey = GlobalKey<FormState>();
  final stdCtl = TextEditingController(
    text: spec.userSpec?.customStandardValue?.toString() ?? '',
  );
  final limCtl = TextEditingController(
    text: spec.userSpec?.customServiceLimit?.toString() ?? '',
  );
  final unitCtl = TextEditingController(text: spec.unit);

  final saved = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Custom Limit · ${spec.definition.componentName}'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                spec.definition.sourceNote,
                style: Theme.of(ctx).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: stdCtl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'User-defined standard measurement (optional)',
                ),
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.isEmpty) return null;
                  final d = double.tryParse(t);
                  if (d == null || d <= 0) return 'Enter a positive number';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: limCtl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'User-defined service / replacement limit',
                ),
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.isEmpty) return null;
                  final d = double.tryParse(t);
                  if (d == null || d <= 0) return 'Enter a positive number';
                  final std = double.tryParse(stdCtl.text.trim());
                  if (std != null && d >= std) {
                    return 'Service limit must be less than standard';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: unitCtl,
                decoration: const InputDecoration(labelText: 'Unit (e.g. mm)'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Navigator.pop(ctx, true);
            }
          },
          child: const Text('Save Limit'),
        ),
      ],
    ),
  );

  if (saved != true) return;
  final std =
      stdCtl.text.trim().isEmpty ? null : double.parse(stdCtl.text.trim());
  final lim =
      limCtl.text.trim().isEmpty ? null : double.parse(limCtl.text.trim());
  final err = await ref.read(componentsActionsProvider.notifier).saveUserSpec(
        specKey: spec.definition.specKey,
        itemId: item.id,
        customStandardValue: std,
        customServiceLimit: lim,
        unit: unitCtl.text.trim(),
      );
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(err ?? 'Component specification updated')),
  );
}

/// Reusable dialog to create or edit a custom maintenance interval for an
/// existing item, including the Honda Manual Recommendation informational note.
Future<void> showCustomIntervalDialog({
  required BuildContext context,
  required WidgetRef ref,
  required int motorcycleId,
  required ItemStatus status,
  RuleDef? existingCustomRule,
}) async {
  final formKey = GlobalKey<FormState>();
  final rules = status.evaluation.ruleEvaluations.map((e) => e.rule).toList();
  final hondaRules =
      rules.where((r) => r.isManufacturer && r.isActive).toList();
  final existing = existingCustomRule ??
      rules.where((r) => !r.isManufacturer && r.isActive).firstOrNull;

  final kmCtl = TextEditingController(
    text: existing?.intervalKm?.toString() ?? '',
  );
  final monthsCtl = TextEditingController(
    text: existing?.intervalMonths?.toString() ?? '',
  );
  final warningKmCtl = TextEditingController(
    text: existing?.warningKm?.toString() ?? '',
  );
  final lastCompletedKmCtl = TextEditingController(
    text:
        (existing?.lastCompletedKm ?? status.evaluation.lastService?.odometerKm)
                ?.toString() ??
            '',
  );
  final notesCtl = TextEditingController(text: existing?.notes ?? '');
  var action = existing?.actionCode ??
      (hondaRules.isNotEmpty
          ? hondaRules.first.actionCode
          : ActionCode.inspect);

  final hondaRecText = StatusText.hondaRecommendationForRules(rules);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final theme = Theme.of(ctx);
        return AlertDialog(
          title: Text(
            '${existing == null ? 'Custom Interval' : 'Edit Custom Interval'} · ${status.item.name}',
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<ActionCode>(
                    value: action,
                    decoration: const InputDecoration(labelText: 'Action'),
                    items: [
                      for (final a in ActionCode.values)
                        DropdownMenuItem(
                          value: a,
                          child: Text('${a.label} (${a.code})'),
                        ),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => action = v);
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('custom_interval_km_field'),
                    controller: kmCtl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Interval (km)',
                      hintText: 'e.g. 3000 or 6000',
                    ),
                    validator: (v) {
                      final rawKm = (v ?? '').replaceAll(',', '').trim();
                      final rawMonths =
                          monthsCtl.text.replaceAll(',', '').trim();
                      if (rawKm.isEmpty && rawMonths.isEmpty) {
                        return 'Enter a distance (km) or time (months) interval';
                      }
                      if (rawKm.isNotEmpty) {
                        final parsed = int.tryParse(rawKm);
                        if (parsed == null || parsed <= 0) {
                          return 'Interval (km) must be a positive whole number';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('custom_interval_months_field'),
                    controller: monthsCtl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Interval (months, optional)',
                    ),
                    validator: (v) {
                      final raw = (v ?? '').replaceAll(',', '').trim();
                      if (raw.isEmpty) return null;
                      final parsed = int.tryParse(raw);
                      if (parsed == null || parsed <= 0) {
                        return 'Months must be a positive whole number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  // Honda Manual Recommendation Note
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.menu_book_outlined,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Recommended Interval',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          StatusText.recommendedIntervalGuidance,
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Honda Recommendation: $hondaRecText',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('custom_warning_km_field'),
                    controller: warningKmCtl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Warning threshold (km, optional)',
                      hintText: 'e.g. 500 or 1500',
                    ),
                    validator: (v) {
                      final raw = (v ?? '').replaceAll(',', '').trim();
                      if (raw.isEmpty) return null;
                      final parsed = int.tryParse(raw);
                      if (parsed == null || parsed <= 0) {
                        return 'Warning threshold must be greater than zero';
                      }
                      final intKm =
                          int.tryParse(kmCtl.text.replaceAll(',', '').trim());
                      if (intKm != null && parsed >= intKm) {
                        return 'Warning threshold must be less than interval';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('custom_last_completed_km_field'),
                    controller: lastCompletedKmCtl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Last completed odometer (km, optional)',
                      hintText: 'e.g. 12000',
                    ),
                    validator: (v) {
                      final raw = (v ?? '').replaceAll(',', '').trim();
                      if (raw.isEmpty) return null;
                      final parsed = int.tryParse(raw);
                      if (parsed == null || parsed < 0) {
                        return 'Enter a non-negative odometer in km';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: notesCtl,
                    decoration: const InputDecoration(labelText: 'Notes'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              key: const Key('save_custom_interval_button'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(ctx, true);
                }
              },
              child: const Text('Save Rule'),
            ),
          ],
        );
      },
    ),
  );

  if (confirmed != true) return;

  int? parseOptionalInt(String text) {
    final cleaned = text.replaceAll(',', '').trim();
    if (cleaned.isEmpty) return null;
    return int.parse(cleaned);
  }

  final err = await ref.read(maintenanceActionsProvider.notifier).addCustomRule(
        ruleId: existing?.id,
        motorcycleId: motorcycleId,
        itemId: status.item.id,
        action: action,
        intervalKm: parseOptionalInt(kmCtl.text),
        intervalMonths: parseOptionalInt(monthsCtl.text),
        warningKm: parseOptionalInt(warningKmCtl.text),
        lastCompletedKm: parseOptionalInt(lastCompletedKmCtl.text),
        notes: notesCtl.text,
      );
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(err ?? 'Custom interval saved')),
  );
}

/// Dialog to create a brand-new user-defined custom maintenance item (e.g.
/// "CVT Cleaning") along with its custom interval schedule.
Future<void> showCreateCustomItemDialog({
  required BuildContext context,
  required WidgetRef ref,
  required int motorcycleId,
  required List<CategoryInfo> categories,
}) async {
  final formKey = GlobalKey<FormState>();
  final nameCtl = TextEditingController();
  final kmCtl = TextEditingController();
  final monthsCtl = TextEditingController();
  final warningKmCtl = TextEditingController();
  final lastCompletedKmCtl = TextEditingController();
  final notesCtl = TextEditingController();
  var action = ActionCode.clean;
  var categoryId = categories.isNotEmpty ? categories.first.id : null;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final theme = Theme.of(ctx);
        return AlertDialog(
          title: const Text('New Custom Maintenance Item'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    key: const Key('custom_item_name_field'),
                    controller: nameCtl,
                    decoration: const InputDecoration(
                      labelText: 'Custom item name',
                      hintText: 'e.g. CVT Cleaning',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Enter a maintenance item name'
                        : null,
                  ),
                  const SizedBox(height: 8),
                  if (categories.isNotEmpty) ...[
                    DropdownButtonFormField<int>(
                      value: categoryId,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: [
                        for (final c in categories)
                          DropdownMenuItem(value: c.id, child: Text(c.name)),
                      ],
                      onChanged: (v) => setState(() => categoryId = v),
                    ),
                    const SizedBox(height: 8),
                  ],
                  DropdownButtonFormField<ActionCode>(
                    value: action,
                    decoration: const InputDecoration(labelText: 'Action'),
                    items: [
                      for (final a in ActionCode.values)
                        DropdownMenuItem(
                          value: a,
                          child: Text('${a.label} (${a.code})'),
                        ),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => action = v);
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('new_custom_item_km_field'),
                    controller: kmCtl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Interval (km)',
                      hintText: 'e.g. 6000',
                    ),
                    validator: (v) {
                      final rawKm = (v ?? '').replaceAll(',', '').trim();
                      final rawMonths =
                          monthsCtl.text.replaceAll(',', '').trim();
                      if (rawKm.isEmpty && rawMonths.isEmpty) {
                        return 'Enter a distance (km) or time (months) interval';
                      }
                      if (rawKm.isNotEmpty) {
                        final parsed = int.tryParse(rawKm);
                        if (parsed == null || parsed <= 0) {
                          return 'Interval (km) must be greater than zero';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: monthsCtl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Interval (months, optional)',
                    ),
                    validator: (v) {
                      final raw = (v ?? '').replaceAll(',', '').trim();
                      if (raw.isEmpty) return null;
                      final parsed = int.tryParse(raw);
                      if (parsed == null || parsed <= 0) {
                        return 'Months must be greater than zero';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.menu_book_outlined,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Recommended Interval',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          StatusText.recommendedIntervalGuidance,
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          StatusText.noHondaIntervalNote,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: warningKmCtl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Warning threshold (km, optional)',
                      hintText: 'e.g. 500 or 1500',
                    ),
                    validator: (v) {
                      final raw = (v ?? '').replaceAll(',', '').trim();
                      if (raw.isEmpty) return null;
                      final parsed = int.tryParse(raw);
                      if (parsed == null || parsed <= 0) {
                        return 'Warning threshold must be greater than zero';
                      }
                      final intKm =
                          int.tryParse(kmCtl.text.replaceAll(',', '').trim());
                      if (intKm != null && parsed >= intKm) {
                        return 'Warning threshold must be less than interval';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('new_custom_item_last_km_field'),
                    controller: lastCompletedKmCtl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Last completed odometer (km, optional)',
                      hintText: 'e.g. 12000',
                    ),
                    validator: (v) {
                      final raw = (v ?? '').replaceAll(',', '').trim();
                      if (raw.isEmpty) return null;
                      final parsed = int.tryParse(raw);
                      if (parsed == null || parsed < 0) {
                        return 'Enter a non-negative odometer in km';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: notesCtl,
                    decoration: const InputDecoration(labelText: 'Notes'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              key: const Key('save_new_custom_item_button'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(ctx, true);
                }
              },
              child: const Text('Create Custom Item'),
            ),
          ],
        );
      },
    ),
  );

  if (confirmed != true) return;

  int? parseOptionalInt(String text) {
    final cleaned = text.replaceAll(',', '').trim();
    if (cleaned.isEmpty) return null;
    return int.parse(cleaned);
  }

  final err = await ref
      .read(maintenanceActionsProvider.notifier)
      .createCustomItemAndRule(
        motorcycleId: motorcycleId,
        itemName: nameCtl.text,
        categoryId: categoryId,
        action: action,
        intervalKm: parseOptionalInt(kmCtl.text),
        intervalMonths: parseOptionalInt(monthsCtl.text),
        warningKm: parseOptionalInt(warningKmCtl.text),
        lastCompletedKm: parseOptionalInt(lastCompletedKmCtl.text),
        notes: notesCtl.text,
      );
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(err ?? 'Custom maintenance item created')),
  );
}
