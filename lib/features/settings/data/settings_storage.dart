import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

import '../domain/app_settings.dart';

/// Abstraction for picking a backup file so tests can supply a local path.
abstract class BackupFilePicker {
  Future<String?> pickBackupFile();
}

class FilePickerBackupFilePicker implements BackupFilePicker {
  @override
  Future<String?> pickBackupFile() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json', 'zip'],
    );
    return res?.files.single.path;
  }
}

/// Offline persistence for [AppSettings].
class SettingsStorage {
  SettingsStorage(this._baseDir);
  final Future<Directory> Function() _baseDir;

  Future<File> _file() async {
    final dir = await _baseDir();
    await dir.create(recursive: true);
    return File(p.join(dir.path, 'app_settings.json'));
  }

  Future<AppSettings> load() async {
    try {
      final f = await _file();
      if (!await f.exists()) return const AppSettings();
      final map = jsonDecode(await f.readAsString()) as Map<String, dynamic>;
      return AppSettings.fromJson(map);
    } catch (_) {
      return const AppSettings();
    }
  }

  Future<void> save(AppSettings settings) async {
    final f = await _file();
    await f.writeAsString(jsonEncode(settings.toJson()));
  }
}
