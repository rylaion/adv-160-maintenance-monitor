import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/services/odometer_service.dart';
import '../../features/maintenance/data/maintenance_repository.dart';
import '../../features/motorcycle/data/motorcycle_repository.dart';
import '../../features/odometer/data/odometer_repository.dart';

/// Root database provider. Overridden in tests with an in-memory database.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
});

final motorcycleRepositoryProvider = Provider<MotorcycleRepository>(
  (ref) => MotorcycleRepository(ref.watch(appDatabaseProvider)),
);

/// Current time source. Overridden in tests for deterministic dates.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final odometerRepositoryProvider = Provider<OdometerRepository>(
  (ref) => OdometerRepository(ref.watch(appDatabaseProvider)),
);

final odometerServiceProvider = Provider<OdometerService>(
  (ref) => OdometerService(ref.watch(odometerRepositoryProvider),
      clock: ref.watch(clockProvider)),
);

final maintenanceRepositoryProvider = Provider<MaintenanceRepository>(
  (ref) => MaintenanceRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(odometerRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);
