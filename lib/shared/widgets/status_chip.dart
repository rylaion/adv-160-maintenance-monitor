import 'package:flutter/material.dart';

import '../../core/enums/enums.dart';
import '../../core/theme/app_theme.dart';

/// Colour + icon pair for a maintenance status. Always paired with a text
/// label so state is not conveyed by colour alone.
class StatusStyle {
  const StatusStyle(this.color, this.icon);
  final Color color;
  final IconData icon;

  static StatusStyle of(MaintenanceStatus s) => switch (s) {
        MaintenanceStatus.good =>
          const StatusStyle(StatusColors.good, Icons.check_circle_outline),
        MaintenanceStatus.upcoming =>
          const StatusStyle(StatusColors.upcoming, Icons.schedule),
        MaintenanceStatus.due => const StatusStyle(
            StatusColors.due, Icons.notifications_active_outlined),
        MaintenanceStatus.overdue =>
          const StatusStyle(StatusColors.overdue, Icons.error_outline),
        MaintenanceStatus.inspectionRequired =>
          const StatusStyle(StatusColors.inspection, Icons.search),
        MaintenanceStatus.replacementRequired => const StatusStyle(
            StatusColors.replacement, Icons.build_circle_outlined),
      };
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});
  final MaintenanceStatus status;

  @override
  Widget build(BuildContext context) {
    final style = StatusStyle.of(status);
    return Chip(
      avatar: Icon(style.icon, size: 18, color: style.color),
      label: Text(status.label),
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: style.color),
      backgroundColor: style.color.withOpacity(0.12),
    );
  }
}
