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
                                final query = [
                                  if (km != null) 'itemId=$km',
                                  'action=REPLACE',
                                  'notes=Replaced with genuine Honda OEM ${part.officialName} (${part.partNumber})',
                                  'partName=${Uri.encodeComponent(part.officialName)}',
                                  'partNo=${Uri.encodeComponent(part.partNumber)}',
                                  'brand=${Uri.encodeComponent("Honda Genuine OEM")}',
                                ].join('&');
                                context.push('/maintenance/record?$query');
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
    required this.parts,
    this.highlightedRef,
    required this.onRefSelected,
  });

  final String diagramCode;
  final List<PartsCatalogItem> parts;
  final int? highlightedRef;
  final ValueChanged<int> onRefSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 360,
      height: 300,
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
      child: Stack(
        children: [
          // Background technical grid watermark
          Positioned.fill(
            child: CustomPaint(
              painter: _BlueprintGridPainter(
                lineColor: theme.colorScheme.outlineVariant.withOpacity(0.3),
              ),
            ),
          ),
          // Schematic Assembly Illustration
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _diagramIcon(diagramCode),
                  size: 80,
                  color: theme.colorScheme.primary.withOpacity(0.7),
                ),
                const SizedBox(height: 8),
                Text(
                  'HONDA ADV 160 OEM DIAGRAM',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                Text(
                  diagramCode,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ),
          // Hotspot Reference Callout Chips
          for (final part in parts)
            if (part.referenceNumber != null)
              _buildHotspot(context, part.referenceNumber!),
        ],
      ),
    );
  }

  IconData _diagramIcon(String code) {
    switch (code) {
      case 'E-17':
        return Icons.settings_input_component;
      case 'F-11':
      case 'F-12':
        return Icons.album_outlined;
      case 'E-19':
        return Icons.air;
      default:
        return Icons.build;
    }
  }

  Widget _buildHotspot(BuildContext context, int refNum) {
    final theme = Theme.of(context);
    final isSelected = highlightedRef == refNum;

    // Fixed radial coordinates on canvas based on reference index
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
    // Spatial positioning inside the 360x300 card for exploded parts
    switch (refNum) {
      case 1:
        return const Offset(20, 30);
      case 2:
        return const Offset(240, 30);
      case 3:
        return const Offset(20, 110);
      case 4:
        return const Offset(250, 110);
      case 5:
        return const Offset(30, 200);
      case 8:
        return const Offset(240, 200);
      case 11:
        return const Offset(140, 240);
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
