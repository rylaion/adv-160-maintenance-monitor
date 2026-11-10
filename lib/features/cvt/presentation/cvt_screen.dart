import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/date_utils.dart';
import 'cvt_compare_screen.dart';
import 'cvt_view_model.dart';

class CvtScreen extends ConsumerWidget {
  const CvtScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configsAsync = ref.watch(cvtConfigurationsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CVT Configurations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            tooltip: 'Compare Setups',
            onPressed: () {
              final configs = configsAsync.valueOrNull ?? [];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CvtCompareScreen(configurations: configs),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/cvt/add'),
        icon: const Icon(Icons.add),
        label: const Text('New CVT Setup'),
      ),
      body: configsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('Error loading configurations: $e')),
        data: (configs) {
          if (configs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.settings_input_component,
                        size: 56, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'No CVT Configurations Recorded',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Record your flyball weights, springs, pulley, and washer setups to track tuning changes and performance over time.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () => context.push('/cvt/add'),
                      icon: const Icon(Icons.add),
                      label: const Text('Create Setup'),
                    ),
                  ],
                ),
              ),
            );
          }

          final activeConfig = configs.where((c) => c.isActive).firstOrNull;
          final otherConfigs = configs.where((c) => !c.isActive).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            children: [
              if (activeConfig != null) ...[
                Text('Active Setup', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Card(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.4),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => context.push('/cvt/${activeConfig.id}'),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade600,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'ACTIVE',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  activeConfig.name,
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                          const Divider(height: 20),
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: [
                              _ParamPill(
                                label: 'Flyball',
                                value: activeConfig.flyballWeightGrams != null
                                    ? '${activeConfig.flyballWeightGrams}g'
                                    : 'Stock',
                              ),
                              _ParamPill(
                                label: 'Center Spring',
                                value: activeConfig.centerSpringRpm != null
                                    ? '${activeConfig.centerSpringRpm} RPM'
                                    : 'Stock',
                              ),
                              _ParamPill(
                                label: 'Washer',
                                value: activeConfig.pulleyWasherThicknessMm !=
                                        null
                                    ? '${activeConfig.pulleyWasherThicknessMm}mm'
                                    : 'None',
                              ),
                              _ParamPill(
                                label: 'Installed',
                                value: AppDates.formatDate(
                                    activeConfig.installedDate),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              Text('Saved Setups (${configs.length})',
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              ...otherConfigs.map((c) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(
                          Icons.settings_input_component_outlined,
                          size: 32),
                      title: Text(c.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text([
                        'Flyball: ${c.flyballWeightGrams != null ? "${c.flyballWeightGrams}g" : "Stock"} · Spring: ${c.centerSpringRpm != null ? "${c.centerSpringRpm} RPM" : "Stock"}',
                        'Installed: ${AppDates.formatDate(c.installedDate)}',
                      ].join('\n')),
                      isThreeLine: true,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/cvt/${c.id}'),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}

class _ParamPill extends StatelessWidget {
  const _ParamPill({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
