import 'package:drift/drift.dart';
import 'motorcycle_tables.dart';

/// CVT setup configurations recorded for the motorcycle.
class CvtConfigurations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get motorcycleId =>
      integer().references(Motorcycles, #id, onDelete: KeyAction.cascade)();

  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get pulleyBrandModel => text().nullable()();
  RealColumn get flyballWeightGrams => real().nullable()();
  TextColumn get flyballArrangement =>
      text().nullable()(); // e.g. "Straight 13g", "3x12g + 3x14g"
  IntColumn get centerSpringRpm =>
      integer().nullable()(); // e.g. 1000, 1500, 2000
  IntColumn get clutchSpringRpm => integer().nullable()(); // e.g. 1000, 1500
  TextColumn get beltBrandPartNumber => text().nullable()();
  RealColumn get pulleyWasherThicknessMm =>
      real().nullable()(); // e.g. 0.5, 1.0
  TextColumn get clutchBellSpec => text().nullable()();
  TextColumn get exhaustSpec => text().nullable()();
  TextColumn get otherMods => text().nullable()();

  DateTimeColumn get installedDate => dateTime()();
  IntColumn get installedOdometerKm => integer().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  TextColumn get notes => text().nullable()();
  TextColumn get photoPaths => text().nullable()(); // JSON string array

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Subjective or measured performance observation logs linked to a CVT configuration.
class CvtPerformanceLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get configurationId => integer()
      .references(CvtConfigurations, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get logDate => dateTime()();
  IntColumn get odometerKm => integer().nullable()();

  // Ratings 1 to 5 (or null)
  IntColumn get accelerationRating => integer().nullable()();
  RealColumn get topSpeedKmh => real().nullable()();
  IntColumn get rpmObserved => integer().nullable()();
  RealColumn get fuelConsumptionKpl => real().nullable()();
  IntColumn get vibrationRating => integer().nullable()();
  IntColumn get comfortRating => integer().nullable()();

  TextColumn get overallAssessment => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isMeasured => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();
}
