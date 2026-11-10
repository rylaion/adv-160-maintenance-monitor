import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/date_utils.dart';
import '../../maintenance/presentation/maintenance_view_model.dart';
import '../../maintenance/presentation/status_text.dart';
import '../domain/cvt_models.dart';
import 'cvt_view_model.dart';

class CvtDetailScreen extends ConsumerStatefulWidget {
  const CvtDetailScreen({super.key, required this.configId});
  final int configId;

  @override
  ConsumerState<CvtDetailScreen> createState() => _CvtDetailScreenState();
}

class _CvtDetailScreenState extends ConsumerState<CvtDetailScreen> {
  CvtConfigurationDetail? _config;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final repo = ref.read(cvtRepositoryProvider);
    final c = await repo.getConfigurationById(widget.configId);
    if (mounted) {
      setState(() {
        _config = c;
        _loading = false;
      });
    }
  }

  Future<void> _addPerformanceLog() async {
    if (_config == null) return;
    int accel = 4;
    int vib = 2;
    int comfort = 4;
    final topSpeedCtrl = TextEditingController();
    final rpmCtrl = TextEditingController();
    final fuelCtrl = TextEditingController();
    final assessCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    bool isMeasured = false;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Record Performance Log'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Instrument Measured?'),
                  subtitle: const Text('Check if recorded via GPS/Dynamometer'),
                  value: isMeasured,
                  onChanged: (val) => setDialogState(() => isMeasured = val),
                ),
                const Divider(),
                Text('Acceleration: $accel / 5'),
                Slider(
                  value: accel.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  onChanged: (val) => setDialogState(() => accel = val.round()),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: topSpeedCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'Top Speed (km/h)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: rpmCtrl,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Observed RPM'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: fuelCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      const InputDecoration(labelText: 'Fuel Eco (km/L)'),
                ),
                const SizedBox(height: 12),
                Text('Vibration: $vib / 5 (1=Smooth, 5=Severe)'),
                Slider(
                  value: vib.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  onChanged: (val) => setDialogState(() => vib = val.round()),
                ),
                Text('Comfort: $comfort / 5'),
                Slider(
                  value: comfort.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  onChanged: (val) =>
                      setDialogState(() => comfort = val.round()),
                ),
                TextField(
                  controller: assessCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Overall Assessment',
                    hintText: 'e.g. Punchy low-end, slight loss on top',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesCtrl,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save Log'),
            ),
          ],
        ),
      ),
    );

    if (saved == true && mounted) {
      final input = NewCvtPerformanceLogInput(
        configurationId: _config!.id,
        logDate: DateTime.now(),
        accelerationRating: accel,
        topSpeedKmh: double.tryParse(topSpeedCtrl.text.trim()),
        rpmObserved: int.tryParse(rpmCtrl.text.trim()),
        fuelConsumptionKpl: double.tryParse(fuelCtrl.text.trim()),
        vibrationRating: vib,
        comfortRating: comfort,
        overallAssessment:
            assessCtrl.text.trim().isEmpty ? null : assessCtrl.text.trim(),
        notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
        isMeasured: isMeasured,
      );

      final err =
          await ref.read(cvtActionsProvider.notifier).addPerformanceLog(input);
      if (mounted) {
        if (err == null) {
          _loadConfig();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Performance log saved.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $err')),
          );
        }
      }
    }
  }

  Future<void> _duplicate() async {
    if (_config == null) return;
    final err = await ref
        .read(cvtActionsProvider.notifier)
        .duplicateConfiguration(_config!.id);
    if (mounted) {
      if (err == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Configuration duplicated successfully.')),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $err')),
        );
      }
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete CVT Configuration?'),
        content: const Text(
            'Are you sure you want to delete this configuration and its test records?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final err = await ref
          .read(cvtActionsProvider.notifier)
          .deleteConfiguration(widget.configId);
      if (mounted) {
        if (err == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Configuration deleted.')),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $err')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('CVT Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final c = _config;
    if (c == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('CVT Details')),
        body: const Center(child: Text('Configuration not found.')),
      );
    }

    final theme = Theme.of(context);
    final allHistory = ref.watch(maintenanceHistoryProvider).valueOrNull ?? [];
    final cvtHistory = allHistory.where((r) {
      final cat = r.categoryName.toLowerCase();
      final item = r.itemName.toLowerCase();
      return cat.contains('cvt') ||
          item.contains('belt') ||
          item.contains('clutch');
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(c.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Setup',
            onPressed: () async {
              await context.push('/cvt/add?edit=${c.id}');
              _loadConfig();
            },
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Duplicate Setup',
            onPressed: _duplicate,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete Setup',
            onPressed: _delete,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addPerformanceLog,
        icon: const Icon(Icons.speed),
        label: const Text('Add Test Log'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (c.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'CURRENTLY ACTIVE',
                            style: TextStyle(
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        )
                      else
                        OutlinedButton(
                          onPressed: () async {
                            await ref
                                .read(cvtActionsProvider.notifier)
                                .setActive(c.id, c.motorcycleId);
                            _loadConfig();
                          },
                          child: const Text('Set as Active Setup'),
                        ),
                      const Spacer(),
                      Text(
                        'Installed: ${AppDates.formatDate(c.installedDate)}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _SpecTile(
                      label: 'Pulley Brand / Model',
                      value: c.pulleyBrandModel ?? 'Stock'),
                  _SpecTile(
                    label: 'Flyball Weight & Setup',
                    value: c.flyballWeightGrams != null
                        ? '${c.flyballWeightGrams}g (${c.flyballArrangement ?? "Straight"})'
                        : (c.flyballArrangement ?? 'Stock (20g)'),
                  ),
                  _SpecTile(
                    label: 'Center Spring',
                    value: c.centerSpringRpm != null
                        ? '${c.centerSpringRpm} RPM'
                        : 'Stock',
                  ),
                  _SpecTile(
                    label: 'Clutch Springs',
                    value: c.clutchSpringRpm != null
                        ? '${c.clutchSpringRpm} RPM'
                        : 'Stock',
                  ),
                  _SpecTile(
                    label: 'Drive Belt',
                    value: c.beltBrandPartNumber ?? 'Honda OEM',
                  ),
                  _SpecTile(
                    label: 'Pulley Washer Thickness',
                    value: c.pulleyWasherThicknessMm != null
                        ? '${c.pulleyWasherThicknessMm} mm'
                        : 'None / Stock',
                  ),
                  if (c.clutchBellSpec != null && c.clutchBellSpec!.isNotEmpty)
                    _SpecTile(label: 'Clutch & Bell', value: c.clutchBellSpec!),
                  if (c.exhaustSpec != null && c.exhaustSpec!.isNotEmpty)
                    _SpecTile(label: 'Exhaust', value: c.exhaustSpec!),
                  if (c.otherMods != null && c.otherMods!.isNotEmpty)
                    _SpecTile(
                        label: 'Other Modifications', value: c.otherMods!),
                  if (c.installedOdometerKm != null)
                    _SpecTile(
                        label: 'Installation Odometer',
                        value: '${c.installedOdometerKm} km'),
                  if (c.notes != null && c.notes!.isNotEmpty) ...[
                    const Divider(height: 16),
                    Text('Notes', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(c.notes!),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Associated Transmission Maintenance',
                  style: theme.textTheme.titleMedium),
              Text('${cvtHistory.length} services',
                  style: theme.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          if (cvtHistory.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                        'No maintenance records for CVT or drive belt yet.'),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () =>
                          context.push('/maintenance/record?action=REPLACE'),
                      icon: const Icon(Icons.build_circle_outlined, size: 18),
                      label:
                          const Text('Record CVT Service / Belt Replacement'),
                    ),
                  ],
                ),
              ),
            )
          else
            Card(
              child: Column(
                children: [
                  for (final r in cvtHistory.take(5))
                    ListTile(
                      leading:
                          const Icon(Icons.settings_input_component, size: 28),
                      title: Text('${r.itemName} · ${r.action.label}'),
                      subtitle: Text(
                        '${AppDates.formatDate(r.performedDate)} @ ${StatusText.km(r.odometerKm)}${r.notes != null && r.notes!.isNotEmpty ? "\n${r.notes!}" : ""}',
                      ),
                      isThreeLine: r.notes != null && r.notes!.isNotEmpty,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          context.push('/maintenance/item/${r.itemId}'),
                    ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          context.push('/maintenance/record?action=REPLACE'),
                      icon: const Icon(Icons.add_task, size: 18),
                      label: const Text('Record New CVT Service'),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Performance & Ride Observations',
                  style: theme.textTheme.titleMedium),
              Text('${c.performanceLogs.length} logs',
                  style: theme.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          if (c.performanceLogs.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.speed_outlined,
                          size: 40, color: Colors.grey),
                      const SizedBox(height: 8),
                      const Text('No performance logs recorded yet.'),
                      const SizedBox(height: 4),
                      Text(
                        'Tap Add Test Log to record acceleration, top speed, and comfort.',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            ...c.performanceLogs.map((log) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppDates.formatDate(log.logDate),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            if (log.isMeasured)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'MEASURED',
                                  style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            else
                              Text('Observation',
                                  style: theme.textTheme.bodySmall),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18),
                              onPressed: () async {
                                await ref
                                    .read(cvtActionsProvider.notifier)
                                    .deletePerformanceLog(log.id);
                                _loadConfig();
                              },
                            ),
                          ],
                        ),
                        if (log.overallAssessment != null &&
                            log.overallAssessment!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              log.overallAssessment!,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            if (log.accelerationRating != null)
                              Text('Accel: ${log.accelerationRating}/5',
                                  style: theme.textTheme.bodySmall),
                            if (log.topSpeedKmh != null)
                              Text('Top: ${log.topSpeedKmh} km/h',
                                  style: theme.textTheme.bodySmall),
                            if (log.rpmObserved != null)
                              Text('RPM: ${log.rpmObserved}',
                                  style: theme.textTheme.bodySmall),
                            if (log.fuelConsumptionKpl != null)
                              Text('Eco: ${log.fuelConsumptionKpl} km/L',
                                  style: theme.textTheme.bodySmall),
                            if (log.comfortRating != null)
                              Text('Comfort: ${log.comfortRating}/5',
                                  style: theme.textTheme.bodySmall),
                          ],
                        ),
                        if (log.notes != null && log.notes!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(log.notes!,
                                style: theme.textTheme.bodySmall),
                          ),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}

class _SpecTile extends StatelessWidget {
  const _SpecTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
