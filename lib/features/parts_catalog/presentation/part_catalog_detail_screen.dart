import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/parts_catalog_models.dart';
import 'exploded_diagram_viewer_screen.dart';
import 'parts_catalog_view_model.dart';

class PartCatalogDetailScreen extends ConsumerStatefulWidget {
  const PartCatalogDetailScreen({super.key, required this.partId});
  final int partId;

  @override
  ConsumerState<PartCatalogDetailScreen> createState() =>
      _PartCatalogDetailScreenState();
}

class _PartCatalogDetailScreenState
    extends ConsumerState<PartCatalogDetailScreen> {
  PartsCatalogItem? _part;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPart();
  }

  Future<void> _loadPart() async {
    final repo = ref.read(partsCatalogRepositoryProvider);
    final item = await repo.getPartById(widget.partId);
    if (mounted) {
      setState(() {
        _part = item;
        _loading = false;
      });
    }
  }

  void _recordReplacement() {
    if (_part == null) return;
    final itemId = _part!.maintenanceItemId;
    final query = [
      if (itemId != null) 'itemId=$itemId',
      'action=REPLACE',
      'notes=Replaced with genuine Honda OEM ${_part!.officialName} (${_part!.partNumber})',
      'partName=${Uri.encodeComponent(_part!.officialName)}',
      'partNo=${Uri.encodeComponent(_part!.partNumber)}',
      'brand=${Uri.encodeComponent("Honda Genuine OEM")}',
    ].join('&');

    context.push('/maintenance/record?$query');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Part Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final p = _part;
    if (p == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Part Details')),
        body: const Center(child: Text('Catalogue part not found.')),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(p.officialName),
        actions: [
          if (p.diagramNumber != null)
            IconButton(
              icon: const Icon(Icons.schema_outlined),
              tooltip: 'View in Diagram',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExplodedDiagramViewerScreen(
                      initialDiagramCode: p.diagramNumber!,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: _recordReplacement,
            icon: const Icon(Icons.build_circle_outlined),
            label: const Text('Record Replacement in Maintenance Log'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Primary Header Card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.precision_manufacturing,
                          color: theme.colorScheme.onPrimaryContainer,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.officialName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                p.partNumber,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.category_outlined, size: 16),
                        label: Text(p.category),
                        visualDensity: VisualDensity.compact,
                      ),
                      Chip(
                        avatar: const Icon(Icons.layers_outlined, size: 16),
                        label: Text(p.assemblyName),
                        visualDensity: VisualDensity.compact,
                      ),
                      Chip(
                        avatar: const Icon(Icons.pin_outlined, size: 16),
                        label: Text('Standard Req: ${p.standardQuantity}'),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Specifications & Diagram Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Catalogue & Engineering Info',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (p.description != null) ...[
                    _InfoRow(label: 'Description', value: p.description!),
                    const Divider(height: 16),
                  ],
                  _InfoRow(
                    label: 'Catalogue Location',
                    value: p.diagramReferenceLabel,
                  ),
                  if (p.diagramNumber != null) ...[
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ExplodedDiagramViewerScreen(
                              initialDiagramCode: p.diagramNumber!,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.zoom_in, size: 18),
                      label: Text('Open Diagram ${p.diagramNumber} in Viewer'),
                    ),
                  ],
                  if (p.supersededPartNumber != null) ...[
                    const Divider(height: 16),
                    _InfoRow(
                      label: 'Superseded From',
                      value: p.supersededPartNumber!,
                    ),
                  ],
                  if (p.remarks != null) ...[
                    const Divider(height: 16),
                    _InfoRow(
                        label: 'Honda Remarks & Limits', value: p.remarks!),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Model Compatibility Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Verified Model Compatibility',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (p.compatibilities.isEmpty)
                    const Text('Standard 2023 Honda ADV 160 fitment.')
                  else
                    ...p.compatibilities.map(
                      (c) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  c.modelName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    c.modelCode,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  c.yearRangeLabel,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Region: ${c.regionalVariant}',
                              style: theme.textTheme.bodySmall,
                            ),
                            if (c.notes != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                c.notes!,
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        const SizedBox(height: 3),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
