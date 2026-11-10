import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/parts_catalog_models.dart';
import 'parts_catalog_view_model.dart';

class ExplodedDiagramViewerScreen extends ConsumerStatefulWidget {
  const ExplodedDiagramViewerScreen({
    super.key,
    this.initialDiagramCode = 'E-17',
  });

  final String initialDiagramCode;

  @override
  ConsumerState<ExplodedDiagramViewerScreen> createState() =>
      _ExplodedDiagramViewerScreenState();
}

class _ExplodedDiagramViewerScreenState
    extends ConsumerState<ExplodedDiagramViewerScreen> {
  late String _selectedCode;
  final TransformationController _transformController =
      TransformationController();
  List<PartsCatalogItem> _diagramParts = [];
  bool _loadingParts = true;
  int? _highlightedRef;

  @override
  void initState() {
    super.initState();
    _selectedCode = widget.initialDiagramCode;
    _loadDiagramParts();
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  Future<void> _loadDiagramParts() async {
    setState(() => _loadingParts = true);
    final repo = ref.read(partsCatalogRepositoryProvider);
    final list = await repo.getPartsForDiagram(_selectedCode);
    if (mounted) {
      setState(() {
        _diagramParts = list;
        _loadingParts = false;
      });
    }
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
  }

  void _zoomIn() {
    final m = _transformController.value.clone();
    m.scale(1.3);
    _transformController.value = m;
  }

  void _zoomOut() {
    final m = _transformController.value.clone();
    m.scale(0.77);
    _transformController.value = m;
  }

  @override
  Widget build(BuildContext context) {
    final diagramsAsync = ref.watch(partsCatalogDiagramsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OEM Exploded Diagrams'),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_in),
            tooltip: 'Zoom In',
            onPressed: _zoomIn,
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            tooltip: 'Zoom Out',
            onPressed: _zoomOut,
          ),
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Reset Zoom',
            onPressed: _resetZoom,
          ),
        ],
      ),
      body: Column(
        children: [
          // Diagram Selector Tabs
          diagramsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
            data: (diagrams) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: diagrams.map((d) {
                    final isSelected = d.diagramCode == _selectedCode;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text('${d.diagramCode}: ${d.title}'),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val && _selectedCode != d.diagramCode) {
                            setState(() {
                              _selectedCode = d.diagramCode;
                              _highlightedRef = null;
                            });
                            _resetZoom();
                            _loadDiagramParts();
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          // Interactive Exploded Diagram Canvas
          Expanded(
            flex: 5,
            child: Container(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              width: double.infinity,
              child: ClipRect(
                child: InteractiveViewer(
                  transformationController: _transformController,
                  minScale: 0.5,
                  maxScale: 4.0,
                  boundaryMargin: const EdgeInsets.all(40),
                  child: Center(
                    child: _DiagramGraphicView(
                      diagramCode: _selectedCode,
                      diagramInfo: diagramsAsync.valueOrNull
                          ?.where((d) => d.diagramCode == _selectedCode)
                          .firstOrNull,
                      parts: _diagramParts,
                      highlightedRef: _highlightedRef,
                      onRefSelected: (ref) {
                        setState(() => _highlightedRef = ref);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Bottom Parts Index for this Diagram
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: theme.colorScheme.surface,
            child: Row(
              children: [
                const Icon(Icons.list_alt, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Diagram Parts (${_diagramParts.length} components)',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  'Pinch & Drag to Zoom',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: _loadingParts
                ? const Center(child: CircularProgressIndicator())
                : _diagramParts.isEmpty
                    ? const Center(
                        child: Text('No catalog items mapped to this diagram.'))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: _diagramParts.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, idx) {
                          final part = _diagramParts[idx];
                          final isSelected =
                              part.referenceNumber == _highlightedRef;

                          return ListTile(
                            selected: isSelected,
                            selectedTileColor: theme
                                .colorScheme.primaryContainer
                                .withOpacity(0.3),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.secondaryContainer,
                              child: Text(
                                '${part.referenceNumber ?? idx + 1}',
                                style: TextStyle(
                                  color: isSelected
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSecondaryContainer,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            title: Text(
                              part.officialName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            subtitle: Text(
                              'OEM #${part.partNumber} · Req: ${part.standardQuantity}',
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(fontFamily: 'monospace'),
                            ),
                            trailing: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onPressed: () {
                                final km = part.maintenanceItemId;
                                final notesBuf = StringBuffer();
                                notesBuf.write(
                                    'Replaced with genuine Honda OEM ${part.officialName} (${part.partNumber}).');
                                notesBuf.write(' Category: ${part.category}.');
                                if (part.diagramNumber != null) {
                                  notesBuf.write(
                                      ' Diagram: ${part.diagramReferenceLabel}.');
                                }

                                final uri = Uri(
                                  path: '/maintenance/record',
                                  queryParameters: {
                                    if (km != null) 'itemId': '$km',
                                    'action': 'REPLACE',
                                    'notes': notesBuf.toString(),
                                    'partName': part.officialName,
                                    'partNo': part.partNumber,
                                    'brand': 'Honda Genuine OEM',
                                  },
                                );
                                context.push(uri.toString());
                              },
                              child: const Text('Record',
                                  style: TextStyle(fontSize: 12)),
                            ),
                            onTap: () {
                              setState(() {
                                _highlightedRef = part.referenceNumber;
                              });
                              context.push('/parts/catalog/${part.id}');
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

/// Vector Schematic Graphic Canvas representing the official exploded assembly
class _DiagramGraphicView extends StatelessWidget {
  const _DiagramGraphicView({
    required this.diagramCode,
    this.diagramInfo,
    required this.parts,
    this.highlightedRef,
    required this.onRefSelected,
  });

  final String diagramCode;
  final PartsCatalogDiagramInfo? diagramInfo;
  final List<PartsCatalogItem> parts;
  final int? highlightedRef;
  final ValueChanged<int> onRefSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imagePath = diagramInfo?.imageAssetPath;

    return Container(
      width: 380,
      constraints: const BoxConstraints(minHeight: 320),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background technical blueprint grid
            Positioned.fill(
              child: CustomPaint(
                painter: _BlueprintGridPainter(
                  lineColor: theme.colorScheme.outlineVariant.withOpacity(0.25),
                ),
              ),
            ),

            // If actual image asset is provided, display image with loading & error states
            if (imagePath != null && imagePath.isNotEmpty)
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, err, stack) =>
                      _buildUnavailableNotice(context),
                  frameBuilder: (ctx, child, frame, wasSync) {
                    if (frame == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return child;
                  },
                ),
              )
            else
              _buildUnavailableNotice(context),

            // Hotspot Reference Callout Chips
            for (final part in parts)
              if (part.referenceNumber != null)
                _buildHotspot(context, part.referenceNumber!),
          ],
        ),
      ),
    );
  }

  Widget _buildUnavailableNotice(BuildContext context) {
    final theme = Theme.of(context);
    final title = diagramInfo?.title ?? 'Assembly Diagram';
    final assembly = diagramInfo?.assemblyName ?? 'OEM Assembly';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _diagramIcon(diagramCode),
              size: 56,
              color: theme.colorScheme.primary.withOpacity(0.85),
            ),
            const SizedBox(height: 10),
            Text(
              'HONDA ADV 160 (K0W) · $diagramCode',
              style: theme.textTheme.labelMedium?.copyWith(
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              assembly,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.surfaceContainerHighest.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Official schematic image not bundled in offline assets.\nView verified OEM component references below.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _diagramIcon(String code) {
    switch (code) {
      case 'E-17':
        return Icons.settings_input_component;
      case 'F-10':
      case 'F-13':
        return Icons.album_outlined;
      case 'F-11':
      case 'F-12':
        return Icons.disc_full;
      case 'E-19':
        return Icons.air;
      case 'E-02':
        return Icons.bolt;
      case 'E-08':
        return Icons.water_drop;
      case 'E-14':
        return Icons.ac_unit;
      case 'E-18':
        return Icons.swap_vert;
      case 'E-12':
        return Icons.electrical_services;
      case 'F-30':
        return Icons.battery_charging_full;
      default:
        return Icons.build;
    }
  }

  Widget _buildHotspot(BuildContext context, int refNum) {
    final theme = Theme.of(context);
    final isSelected = highlightedRef == refNum;

    // Spatial positioning coordinates on canvas based on reference index
    final offset = _getHotspotOffset(refNum, diagramCode);

    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: GestureDetector(
        onTap: () => onRefSelected(refNum),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.white : theme.colorScheme.primary,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.5),
                  blurRadius: 8,
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.place, size: 12),
              const SizedBox(width: 2),
              Text(
                '#$refNum',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Offset _getHotspotOffset(int refNum, String code) {
    // Spatial positioning inside the 380-wide card for exploded parts
    switch (refNum) {
      case 1:
        return const Offset(20, 20);
      case 2:
        return const Offset(280, 20);
      case 3:
        return const Offset(20, 260);
      case 4:
        return const Offset(280, 260);
      case 5:
        return const Offset(20, 140);
      case 8:
        return const Offset(280, 140);
      case 11:
        return const Offset(150, 260);
      default:
        return Offset((refNum * 45) % 260 + 20, (refNum * 65) % 220 + 20);
    }
  }
}

class _BlueprintGridPainter extends CustomPainter {
  const _BlueprintGridPainter({required this.lineColor});
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.5;

    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
