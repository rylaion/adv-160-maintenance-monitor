import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/offline_map_models.dart';
import '../offline_maps_view_model.dart';

/// Screen for managing offline map packages, importing MBTiles,
/// viewing touring zone boundaries, and verifying OSM policy compliance.
class OfflineMapsScreen extends ConsumerWidget {
  const OfflineMapsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(offlineMapsViewModelProvider);
    final vm = ref.read(offlineMapsViewModelProvider.notifier);
    final theme = Theme.of(context);

    // Display transient snackbars for success or error
    ref.listen<OfflineMapsState>(offlineMapsViewModelProvider, (prev, next) {
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
      if (next.successMessage != null &&
          next.successMessage != prev?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: Colors.green.shade800,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Maps & Regions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: vm.refresh,
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. Storage & Active Overview Card
                Card(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.sd_storage,
                                color: theme.colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Offline Map Storage',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Consumed',
                                    style: theme.textTheme.bodySmall),
                                Text(
                                  state.formattedTotalStorage,
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Active Map Mode',
                                    style: theme.textTheme.bodySmall),
                                Text(
                                  state.activePackageId != null
                                      ? 'Offline MBTiles Active'
                                      : 'Online OSM / Standard',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: state.activePackageId != null
                                        ? Colors.amber.shade800
                                        : Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Import Button
                FilledButton.icon(
                  onPressed: vm.importFromFilePicker,
                  icon: const Icon(Icons.file_upload_outlined),
                  label: const Text(
                      'Import Offline Package (.MBTiles / .PMTiles)'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 20),

                // 3. OSM Tile Usage Policy Notice
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blueGrey.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          size: 20, color: Colors.blueGrey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'OpenStreetMap Tile Usage Policy: Bulk-downloading or scraping tiles '
                          'from standard public OSM tile servers is prohibited. Offline mapping '
                          'in ADV-MON operates via authorized MBTiles/PMTiles archives, custom tile '
                          'extracts, or self-hosted tile infrastructure.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 4. Installed Packages Section
                Text(
                  'Installed Offline Packages (${state.packages.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                if (state.packages.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.map_outlined,
                                size: 40, color: theme.colorScheme.outline),
                            const SizedBox(height: 8),
                            const Text(
                              'No offline map packages installed yet.',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Import an MBTiles package or pre-extract a touring zone to navigate without cellular reception.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  ...state.packages.map((pkg) {
                    final isActive = state.activePackageId == pkg.id;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isActive
                              ? Colors.amber.shade700
                              : theme.colorScheme.outlineVariant,
                          width: isActive ? 2 : 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pkg.name,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        pkg.description,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: isActive,
                                  activeColor: Colors.amber.shade700,
                                  onChanged: (val) {
                                    vm.setActivePackage(val ? pkg.id : null);
                                  },
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _StatPill(
                                  icon: Icons.data_usage,
                                  label: pkg.formattedSize,
                                ),
                                _StatPill(
                                  icon: Icons.zoom_in,
                                  label: 'z${pkg.minZoom} - z${pkg.maxZoom}',
                                ),
                                if (pkg.tileCount != null)
                                  _StatPill(
                                    icon: Icons.grid_on,
                                    label: '${pkg.tileCount} tiles',
                                  ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      size: 20),
                                  tooltip: 'Delete Package',
                                  color: theme.colorScheme.error,
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title:
                                            const Text('Delete Offline Map?'),
                                        content: Text(
                                          'Are you sure you want to delete "${pkg.name}" (${pkg.formattedSize})? This will free up storage space.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(ctx, false),
                                            child: const Text('Cancel'),
                                          ),
                                          FilledButton(
                                            style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  theme.colorScheme.error,
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(ctx, true),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await vm.deletePackage(pkg.id);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 24),

                // 5. Predefined Motorcycle Touring Zones
                Text(
                  'Recommended Motorcycle Touring Zones',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Geographic bounds for popular Philippine motorcycle routes. Use these coordinates when generating MBTiles via Planetiler or Protomaps.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),

                ...PredefinedMotorcycleZone.curatedZones.map((zone) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.two_wheeler,
                                  color: Colors.amber, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  zone.name,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '~${zone.estimatedSizeMb.toInt()} MB',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(zone.description,
                              style: theme.textTheme.bodySmall),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.crop_free,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Bounds: [${zone.bounds.minLongitude.toStringAsFixed(2)}, ${zone.bounds.minLatitude.toStringAsFixed(2)}] to [${zone.bounds.maxLongitude.toStringAsFixed(2)}, ${zone.bounds.maxLatitude.toStringAsFixed(2)}]',
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 11,
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
                }),
              ],
            ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
