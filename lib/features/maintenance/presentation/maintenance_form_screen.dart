import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/money.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/widgets/photo_attachments_field.dart';
import '../../components/domain/component_models.dart';
import '../../components/presentation/components_view_model.dart';
import '../../cvt/presentation/cvt_view_model.dart';
import '../../motorcycle/presentation/motorcycle_view_model.dart';
import '../../parts/domain/part_models.dart';
import '../data/maintenance_repository.dart';
import '../domain/maintenance_record_detail.dart';
import 'maintenance_view_model.dart';
import 'status_text.dart';

/// Add or edit a maintenance service record.
///
/// Editing never overwrites the existing row in SQLite; it voids the old record
/// and creates a superseding record (`supersedesRecordId`).
class MaintenanceFormScreen extends ConsumerStatefulWidget {
  const MaintenanceFormScreen({
    super.key,
    this.initialItemId,
    this.initialAction,
    this.initialOdometerKm,
    this.editRecordId,
    this.initialNotes,
    this.initialPartName,
    this.initialPartNumber,
    this.initialBrand,
  });

  final int? initialItemId;
  final MaintenanceAction? initialAction;
  final int? initialOdometerKm;
  final int? editRecordId;
  final String? initialNotes;
  final String? initialPartName;
  final String? initialPartNumber;
  final String? initialBrand;

  @override
  ConsumerState<MaintenanceFormScreen> createState() =>
      _MaintenanceFormScreenState();
}

class _PartDraft {
  _PartDraft({
    String name = '',
    String brand = '',
    String partNumber = '',
    String specification = '',
    String quantity = '1',
    String unitCostPesos = '0',
    this.trackInstallation = true,
  })  : name = TextEditingController(text: name),
        brand = TextEditingController(text: brand),
        partNumber = TextEditingController(text: partNumber),
        specification = TextEditingController(text: specification),
        quantity = TextEditingController(text: quantity),
        unitCostPesos = TextEditingController(text: unitCostPesos);

  final TextEditingController name;
  final TextEditingController brand;
  final TextEditingController partNumber;
  final TextEditingController specification;
  final TextEditingController quantity;
  final TextEditingController unitCostPesos;
  String? position;
  bool trackInstallation;

  void dispose() {
    name.dispose();
    brand.dispose();
    partNumber.dispose();
    specification.dispose();
    quantity.dispose();
    unitCostPesos.dispose();
  }
}

