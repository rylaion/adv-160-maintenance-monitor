import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/parts_catalog_models.dart';
import 'parts_catalog_view_model.dart';

class ExplodedDiagramViewerScreen extends ConsumerStatefulWidget {
  const ExplodedDiagramViewerScreen({
    super.key,
    this.initialDiagramCode = 'E-17',
    this.initialPartId,
    this.initialPartNumber,
    this.initialPartName,
    this.initialRefNo,
  });

  final String initialDiagramCode;
  final int? initialPartId;
  final String? initialPartNumber;
  final String? initialPartName;
  final int? initialRefNo;

  @override
  ConsumerState<ExplodedDiagramViewerScreen> createState() =>
      _ExplodedDiagramViewerScreenState();
}

class _ExplodedDiagramViewerScreenState
    extends ConsumerState<ExplodedDiagramViewerScreen> {
  late String _selectedCode;
  int _selectedPageIndex = 0;
  String _selectedGroup = 'ALL'; // 'ALL', 'ENGINE GROUP', 'FRAME GROUP'
  final TransformationController _transformController =
      TransformationController();
  List<PartsCatalogItem> _diagramParts = [];
  bool _loadingParts = true;
  int? _highlightedRef;
  bool _showDebugPanel = false;
  String _imageLoadStatus = 'Loading...';

  @override
  void initState() {
    super.initState();
    _selectedCode = widget.initialDiagramCode;
    _highlightedRef = widget.initialRefNo;
    _logRuntimeTrace('initState');
    _loadDiagramParts();
  }

  void _logRuntimeTrace(String event) {
    developer.log(
      'ExplodedDiagramViewer [$event]: partId=${widget.initialPartId}, '
      'partNo=${widget.initialPartNumber}, expectedDiagram=${widget.initialDiagramCode}, '
      'selectedCode=$_selectedCode, highlightedRef=$_highlightedRef',
      name: 'adv_mon.parts_catalog',
    );
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
    m.scale(1.35);
    _transformController.value = m;
  }

  void _zoomOut() {
    final m = _transformController.value.clone();
    m.scale(0.74);
    _transformController.value = m;
  }

  List<PartsCatalogDiagramInfo> _filterDiagrams(
      List<PartsCatalogDiagramInfo> diagrams) {
    if (_selectedGroup == 'ALL') return diagrams;
    return diagrams.where((d) => d.assemblyName == _selectedGroup).toList();
  }

  void _selectDiagram(String code) {
    if (_selectedCode == code) return;
    setState(() {
      _selectedCode = code;
      _selectedPageIndex = 0;
      _highlightedRef = null;
      _imageLoadStatus = 'Loading...';
    });
    _logRuntimeTrace('selectDiagram');
    _resetZoom();
    _loadDiagramParts();
  }

  void _goToPrevious(List<PartsCatalogDiagramInfo> diagrams) {
    final filtered = _filterDiagrams(diagrams);
    if (filtered.isEmpty) return;
    final currentIndex =
        filtered.indexWhere((d) => d.diagramCode == _selectedCode);
    if (currentIndex > 0) {
      _selectDiagram(filtered[currentIndex - 1].diagramCode);
    } else if (currentIndex == -1 && filtered.isNotEmpty) {
      _selectDiagram(filtered.first.diagramCode);
    }
  }

  void _goToNext(List<PartsCatalogDiagramInfo> diagrams) {
    final filtered = _filterDiagrams(diagrams);
    if (filtered.isEmpty) return;
    final currentIndex =
        filtered.indexWhere((d) => d.diagramCode == _selectedCode);
    if (currentIndex >= 0 && currentIndex < filtered.length - 1) {
      _selectDiagram(filtered[currentIndex + 1].diagramCode);
    }
  }

  void _openDiagramPicker(
      BuildContext context, List<PartsCatalogDiagramInfo> allDiagrams) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) {
        return _DiagramSearchModal(
          allDiagrams: allDiagrams,
          currentCode: _selectedCode,
          onSelected: (code) {
            Navigator.of(ctx).pop();
            _selectDiagram(code);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final diagramsAsync = ref.watch(partsCatalogDiagramsProvider);
    final theme = Theme.of(context);

    final allDiagrams = diagramsAsync.valueOrNull ?? [];
    final filteredDiagrams = _filterDiagrams(allDiagrams);

    final currentDiagram =
        allDiagrams.where((d) => d.diagramCode == _selectedCode).firstOrNull;

    final currentIndex =
        filteredDiagrams.indexWhere((d) => d.diagramCode == _selectedCode);
    final hasPrev = currentIndex > 0;
    final hasNext =
        currentIndex >= 0 && currentIndex < filteredDiagrams.length - 1;

    final pagePaths = currentDiagram?.pageAssetPaths ?? [];
    final activeImagePath = _selectedPageIndex < pagePaths.length
        ? pagePaths[_selectedPageIndex]
        : (currentDiagram?.imageAssetPath ?? '');

    final activePrintedPage = (currentDiagram?.printedPageNumber != null)
        ? currentDiagram!.printedPageNumber! + _selectedPageIndex
        : null;
    final activePdfPage = (currentDiagram?.pdfPageNumber != null)
        ? currentDiagram!.pdfPageNumber! + _selectedPageIndex
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _selectedCode,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (currentDiagram != null) ...[
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      currentDiagram.title,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ],
              ],
            ),
            if (currentDiagram != null)
              Text(
                'Honda ADV 160 · ${currentDiagram.assemblyName}'
                '${activePrintedPage != null ? ' · p. $activePrintedPage' : ''}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search Diagrams & Pages',
            onPressed: allDiagrams.isNotEmpty
                ? () => _openDiagramPicker(context, allDiagrams)
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Previous Diagram',
            onPressed: hasPrev ? () => _goToPrevious(allDiagrams) : null,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Next Diagram',
            onPressed: hasNext ? () => _goToNext(allDiagrams) : null,
          ),
          IconButton(
            icon: Icon(
              _showDebugPanel ? Icons.bug_report : Icons.bug_report_outlined,
              color: _showDebugPanel ? theme.colorScheme.primary : null,
            ),
            tooltip: _showDebugPanel
                ? 'Hide Debug Panel'
                : 'Show Runtime Debug Panel',
            onPressed: () {
              setState(() => _showDebugPanel = !_showDebugPanel);
            },
          ),
          PopupMenuButton<String>(
            tooltip: 'More actions',
            onSelected: (value) {
              if (value == 'zoom_in') _zoomIn();
              if (value == 'zoom_out') _zoomOut();
              if (value == 'fit') _resetZoom();
              if (value == 'browse') _openDiagramPicker(context, allDiagrams);
              if (value == 'debug') {
                setState(() => _showDebugPanel = !_showDebugPanel);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'debug',
                child: ListTile(
                  leading: const Icon(Icons.bug_report),
                  title: Text(_showDebugPanel
                      ? 'Hide Debug Panel'
                      : 'Show Debug Panel'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'fit',
                child: ListTile(
                  leading: Icon(Icons.fit_screen),
                  title: Text('Fit to Screen'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'zoom_in',
                child: ListTile(
                  leading: Icon(Icons.zoom_in),
                  title: Text('Zoom In'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'zoom_out',
                child: ListTile(
                  leading: Icon(Icons.zoom_out),
                  title: Text('Zoom Out'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'browse',
                child: ListTile(
                  leading: Icon(Icons.grid_view),
                  title: Text('Browse All Diagrams'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips (All, Engine Group, Frame Group)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            color: theme.colorScheme.surface,
            child: Row(
              children: [
                _buildGroupChip('ALL', 'All (54)'),
                const SizedBox(width: 8),
                _buildGroupChip('ENGINE GROUP', 'Engine (23)'),
                const SizedBox(width: 8),
                _buildGroupChip('FRAME GROUP', 'Frame (31)'),
              ],
            ),
          ),

          // Horizontal Diagram Slider
          if (filteredDiagrams.isNotEmpty)
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: filteredDiagrams.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (context, idx) {
                  final d = filteredDiagrams[idx];
                  final isSelected = d.diagramCode == _selectedCode;
                  return ChoiceChip(
                    visualDensity: VisualDensity.compact,
                    label: Text(
                      '${d.diagramCode} ${d.printedPageNumber != null ? "(p.${d.printedPageNumber})" : ""}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) _selectDiagram(d.diagramCode);
                    },
                  );
                },
              ),
            ),

          const Divider(height: 1),

          // Interactive High-Resolution Catalogue Page Viewer
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Container(
                  color: Colors.black.withOpacity(0.04),
                  width: double.infinity,
                  height: double.infinity,
                  child: ClipRect(
                    child: InteractiveViewer(
                      transformationController: _transformController,
                      minScale: 0.5,
                      maxScale: 6.0,
                      boundaryMargin: const EdgeInsets.all(40),
                      child: Center(
                        child: _CataloguePageImage(
                          imageAssetPath: activeImagePath,
                          diagramInfo: currentDiagram,
                          diagramCode: _selectedCode,
                          onLoadStatusChanged: (status) {
                            if (_imageLoadStatus != status) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  setState(() => _imageLoadStatus = status);
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Runtime Debug Panel overlay (when toggled on)
                if (_showDebugPanel)
                  Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    child: _RuntimeDebugPanel(
                      selectedPartId: widget.initialPartId,
                      oemPartNumber: widget.initialPartNumber,
                      partDescription: widget.initialPartName,
                      expectedDiagramCode: widget.initialDiagramCode,
                      actualDiagramId: currentDiagram?.id,
                      actualDiagramCode: _selectedCode,
                      diagramTitle: currentDiagram?.title,
                      pdfPageNumber: activePdfPage,
                      printedPageNumber: activePrintedPage,
                      imageAssetPath: activeImagePath,
                      imageLoadStatus: _imageLoadStatus,
                      onClose: () => setState(() => _showDebugPanel = false),
                    ),
                  ),

                // Multi-page switcher pill (Bottom Left of Image Canvas)
                if (currentDiagram != null && currentDiagram.pageCount > 1)
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: theme.colorScheme.surface.withOpacity(0.92),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(currentDiagram.pageCount,
                              (pageIdx) {
                            final isPageSelected =
                                _selectedPageIndex == pageIdx;
                            final prP =
                                (currentDiagram.printedPageNumber ?? 0) +
                                    pageIdx;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: ChoiceChip(
                                visualDensity: VisualDensity.compact,
                                label: Text(
                                  'Page ${pageIdx + 1} (p.$prP)',
                                  style: const TextStyle(fontSize: 11),
                                ),
                                selected: isPageSelected,
                                onSelected: (val) {
                                  if (val) {
                                    setState(
                                        () => _selectedPageIndex = pageIdx);
                                    _resetZoom();
                                  }
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),

                // Floating Viewport Controls (Bottom Right of Image Canvas)
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: theme.colorScheme.surface.withOpacity(0.92),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.zoom_out, size: 20),
                          tooltip: 'Zoom Out',
                          onPressed: _zoomOut,
                        ),
                        IconButton(
                          icon: const Icon(Icons.fit_screen, size: 20),
                          tooltip: 'Fit to Screen',
                          onPressed: _resetZoom,
                        ),
                        IconButton(
                          icon: const Icon(Icons.zoom_in, size: 20),
                          tooltip: 'Zoom In',
                          onPressed: _zoomIn,
                        ),
                      ],
                    ),
                  ),
                ),

                // Catalogue Page Metadata Chip (Top Left of Image Canvas)
                if (currentDiagram != null)
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withOpacity(0.90),
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: theme.colorScheme.outlineVariant),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_stories,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Catalogue p. ${activePrintedPage ?? "?"} (PDF p. ${activePdfPage ?? "?"})',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Bottom Component References Section Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(color: theme.colorScheme.outlineVariant),
                bottom: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.view_list,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Components in $_selectedCode (${_diagramParts.length} items)',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  'Tap part to view or record',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(fontStyle: FontStyle.italic, fontSize: 11),
                ),
              ],
            ),
          ),

          // Components List for Current Diagram
          Expanded(
            flex: 4,
            child: _loadingParts
                ? const Center(child: CircularProgressIndicator())
                : _diagramParts.isEmpty
                    ? Center(
                        child: Text(
                          'No individual part entries indexed for $_selectedCode.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                        itemCount: _diagramParts.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, idx) {
                          final part = _diagramParts[idx];
                          final isSelected =
                              part.referenceNumber == _highlightedRef;

                          return ListTile(
                            dense: true,
                            selected: isSelected,
                            selectedTileColor: theme
                                .colorScheme.primaryContainer
                                .withOpacity(0.35),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            leading: CircleAvatar(
                              radius: 14,
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
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            title: Text(
                              part.officialName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            subtitle: Text(
                              'OEM #${part.partNumber} · Req: ${part.standardQuantity}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                                fontSize: 11,
                              ),
                            ),
                            trailing: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
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
                                  style: TextStyle(fontSize: 11)),
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

  Widget _buildGroupChip(String group, String label) {
    final isSelected = _selectedGroup == group;
    return FilterChip(
      visualDensity: VisualDensity.compact,
      label: Text(label, style: const TextStyle(fontSize: 11)),
      selected: isSelected,
      onSelected: (val) {
        setState(() {
          _selectedGroup = val ? group : 'ALL';
        });
      },
    );
  }
}

/// Renders the complete, authentic Honda Parts Catalogue page image
class _CataloguePageImage extends StatelessWidget {
  const _CataloguePageImage({
    required this.imageAssetPath,
    required this.diagramInfo,
    required this.diagramCode,
    this.onLoadStatusChanged,
  });

  final String imageAssetPath;
  final PartsCatalogDiagramInfo? diagramInfo;
  final String diagramCode;
  final ValueChanged<String>? onLoadStatusChanged;

  @override
  Widget build(BuildContext context) {
    if (imageAssetPath.isEmpty) {
      onLoadStatusChanged?.call('No image path');
      return _buildFallback(context);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imageAssetPath,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (ctx, err, stack) {
            onLoadStatusChanged?.call('Error loading asset ($err)');
            return Container(
              width: 360,
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.broken_image, size: 54, color: Colors.red),
                  const SizedBox(height: 12),
                  const Text(
                    'Failed to Load Diagram Asset',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    imageAssetPath,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Error: $err',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            );
          },
          frameBuilder: (ctx, child, frame, wasSync) {
            if (frame == null) {
              return const SizedBox(
                width: 320,
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            onLoadStatusChanged?.call('Loaded');
            return child;
          },
        ),
      ),
    );
  }

  Widget _buildFallback(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 360,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.menu_book,
            size: 48,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'Honda ADV 160 · $diagramCode',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            diagramInfo?.title ?? 'Assembly Diagram',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Original catalogue page illustration for $diagramCode.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

/// Runtime Debug Panel for inspecting Part -> Diagram -> Asset association
class _RuntimeDebugPanel extends StatelessWidget {
  const _RuntimeDebugPanel({
    required this.selectedPartId,
    required this.oemPartNumber,
    required this.partDescription,
    required this.expectedDiagramCode,
    required this.actualDiagramId,
    required this.actualDiagramCode,
    required this.diagramTitle,
    required this.pdfPageNumber,
    required this.printedPageNumber,
    required this.imageAssetPath,
    required this.imageLoadStatus,
    required this.onClose,
  });

  final int? selectedPartId;
  final String? oemPartNumber;
  final String? partDescription;
  final String? expectedDiagramCode;
  final int? actualDiagramId;
  final String actualDiagramCode;
  final String? diagramTitle;
  final int? pdfPageNumber;
  final int? printedPageNumber;
  final String imageAssetPath;
  final String imageLoadStatus;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMatch =
        expectedDiagramCode == null || expectedDiagramCode == actualDiagramCode;

    return Card(
      elevation: 6,
      color: theme.colorScheme.surface.withOpacity(0.96),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isMatch ? theme.colorScheme.primary : Colors.orange,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bug_report,
                  size: 18,
                  color: isMatch ? theme.colorScheme.primary : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  'Runtime Trace & Mapping Debug',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onClose,
                ),
              ],
            ),
            const Divider(height: 12),
            if (selectedPartId != null || oemPartNumber != null) ...[
              _row('Selected Part ID', '#$selectedPartId'),
              _row('OEM Part Number', oemPartNumber ?? 'N/A'),
              _row('Part Name', partDescription ?? 'N/A'),
              _row('Expected Diagram', expectedDiagramCode ?? 'N/A'),
            ],
            _row('Active Diagram Code', actualDiagramCode),
            _row('Diagram Record ID', actualDiagramId?.toString() ?? 'N/A'),
            _row('Diagram Title', diagramTitle ?? 'N/A'),
            _row('Catalogue Page',
                'Printed p. ${printedPageNumber ?? "?"} (PDF p. ${pdfPageNumber ?? "?"})'),
            _row('Image Asset Path', imageAssetPath, mono: true),
            _row(
              'Image Status',
              imageLoadStatus,
              color: imageLoadStatus == 'Loaded'
                  ? Colors.green
                  : (imageLoadStatus.contains('Error')
                      ? Colors.red
                      : Colors.orange),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool mono = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontFamily: mono ? 'monospace' : null,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Search & Quick Jump Dialog for Diagrams and Catalogue Pages
class _DiagramSearchModal extends StatefulWidget {
  const _DiagramSearchModal({
    required this.allDiagrams,
    required this.currentCode,
    required this.onSelected,
  });

  final List<PartsCatalogDiagramInfo> allDiagrams;
  final String currentCode;
  final ValueChanged<String> onSelected;

  @override
  State<_DiagramSearchModal> createState() => _DiagramSearchModalState();
}

class _DiagramSearchModalState extends State<_DiagramSearchModal> {
  String _query = '';
  String _groupFilter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filtered = widget.allDiagrams.where((d) {
      if (_groupFilter != 'ALL' && d.assemblyName != _groupFilter) {
        return false;
      }
      if (_query.trim().isEmpty) return true;
      final q = _query.toLowerCase().trim();
      final codeMatch = d.diagramCode.toLowerCase().contains(q);
      final titleMatch = d.title.toLowerCase().contains(q);
      final pageMatch = d.printedPageNumber?.toString().contains(q) ?? false;

      // Common mechanical terminology synonyms
      final isRearBrake = q.contains('rear brake') &&
          ['F-6', 'F-7-10', 'F-21'].contains(d.diagramCode);
      final isFrontBrake = q.contains('front brake') &&
          ['F-5-20', 'F-18'].contains(d.diagramCode);
      final isShockOrStem = (q.contains('front shock') ||
              q.contains('t-post') ||
              q.contains('t post') ||
              q.contains('fork') ||
              q.contains('stem')) &&
          ['F-10', 'F-17'].contains(d.diagramCode);
      final isRearShock = (q.contains('rear shock') || q.contains('cushion')) &&
          d.diagramCode == 'F-36';
      final isCvt =
          (q.contains('cvt') || q.contains('belt') || q.contains('pulley')) &&
              ['E-16', 'E-17', 'E-17-10'].contains(d.diagramCode);

      return codeMatch ||
          titleMatch ||
          pageMatch ||
          isRearBrake ||
          isFrontBrake ||
          isShockOrStem ||
          isRearShock ||
          isCvt;
    }).toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (ctx, scrollController) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText:
                        'Search diagram (e.g. Rear Brake, F-6, F-10, E-17)...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onChanged: (val) => setState(() => _query = val),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: _groupFilter == 'ALL',
                      onSelected: (_) => setState(() => _groupFilter = 'ALL'),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Engine Group'),
                      selected: _groupFilter == 'ENGINE GROUP',
                      onSelected: (_) =>
                          setState(() => _groupFilter = 'ENGINE GROUP'),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Frame Group'),
                      selected: _groupFilter == 'FRAME GROUP',
                      onSelected: (_) =>
                          setState(() => _groupFilter = 'FRAME GROUP'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('No diagrams found.'))
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: filtered.length,
                        itemBuilder: (ctx, idx) {
                          final d = filtered[idx];
                          final isCurrent = d.diagramCode == widget.currentCode;

                          return ListTile(
                            selected: isCurrent,
                            leading: Container(
                              width: 56,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 6),
                              decoration: BoxDecoration(
                                color: isCurrent
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                d.diagramCode,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: isCurrent
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                            title: Text(
                              d.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              '${d.assemblyName} · Catalogue p. ${d.printedPageNumber ?? "?"}${d.pageCount > 1 ? " (${d.pageCount} pages)" : ""}',
                              style: theme.textTheme.bodySmall,
                            ),
                            trailing: isCurrent
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green)
                                : const Icon(Icons.chevron_right),
                            onTap: () => widget.onSelected(d.diagramCode),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
