import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../../features/maintenance/domain/maintenance_record_detail.dart';
import '../constants/app_constants.dart';
import '../database/app_database.dart';
import '../exceptions/user_facing_exception.dart';
import '../utils/zip_codec.dart';

const String kBackupAppId = 'ADV-MON';
const int kBackupFormatVersion = 1;

class BackupException implements UserFacingException {
  const BackupException(this.message);
  @override
  final String message;
  @override
  String toString() => message;
}

/// Summary of a validated backup archive, shown to the user before confirming
/// a restore operation.
class BackupPreview {
  const BackupPreview({
    required this.formatVersion,
    required this.schemaVersion,
    required this.createdAt,
    required this.tableCounts,
    required this.bundledAttachmentCount,
  });

  final int formatVersion;
  final int schemaVersion;
  final String createdAt;
  final Map<String, int> tableCounts;
  final int bundledAttachmentCount;

  int get totalRows => tableCounts.values.fold<int>(0, (a, b) => a + b);
}

/// Service for full JSON backup, ZIP backup (with inspection photos), validated
/// atomic restoration preserving original IDs and relationships, and CSV
/// exports for maintenance records and expenses.
class BackupService {
  BackupService(
    this._db,
    this._baseDir, {
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final Future<Directory> Function() _baseDir;
  final DateTime Function() _clock;

  static const List<String> requiredTables = [
    'motorcycles',
    'maintenance_categories',
    'maintenance_items',
    'maintenance_rules',
    'maintenance_rule_steps',
    'maintenance_records',
    'odometer_logs',
    'component_measurements',
    'parts',
    'maintenance_record_parts',
    'part_installations',
    'maintenance_reminders',
    'attachments',
  ];

  // ------------------------------------------------------------------ EXPORT

  /// Serializes all 13 database tables into a full JSON map.
  Future<Map<String, dynamic>> buildBackupMap() async {
    final bikes = await _db.select(_db.motorcycles).get();
    final cats = await _db.select(_db.maintenanceCategories).get();
    final items = await _db.select(_db.maintenanceItems).get();
    final rules = await _db.select(_db.maintenanceRules).get();
    final steps = await _db.select(_db.maintenanceRuleSteps).get();
    final records = await _db.select(_db.maintenanceRecords).get();
    final odo = await _db.select(_db.odometerLogs).get();
    final meas = await _db.select(_db.componentMeasurements).get();
    final specs = await _db.select(_db.componentSpecs).get();
    final parts = await _db.select(_db.parts).get();
    final recParts = await _db.select(_db.maintenanceRecordParts).get();
    final installs = await _db.select(_db.partInstallations).get();
    final reminders = await _db.select(_db.maintenanceReminders).get();
    final atts = await _db.select(_db.attachments).get();

    return {
      'app': kBackupAppId,
      'formatVersion': kBackupFormatVersion,
      'schemaVersion': kDatabaseSchemaVersion,
      'createdAt': _clock().toIso8601String(),
      'tables': {
        'motorcycles': [for (final r in bikes) r.toJson()],
        'maintenance_categories': [for (final r in cats) r.toJson()],
        'maintenance_items': [for (final r in items) r.toJson()],
        'maintenance_rules': [for (final r in rules) r.toJson()],
        'maintenance_rule_steps': [for (final r in steps) r.toJson()],
        'maintenance_records': [for (final r in records) r.toJson()],
        'odometer_logs': [for (final r in odo) r.toJson()],
        'component_measurements': [for (final r in meas) r.toJson()],
        'component_specs': [for (final r in specs) r.toJson()],
        'parts': [for (final r in parts) r.toJson()],
        'maintenance_record_parts': [for (final r in recParts) r.toJson()],
        'part_installations': [for (final r in installs) r.toJson()],
        'maintenance_reminders': [for (final r in reminders) r.toJson()],
        'attachments': [for (final r in atts) r.toJson()],
      },
    };
  }

  /// Writes a formatted JSON backup file and returns its path.
  Future<String> exportJsonBackup({String? targetPath}) async {
    final map = await buildBackupMap();
    final jsonStr = const JsonEncoder.withIndent('  ').convert(map);
    final path =
        targetPath ?? await _defaultExportPath('adv_mon_backup', 'json');
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(jsonStr);
    return file.path;
  }

  /// Creates a ZIP backup containing `backup.json` and all existing attachment
  /// & motorcycle photo files, returning the `.zip` path.
  Future<String> exportZipBackup({String? targetPath}) async {
    final map = await buildBackupMap();
    final entries = <ZipEntry>[];
    final seenNames = <String>{};

    Future<String?> bundleFile(String? filePath, String prefix) async {
      if (filePath == null || filePath.trim().isEmpty) return null;
      final f = File(filePath);
      if (!await f.exists()) return null;
      var archiveName = '$prefix/${p.basename(filePath)}';
      var counter = 1;
      while (!seenNames.add(archiveName)) {
        final stem = p.basenameWithoutExtension(filePath);
        final ext = p.extension(filePath);
        archiveName = '$prefix/${stem}_${counter++}$ext';
      }
      entries.add(ZipEntry(name: archiveName, bytes: await f.readAsBytes()));
      return archiveName;
    }

    final tables = map['tables'] as Map<String, dynamic>;
    final bikes = tables['motorcycles'] as List<dynamic>;
    for (final b in bikes.cast<Map<String, dynamic>>()) {
      final archived = await bundleFile(b['photoPath'] as String?, 'photos');
      if (archived != null) b['archiveEntry'] = archived;
    }

    final atts = tables['attachments'] as List<dynamic>;
    for (final a in atts.cast<Map<String, dynamic>>()) {
      final archived =
          await bundleFile(a['filePath'] as String?, 'attachments');
      if (archived != null) a['archiveEntry'] = archived;
    }

    final jsonBytes = Uint8List.fromList(
      utf8.encode(const JsonEncoder.withIndent('  ').convert(map)),
    );
    entries.insert(0, ZipEntry(name: 'backup.json', bytes: jsonBytes));

    final zipBytes = ZipCodec.encode(entries);
    final path =
        targetPath ?? await _defaultExportPath('adv_mon_backup', 'zip');
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(zipBytes);
    return file.path;
  }

  // --------------------------------------------------- VALIDATION & RESTORE

  /// Inspects and validates a `.json` or `.zip` backup file without modifying
  /// the database. Throws [BackupException] if invalid or unsupported.
  Future<BackupPreview> inspectBackupFile(String filePath) async {
    final parsed = await _loadAndValidateFile(filePath);
    return parsed.preview;
  }

  /// Restores a `.json` or `.zip` backup into the database.
  ///
  /// SAFETY: Requires `confirmedByUser == true`. Runs inside a single database
  /// transaction so any failure rolls back and leaves the existing database
  /// intact. Restores original IDs and relationships verbatim.
  Future<BackupPreview> restoreFromFile(
    String filePath, {
    required bool confirmedByUser,
  }) async {
    if (!confirmedByUser) {
      throw const BackupException(
        'Restore requires explicit user confirmation before overwriting data.',
      );
    }
    final parsed = await _loadAndValidateFile(filePath);
    final map = parsed.map;
    final tables = map['tables'] as Map<String, dynamic>;

    // Extract bundled attachment files into app storage first.
    final extractedPaths = <String, String>{};
    final createdFiles = <File>[];
    if (parsed.zipEntries.isNotEmpty) {
      final root = await _baseDir();
      for (final entry in parsed.zipEntries) {
        if (entry.name == 'backup.json') continue;
        final safeRel = entry.name
            .split('/')
            .where((s) => s.isNotEmpty && s != '..' && s != '.')
            .join(Platform.pathSeparator);
        if (safeRel.isEmpty) continue;
        final destPath = p.join(
          root.path,
          'restored_${_clock().microsecondsSinceEpoch}_$safeRel',
        );
        final destFile = File(destPath);
        await destFile.parent.create(recursive: true);
        await destFile.writeAsBytes(entry.bytes);
        createdFiles.add(destFile);
        extractedPaths[entry.name] = destFile.path;
      }
    }

    List<Map<String, dynamic>> rowsOf(String name) =>
        (tables[name] as List<dynamic>).cast<Map<String, dynamic>>();

    try {
      await _db.transaction(() async {
        // Delete existing rows in child-to-parent order so foreign keys stay
        // satisfied throughout the transaction.
        await _db.delete(_db.attachments).go();
        await _db.delete(_db.maintenanceReminders).go();
        await _db.delete(_db.partInstallations).go();
        await _db.delete(_db.maintenanceRecordParts).go();
        await _db.delete(_db.parts).go();
        await _db.delete(_db.componentSpecs).go();
        await _db.delete(_db.componentMeasurements).go();
        await _db.customStatement(
            'UPDATE odometer_logs SET supersedes_log_id = NULL');
        await _db.delete(_db.odometerLogs).go();
        await _db.customStatement(
            'UPDATE maintenance_records SET supersedes_record_id = NULL');
        await _db.delete(_db.maintenanceRecords).go();
        await _db.delete(_db.maintenanceRuleSteps).go();
        await _db.delete(_db.maintenanceRules).go();
        await _db.delete(_db.maintenanceItems).go();
        await _db.delete(_db.maintenanceCategories).go();
        await _db.delete(_db.motorcycles).go();

        // Insert in parent-to-child order, preserving original IDs.
        for (final m in rowsOf('motorcycles')) {
          final copy = Map<String, dynamic>.of(m);
          final entryName = copy.remove('archiveEntry') as String?;
          if (entryName != null && extractedPaths.containsKey(entryName)) {
            copy['photoPath'] = extractedPaths[entryName];
          }
          await _db.into(_db.motorcycles).insert(MotorcycleRow.fromJson(copy));
        }

        for (final m in rowsOf('maintenance_categories')) {
          await _db
              .into(_db.maintenanceCategories)
              .insert(MaintenanceCategoryRow.fromJson(m));
        }

        for (final m in rowsOf('maintenance_items')) {
          final copy = Map<String, dynamic>.of(m);
          copy.putIfAbsent(
              'isUserDefined', () => copy['name'] == 'Fuel Filter');
          await _db
              .into(_db.maintenanceItems)
              .insert(MaintenanceItemRow.fromJson(copy));
        }

        for (final m in rowsOf('maintenance_rules')) {
          await _db
              .into(_db.maintenanceRules)
              .insert(MaintenanceRuleRow.fromJson(m));
        }

        for (final m in rowsOf('maintenance_rule_steps')) {
          await _db
              .into(_db.maintenanceRuleSteps)
              .insert(MaintenanceRuleStepRow.fromJson(m));
        }

        // Sort self-referencing tables by ID ascending so referenced rows exist
        // before superseding rows.
        final recMaps =
            List<Map<String, dynamic>>.of(rowsOf('maintenance_records'))
              ..sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));
        for (final m in recMaps) {
          await _db
              .into(_db.maintenanceRecords)
              .insert(MaintenanceRecordRow.fromJson(m));
        }

        final odoMaps = List<Map<String, dynamic>>.of(rowsOf('odometer_logs'))
          ..sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));
        for (final m in odoMaps) {
          await _db.into(_db.odometerLogs).insert(OdometerLogRow.fromJson(m));
        }

        for (final m in rowsOf('component_measurements')) {
          await _db
              .into(_db.componentMeasurements)
              .insert(ComponentMeasurementRow.fromJson(m));
        }

        if (tables['component_specs'] is List) {
          for (final m in rowsOf('component_specs')) {
            await _db
                .into(_db.componentSpecs)
                .insert(ComponentSpecRow.fromJson(m));
          }
        }

        for (final m in rowsOf('parts')) {
          await _db.into(_db.parts).insert(PartRow.fromJson(m));
        }

        for (final m in rowsOf('maintenance_record_parts')) {
          await _db
              .into(_db.maintenanceRecordParts)
              .insert(MaintenanceRecordPartRow.fromJson(m));
        }

        for (final m in rowsOf('part_installations')) {
          await _db
              .into(_db.partInstallations)
              .insert(PartInstallationRow.fromJson(m));
        }

        for (final m in rowsOf('maintenance_reminders')) {
          await _db
              .into(_db.maintenanceReminders)
              .insert(MaintenanceReminderRow.fromJson(m));
        }

        for (final m in rowsOf('attachments')) {
          final copy = Map<String, dynamic>.of(m);
          final entryName = copy.remove('archiveEntry') as String?;
          if (entryName != null && extractedPaths.containsKey(entryName)) {
            copy['filePath'] = extractedPaths[entryName];
          }
          await _db.into(_db.attachments).insert(AttachmentRow.fromJson(copy));
        }
      });
      return parsed.preview;
    } catch (e) {
      for (final f in createdFiles) {
        try {
          if (await f.exists()) await f.delete();
        } catch (_) {}
      }
      if (e is BackupException) rethrow;
      throw BackupException('Failed to restore backup: $e');
    }
  }

  Future<_ParsedBackup> _loadAndValidateFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw const BackupException('Backup file does not exist.');
    }
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) {
      throw const BackupException('Backup file is empty.');
    }

    List<ZipEntry> zipEntries = const [];
    String jsonText;

    final isZipMagic = bytes.length >= 4 &&
        bytes[0] == 0x50 &&
        bytes[1] == 0x4b &&
        bytes[2] == 0x03 &&
        bytes[3] == 0x04;

    if (isZipMagic || filePath.toLowerCase().endsWith('.zip')) {
      try {
        zipEntries = ZipCodec.decode(bytes);
      } catch (e) {
        throw BackupException('Corrupted ZIP backup archive: $e');
      }
      final backupEntry =
          zipEntries.where((e) => e.name == 'backup.json').firstOrNull;
      if (backupEntry == null) {
        throw const BackupException(
            'ZIP archive does not contain backup.json.');
      }
      try {
        jsonText = utf8.decode(backupEntry.bytes);
      } catch (_) {
        throw const BackupException(
            'backup.json inside ZIP is not valid UTF-8.');
      }
    } else {
      try {
        jsonText = utf8.decode(bytes);
      } catch (_) {
        throw const BackupException('Backup file is not valid UTF-8 JSON.');
      }
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(jsonText);
    } catch (_) {
      throw const BackupException('Backup file is not valid JSON.');
    }
    if (decoded is! Map<String, dynamic>) {
      throw const BackupException('Backup root must be a JSON object.');
    }

    final preview = validateBackupStructure(
      decoded,
      bundledAttachments:
          zipEntries.where((e) => e.name != 'backup.json').length,
    );
    return _ParsedBackup(
      map: decoded,
      preview: preview,
      zipEntries: zipEntries,
    );
  }

  /// Validates the structure, app identifier, format version, schema version,
  /// required tables, and row IDs of a decoded backup map.
  BackupPreview validateBackupStructure(
    Map<String, dynamic> map, {
    int bundledAttachments = 0,
  }) {
    if (map['app'] != kBackupAppId) {
      throw const BackupException(
          'Unrecognized backup file (missing ADV-MON header).');
    }
    final formatVersion = map['formatVersion'];
    if (formatVersion is! int ||
        formatVersion < 1 ||
        formatVersion > kBackupFormatVersion) {
      throw BackupException(
          'Unsupported backup format version: $formatVersion.');
    }
    final schemaVersion = map['schemaVersion'];
    if (schemaVersion is! int ||
        schemaVersion < 1 ||
        schemaVersion > kDatabaseSchemaVersion) {
      throw BackupException(
          'Unsupported database schema version: $schemaVersion '
          '(current app supports up to v$kDatabaseSchemaVersion).');
    }
    final createdAt = map['createdAt'];
    if (createdAt is! String || createdAt.isEmpty) {
      throw const BackupException('Backup is missing createdAt timestamp.');
    }
    final tables = map['tables'];
    if (tables is! Map<String, dynamic>) {
      throw const BackupException('Backup is missing tables payload.');
    }

    final counts = <String, int>{};
    final idSets = <String, Set<int>>{};

    for (final t in requiredTables) {
      final list = tables[t];
      if (list is! List) {
        throw BackupException('Backup is missing required table "$t".');
      }
      final ids = <int>{};
      for (final row in list) {
        if (row is! Map<String, dynamic>) {
          throw BackupException('Invalid row in table "$t".');
        }
        final id = row['id'];
        if (id is! int || id <= 0) {
          throw BackupException('Invalid or missing row id in table "$t".');
        }
        if (!ids.add(id)) {
          throw BackupException('Duplicate row id $id in table "$t".');
        }
      }
      counts[t] = list.length;
      idSets[t] = ids;
    }

    // Referential integrity pre-check before touching the live database.
    void checkRef(String childTable, String fkField, String parentTable,
        {bool nullable = false}) {
      final parentIds = idSets[parentTable]!;
      for (final r
          in (tables[childTable] as List).cast<Map<String, dynamic>>()) {
        final fk = r[fkField];
        if (fk == null) {
          if (!nullable) {
            throw BackupException(
                'Null "$fkField" in "$childTable" (id=${r['id']}).');
          }
          continue;
        }
        if (fk is! int || !parentIds.contains(fk)) {
          throw BackupException(
            'Broken foreign key in "$childTable" (id=${r['id']}): '
            '$fkField=$fk not found in "$parentTable".',
          );
        }
      }
    }

    checkRef('maintenance_items', 'categoryId', 'maintenance_categories');
    checkRef('maintenance_rules', 'motorcycleId', 'motorcycles');
    checkRef('maintenance_rules', 'itemId', 'maintenance_items');
    checkRef('maintenance_rule_steps', 'ruleId', 'maintenance_rules');
    checkRef('maintenance_records', 'motorcycleId', 'motorcycles');
    checkRef('maintenance_records', 'itemId', 'maintenance_items');
    checkRef('maintenance_records', 'supersedesRecordId', 'maintenance_records',
        nullable: true);
    checkRef('odometer_logs', 'motorcycleId', 'motorcycles');
    checkRef('odometer_logs', 'supersedesLogId', 'odometer_logs',
        nullable: true);
    checkRef('component_measurements', 'motorcycleId', 'motorcycles');
    checkRef('component_measurements', 'itemId', 'maintenance_items');
    checkRef('parts', 'itemId', 'maintenance_items', nullable: true);
    checkRef('maintenance_record_parts', 'recordId', 'maintenance_records');
    checkRef('maintenance_record_parts', 'partId', 'parts');
    checkRef('part_installations', 'partId', 'parts');
    checkRef('part_installations', 'motorcycleId', 'motorcycles');
    checkRef('maintenance_reminders', 'motorcycleId', 'motorcycles');

    return BackupPreview(
      formatVersion: formatVersion,
      schemaVersion: schemaVersion,
      createdAt: createdAt,
      tableCounts: counts,
      bundledAttachmentCount: bundledAttachments,
    );
  }

  // --------------------------------------------------------------------- CSV

  /// Generates RFC-4180 CSV content for maintenance records.
  String buildMaintenanceRecordsCsv(List<MaintenanceRecordDetail> records) {
    final buf = StringBuffer();
    buf.writeln(_csvRow([
      'Record ID',
      'Date',
      'Odometer (km)',
      'Category',
      'Maintenance Item',
      'Action',
      'Parts Used',
      'Labor Cost (PHP)',
      'Parts Cost (PHP)',
      'Total Cost (PHP)',
      'Service Provider',
      'Notes',
    ]));
    for (final r in records) {
      final partsDesc =
          r.parts.map((p) => '${p.part.name} x${p.quantity}').join('; ');
      buf.writeln(_csvRow([
        '${r.id}',
        _isoDate(r.performedDate),
        '${r.odometerKm}',
        r.categoryName,
        r.itemName,
        r.action.code,
        partsDesc,
        _pesosDecimal(r.laborCostCentavos),
        _pesosDecimal(r.partsCostCentavos),
        _pesosDecimal(r.totalCostCentavos),
        r.serviceProvider ?? '',
        r.notes ?? '',
      ]));
    }
    return buf.toString();
  }

  /// Generates RFC-4180 CSV content for maintenance expenses.
  String buildExpensesCsv(List<MaintenanceRecordDetail> records) {
    final buf = StringBuffer();
    buf.writeln(_csvRow([
      'Record ID',
      'Date',
      'Year-Month',
      'Category',
      'Maintenance Item',
      'Action',
      'Odometer (km)',
      'Parts Cost (PHP)',
      'Labor Cost (PHP)',
      'Total Cost (PHP)',
    ]));
    for (final r in records) {
      final ym = '${r.performedDate.year.toString().padLeft(4, '0')}-'
          '${r.performedDate.month.toString().padLeft(2, '0')}';
      buf.writeln(_csvRow([
        '${r.id}',
        _isoDate(r.performedDate),
        ym,
        r.categoryName,
        r.itemName,
        r.action.code,
        '${r.odometerKm}',
        _pesosDecimal(r.partsCostCentavos),
        _pesosDecimal(r.laborCostCentavos),
        _pesosDecimal(r.totalCostCentavos),
      ]));
    }
    return buf.toString();
  }

  /// Writes maintenance records CSV to disk and returns the file path.
  Future<String> exportMaintenanceRecordsCsv(
    List<MaintenanceRecordDetail> records, {
    String? targetPath,
  }) async {
    final csv = buildMaintenanceRecordsCsv(records);
    final path = targetPath ??
        await _defaultExportPath('adv_mon_maintenance_records', 'csv');
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(csv);
    return file.path;
  }

  /// Writes expenses CSV to disk and returns the file path.
  Future<String> exportExpensesCsv(
    List<MaintenanceRecordDetail> records, {
    String? targetPath,
  }) async {
    final csv = buildExpensesCsv(records);
    final path =
        targetPath ?? await _defaultExportPath('adv_mon_expenses', 'csv');
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(csv);
    return file.path;
  }

  Future<String> _defaultExportPath(String prefix, String ext) async {
    final root = await _baseDir();
    final dir = Directory(p.join(root.path, 'exports'));
    await dir.create(recursive: true);
    final ts =
        _clock().toIso8601String().replaceAll(':', '-').replaceAll('.', '-');
    return p.join(dir.path, '${prefix}_$ts.$ext');
  }

  static String _isoDate(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  static String _pesosDecimal(int centavos) =>
      '${centavos ~/ 100}.${(centavos % 100).abs().toString().padLeft(2, '0')}';

  static String _csvRow(List<String> cells) => cells.map(_escapeCsv).join(',');

  static String _escapeCsv(String value) {
    if (value.contains(',') ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}

class _ParsedBackup {
  const _ParsedBackup({
    required this.map,
    required this.preview,
    required this.zipEntries,
  });

  final Map<String, dynamic> map;
  final BackupPreview preview;
  final List<ZipEntry> zipEntries;
}