class _MaintenanceFormScreenState extends ConsumerState<MaintenanceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _odometer = TextEditingController();
  final _measurementValue = TextEditingController();
  final _measurementUnit = TextEditingController(text: 'mm');
  final _laborPesos = TextEditingController(text: '0');
  final _totalPesos = TextEditingController(text: '0');
  final _provider = TextEditingController();
  final _notes = TextEditingController();

  int? _itemId;
  MaintenanceAction _action = MaintenanceAction.inspection;
  String? _measurementPosition;
  late DateTime _date;
  bool _manualTotal = false;
  final List<_PartDraft> _parts = [];
  final List<String> _newPhotos = [];
  List<AttachmentInfo> _existingAttachments = const [];
  final Set<int> _keptAttachmentIds = {};
  bool _loadedEdit = false;
  bool _syncWithCvt = true;

  @override
  void initState() {
    super.initState();
    _itemId = widget.initialItemId;
    if (widget.initialAction != null) {
      _action = widget.initialAction!;
    }
    if (widget.initialOdometerKm != null) {
      _odometer.text = '${widget.initialOdometerKm}';
    }
    if (widget.initialNotes != null && widget.initialNotes!.isNotEmpty) {
      _notes.text = widget.initialNotes!;
    }
    if (widget.initialPartName != null &&
        widget.initialPartName!.trim().isNotEmpty) {
      _parts.add(
        _PartDraft(
          name: widget.initialPartName!.trim(),
          partNumber: widget.initialPartNumber?.trim() ?? '',
          brand: widget.initialBrand?.trim() ?? 'Honda Genuine OEM',
          trackInstallation: true,
        ),
      );
    }
    _date = AppDates.todayManila(ref.read(clockProvider)());
    _laborPesos.addListener(_recomputeTotal);
  }

  @override
  void dispose() {
    for (final c in [
      _odometer,
      _measurementValue,
      _measurementUnit,
      _laborPesos,
      _totalPesos,
      _provider,
      _notes,
    ]) {
      c.dispose();
    }
    for (final p in _parts) {
      p.dispose();
    }
    super.dispose();
  }

  void _populateFromExisting(MaintenanceRecordDetail r) {
    if (_loadedEdit) return;
    _loadedEdit = true;
    _itemId = r.itemId;
    _action = r.action;
    _date = r.performedDate;
    _odometer.text = '${r.odometerKm}';
    _laborPesos.text = Money.toInput(r.laborCostCentavos);
    _totalPesos.text = Money.toInput(r.totalCostCentavos);
    _provider.text = r.serviceProvider ?? '';
    _notes.text = r.notes ?? '';
    _existingAttachments = r.attachments;
    _keptAttachmentIds.addAll(r.attachments.map((a) => a.id));
    for (final rp in r.parts) {
      final d = _PartDraft(
        name: rp.part.name,
        brand: rp.part.brand ?? '',
        partNumber: rp.part.partNumber ?? '',
        specification: rp.part.specification ?? '',
        quantity: '${rp.quantity}',
        unitCostPesos: Money.toInput(rp.unitCostCentavos),
        trackInstallation: false,
      );
      d.quantity.addListener(_recomputeTotal);
      d.unitCostPesos.addListener(_recomputeTotal);
      _parts.add(d);
    }
  }

  int _computedTotalCentavos() {
    final labor = Money.tryParsePesos(_laborPesos.text) ?? 0;
    final parts = [
      for (final p in _parts)
        (
          quantity: int.tryParse(p.quantity.text.trim()) ?? 0,
          unitCostCentavos: Money.tryParsePesos(p.unitCostPesos.text) ?? 0,
        ),
    ];
    return ref
        .read(expenseServiceProvider)
        .totalCentavos(laborCentavos: labor, parts: parts);
  }

  void _recomputeTotal() {
    if (_manualTotal) return;
    final cents = _computedTotalCentavos();
    _totalPesos.text = Money.toInput(cents);
    if (mounted) setState(() {});
  }

  void _addPartDraft() {
    final d = _PartDraft();
    d.quantity.addListener(_recomputeTotal);
    d.unitCostPesos.addListener(_recomputeTotal);
    setState(() => _parts.add(d));
    _recomputeTotal();
  }

  void _removePartDraft(int index) {
    final d = _parts.removeAt(index);
    d.dispose();
    setState(() {});
    _recomputeTotal();
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
    final itemId = _itemId;
    if (itemId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select a maintenance item')));
      return;
    }
    final bike = await ref.read(primaryMotorcycleProvider.future);
    if (bike == null) return;

    final labor = Money.tryParsePesos(_laborPesos.text) ?? 0;
    final total = Money.tryParsePesos(_totalPesos.text) ?? 0;
    final partInputs = [
      for (final p in _parts)
        RecordPartInput(
          name: p.name.text,
          brand: p.brand.text,
          partNumber: p.partNumber.text,
          specification: p.specification.text,
          quantity: int.parse(p.quantity.text.trim()),
          unitCostCentavos: Money.tryParsePesos(p.unitCostPesos.text) ?? 0,
          position: p.position,
          trackInstallation: p.trackInstallation,
        ),
    ];

    final measText = _measurementValue.text.trim();
    final double? measVal = measText.isEmpty ? null : double.tryParse(measText);
    final selectedItem = await ref
        .read(maintenanceOverviewProvider.future)
        .then((o) => o.itemById(itemId));
    final matchedSpecs = selectedItem == null
        ? const <ComponentSpecDefinition>[]
        : ComponentSpecDefinition.specsForItem(
            itemId: itemId,
            itemName: selectedItem.name,
          );
    final mType = matchedSpecs.isNotEmpty
        ? matchedSpecs.first.measurementType
        : MeasurementType.generalMeasurement;

    final input = NewMaintenanceRecord(
      motorcycleId: bike.id,
      itemId: itemId,
      action: _action,
      date: _date,
      odometerKm: int.parse(_odometer.text.replaceAll(',', '').trim()),
      laborCostCentavos: labor,
      totalCostCentavos: total,
      serviceProvider: _provider.text,
      notes: _notes.text,
      parts: partInputs,
      photoPaths: List.of(_newPhotos),
      keepAttachmentIds: _keptAttachmentIds.toList(),
      measurementValue: measVal,
      measurementUnit: _measurementUnit.text.trim(),
      measurementType: mType,
      measurementPosition: _measurementPosition,
    );

    final notifier = ref.read(maintenanceActionsProvider.notifier);
    final err = widget.editRecordId == null
        ? await notifier.addRecord(input)
        : await notifier.editRecord(widget.editRecordId!, input);
    if (!mounted) return;
    if (err == null) {
      ref.invalidate(componentMeasurementsProvider);
      ref.invalidate(activeCvtConfigurationProvider);
      ref.invalidate(cvtConfigurationsProvider);

      if (_syncWithCvt && selectedItem != null) {
        final isCvt = selectedItem.name.toLowerCase().contains('cvt') ||
            selectedItem.name.toLowerCase().contains('belt') ||
            selectedItem.name.toLowerCase().contains('clutch');
        if (isCvt) {
          try {
            final activeConfig =
                await ref.read(activeCvtConfigurationProvider.future);
            if (activeConfig != null) {
              final odo =
                  int.tryParse(_odometer.text.replaceAll(',', '').trim());
              final beltPart = _parts.where((p) {
                final n = p.name.text.toLowerCase();
                final pn = p.partNumber.text.toLowerCase();
                return n.contains('belt') || pn.contains('23100');
              }).firstOrNull;

              final updatedBelt = (beltPart != null &&
                      beltPart.partNumber.text.trim().isNotEmpty)
                  ? beltPart.partNumber.text.trim()
                  : activeConfig.beltBrandPartNumber;

              await ref.read(cvtRepositoryProvider).updateConfiguration(
                    id: activeConfig.id,
                    name: activeConfig.name,
                    pulleyBrandModel: activeConfig.pulleyBrandModel,
                    flyballWeightGrams: activeConfig.flyballWeightGrams,
                    flyballArrangement: activeConfig.flyballArrangement,
                    centerSpringRpm: activeConfig.centerSpringRpm,
                    clutchSpringRpm: activeConfig.clutchSpringRpm,
                    beltBrandPartNumber: updatedBelt,
                    pulleyWasherThicknessMm:
                        activeConfig.pulleyWasherThicknessMm,
                    clutchBellSpec: activeConfig.clutchBellSpec,
                    exhaustSpec: activeConfig.exhaustSpec,
                    otherMods: activeConfig.otherMods,
                    installedDate: _date,
                    installedOdometerKm:
                        odo ?? activeConfig.installedOdometerKm,
                    notes: activeConfig.notes,
                  );
              ref.invalidate(activeCvtConfigurationProvider);
              ref.invalidate(cvtConfigurationsProvider);
            }
          } catch (_) {}
        }
      }

      if (!mounted) return;
      if (context.canPop()) context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final overviewAsync = ref.watch(maintenanceOverviewProvider);
    final historyAsync = ref.watch(maintenanceHistoryProvider);
    final saving = ref.watch(maintenanceActionsProvider).isLoading;

    if (widget.editRecordId != null && !_loadedEdit) {
      final list = historyAsync.valueOrNull;
      final existing =
          list?.where((r) => r.id == widget.editRecordId).firstOrNull;
      if (existing != null) {
        _populateFromExisting(existing);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editRecordId == null
            ? 'Record Maintenance'
            : 'Edit Maintenance Record'),
      ),
      body: overviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load items: $e')),
        data: (o) {
          final items = o.snapshot.items;
          if (_itemId == null && items.isNotEmpty) {
            _itemId = items.first.id;
          }
          if (_odometer.text.isEmpty &&
              widget.editRecordId == null &&
              o.currentKm != null) {
            _odometer.text = '${o.currentKm}';
          }
          final selectedItem = items.where((i) => i.id == _itemId).firstOrNull;
          final itemSpecs = selectedItem == null
              ? const <ComponentSpecDefinition>[]
              : ComponentSpecDefinition.specsForItem(
                  itemId: selectedItem.id,
                  itemName: selectedItem.name,
                );
          final needsPosition = itemSpecs.any((s) => s.position != null);
          if (needsPosition && _measurementPosition == null) {
            _measurementPosition = ComponentPosition.front.code;
          }
          final isCvtItem = selectedItem != null &&
              (selectedItem.name.toLowerCase().contains('cvt') ||
                  selectedItem.name.toLowerCase().contains('belt') ||
                  selectedItem.name.toLowerCase().contains('clutch'));

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (widget.initialItemId != null && selectedItem != null)
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Maintenance item / component',
                    ),
                    child: Text(
                      selectedItem.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                else
                  DropdownButtonFormField<int>(
                    value: _itemId,
                    decoration: const InputDecoration(
                        labelText: 'Maintenance item / component'),
                    items: [
                      for (final i in items)
                        DropdownMenuItem(value: i.id, child: Text(i.name)),
                    ],
                    onChanged: (v) => setState(() {
                      _itemId = v;
                      _measurementPosition = null;
                    }),
                  ),
                const SizedBox(height: 12),
                DropdownButtonFormField<MaintenanceAction>(
                  key: const Key('maintenance_action_dropdown'),
                  value: _action,
                  decoration:
                      const InputDecoration(labelText: 'Maintenance action'),
                  items: [
                    for (final a in MaintenanceAction.values)
                      DropdownMenuItem(
                        value: a,
                        child: Text(_actionLabel(a)),
                      ),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _action = v);
                  },
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Service date'),
                  subtitle: Text(AppDates.formatDate(_date)),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: _pickDate,
                ),
                TextFormField(
                  key: const Key('maintenance_odometer_field'),
                  controller: _odometer,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Current odometer reading (km)'),
                  validator: (v) {
                    final n =
                        int.tryParse((v ?? '').replaceAll(',', '').trim());
                    if (n == null || n < 0) {
                      return 'Enter a non-negative odometer in km';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        key: const Key('maintenance_measurement_field'),
                        controller: _measurementValue,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Actual measurement (optional)',
                          hintText: 'e.g. 4.5 or 19.2',
                        ),
                        validator: (v) {
                          final raw = (v ?? '').trim();
                          if (raw.isEmpty) return null;
                          final d = double.tryParse(raw);
                          if (d == null || d <= 0) {
                            return 'Enter a positive measurement';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        key: const Key('maintenance_measurement_unit_dropdown'),
                        value: const ['mm', 'km', 'V', 'kPa', 'rpm']
                                .contains(_measurementUnit.text.trim())
                            ? _measurementUnit.text.trim()
                            : 'mm',
                        decoration: const InputDecoration(labelText: 'Unit'),
                        items: const [
                          DropdownMenuItem(value: 'mm', child: Text('mm')),
                          DropdownMenuItem(value: 'km', child: Text('km')),
                          DropdownMenuItem(value: 'V', child: Text('V')),
                          DropdownMenuItem(value: 'kPa', child: Text('kPa')),
                          DropdownMenuItem(value: 'rpm', child: Text('rpm')),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => _measurementUnit.text = v);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                if (needsPosition) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _measurementPosition,
                    decoration: const InputDecoration(
                        labelText: 'Component position (Front / Rear)'),
                    items: [
                      for (final p in ComponentPosition.values)
                        DropdownMenuItem(value: p.code, child: Text(p.label)),
                    ],
                    onChanged: (v) => setState(() => _measurementPosition = v),
                  ),
                ],
                const SizedBox(height: 12),
                TextFormField(
                  controller: _provider,
                  decoration: const InputDecoration(
                      labelText: 'Mechanic or service center'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text('Parts used',
                          style: Theme.of(context).textTheme.titleSmall),
                    ),
                    TextButton.icon(
                      onPressed: _addPartDraft,
                      icon: const Icon(Icons.add),
                      label: const Text('Add part'),
                    ),
                  ],
                ),
                for (var i = 0; i < _parts.length; i++)
                  _PartDraftCard(
                    index: i,
                    draft: _parts[i],
                    showInstallToggle: _action == MaintenanceAction.replacement,
                    onRemove: () => _removePartDraft(i),
                    onChanged: () => setState(() {}),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _laborPesos,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration:
                            const InputDecoration(labelText: 'Labor cost (₱)'),
                        validator: (v) => Money.tryParsePesos(v) == null
                            ? 'Enter valid amount'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _totalPesos,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Total cost (₱)',
                          helperText: StatusText.pesos(
                              Money.tryParsePesos(_totalPesos.text) ?? 0),
                        ),
                        onChanged: (_) => _manualTotal = true,
                        validator: (v) => Money.tryParsePesos(v) == null
                            ? 'Enter valid amount'
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notes,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
                if (isCvtItem)
                  Card(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.3),
                    margin: const EdgeInsets.only(top: 12),
                    child: SwitchListTile(
                      secondary: const Icon(Icons.tune),
                      title: const Text('Sync with Active CVT Setup'),
                      subtitle: const Text(
                          'Updates installation odometer & belt spec on your active CVT configuration'),
                      value: _syncWithCvt,
                      onChanged: (val) => setState(() => _syncWithCvt = val),
                    ),
                  ),
                const SizedBox(height: 16),
                PhotoAttachmentsSection(
                  newPaths: _newPhotos,
                  existing: _existingAttachments,
                  keptExistingIds: _keptAttachmentIds,
                  onAddPath: (p) => setState(() => _newPhotos.add(p)),
                  onRemoveNewAt: (idx) =>
                      setState(() => _newPhotos.removeAt(idx)),
                  onToggleExisting: (id) => setState(() {
                    if (!_keptAttachmentIds.remove(id)) {
                      _keptAttachmentIds.add(id);
                    }
                  }),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: saving ? null : _save,
                  child: Text(widget.editRecordId == null
                      ? 'Save Service Record'
                      : 'Save Edited Version'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static String _actionLabel(MaintenanceAction a) => a.label;
}

class _PartDraftCard extends StatelessWidget {
  const _PartDraftCard({
    required this.index,
    required this.draft,
    required this.showInstallToggle,
    required this.onRemove,
    required this.onChanged,
  });

  final int index;
  final _PartDraft draft;
  final bool showInstallToggle;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Part #${index + 1}',
                      style: Theme.of(context).textTheme.labelLarge),
                ),
                IconButton(
                  tooltip: 'Remove part',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onRemove,
                ),
              ],
            ),
            TextFormField(
              controller: draft.name,
              decoration: const InputDecoration(labelText: 'Part name'),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Part name is required'
                  : null,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: draft.brand,
                    decoration: const InputDecoration(labelText: 'Brand'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: draft.partNumber,
                    decoration: const InputDecoration(labelText: 'Part number'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: draft.specification,
              decoration: const InputDecoration(labelText: 'Specification'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: draft.quantity,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    validator: (v) {
                      final q = int.tryParse((v ?? '').trim());
                      return (q == null || q < 1) ? 'Min 1' : null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: draft.unitCostPesos,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration:
                        const InputDecoration(labelText: 'Unit cost (₱)'),
                    validator: (v) =>
                        Money.tryParsePesos(v) == null ? 'Invalid' : null,
                  ),
                ),
              ],
            ),
            if (showInstallToggle)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Track as installed part'),
                value: draft.trackInstallation,
                onChanged: (v) {
                  draft.trackInstallation = v;
                  onChanged();
                },
              ),
          ],
        ),
      ),
    );
  }
}
