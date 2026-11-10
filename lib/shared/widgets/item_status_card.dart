import 'package:flutter/material.dart';

import '../../features/maintenance/domain/maintenance_overview.dart';
import '../../features/maintenance/presentation/status_text.dart';
import 'status_chip.dart';

/// Card showing one maintenance item's computed status and schedule.
class ItemStatusCard extends StatelessWidget {
  const ItemStatusCard({
    super.key,
    required this.status,
    this.showCategory = false,
    this.onTap,
    this.onQuickLog,
  });

  final ItemStatus status;
  final bool showCategory;
  final VoidCallback? onTap;
  final VoidCallback? onQuickLog;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eval = status.evaluation;
    final next = eval.next;
    final lines = StatusText.nextLines(next);
    final hondaRules = eval.ruleEvaluations
        .map((r) => r.rule)
        .where((r) => r.isManufacturer && r.isActive)
        .toList();
    final customRules = eval.ruleEvaluations
        .map((r) => r.rule)
        .where((r) => !r.isManufacturer && r.isActive)
        .toList();

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text(
                    status.item.name,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (eval.hasSchedule) StatusChip(status: eval.status),
                if (onTap != null) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, size: 20),
                ],
              ]),
              if (showCategory || status.item.isUserDefined)
                Text(
                  [
                    if (showCategory) status.category.name,
                    if (status.item.isUserDefined) 'Custom Maintenance Item',
                  ].join(' · '),
                  style: theme.textTheme.bodySmall,
                ),
              const SizedBox(height: 6),
              if (!eval.hasSchedule)
                Text(
                  eval.needsBaseline
                      ? 'Set the purchase date or record an odometer reading to '
                          'enable date-based schedules.'
                      : 'No schedule configured.',
                  style: theme.textTheme.bodyMedium,
                )
              else ...[
                for (final l in lines) Text(l),
                if (next != null && next.missedCount > 1)
                  Text('${next.missedCount} scheduled checkpoints missed',
                      style: theme.textTheme.bodySmall),
                if (hondaRules.isNotEmpty)
                  Text(
                    'Honda Recommendation: ${hondaRules.map(StatusText.ruleIntervalDescription).join(' · ')}',
                    style: theme.textTheme.bodySmall,
                  ),
                if (customRules.isNotEmpty)
                  Text(
                    'Your Custom Interval: ${customRules.map(StatusText.ruleIntervalDescription).join(' · ')}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                if (hondaRules.isEmpty && customRules.isEmpty && next != null)
                  Text(StatusText.source(next.rule),
                      style: theme.textTheme.bodySmall),
              ],
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Last service: ${StatusText.lastService(eval.lastService)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  if (onQuickLog != null)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      onPressed: onQuickLog,
                      icon: const Icon(Icons.add_task, size: 16),
                      label: const Text('Add Maintenance Log'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
