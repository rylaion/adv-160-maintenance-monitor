import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'exploded_diagram_viewer_screen.dart';
import 'parts_catalog_view_model.dart';

class PartsCatalogScreen extends ConsumerStatefulWidget {
  const PartsCatalogScreen({super.key});

  @override
  ConsumerState<PartsCatalogScreen> createState() => _PartsCatalogScreenState();
}

class _PartsCatalogScreenState extends ConsumerState<PartsCatalogScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final partsAsync = ref.watch(partsCatalogItemsProvider);
    final categoriesAsync = ref.watch(partsCatalogCategoriesProvider);
    final filter = ref.watch(partsCatalogFilterProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Honda ADV 160 Parts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory_2_outlined),
            tooltip: 'My Installed Parts',
            onPressed: () => context.push('/parts/inventory'),
          ),
          IconButton(
            icon: const Icon(Icons.schema_outlined),
            tooltip: 'Exploded Diagrams',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ExplodedDiagramViewerScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search part #, name, or assembly...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          ref
                              .read(partsCatalogFilterProvider.notifier)
                              .setQuery('');
                        },
                      )
                    : null,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (val) {
                ref.read(partsCatalogFilterProvider.notifier).setQuery(val);
              },
            ),
          ),

          // Categories Horizontal List
          categoriesAsync.when(
            loading: () => const SizedBox(height: 48),
            error: (_, __) => const SizedBox.shrink(),
            data: (cats) {
              final allCats = ['All', ...cats];
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: allCats.map((cat) {
                    final isSelected = filter.selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (_) {
                          ref
                              .read(partsCatalogFilterProvider.notifier)
                              .setCategory(cat);
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),

          // Parts List View
          Expanded(
            child: partsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text('Error loading catalogue: $e')),
              data: (parts) {
                if (parts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search_off,
                              size: 56, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text(
                            'No OEM parts match your search',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Try searching with partial part numbers (e.g. 23100) or check category filters.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () {
                              _searchCtrl.clear();
                              ref
                                  .read(partsCatalogFilterProvider.notifier)
                                  .reset();
                            },
                            child: const Text('Reset Search Filters'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                  itemCount: parts.length,
                  itemBuilder: (context, idx) {
                    final item = parts[idx];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 1,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => context.push('/parts/catalog/${item.id}'),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.officialName,
                                          style: theme.textTheme.titleSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: theme
                                                .colorScheme.primaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            item.partNumber,
                                            style: TextStyle(
                                              fontFamily: 'monospace',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: theme.colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (item.diagramNumber != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme
                                            .surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${item.diagramNumber} #${item.referenceNumber ?? ''}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.secondary,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${item.category} · ${item.assemblyName}',
                                style: theme.textTheme.bodySmall,
                              ),
                              if (item.description != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item.description!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              const Divider(height: 18),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Standard Req: ${item.standardQuantity}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  FilledButton.tonalIcon(
                                    style: FilledButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                    ),
                                    onPressed: () {
                                      final km = item.maintenanceItemId;
                                      final notesBuf = StringBuffer();
                                      notesBuf.write(
                                          'Replaced with OEM ${item.officialName} (${item.partNumber}).');
                                      notesBuf.write(
                                          ' Category: ${item.category}.');
                                      if (item.diagramNumber != null) {
                                        notesBuf.write(
                                            ' Diagram: ${item.diagramReferenceLabel}.');
                                      }

                                      final uri = Uri(
                                        path: '/maintenance/record',
                                        queryParameters: {
                                          if (km != null) 'itemId': '$km',
                                          'action': 'REPLACE',
                                          'notes': notesBuf.toString(),
                                          'partName': item.officialName,
                                          'partNo': item.partNumber,
                                          'brand': 'Honda Genuine OEM',
                                        },
                                      );
                                      context.push(uri.toString());
                                    },
                                    icon: const Icon(
                                        Icons.build_circle_outlined,
                                        size: 16),
                                    label: const Text('Record Replacement',
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
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
