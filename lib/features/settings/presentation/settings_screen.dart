import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/providers/providers.dart';
import '../domain/app_settings.dart';
import 'settings_view_model.dart';

/// Application Settings & Backup/Restore screen (Module J + Settings tab).
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String? _lastExportPath;

  void _showMessage(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _runExport(
    String label,
    Future<({String? path, String? error})> Function() action,
  ) async {
    final res = await action();
    if (!mounted) return;
    if (res.error != null) {
      _showMessage(res.error!);
    } else if (res.path != null) {
      setState(() => _lastExportPath = res.path);
      _showMessage('$label saved: ${res.path}');
    }
  }

  Future<void> _pickAndRestoreBackup() async {
    final path = await ref.read(backupFilePickerProvider).pickBackupFile();
    if (path == null || !mounted) return;

    final inspected =
        await ref.read(settingsActionsProvider.notifier).inspectBackup(path);
    if (!mounted) return;
    if (inspected.error != null || inspected.preview == null) {
      _showMessage(inspected.error ?? 'Invalid backup file.');
      return;
    }

    final preview = inspected.preview!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Restore Backup'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Restoring this backup will replace current database records '
                'with the backup contents. Original record IDs and '
                'relationships are preserved.',
              ),
              const SizedBox(height: 12),
              Text('Backup created: ${preview.createdAt}'),
              Text('Schema version: v${preview.schemaVersion} '
                  '(format v${preview.formatVersion})'),
              Text('Total rows: ${preview.totalRows}'),
              Text('Bundled photos: ${preview.bundledAttachmentCount}'),
              const Divider(height: 16),
              Text(
                'Motorcycles: ${preview.tableCounts['motorcycles'] ?? 0} · '
                'Records: ${preview.tableCounts['maintenance_records'] ?? 0} · '
                'Odometer logs: ${preview.tableCounts['odometer_logs'] ?? 0} · '
                'Measurements: ${preview.tableCounts['component_measurements'] ?? 0} · '
                'Parts: ${preview.tableCounts['parts'] ?? 0}',
                style: Theme.of(ctx).textTheme.bodySmall,
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
            child: const Text('Confirm & Restore'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final err = await ref
        .read(settingsActionsProvider.notifier)
        .restoreBackup(path, confirmedByUser: true);
    if (!mounted) return;
    _showMessage(err ?? 'Backup restored successfully.');
  }

  Future<void> _showThresholdsDialog(AppSettings current) async {
    final dueKmCtl = TextEditingController(text: '${current.dueThresholdKm}');
    final upKmCtl =
        TextEditingController(text: '${current.upcomingThresholdKm}');
    final dueDaysCtl =
        TextEditingController(text: '${current.dueThresholdDays}');
    final upDaysCtl =
        TextEditingController(text: '${current.upcomingThresholdDays}');
    final key = GlobalKey<FormState>();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reminder Status Thresholds'),
        content: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: dueKmCtl,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Due threshold (km)'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: upKmCtl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Upcoming threshold (km)'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: dueDaysCtl,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Due threshold (days)'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: upDaysCtl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Upcoming threshold (days)'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save')),
        ],
      ),
    );
    if (ok != true) return;
    final next = current.copyWith(
      dueThresholdKm: int.tryParse(dueKmCtl.text.trim()) ?? 100,
      upcomingThresholdKm: int.tryParse(upKmCtl.text.trim()) ?? 1000,
      dueThresholdDays: int.tryParse(dueDaysCtl.text.trim()) ?? 7,
      upcomingThresholdDays: int.tryParse(upDaysCtl.text.trim()) ?? 30,
    );
    final err =
        await ref.read(settingsActionsProvider.notifier).updateSettings(next);
    if (err != null) _showMessage(err);
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(appSettingsProvider);
    final busy = ref.watch(settingsActionsProvider).isLoading;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Backup')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (settings) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Appearance & Thresholds', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.brightness_6_outlined),
                    title: const Text('Theme mode'),
                    trailing: DropdownButton<ThemeMode>(
                      value: settings.themeMode,
                      items: const [
                        DropdownMenuItem(
                            value: ThemeMode.system, child: Text('System')),
                        DropdownMenuItem(
                            value: ThemeMode.light, child: Text('Light')),
                        DropdownMenuItem(
                            value: ThemeMode.dark, child: Text('Dark')),
                      ],
                      onChanged: (mode) {
                        if (mode != null) {
                          ref
                              .read(settingsActionsProvider.notifier)
                              .updateSettings(
                                  settings.copyWith(themeMode: mode));
                        }
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.tune_outlined),
                    title: const Text('Upcoming & Due thresholds'),
                    subtitle: Text(
                      'Due ≤ ${settings.dueThresholdKm} km / ${settings.dueThresholdDays} d · '
                      'Upcoming ≤ ${settings.upcomingThresholdKm} km / ${settings.upcomingThresholdDays} d',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showThresholdsDialog(settings),
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined),
                    title: const Text('Notification preferences & reminders'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/reminders'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.two_wheeler_outlined),
                    title: const Text('Motorcycle profile'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/motorcycle'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Backup & Restore (Offline)',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.data_object_outlined),
                    title: const Text('Full JSON Backup'),
                    subtitle: const Text(
                        'Exports all 13 database tables to a JSON file'),
                    onTap: busy
                        ? null
                        : () => _runExport(
                              'JSON backup',
                              ref
                                  .read(settingsActionsProvider.notifier)
                                  .exportJsonBackup,
                            ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.folder_zip_outlined),
                    title: const Text('ZIP Backup (with inspection photos)'),
                    subtitle: const Text(
                        'Bundles backup.json and all attachment images'),
                    onTap: busy
                        ? null
                        : () => _runExport(
                              'ZIP backup',
                              ref
                                  .read(settingsActionsProvider.notifier)
                                  .exportZipBackup,
                            ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.restore_outlined),
                    title: const Text('Restore Backup'),
                    subtitle: const Text(
                        'Validates version & structure before confirmation'),
                    onTap: busy ? null : _pickAndRestoreBackup,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('CSV Exports', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.table_chart_outlined),
                    title: const Text('Export Maintenance Records (CSV)'),
                    subtitle: const Text(
                        'Chronological service records, parts, and notes'),
                    onTap: busy
                        ? null
                        : () => _runExport(
                              'Maintenance CSV',
                              ref
                                  .read(settingsActionsProvider.notifier)
                                  .exportMaintenanceRecordsCsv,
                            ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.receipt_long_outlined),
                    title: const Text('Export Expenses (CSV)'),
                    subtitle:
                        const Text('Parts, labor, and total costs in PHP'),
                    onTap: busy
                        ? null
                        : () => _runExport(
                              'Expenses CSV',
                              ref
                                  .read(settingsActionsProvider.notifier)
                                  .exportExpensesCsv,
                            ),
                  ),
                ],
              ),
            ),
            if (_lastExportPath != null) ...[
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SelectableText(
                    'Last exported file:\n$_lastExportPath',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            const Card(
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('$kAppName – Honda ADV 160 Maintenance Monitor'),
                subtitle: Text(
                  'Database schema v$kDatabaseSchemaVersion · '
                  'Timezone $kAppTimeZone · 100% Offline',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
