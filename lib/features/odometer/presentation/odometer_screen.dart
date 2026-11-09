import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../shared/providers/providers.dart';
import '../../maintenance/presentation/status_text.dart';
import '../domain/odometer_log.dart';
import 'odometer_view_model.dart';

/// Odometer entry form plus audit history with correction.
class OdometerScreen extends ConsumerStatefulWidget {
  const OdometerScreen({super.key});

  @override
  ConsumerState<OdometerScreen> createState() => _OdometerScreenState();
}

class _OdometerScreenState extends ConsumerState<OdometerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _km = TextEditingController();
  final _notes = TextEditingController();
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _date = AppDates.todayManila(ref.read(clockProvider)());
  }

  @override
  void dispose() {
    _km.dispose();
    _notes.dispose();
    super.dispose();
  }

  static String? _validateKm(String? v) {
    final n = int.tryParse((v ?? '').trim());
    if (n == null) return 'Enter a whole number of kilometers';
    if (n < 0) return 'Odometer cannot be negative';
    return null;
  }

  Future<void> _pickDate() async {
    final today = AppDates.todayManila(ref.read(clockProvider)());
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: today,
    );
    if (d != null) setState(() => _date = AppDates.dateOnly(d));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final error = await ref.read(odometerActionsProvider.notifier).record(
          readingKm: int.parse(_km.text.trim()),
          date: _date,
          notes: _notes.text,
        );
    if (!mounted) return;
    if (error == null) {
      _km.clear();
      _notes.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Odometer saved')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _correct(OdometerLog log) async {
    final kmCtl = TextEditingController(text: '${log.readingKm}');
    final reasonCtl = TextEditingController();
    final key = GlobalKey<FormState>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Correct odometer entry'),
        content: Form(
          key: key,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('The original entry is kept in the audit trail.'),
            const SizedBox(height: 12),
            TextFormField(
              controller: kmCtl,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Corrected reading (km)'),
              validator: _validateKm,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: reasonCtl,
              decoration: const InputDecoration(labelText: 'Reason'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Reason is required' : null,
            ),
          ]),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () {
                if (key.currentState!.validate()) Navigator.pop(ctx, true);
              },
              child: const Text('Apply correction')),
        ],
      ),
    );
    if (confirmed != true) return;
    final error = await ref.read(odometerActionsProvider.notifier).correct(
          logId: log.id,
          newReadingKm: int.parse(kmCtl.text.trim()),
          reason: reasonCtl.text,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(error ?? 'Correction applied')));
  }

  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(odometerLogsProvider);
    final saving = ref.watch(odometerActionsProvider).isLoading;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Odometer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                controller: _km,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Current odometer (km)'),
                validator: _validateKm,
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date recorded'),
                subtitle: Text(AppDates.formatDate(_date)),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: _pickDate,
              ),
              TextFormField(
                controller: _notes,
                decoration:
                    const InputDecoration(labelText: 'Notes (optional)'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: saving ? null : _save,
                  child: const Text('Save reading'),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 24),
          Text('History', style: theme.textTheme.titleMedium),
          logs.when(
            loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator())),
            error: (e, _) => Text('Could not load history: $e'),
            data: (list) => list.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(8), child: Text('No readings yet'))
                : Column(children: [
                    for (final l in list) _LogTile(log: l, onCorrect: _correct)
                  ]),
          ),
        ],
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.log, required this.onCorrect});
  final OdometerLog log;
  final void Function(OdometerLog) onCorrect;

  @override
  Widget build(BuildContext context) {
    final superseded = log.status != OdometerLogStatus.confirmed;
    final style = superseded
        ? TextStyle(
            decoration: TextDecoration.lineThrough,
            color: Theme.of(context).colorScheme.outline)
        : null;
    final sub = [
      AppDates.formatDate(log.recordedDate),
      if (superseded) 'Corrected',
      if (log.correctionReason != null) 'Correction: ${log.correctionReason}',
      if (log.notes != null) log.notes!,
    ].join(' · ');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(StatusText.km(log.readingKm), style: style),
      subtitle: Text(sub),
      trailing: superseded
          ? null
          : IconButton(
              tooltip: 'Correct entry',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => onCorrect(log),
            ),
    );
  }
}
