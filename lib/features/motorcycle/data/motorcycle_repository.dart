import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/motorcycle.dart';

/// Repository for the motorcycle profile. All DB access lives here.
class MotorcycleRepository {
  MotorcycleRepository(this._db);
  final AppDatabase _db;

  /// Streams the primary (first) motorcycle, or null if none exists.
  Stream<Motorcycle?> watchPrimary() {
    final query = _db.select(_db.motorcycles)
      ..orderBy([(t) => OrderingTerm.asc(t.id)])
      ..limit(1);
    return query
        .watchSingleOrNull()
        .map((row) => row == null ? null : Motorcycle.fromRow(row));
  }

  Future<void> update(Motorcycle m) async {
    await (_db.update(_db.motorcycles)..where((t) => t.id.equals(m.id))).write(
      MotorcyclesCompanion(
        brand: Value(m.brand.trim()),
        model: Value(m.model.trim()),
        modelYear: Value(m.modelYear),
        plateNumber: Value(_clean(m.plateNumber)),
        chassisNumber: Value(_clean(m.chassisNumber)),
        engineNumber: Value(_clean(m.engineNumber)),
        purchaseDate:
            Value(m.purchaseDate == null ? null : _dateOnly(m.purchaseDate!)),
        photoPath: Value(m.photoPath),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
  }

  static String? _clean(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  static String _dateOnly(DateTime d) =>
      DateTime(d.year, d.month, d.day).toIso8601String().substring(0, 10);
}
