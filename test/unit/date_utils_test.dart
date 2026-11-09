import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'package:adv_mon/core/utils/date_utils.dart';

DateTime d(int y, int m, int day) => DateTime.utc(y, m, day);

void main() {
  group('addMonths', () {
    test('simple month addition', () {
      expect(AppDates.addMonths(d(2026, 1, 15), 1), d(2026, 2, 15));
      expect(AppDates.addMonths(d(2026, 11, 9), 3), d(2027, 2, 9));
    });

    test('clamps to month end', () {
      expect(AppDates.addMonths(d(2026, 1, 31), 1), d(2026, 2, 28));
      expect(AppDates.addMonths(d(2024, 1, 31), 1), d(2024, 2, 29));
      expect(AppDates.addMonths(d(2026, 8, 31), 1), d(2026, 9, 30));
    });

    test('leap day handling', () {
      expect(AppDates.addMonths(d(2024, 2, 29), 12), d(2025, 2, 28));
      expect(AppDates.addMonths(d(2024, 2, 29), 24), d(2026, 2, 28));
      expect(AppDates.addMonths(d(2024, 2, 29), 48), d(2028, 2, 29));
      expect(AppDates.addMonths(d(2023, 2, 28), 12), d(2024, 2, 28));
    });

    test('year rollover and 24/36 month intervals', () {
      expect(AppDates.addMonths(d(2025, 12, 1), 1), d(2026, 1, 1));
      expect(AppDates.addMonths(d(2023, 6, 15), 24), d(2025, 6, 15));
      expect(AppDates.addMonths(d(2023, 6, 15), 36), d(2026, 6, 15));
    });

    test('negative months', () {
      expect(AppDates.addMonths(d(2026, 3, 31), -1), d(2026, 2, 28));
    });
  });

  group('daysBetween', () {
    test('basic and sign', () {
      expect(AppDates.daysBetween(d(2026, 11, 9), d(2026, 11, 10)), 1);
      expect(AppDates.daysBetween(d(2026, 11, 10), d(2026, 11, 9)), -1);
      expect(AppDates.daysBetween(d(2026, 11, 9), d(2026, 11, 9)), 0);
    });

    test('across leap day', () {
      expect(AppDates.daysBetween(d(2024, 2, 28), d(2024, 3, 1)), 2);
      expect(AppDates.daysBetween(d(2025, 2, 28), d(2025, 3, 1)), 1);
      expect(AppDates.daysBetween(d(2024, 1, 1), d(2025, 1, 1)), 366);
    });

    test('ignores time of day', () {
      expect(
          AppDates.daysBetween(
              DateTime(2026, 1, 1, 23, 59), DateTime(2026, 1, 2, 0, 1)),
          1);
    });
  });

  group('ISO dates', () {
    test('toIsoDate and parseDateOnly round trip', () {
      expect(AppDates.toIsoDate(d(2026, 3, 5)), '2026-03-05');
      expect(AppDates.parseDateOnly('2026-03-05'), d(2026, 3, 5));
      expect(AppDates.parseDateOnly('2024-02-29T10:00:00'), d(2024, 2, 29));
      expect(AppDates.parseDateOnly('bad'), isNull);
      expect(AppDates.parseDateOnly(null), isNull);
    });
  });

  group('Asia/Manila time zone', () {
    void checks() {
      // Manila is UTC+8 with no DST.
      expect(AppDates.todayManila(DateTime.utc(2026, 11, 9, 15, 59)),
          d(2026, 11, 9));
      expect(AppDates.todayManila(DateTime.utc(2026, 11, 9, 16, 0)),
          d(2026, 11, 10));
      // New Year boundary.
      expect(AppDates.todayManila(DateTime.utc(2026, 12, 31, 16, 30)),
          d(2027, 1, 1));
      // Leap day boundary.
      expect(AppDates.todayManila(DateTime.utc(2028, 2, 28, 16, 0)),
          d(2028, 2, 29));
      expect(AppDates.toManila(DateTime.utc(2026, 6, 1, 0, 0)).hour, 8);
    }

    test('fallback offset (time zone database not loaded)', checks);

    test('with time zone database loaded', () {
      tzdata.initializeTimeZones();
      checks();
    });
  });
}
