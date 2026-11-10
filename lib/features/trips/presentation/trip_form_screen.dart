import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/date_utils.dart';
import '../../../shared/providers/providers.dart';
import '../../motorcycle/presentation/motorcycle_view_model.dart';
import '../domain/trip_models.dart';
import 'trips_view_model.dart';

class TripFormScreen extends ConsumerStatefulWidget {
  const TripFormScreen({super.key});

  @override
  ConsumerState<TripFormScreen> createState() => _TripFormScreenState();
}

class _TripFormScreenState extends ConsumerState<TripFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _originCtrl = TextEditingController();
  final _destCtrl = TextEditingController();
  final _startOdoCtrl = TextEditingController();
  final _endOdoCtrl = TextEditingController();
  final _distanceCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  TripCategory _category = TripCategory.commute;
  late DateTime _startDate;
  TimeOfDay _startTime = TimeOfDay.now();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _initOdometer();
  }

  Future<void> _initOdometer() async {
    final bike = await ref.read(primaryMotorcycleProvider.future);
    if (bike != null) {
      final odoRepo = ref.read(odometerRepositoryProvider);
      final latest = await odoRepo.latestConfirmed(bike.id);
      if (latest != null && mounted) {
        setState(() {
          _startOdoCtrl.text = '${latest.readingKm}';
        });
      }
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _originCtrl.dispose();
    _destCtrl.dispose();
    _startOdoCtrl.dispose();
    _endOdoCtrl.dispose();
    _distanceCtrl.dispose();
    _durationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _onOdometerChanged() {
    final start = int.tryParse(_startOdoCtrl.text.trim());
    final end = int.tryParse(_endOdoCtrl.text.trim());
    if (start != null && end != null && end >= start) {
      _distanceCtrl.text = (end - start).toString();
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final bike = await ref.read(primaryMotorcycleProvider.future);
    if (!mounted) return;
    if (bike == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active motorcycle profile.')),
      );
      return;
    }

    setState(() => _saving = true);

    final startOdo = int.tryParse(_startOdoCtrl.text.trim());
    final endOdo = int.tryParse(_endOdoCtrl.text.trim());
    final dist = double.parse(_distanceCtrl.text.trim());
    final durationMins = int.tryParse(_durationCtrl.text.trim()) ?? 0;

    final startDateTime = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _startTime.hour,
      _startTime.minute,
    );

    final endDateTime = startDateTime.add(Duration(minutes: durationMins));
    final durationSecs = durationMins * 60;
    final avgSpeed = durationSecs > 0 ? (dist / (durationSecs / 3600)) : null;

    final input = NewTripInput(
      motorcycleId: bike.id,
      title: _titleCtrl.text.trim(),
      category: _category,
      origin: _originCtrl.text.trim().isEmpty ? null : _originCtrl.text.trim(),
      destination: _destCtrl.text.trim().isEmpty ? null : _destCtrl.text.trim(),
      startOdometerKm: startOdo,
      endOdometerKm: endOdo,
      distanceKm: dist,
      startTime: startDateTime,
      endTime: endDateTime,
      durationSeconds: durationSecs,
      avgSpeedKmh: avgSpeed,
      isGpsTracked: false,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );

    final err = await ref.read(tripActionsProvider.notifier).saveTrip(input);

    if (!mounted) return;
    setState(() => _saving = false);
    if (err == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Manual trip log saved successfully.')),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $err')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Manual Trip'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Trip Title *',
                hintText: 'e.g. Morning Ride to Marilaque',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Title is required' : null,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<TripCategory>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: TripCategory.values
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _category = v);
              },
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _originCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Origin',
                      hintText: 'Starting location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _destCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Destination',
                      hintText: 'End location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startOdoCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Start Odometer (km)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _onOdometerChanged(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _endOdoCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'End Odometer (km)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _onOdometerChanged(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _distanceCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Distance (km) *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      final n = double.tryParse((v ?? '').trim());
                      if (n == null || n <= 0) return 'Enter valid distance';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _durationCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Duration (minutes)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Trip Date & Time'),
              subtitle: Text(
                '${AppDates.formatDate(_startDate)} at ${_startTime.format(context)}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (d == null || !context.mounted) return;
                final t = await showTimePicker(
                  context: context,
                  initialTime: _startTime,
                );
                if (t == null || !mounted) return;
                setState(() {
                  _startDate = d;
                  _startTime = t;
                });
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _saving ? null : _submit,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.check),
              label: const Text('Save Trip'),
            ),
          ],
        ),
      ),
    );
  }
}
