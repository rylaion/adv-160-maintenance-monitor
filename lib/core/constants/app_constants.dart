/// App-wide constants.
library;

const String kAppName = 'ADV-MON';
const String kDatabaseFileName = 'adv_mon.sqlite';

/// Increment when the schema changes and add a step in
/// `core/database/migrations/migrations.dart`.
const int kDatabaseSchemaVersion = 5;

/// Local time zone used for display and reminder scheduling.
const String kAppTimeZone = 'Asia/Manila';

/// Seeded motorcycle.
const String kSeedBrand = 'Honda';
const String kSeedModel = 'ADV 160';
const int kSeedModelYear = 2023;
