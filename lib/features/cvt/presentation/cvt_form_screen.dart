import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/date_utils.dart';
import '../../motorcycle/presentation/motorcycle_view_model.dart';
import '../../../shared/providers/providers.dart';
import '../domain/cvt_models.dart';
import 'cvt_view_model.dart';

class CvtFormScreen extends ConsumerStatefulWidget {
  const CvtFormScreen({
    super.key,
    this.editConfigId,
    this.cloneFromId,
  });

  final int? editConfigId;
  final int? cloneFromId;

  @override
  ConsumerState<CvtFormScreen> createState() => _CvtFormScreenState();
}

class _CvtFormScreenState extends ConsumerState<CvtFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _pulleyCtrl = TextEditingController();
  final _flyballWeightCtrl = TextEditingController();
  final _flyballArrangementCtrl = TextEditingController();
  final _centerSpringCtrl = TextEditingController();
  final _clutchSpringCtrl = TextEditingController();
  final _beltCtrl = TextEditingController();
  final _washerCtrl = TextEditingController();
  final _clutchBellCtrl = TextEditingController();
  final _exhaustCtrl = TextEditingController();
  final _otherModsCtrl = TextEditingController();
  final _odoCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  DateTime _installedDate = DateTime.now();
  bool _isActive = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.editConfigId != null) {
      _loadExisting(widget.editConfigId!, isEdit: true);
    } else if (widget.cloneFromId != null) {
      _loadExisting(widget.cloneFromId!, isEdit: false);
    } else {
      _initOdometer();
    }
  }

  Future<void> _loadExisting(int id, {required bool isEdit}) async {
    final repo = ref.read(cvtRepositoryProvider);
    final c = await repo.getConfigurationById(id);
    if (c != null && mounted) {
      setState(() {
        _nameCtrl.text = isEdit ? c.name : '${c.name} (Copy)';
        _pulleyCtrl.text = c.pulleyBrandModel ?? '';
        _flyballWeightCtrl.text = c.flyballWeightGrams?.toString() ?? '';
        _flyballArrangementCtrl.text = c.flyballArrangement ?? '';
        _centerSpringCtrl.text = c.centerSpringRpm?.toString() ?? '';
        _clutchSpringCtrl.text = c.clutchSpringRpm?.toString() ?? '';
        _beltCtrl.text = c.beltBrandPartNumber ?? '';
        _washerCtrl.text = c.pulleyWasherThicknessMm?.toString() ?? '';
        _clutchBellCtrl.text = c.clutchBellSpec ?? '';
        _exhaustCtrl.text = c.exhaustSpec ?? '';
        _otherModsCtrl.text = c.otherMods ?? '';
        _odoCtrl.text = c.installedOdometerKm?.toString() ?? '';
        _notesCtrl.text = c.notes ?? '';
        _installedDate = isEdit ? c.installedDate : DateTime.now();
        _isActive = isEdit ? c.isActive : false;
      });
    }
    if (!isEdit) {
      _initOdometer();
    }
  }

  void _loadStockOemSpecs() {
    setState(() {
      _nameCtrl.text = 'Stock OEM ADV 160';
      _pulleyCtrl.text = 'Honda OEM Pulley (K0W / 15°)';
      _flyballWeightCtrl.text = '19.0';
      _flyballArrangementCtrl.text = 'Straight: 6 x 19.0g (Part 22123-K0W-N00)';
      _centerSpringCtrl.text = '1000';
      _clutchSpringCtrl.text = '1000';
      _beltCtrl.text = 'Honda OEM 23100-K0W-N01 (Bando)';
      _washerCtrl.text = '0.5';
      _clutchBellCtrl.text = 'Honda OEM Clutch & Bell';
      _exhaustCtrl.text = 'Honda OEM Stock';
      _notesCtrl.text =
          'Standard factory transmission configuration for Honda ADV 160.';
    });
  }

  Future<void> _initOdometer() async {
    final bike = await ref.read(primaryMotorcycleProvider.future);
    if (bike != null) {
      final odoRepo = ref.read(odometerRepositoryProvider);
      final latest = await odoRepo.latestConfirmed(bike.id);
      if (latest != null && mounted) {
        setState(() {
          _odoCtrl.text = '${latest.readingKm}';
        });
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pulleyCtrl.dispose();
    _flyballWeightCtrl.dispose();
    _flyballArrangementCtrl.dispose();
    _centerSpringCtrl.dispose();
    _clutchSpringCtrl.dispose();
    _beltCtrl.dispose();
    _washerCtrl.dispose();
    _clutchBellCtrl.dispose();
    _exhaustCtrl.dispose();
    _otherModsCtrl.dispose();
    _odoCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
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

    final input = NewCvtConfigurationInput(
      motorcycleId: bike.id,
      name: _nameCtrl.text.trim(),
      pulleyBrandModel:
          _pulleyCtrl.text.trim().isEmpty ? null : _pulleyCtrl.text.trim(),
      flyballWeightGrams: double.tryParse(_flyballWeightCtrl.text.trim()),
      flyballArrangement: _flyballArrangementCtrl.text.trim().isEmpty
          ? null
          : _flyballArrangementCtrl.text.trim(),
      centerSpringRpm: int.tryParse(_centerSpringCtrl.text.trim()),
      clutchSpringRpm: int.tryParse(_clutchSpringCtrl.text.trim()),
      beltBrandPartNumber:
          _beltCtrl.text.trim().isEmpty ? null : _beltCtrl.text.trim(),
      pulleyWasherThicknessMm: double.tryParse(_washerCtrl.text.trim()),
      clutchBellSpec: _clutchBellCtrl.text.trim().isEmpty
          ? null
          : _clutchBellCtrl.text.trim(),
      exhaustSpec:
          _exhaustCtrl.text.trim().isEmpty ? null : _exhaustCtrl.text.trim(),
      otherMods: _otherModsCtrl.text.trim().isEmpty
          ? null
          : _otherModsCtrl.text.trim(),
      installedDate: _installedDate,
      installedOdometerKm: int.tryParse(_odoCtrl.text.trim()),
      isActive: _isActive,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );

    final String? err;
    if (widget.editConfigId != null) {
      err = await ref.read(cvtActionsProvider.notifier).updateConfiguration(
            id: widget.editConfigId!,
            name: _nameCtrl.text.trim(),
            pulleyBrandModel: _pulleyCtrl.text.trim().isEmpty
                ? null
                : _pulleyCtrl.text.trim(),
            flyballWeightGrams: double.tryParse(_flyballWeightCtrl.text.trim()),
            flyballArrangement: _flyballArrangementCtrl.text.trim().isEmpty
                ? null
                : _flyballArrangementCtrl.text.trim(),
            centerSpringRpm: int.tryParse(_centerSpringCtrl.text.trim()),
            clutchSpringRpm: int.tryParse(_clutchSpringCtrl.text.trim()),
            beltBrandPartNumber:
                _beltCtrl.text.trim().isEmpty ? null : _beltCtrl.text.trim(),
            pulleyWasherThicknessMm: double.tryParse(_washerCtrl.text.trim()),
            clutchBellSpec: _clutchBellCtrl.text.trim().isEmpty
                ? null
                : _clutchBellCtrl.text.trim(),
            exhaustSpec: _exhaustCtrl.text.trim().isEmpty
                ? null
                : _exhaustCtrl.text.trim(),
            otherMods: _otherModsCtrl.text.trim().isEmpty
                ? null
                : _otherModsCtrl.text.trim(),
            installedDate: _installedDate,
            installedOdometerKm: int.tryParse(_odoCtrl.text.trim()),
            notes:
                _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
          );
      if (_isActive) {
        await ref
            .read(cvtActionsProvider.notifier)
            .setActive(widget.editConfigId!, bike.id);
      }
    } else {
      err =
          await ref.read(cvtActionsProvider.notifier).saveConfiguration(input);
    }

    if (!mounted) return;
    setState(() => _saving = false);
    if (err == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.editConfigId != null
              ? 'CVT configuration updated.'
              : 'CVT configuration saved.'),
        ),
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
        title: Text(widget.editConfigId != null
            ? 'Edit CVT Configuration'
            : 'Add CVT Configuration'),
        actions: [
          if (widget.editConfigId == null)
            TextButton.icon(
              onPressed: _loadStockOemSpecs,
              icon: const Icon(Icons.auto_fix_high, size: 18),
              label: const Text('Load OEM Stock'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Configuration Name *',
                hintText: 'e.g. Touring Setup (13g + 1500 RPM)',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _pulleyCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Pulley Brand / Model',
                      hintText: 'e.g. Stock, JVT, RS8',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _flyballWeightCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Flyball Weight (grams)',
                      hintText: 'e.g. 13.0',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _flyballArrangementCtrl,
              decoration: const InputDecoration(
                labelText: 'Flyball Arrangement',
                hintText: 'e.g. Straight 13g or 3x12g + 3x14g alternate',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _centerSpringCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Center Spring (RPM)',
                      hintText: 'e.g. 1000, 1500',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _clutchSpringCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Clutch Spring (RPM)',
                      hintText: 'e.g. 1000, 1500',
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
                    controller: _beltCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Drive Belt Brand / P/N',
                      hintText: 'e.g. Honda 23100-K0W-N01',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _washerCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Washer Thickness (mm)',
                      hintText: 'e.g. 0.5',
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
                    controller: _clutchBellCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Clutch & Bell Info',
                      hintText: 'e.g. Stock regrooved bell',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _exhaustCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Exhaust Setup',
                      hintText: 'e.g. Stock pipe',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _otherModsCtrl,
              decoration: const InputDecoration(
                labelText: 'Other Modifications',
                hintText: 'e.g. Torsion controller, slider piece brand',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _odoCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Install Odometer (km)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Install Date'),
                    subtitle: Text(AppDates.formatDate(_installedDate)),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _installedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (d != null) setState(() => _installedDate = d);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Set as Active Setup'),
              subtitle: const Text(
                  'Designates this configuration as the currently installed CVT setup'),
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Initial impressions or installation notes',
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
              label: const Text('Save CVT Configuration'),
            ),
          ],
        ),
      ),
    );
  }
}
