import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../features/maintenance/domain/maintenance_record_detail.dart';
import '../providers/providers.dart';

/// Picker + thumbnail strip for new and existing inspection photos.
class PhotoAttachmentsSection extends ConsumerWidget {
  const PhotoAttachmentsSection({
    super.key,
    required this.newPaths,
    required this.onAddPath,
    required this.onRemoveNewAt,
    this.existing = const [],
    this.keptExistingIds = const {},
    this.onToggleExisting,
  });

  final List<String> newPaths;
  final void Function(String path) onAddPath;
  final void Function(int index) onRemoveNewAt;
  final List<AttachmentInfo> existing;
  final Set<int> keptExistingIds;
  final void Function(int attachmentId)? onToggleExisting;

  Future<void> _pick(WidgetRef ref, bool camera) async {
    final path = await ref.read(photoPickerProvider).pick(camera: camera);
    if (path != null) onAddPath(path);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child:
                  Text('Inspection photos', style: theme.textTheme.titleSmall),
            ),
            TextButton.icon(
              onPressed: () => _pick(ref, false),
              icon: const Icon(Icons.photo_library_outlined, size: 18),
              label: const Text('Gallery'),
            ),
            TextButton.icon(
              onPressed: () => _pick(ref, true),
              icon: const Icon(Icons.photo_camera_outlined, size: 18),
              label: const Text('Camera'),
            ),
          ],
        ),
        if (existing.isEmpty && newPaths.isEmpty)
          Text('No photos attached', style: theme.textTheme.bodySmall)
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final a in existing)
                if (keptExistingIds.contains(a.id))
                  _PhotoChip(
                    path: a.filePath,
                    onRemove: onToggleExisting == null
                        ? null
                        : () => onToggleExisting!(a.id),
                  ),
              for (var i = 0; i < newPaths.length; i++)
                _PhotoChip(
                  path: newPaths[i],
                  onRemove: () => onRemoveNewAt(i),
                ),
            ],
          ),
      ],
    );
  }
}

class _PhotoChip extends StatelessWidget {
  const _PhotoChip({required this.path, this.onRemove});
  final String path;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final file = File(path);
    final exists = file.existsSync();
    return InputChip(
      avatar: exists
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.file(file, width: 24, height: 24, fit: BoxFit.cover),
            )
          : const Icon(Icons.image_outlined, size: 18),
      label: Text(p.basename(path), overflow: TextOverflow.ellipsis),
      onDeleted: onRemove,
    );
  }
}

/// Read-only photo thumbnail row for history & measurement cards.
class AttachmentGalleryRow extends StatelessWidget {
  const AttachmentGalleryRow({super.key, required this.attachments});
  final List<AttachmentInfo> attachments;

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [
          for (final a in attachments) _AttachmentThumb(attachment: a),
        ],
      ),
    );
  }
}

class _AttachmentThumb extends StatelessWidget {
  const _AttachmentThumb({required this.attachment});
  final AttachmentInfo attachment;

  @override
  Widget build(BuildContext context) {
    final file = File(attachment.filePath);
    final exists = file.existsSync();
    return ActionChip(
      avatar: const Icon(Icons.photo_outlined, size: 16),
      label: Text(p.basename(attachment.filePath)),
      visualDensity: VisualDensity.compact,
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(p.basename(attachment.filePath)),
            content: exists
                ? Image.file(file, fit: BoxFit.contain)
                : Text('Photo file at ${attachment.filePath}'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Close')),
            ],
          ),
        );
      },
    );
  }
}
