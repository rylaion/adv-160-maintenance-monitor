import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../maintenance/domain/maintenance_overview.dart';
import '../../maintenance/presentation/maintenance_view_model.dart';
import '../../maintenance/presentation/status_text.dart';
import '../domain/component_models.dart';
import 'components_view_model.dart';

/// Descriptor for each monitored component in Module E.
class MonitoredComponentDef {
  const MonitoredComponentDef({
    required this.slug,
    required this.title,
    required this.itemName,
    this.legacyItemNames = const [],
    required this.subtitle,
    required this.icon,
  });

  final String slug;
  final String title;
  final String itemName;
  final List<String> legacyItemNames;
  final String subtitle;
  final IconData icon;

  bool matchesItemName(String name) =>
      name == itemName || legacyItemNames.contains(name);

  static const List<MonitoredComponentDef> all = [
    MonitoredComponentDef(
      slug: 'cvt_belt',
      title: 'CVT Belt',
      itemName: 'Drive Belt',
      legacyItemNames: ['CVT Drive Belt'],
      subtitle: 'Thickness (mm), visual condition, cracks/damage & photos',
      icon: Icons.settings_input_component_outlined,
    ),
    MonitoredComponentDef(
      slug: 'brake_pads',
      title: 'Brake Pads (Front & Rear)',
      itemName: 'Brake Pads Wear',
      legacyItemNames: ['Brake Pads'],
      subtitle: 'Front/rear lining thickness (mm), wear limit & condition',
      icon: Icons.disc_full_outlined,
    ),
    MonitoredComponentDef(
      slug: 'brake_discs',
      title: 'Brake Discs (Front & Rear)',
      itemName: 'Brake System',
      subtitle: 'Front/rear disc rotor thickness (mm) & service limit',
      icon: Icons.album_outlined,
    ),
    MonitoredComponentDef(
      slug: 'tires',
      title: 'Tires (Front & Rear)',
      itemName: 'Wheels/Tyres',
      legacyItemNames: ['Tire'],
      subtitle:
          'Front (1.5 mm limit) & Rear (2.0 mm limit) tread depth, pressure',
      icon: Icons.tire_repair_outlined,
    ),
    MonitoredComponentDef(
      slug: 'throttle',
      title: 'Throttle Grip Freeplay',
      itemName: 'Throttle Operation',
      subtitle: 'Standard 2.0 – 6.0 mm (32K0WA100, p. 110) freeplay check',
      icon: Icons.tune_outlined,
    ),
    MonitoredComponentDef(
      slug: 'fuel_filter',
      title: 'Fuel Filter',
      itemName: 'Fuel Filter',
      subtitle: 'Brand, part number, installation & replacement tracking',
      icon: Icons.filter_alt_outlined,
    ),
    MonitoredComponentDef(
      slug: 'brake_fluid',
      title: 'Brake Fluid',
      itemName: 'Brake Fluid',
      subtitle: 'Fluid specification, condition & replacement schedule',
      icon: Icons.water_drop_outlined,
    ),
    MonitoredComponentDef(
      slug: 'battery',
      title: 'Battery',
      itemName: 'Battery',
      subtitle:
          'Voltage (engine off/running/charging), brand/model & condition',
      icon: Icons.battery_charging_full_outlined,
    ),
    MonitoredComponentDef(
      slug: 'coolant',
      title: 'Coolant',
      itemName: 'Radiator Coolant',
      legacyItemNames: ['Coolant'],
      subtitle: 'Brand, specification, replacement date & condition',
      icon: Icons.ac_unit_outlined,
    ),
    MonitoredComponentDef(
      slug: 'final_drive_oil',
      title: 'Final Drive Oil',
      itemName: 'Final Drive Oil',
      subtitle: 'Brand, specification, replacement date, quantity & cost',
      icon: Icons.oil_barrel_outlined,
    ),
  ];

  static MonitoredComponentDef? bySlug(String slug) {
    for (final d in all) {
      if (d.slug == slug) return d;
    }
    return null;
  }
}

/// Overview screen listing all 8 monitored components.
class ComponentsScreen extends ConsumerWidget {
  const ComponentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(maintenanceOverviewProvider);
    final allMeasurements =
        ref.watch(componentMeasurementsProvider(null)).valueOrNull ?? const [];
    final userSpecs =
        ref.watch(userComponentSpecsProvider).valueOrNull ?? const {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Component Condition'),
        actions: [
          IconButton(
            tooltip: 'Parts management',
            icon: const Icon(Icons.inventory_2_outlined),
            onPressed: () => context.push('/parts'),
          ),
        ],
      ),
      body: overviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load components: $e')),
        data: (o) => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: MonitoredComponentDef.all.length,
          itemBuilder: (_, idx) {
            final def = MonitoredComponentDef.all[idx];
            final itemStatus = o.items
                .where((i) => def.matchesItemName(i.item.name))
                .firstOrNull;
            final itemMeas = itemStatus == null
                ? const <ComponentMeasurement>[]
                : allMeasurements
                    .where((m) => m.itemId == itemStatus.item.id)
                    .toList();
            final latest = itemMeas.firstOrNull;
            final specDefs = ComponentSpecDefinition.catalog
                .where((c) => c.matchesItemName(def.itemName))
                .toList();
            final evaluatedSpecs = [
              for (final s in specDefs)
                EvaluatedComponentSpec.evaluate(
                  definition: s,
                  userSpec: userSpecs[s.specKey],
                  itemMeasurements: itemMeas,
                ),
            ];
            return _ComponentSummaryTile(
              def: def,
              status: itemStatus,
              evaluatedSpecs: evaluatedSpecs,
              latestSummary: latest == null
                  ? null
                  : latest.value != null
                      ? 'Latest: ${latest.value!.toStringAsFixed(2)} ${latest.unit}'
                      : (latest.visualCondition != null
                          ? 'Condition: ${latest.visualCondition}'
                          : null),
            );
          },
        ),
      ),
    );
  }
}

class _ComponentSummaryTile extends StatelessWidget {
  const _ComponentSummaryTile({
    required this.def,
    this.status,
    this.evaluatedSpecs = const [],
    this.latestSummary,
  });

  final MonitoredComponentDef def;
  final ItemStatus? status;
  final List<EvaluatedComponentSpec> evaluatedSpecs;
  final String? latestSummary;

  @override
  Widget build(BuildContext context) {
    final last = status?.evaluation.lastService;
    final specSummary = evaluatedSpecs.isEmpty
        ? null
        : evaluatedSpecs
            .map((s) => '${s.definition.componentName}: ${s.status.label}')
            .join(' · ');
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(def.icon, size: 32),
        title: Text(def.title),
        subtitle: Text([
          def.subtitle,
          if (specSummary != null) specSummary,
          if (latestSummary != null) latestSummary!,
          if (last != null) 'Last service: ${StatusText.lastService(last)}',
        ].join('\n')),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/components/${def.slug}'),
      ),
    );
  }
}
