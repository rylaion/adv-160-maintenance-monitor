import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

/// Date helpers. Display uses Asia/Manila (UTC+8, no DST).
/// Call `tz.initializeTimeZones()` at startup; otherwise a fixed UTC+8 offset
/// is used as a fallback.
class AppDates {
  AppDates._();

  static tz.Location _manila() {
    try {
      return tz.getLocation('Asia/Manila');
    } catch (_) {
      // Time zone database not initialised: Manila is a fixed UTC+8 zone.
      return tz.UTC;
    }
  }

  /// Converts an instant to Manila wall-clock time.
  static DateTime toManila(DateTime instant) {
    final loc = _manila();
    if (identical(loc, tz.UTC)) {
      final u = instant.toUtc().add(const Duration(hours: 8));
      return DateTime(u.year, u.month, u.day, u.hour, u.minute, u.second);
    }
    final t = tz.TZDateTime.from(instant, loc);
    return DateTime(t.year, t.month, t.day, t.hour, t.minute, t.second);
  }

  /// Formats a date for display, e.g. "09 Nov 2026".
  static String formatDate(DateTime d) => DateFormat('dd MMM yyyy').format(d);

  /// Parses an ISO 8601 string into Manila wall-clock time.
  static DateTime? parseIso(String? iso) {
    if (iso == null) return null;
    final d = DateTime.tryParse(iso);
    return d == null ? null : toManila(d);
  }

  /// Strips time. Result is a UTC-midnight value so day arithmetic never
  /// crosses a DST boundary.
  static DateTime dateOnly(DateTime d) => DateTime.utc(d.year, d.month, d.day);

  /// Parses yyyy-MM-dd (or a full ISO string, using its calendar date).
  static DateTime? parseDateOnly(String? iso) {
    if (iso == null || iso.length < 10) return null;
    final y = int.tryParse(iso.substring(0, 4));
    final m = int.tryParse(iso.substring(5, 7));
    final d = int.tryParse(iso.substring(8, 10));
    if (y == null || m == null || d == null) return null;
    return DateTime.utc(y, m, d);
  }

  /// yyyy-MM-dd.
  static String toIsoDate(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  /// Today's calendar date in Asia/Manila for the given instant.
  static DateTime todayManila([DateTime? now]) =>
      dateOnly(toManila(now ?? DateTime.now()));

  /// Adds calendar months, clamping the day to the target month's length
  /// (31 Jan + 1 month = 28/29 Feb; 29 Feb 2024 + 12 months = 28 Feb 2025).
  static DateTime addMonths(DateTime d, int months) {
    final total = d.year * 12 + (d.month - 1) + months;
    final year = total ~/ 12;
    final month = total % 12 + 1;
    final lastDay = DateTime.utc(year, month + 1, 0).day;
    return DateTime.utc(year, month, d.day > lastDay ? lastDay : d.day);
  }

  /// Whole days from [a] to [b] (positive when [b] is later).
  static int daysBetween(DateTime a, DateTime b) =>
      dateOnly(b).difference(dateOnly(a)).inDays;
}
