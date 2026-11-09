import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

/// Source of inspection photos. Abstracted so tests can fake it.
abstract class PhotoPicker {
  /// Returns a local file path, or null if cancelled.
  Future<String?> pick({required bool camera});
}

class ImagePickerPhotoPicker implements PhotoPicker {
  final _picker = ImagePicker();

  @override
  Future<String?> pick({required bool camera}) async {
    final file = await _picker.pickImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 2048,
      imageQuality: 85,
    );
    return file?.path;
  }
}

/// A photo copied into app storage.
class StoredPhoto {
  const StoredPhoto({required this.path, this.mimeType});
  final String path;
  final String? mimeType;
}

/// Copies picked photos into app-private storage so they survive the picker's
/// temporary files and can be included in backups (Phase 5).
class AttachmentService {
  AttachmentService(this._baseDir);

  /// Provides the app documents directory.
  final Future<Directory> Function() _baseDir;

  Future<List<StoredPhoto>> store(List<String> sourcePaths) async {
    if (sourcePaths.isEmpty) return const [];
    final root = await _baseDir();
    final dir = Directory(p.join(root.path, 'attachments'));
    await dir.create(recursive: true);
    final stored = <StoredPhoto>[];
    try {
      var i = 0;
      for (final src in sourcePaths) {
        final source = File(src);
        if (!await source.exists()) {
          throw FileSystemException('Photo not found', src);
        }
        final ext = p.extension(src).toLowerCase();
        final name =
            'photo_${DateTime.now().microsecondsSinceEpoch}_${i++}$ext';
        final dest = p.join(dir.path, name);
        await source.copy(dest);
        stored.add(StoredPhoto(path: dest, mimeType: _mime(ext)));
      }
    } catch (_) {
      await discard(stored); // do not leave orphaned copies behind
      rethrow;
    }
    return stored;
  }

  /// Deletes stored copies (used when saving to the database fails).
  Future<void> discard(List<StoredPhoto> photos) async {
    for (final ph in photos) {
      try {
        final f = File(ph.path);
        if (await f.exists()) await f.delete();
      } catch (_) {}
    }
  }

  static String? _mime(String ext) => switch (ext) {
        '.jpg' || '.jpeg' => 'image/jpeg',
        '.png' => 'image/png',
        '.webp' => 'image/webp',
        '.heic' => 'image/heic',
        _ => null,
      };
}

