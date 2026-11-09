import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../shared/providers/providers.dart';
import '../../maintenance/presentation/maintenance_view_model.dart';
import '../../maintenance/presentation/status_text.dart';
import '../domain/reminder_models.dart';
import 'reminders_view_model.dart';

/// Reminders & Notification Preferences screen (Module H).
class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  Future<void> _showAddCustomReminderDialog() async {
    final overview = ref.read(maintenanceOverviewProvider).valueOrNull;
    final items = overview?.snapshot.items ?? const [];
    final today = AppDates.todayManila(ref.read(clockProvider)());

    final titleCtl = TextEditingController();
    final bodyCtl = TextEditingController();
    final kmCtl = TextEditingController();
    int? itemId;
    DateTime? dueDate;
    final key = GlobalKey<FormState>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('New Custom Reminder'),
          content: SingleChildScrollView(
            child: Form(
              key: key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleCtl,
                    decoration:
                        const InputDecoration(labelText: 'Reminder title'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Title is required'
                        : null,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int?>(
                    value: itemId,
                    decoration: const InputDecoration(
                        labelText: 'Maintenance item (optional)'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('None')),
                      for (final i in items)
                        DropdownMenuItem(value: i.id, child: Text(i.name)),
                    ],
                    onChanged: (v) => setState(() => itemId = v),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: kmCtl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Due odometer (km, optional)'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Due date (optional)'),
                    subtitle: Text(dueDate == null
                        ? 'Not set'
                        : AppDates.formatDate(dueDate!)),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: () async {
                      final d = await showDatePicker(
                        context: ctx,
                        initialDate: dueDate ?? today,
                        firstDate: today,
                        lastDate: DateTime(today.year + 10),
                      );
                      if (d != null) setState(() => dueDate = d);
                    },
                  ),
                  TextFormField(
                    controller: bodyCtl,
                    decoration:
                        const InputDecoration(labelText: 'Notes (optional)'),
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
                onPressed: () {
                  if (key.currentState!.validate()) Navigator.pop(ctx, true);
                },
                child: const Text('Save Reminder')),
          ],
        ),
      ),
    );
    if (confirmed != true) return;
    final err =
        await ref.read(remindersActionsProvider.notifier).addCustomReminder(
              title: titleCtl.text,
              itemId: itemId,
              body: bodyCtl.text,
              dueDate: dueDate,
              dueOdometerKm: int.tryParse(kmCtl.text.trim()),
            );
    if (mounted && err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final remindersAsync = ref.watch(activeRemindersProvider);
    final prefsAsync = ref.watch(notificationPreferencesProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reminders & Notifications'),
          actions: [
            IconButton(
              tooltip: 'Request Android notification permission',
              icon: const Icon(Icons.notifications_active_outlined),
              onPressed: () async {
                final granted = await ref
                    .read(remindersActionsProvider.notifier)
                    .requestPermissions();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(granted
                        ? 'Notifications permission granted'
                        : 'Notifications permission not granted'),
                  ));
                }
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active Reminders'),
              Tab(text: 'Preferences'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddCustomReminderDialog,
          icon: const Icon(Icons.add_alert_outlined),
          label: const Text('Custom Reminder'),
        ),
        body: TabBarView(
          children: [
            remindersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (list) => list.isEmpty
                  ? const Center(child: Text('No active reminders'))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
                      itemCount: list.length,
                      itemBuilder: (_, i) => _ReminderCard(reminder: list[i]),
                    ),
            ),
            prefsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (prefs) => _PreferencesView(prefs: prefs),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderCard extends ConsumerWidget {
  const _ReminderCard({required this.reminder});
  final MaintenanceReminder reminder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = reminder;
    final sub = [
      _typeLabel(r.reminderType),
      if (r.dueOdometerKm != null) 'Due @ ${StatusText.km(r.dueOdometerKm!)}',
      if (r.dueDate != null) 'Due ${AppDates.formatDate(r.dueDate!)}',
      if (r.body != null && r.body != r.title) r.body!,
    ].join(' · ');

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(_typeIcon(r.reminderType)),
        title: Text(r.title),
        subtitle: Text(sub),
        trailing: IconButton(
          tooltip: 'Dismiss reminder',
          icon: const Icon(Icons.check_circle_outline),
          onPressed: () =>
              ref.read(remindersActionsProvider.notifier).dismiss(r.id),
        ),
      ),
    );
  }

  static String _typeLabel(ReminderType t) => switch (t) {
        ReminderType.upcoming => 'Upcoming',
        ReminderType.due => 'Due',
        ReminderType.overdue => 'Overdue',
        ReminderType.dateBased => 'Date-based',
        ReminderType.custom => 'Custom',
      };

  static IconData _typeIcon(ReminderType t) => switch (t) {
        ReminderType.upcoming => Icons.schedule,
        ReminderType.due => Icons.notifications_active_outlined,
        ReminderType.overdue => Icons.error_outline,
        ReminderType.dateBased => Icons.event_outlined,
        ReminderType.custom => Icons.bookmark_outline,
      };
}

class _PreferencesView extends ConsumerWidget {
  const _PreferencesView({required this.prefs});
  final NotificationPreferences prefs;

  Future<void> _update(WidgetRef ref, NotificationPreferences next) async {
    await ref.read(remindersActionsProvider.notifier).updatePreferences(next);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text('Enable offline notifications'),
          subtitle: const Text(
              'Master toggle for all local maintenance notifications'),
          value: prefs.enabled,
          onChanged: (v) => _update(ref, prefs.copyWith(enabled: v)),
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('Upcoming maintenance'),
          subtitle: const Text('Notify when service is approaching'),
          value: prefs.notifyUpcoming,
          onChanged: prefs.enabled
              ? (v) => _update(ref, prefs.copyWith(notifyUpcoming: v))
              : null,
        ),
        SwitchListTile(
          title: const Text('Due maintenance'),
          subtitle: const Text('Notify when service reaches due threshold'),
          value: prefs.notifyDue,
          onChanged: prefs.enabled
              ? (v) => _update(ref, prefs.copyWith(notifyDue: v))
              : null,
        ),
        SwitchListTile(
          title: const Text('Overdue maintenance'),
          subtitle: const Text('Notify when service is past due'),
          value: prefs.notifyOverdue,
          onChanged: prefs.enabled
              ? (v) => _update(ref, prefs.copyWith(notifyOverdue: v))
              : null,
        ),
        SwitchListTile(
          title: const Text('Date-based maintenance'),
          subtitle: const Text('Scheduled calendar reminders (Asia/Manila)'),
          value: prefs.notifyDateBased,
          onChanged: prefs.enabled
              ? (v) => _update(ref, prefs.copyWith(notifyDateBased: v))
              : null,
        ),
        SwitchListTile(
          title: const Text('Custom reminders'),
          subtitle: const Text('User-created mileage or date reminders'),
          value: prefs.notifyCustom,
          onChanged: prefs.enabled
              ? (v) => _update(ref, prefs.copyWith(notifyCustom: v))
              : null,
        ),
      ],
    );
  }
}
