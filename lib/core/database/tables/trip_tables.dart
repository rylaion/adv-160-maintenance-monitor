import 'package:drift/drift.dart';
import 'motorcycle_tables.dart';

/// Recorded motorcycle trips / ride history.
class Trips extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get motorcycleId =>
      integer().references(Motorcycles, #id, onDelete: KeyAction.cascade)();

  TextColumn get title => text().withLength(min: 1, max: 120)();
  TextColumn get category => text()(); // commute, work, leisure, touring, other
  TextColumn get origin => text().nullable()();
  TextColumn get destination => text().nullable()();

  IntColumn get startOdometerKm => integer().nullable()();
  IntColumn get endOdometerKm => integer().nullable()();
  RealColumn get distanceKm => real()();

  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();

  RealColumn get avgSpeedKmh => real().nullable()();
  RealColumn get maxSpeedKmh => real().nullable()();

  BoolColumn get isGpsTracked => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  TextColumn get photoPaths => text().nullable()(); // JSON string array

  DateTimeColumn get createdAt => dateTime()();
}

/// GPS Waypoints captured during active GPS tracking for a trip.
class TripWaypoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tripId =>
      integer().references(Trips, #id, onDelete: KeyAction.cascade)();

  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get altitude => real().nullable()();
  RealColumn get speedKmh => real().nullable()();
  RealColumn get heading => real().nullable()();
  RealColumn get accuracyMeters => real().nullable()();
  DateTimeColumn get recordedAt => dateTime()();
  IntColumn get sequence => integer()();
}

/// Saved favorite destinations and motorcycle landmarks.
class SavedLocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get category => text()(); // home, work, service, favorite, scenic
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get address => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

/// Saved planned motorcycle routes.
class SavedRoutes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get motorcycleId =>
      integer().references(Motorcycles, #id, onDelete: KeyAction.cascade)();

  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get originName => text().nullable()();
  TextColumn get destinationName => text().nullable()();
  RealColumn get originLat => real()();
  RealColumn get originLng => real()();
  RealColumn get destLat => real()();
  RealColumn get destLng => real()();
  TextColumn get waypointsJson => text().nullable()();
  RealColumn get distanceKm => real().withDefault(const Constant(0.0))();
  IntColumn get durationMinutes => integer().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
