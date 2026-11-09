import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../shared/widgets/photo_attachments_field.dart';
import '../domain/maintenance_record_detail.dart';
import 'maintenance_view_model.dart';
import 'status_text.dart';

/// Displays maintenance records in chronological order with filtering by date,
/// category and maintenance item. Never overwrites old records.
class MaintenanceHistoryScreen extends ConsumerWidget {
  const MaintenanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(maintenanceOverviewProvider);
    final historyAsync = ref.watch(maintenanceHistoryProvider);
    final filter = ref.watch(maintenanceHistoryFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance History'),
        actions: [
          if (filter.categoryId != null ||
              filter.itemId != null ||
              filter.fromDate != null ||
              filter.toDate != null)
            IconButton(
              tooltip: 'Clear filters',
              icon: const Icon(Icons.filter_alt_off_outlined),
              onPressed: () => ref
                  .read(maintenanceHistoryFilterProvider.notifier)
                  .state = const MaintenanceHistoryFilter(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/maintenance/record'),
        icon: const Icon(Icons.add),
        label: const Text('Add Record'),
      ),
      body: Column(
        children: [
          if (overviewAsync.valueOrNull != null)
            _FilterBar(
              categories: overviewAsync.value!.snapshot.categories,
              items: overviewAsync.value!.snapshot.items,
              filter: filter,
              onChanged: (f) =>
                  ref.read(maintenanceHistoryFilterProvider.notifier).state = f,
            ),
          Expanded(
            child: historyAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text('Could not load history: $e')),
              data: (records) => records.isEmpty
                  ? const Center(child: Text('No maintenance records found'))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
                      itemCount: records.length,
                      itemBuilder: (_, i) =>
                          MaintenanceRecordCard(record: records[i]),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.categories,
    required this.items,
    required this.filter,
    required this.onChanged,
  });

  final List<dynamic> categories;
  final List<dynamic> items;
  final MaintenanceHistoryFilter filter;
  final void Function(MaintenanceHistoryFilter) onChanged;

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (range != null) {
      onChanged(MaintenanceHistoryFilter(
        categoryId: filter.categoryId,
        itemId: filter.itemId,
        fromDate: AppDates.dateOnly(range.start),
        toDate: AppDates.dateOnly(range.end),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = filter.categoryId == null
        ? items
        : items.where((i) => i.categoryId == filter.categoryId).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          DropdownButton<int?>(
            value: filter.categoryId,
            hint: const Text('All categories'),
            items: [
              const DropdownMenuItem(
                  value: null, child: Text('All categories')),
              for (final c in categories)
                DropdownMenuItem(value: c.id as int, child: Text('${c.name}')),
            ],
            onChanged: (catId) => onChanged(MaintenanceHistoryFilter(
              categoryId: catId,
              itemId: null,
              fromDate: filter.fromDate,
              toDate: filter.toDate,
            )),
          ),
          DropdownButton<int?>(
            value: filter.itemId,
            hint: const Text('All items'),
            items: [
              const DropdownMenuItem(value: null, child: Text('All items')),
              for (final i in visibleItems)
                DropdownMenuItem(value: i.id as int, child: Text('${i.name}')),
            ],
            onChanged: (itemId) => onChanged(MaintenanceHistoryFilter(
              categoryId: filter.categoryId,
              itemId: itemId,
              fromDate: filter.fromDate,
              toDate: filter.toDate,
            )),
          ),
          OutlinedButton.icon(
            onPressed: () => _pickDateRange(context),
            icon: const Icon(Icons.date_range_outlined, size: 18),
            label: Text(filter.fromDate == null
                ? 'Date range'
                : '${AppDates.formatDate(filter.fromDate!)} – '
                    '${AppDates.formatDate(filter.toDate!)}'),
          ),
        ],
      ),
    );
  }
}

/// Reusable card displaying a single maintenance record.
class MaintenanceRecordCard extends ConsumerWidget {
  const MaintenanceRecordCard({super.key, required this.record});
  final MaintenanceRecordDetail record;

  Future<void> _confirmVoid(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Void maintenance record?'),
        content: const Text(
            'The record is kept in the database audit trail as voided and '
            'excluded from calculations.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Void record')),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(maintenanceActionsProvider.notifier).voidRecord(record.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${record.itemName} · ${_actionLabel(record.action)}',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Edit record',
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () =>
                      context.push('/maintenance/record?edit=${record.id}'),
                ),
                IconButton(
                  tooltip: 'Void record',
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () => _confirmVoid(context, ref),
                ),
              ],
            ),
            Text(
              '${AppDates.formatDate(record.performedDate)} · '
              '${StatusText.km(record.odometerKm)} · '
              '${StatusText.pesos(record.totalCostCentavos)}',
              style: theme.textTheme.bodyMedium,
            ),
            if (record.serviceProvider != null)
              Text('Mechanic/Center: ${record.serviceProvider}',
                  style: theme.textTheme.bodySmall),
            if (record.parts.isNotEmpty) ...[
              const SizedBox(height: 6),
              for (final p in record.parts)
                Text(
                  'Part: ${p.part.name}'
                  '${p.part.brand == null ? '' : ' (${p.part.brand})'}'
                  '${p.part.specification == null ? '' : ' [${p.part.specification}]'}'
                  ' × ${p.quantity} @ ${StatusText.pesos(p.unitCostCentavos)}',
                  style: theme.textTheme.bodySmall,
                ),
            ],
            if (record.notes != null) ...[
              const SizedBox(height: 4),
              Text(record.notes!, style: theme.textTheme.bodySmall),
            ],
            if (record.supersedesRecordId != null)
              Text('Edited version (supersedes #${record.supersedesRecordId})',
                  style: theme.textTheme.labelSmall),
            AttachmentGalleryRow(attachments: record.attachments),
          ],
        ),
      ),
    );
  }

  static String _actionLabel(MaintenanceAction a) => switch (a) {
        MaintenanceAction.inspection => 'Inspection',
        MaintenanceAction.cleaning => 'Cleaning',
        MaintenanceAction.adjustment => 'Adjustment',
        MaintenanceAction.replacement => 'Replacement',
        MaintenanceAction.lubrication => 'Lubrication',
      };
}
