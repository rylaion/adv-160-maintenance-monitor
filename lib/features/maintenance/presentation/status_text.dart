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
        return 'Custom interval (User-defined)';
      case MaintenanceSource.hondaManual:
      case MaintenanceSource.serviceManual:
        final base = r.source == MaintenanceSource.hondaManual
            ? 'Honda ADV160 Owner\'s Manual (32K0WA100)'
            : 'Honda Service Manual';
        return r.isVerified ? base : '$base (unverified)';
    }
  }

  /// Formats a single rule's interval schedule for display (e.g.
  /// "Inspect (I) every 6,000 km" or "Replace (R) at 1,000 km, then every 6,000 km").
  static String ruleIntervalDescription(RuleDef rule) {
    final actionText = '${rule.actionCode.label} (${rule.actionCode.code})';
    if (rule.steps.isNotEmpty) {
      final parts = <String>[];
      for (final s in rule.steps) {
        if (s.atKm != null && s.repeatEveryKm != null) {
          if (s.atKm == s.repeatEveryKm) {
            parts.add('every ${km(s.repeatEveryKm!)}');
          } else {
            parts.add('at ${km(s.atKm!)}, then every ${km(s.repeatEveryKm!)}');
          }
        } else if (s.atKm != null) {
          parts.add('at ${km(s.atKm!)}');
        } else if (s.atMonths != null && s.repeatEveryMonths != null) {
          parts.add('every ${s.repeatEveryMonths} months');
        } else if (s.atMonths != null) {
          parts.add('at ${s.atMonths} months');
        }
      }
      if (parts.isNotEmpty) {
        return '$actionText ${parts.join(', ')}';
      }
    }
    final parts = <String>[];
    if (rule.intervalKm != null) {
      parts.add('every ${km(rule.intervalKm!)}');
    }
    if (rule.intervalMonths != null) {
      final m = rule.intervalMonths!;
      if (m % 12 == 0 && m >= 12) {
        final yrs = m ~/ 12;
        parts.add('every $m months ($yrs ${yrs == 1 ? 'year' : 'years'})');
      } else {
        parts.add('every $m ${m == 1 ? 'month' : 'months'}');
      }
    }
    if (parts.isEmpty) return actionText;
    return '$actionText ${parts.join(' or ')}';
  }

  static const String noHondaIntervalNote =
      'No fixed interval found in the available Honda maintenance schedule. '
      'You may set a custom interval based on your usage and inspection results.';

  static const String recommendedIntervalGuidance =
      'Check the Honda ADV160 maintenance schedule for the recommended '
      'inspection or replacement interval before setting a custom interval. '
      'The recommended range shown here is based on available Honda '
      'documentation. If no official interval is specified, choose an interval '
      'based on your usage and have the component inspected as necessary.';

  /// Returns a formatted summary of the official 2023 Honda ADV160 Owner's
  /// Manual (`32K0WA100`) schedule for an item, or [noHondaIntervalNote] when
  /// no fixed Honda interval exists.
  static String hondaRecommendationForRules(Iterable<RuleDef> rules) {
    final hondaRules =
        rules.where((r) => r.isManufacturer && r.isActive).toList();
    if (hondaRules.isEmpty) return noHondaIntervalNote;
    final lines = [
      for (final r in hondaRules) ruleIntervalDescription(r),
    ];
    return '${lines.join(' · ')} '
        '(Source: Honda ADV160 Owner\'s Manual 32K0WA100)';
  }

  static final _peso = NumberFormat.currency(locale: 'en_PH', symbol: '₱');

  /// Formats integer centavos as pesos.
  static String pesos(int centavos) => _peso.format(centavos / 100);
}
