import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/item_status_card.dart';
import 'maintenance_view_model.dart';

/// Maintenance items grouped by category with computed status (read-only in
/// Phase 2; service recording arrives in Phase 3).
class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(maintenanceOverviewProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load maintenance: $e')),
        data: (o) {
          final children = <Widget>[];
          for (final cat in o.snapshot.categories) {
            final items =
                o.items.where((i) => i.category.id == cat.id).toList();
            if (items.isEmpty) continue;
            children.add(Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
              child:
                  Text(cat.name, style: Theme.of(context).textTheme.titleSmall),
            ));
            children.addAll(items.map((i) => ItemStatusCard(status: i)));
          }
          return ListView(
              padding: const EdgeInsets.all(12), children: children);
        },
      ),
    );
  }
}
