import 'package:flutter/material.dart';

import '../../features/maintenance/domain/maintenance_overview.dart';
import '../../features/maintenance/presentation/status_text.dart';
import 'status_chip.dart';

/// Card showing one maintenance item's computed status and schedule.
class ItemStatusCard extends StatelessWidget {
  const ItemStatusCard(
      {super.key, required this.status, this.showCategory = false});
  final ItemStatus status;
  final bool showCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eval = status.evaluation;
    final next = eval.next;
    final lines = StatusText.nextLines(next);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child:
                    Text(status.item.name, style: theme.textTheme.titleMedium),
              ),
              if (eval.hasSchedule) StatusChip(status: eval.status),
            ]),
            if (showCategory)
              Text(status.category.name, style: theme.textTheme.bodySmall),
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
              if (next != null)
                Text(StatusText.source(next.rule),
                    style: theme.textTheme.bodySmall),
            ],
            const SizedBox(height: 4),
            Text('Last service: ${StatusText.lastService(eval.lastService)}',
                style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
