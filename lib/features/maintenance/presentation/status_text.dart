import 'package:intl/intl.dart';

import '../../../core/enums/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../domain/maintenance_models.dart';

/// Pure text formatting for maintenance status display.
class StatusText {
  StatusText._();

  static final _km = NumberFormat.decimalPattern('en_US');

  static String km(int v) => '${_km.format(v)} km';

  /// "in 1,200 km" / "800 km overdue".
  static String remainingKm(int v) =>
      v >= 0 ? 'in ${km(v)}' : '${km(-v)} overdue';

  /// "in 12 days" / "today" / "3 days overdue".
  static String remainingDays(int v) {
    if (v == 0) return 'today';
    final n = v.abs();
    final unit = n == 1 ? 'day' : 'days';
    return v > 0 ? 'in $n $unit' : '$n $unit overdue';
  }

  /// Description of the next checkpoint, e.g.
  /// "Replace at 6,000 km (in 1,200 km)".
  static List<String> nextLines(RuleEvaluation? e) {
    final cp = e?.next;
    if (e == null || cp == null) return const [];
    final lines = <String>[];
    if (cp.dueKm != null && e.remainingKm != null) {
      lines.add('${cp.actionCode.label} at ${km(cp.dueKm!)} '
          '(${remainingKm(e.remainingKm!)})');
    }
    if (cp.dueDate != null && e.remainingDays != null) {
      lines.add('${cp.actionCode.label} by ${AppDates.formatDate(cp.dueDate!)} '
          '(${remainingDays(e.remainingDays!)})');
    }
    return lines;
  }

  static String lastService(ServiceEvent? s) => s == null
      ? 'No service recorded'
      : '${AppDates.formatDate(s.date)} at ${km(s.odometerKm)}';

  static String source(RuleDef r) {
    switch (r.source) {
      case MaintenanceSource.custom:
        return 'Custom';
      case MaintenanceSource.hondaManual:
      case MaintenanceSource.serviceManual:
        final base = r.source == MaintenanceSource.hondaManual
            ? 'Honda manual'
            : 'Service manual';
        return r.isVerified ? base : '$base (unverified)';
    }
  }

  static final _peso = NumberFormat.currency(locale: 'en_PH', symbol: '₱');

  /// Formats integer centavos as pesos.
  static String pesos(int centavos) => _peso.format(centavos / 100);
}

