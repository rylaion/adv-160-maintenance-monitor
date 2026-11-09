import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/money.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/widgets/item_status_card.dart';
import '../../../shared/widgets/measurement_trend_chart.dart';
import '../../../shared/widgets/photo_attachments_field.dart';
import '../../maintenance/data/maintenance_repository.dart';
import '../../maintenance/domain/maintenance_overview.dart';
import '../../maintenance/presentation/maintenance_history_screen.dart';
import '../../maintenance/presentation/maintenance_view_model.dart';
import '../../maintenance/presentation/status_text.dart';
import '../../motorcycle/presentation/motorcycle_view_model.dart';
import '../../parts/domain/part_models.dart';
import '../../parts/presentation/parts_view_model.dart';
import '../domain/component_models.dart';
import 'components_screen.dart';
import 'components_view_model.dart';

/// Individual component monitoring screen (Module E).
///
/// Supports all 8 components:
/// - `cvt_belt`: CVT Belt
/// - `fuel_filter`: Fuel Filter
/// - `brake_pads`: Brake Pads
/// - `brake_fluid`: Brake Fluid
/// - `battery`: Battery
/// - `tires`: Tires
/// - `coolant`: Coolant
/// - `final_drive_oil`: Final Drive Oil
///
/// Never automatically declares a component safe based on mileage or
/// measurement alone; displays recorded inspection results and verified
/// specification limits separately.
class ComponentDetailScreen extends ConsumerStatefulWidget {
  const ComponentDetailScreen({super.key, required this.slug});
  final String slug;

  @override
  ConsumerState<ComponentDetailScreen> createState() =>
      _ComponentDetailScreenState();
}

class _ComponentDetailScreenState extends ConsumerState<ComponentDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _odometer = TextEditingController();
  final _brand = TextEditingController();
  final _partOrModel = TextEditingController();
  final _spec = TextEditingController();
  final _value1 = TextEditingController();
  final _value2 = TextEditingController();
  final _condition = TextEditingController();
  final _notes = TextEditingController();
  final _quantity = TextEditingController(text: '1');
  final _costPesos = TextEditingController(text: '0');

  late DateTime _date;
  String _position = ComponentPosition.front.code;
  String _batteryContext = BatteryMeasurementContext.engineOff.code;
  bool _hasDamage = false;
  bool _isReplacementAction = false;
  final List<String> _photos = [];

  @override
  void initState() {
    super.initState();
    _date = AppDates.todayManila(ref.read(clockProvider)());
    _isReplacementAction = const {
      'fuel_filter',
      'brake_fluid',
      'coolant',
      'final_drive_oil',
    }.contains(widget.slug);
  }

  @override
  void dispose() {
    for (final c in [
      _odometer,
      _brand,
      _partOrModel,
      _spec,
      _value1,
      _value2,
      _condition,
      _notes,
      _quantity,
      _costPesos,
    ]) {
      c.dispose();
    }
    super.dispose();
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

  Future<void> _submit(ItemStatus itemStatus) async {
    if (!_formKey.currentState!.validate()) return;
    final bike = await ref.read(primaryMotorcycleProvider.future);
    if (bike == null) return;
    final itemId = itemStatus.item.id;
    final km = int.parse(_odometer.text.trim());
    final slug = widget.slug;

    final compNotifier = ref.read(componentsActionsProvider.notifier);
    final maintNotifier = ref.read(maintenanceActionsProvider.notifier);
    final partsNotifier = ref.read(partsActionsProvider.notifier);

    String? err;

    if (slug == 'cvt_belt') {
      final mm = double.parse(_value1.text.trim());
      err = await compNotifier.addMeasurement(NewComponentMeasurement(
        motorcycleId: bike.id,
        itemId: itemId,
        measuredDate: _date,
        odometerKm: km,
        measurementType: MeasurementType.thicknessMm,
        value: mm,
        brand: _brand.text,
        partNumber: _partOrModel.text,
        visualCondition: _condition.text,
        hasDamage: _hasDamage,
        notes: _notes.text,
        photoPaths: List.of(_photos),
      ));
    } else if (slug == 'brake_pads') {
      final mm = double.parse(_value1.text.trim());
      err = await compNotifier.addMeasurement(NewComponentMeasurement(
        motorcycleId: bike.id,
        itemId: itemId,
        measuredDate: _date,
        odometerKm: km,
        measurementType: MeasurementType.thicknessMm,
        value: mm,
        position: _position,
        visualCondition: _condition.text,
        notes: _notes.text,
        photoPaths: List.of(_photos),
      ));
    } else if (slug == 'battery') {
      final volts = double.parse(_value1.text.trim());
      err = await compNotifier.addMeasurement(NewComponentMeasurement(
        motorcycleId: bike.id,
        itemId: itemId,
        measuredDate: _date,
        odometerKm: km,
        measurementType: MeasurementType.voltageV,
        value: volts,
        measurementContext: _batteryContext,
        brand: _brand.text,
        partNumber: _partOrModel.text,
        visualCondition: _condition.text,
        notes: _notes.text,
        photoPaths: List.of(_photos),
      ));
      if (err == null && _isReplacementAction) {
        err = await partsNotifier.addPart(
          part: NewPart(
            itemId: itemId,
            name: 'Battery',
            brand: _brand.text.isEmpty ? null : _brand.text,
            partNumber: _partOrModel.text.isEmpty ? null : _partOrModel.text,
            purchaseDate: _date,
          ),
          installDate: _date,
          installOdometerKm: km,
          installNotes: _notes.text,
        );
      }
    } else if (slug == 'tires') {
      final kpa = double.parse(_value1.text.trim());
      final tread = double.parse(_value2.text.trim());
      err = await compNotifier.addMeasurements([
        NewComponentMeasurement(
          motorcycleId: bike.id,
          itemId: itemId,
          measuredDate: _date,
          odometerKm: km,
          measurementType: MeasurementType.pressureKpa,
          value: kpa,
          position: _position,
          brand: _brand.text,
          partNumber: _partOrModel.text,
          visualCondition: _condition.text,
          notes: _notes.text,
          photoPaths: List.of(_photos),
        ),
        NewComponentMeasurement(
          motorcycleId: bike.id,
          itemId: itemId,
          measuredDate: _date,
          odometerKm: km,
          measurementType: MeasurementType.treadDepthMm,
          value: tread,
          position: _position,
          brand: _brand.text,
          partNumber: _partOrModel.text,
          visualCondition: _condition.text,
          notes: _notes.text,
        ),
      ]);
      if (err == null && _isReplacementAction) {
        err = await partsNotifier.addPart(
          part: NewPart(
            itemId: itemId,
            name: 'Tire ($_position)',
            brand: _brand.text.isEmpty ? null : _brand.text,
            partNumber: _partOrModel.text.isEmpty ? null : _partOrModel.text,
            purchaseDate: _date,
          ),
          installDate: _date,
          installOdometerKm: km,
          position: _position,
          installNotes: _notes.text,
        );
      }
    } else if (slug == 'fuel_filter') {
      err = await maintNotifier.addRecord(NewMaintenanceRecord(
        motorcycleId: bike.id,
        itemId: itemId,
        action: _isReplacementAction
            ? MaintenanceAction.replacement
            : MaintenanceAction.inspection,
        date: _date,
        odometerKm: km,
        notes: _notes.text,
        photoPaths: List.of(_photos),
        parts: [
          if (_brand.text.trim().isNotEmpty ||
              _partOrModel.text.trim().isNotEmpty ||
              _isReplacementAction)
            RecordPartInput(
              name: 'Fuel Filter',
              brand: _brand.text,
              partNumber: _partOrModel.text,
              trackInstallation: _isReplacementAction,
            ),
        ],
      ));
    } else if (slug == 'brake_fluid' ||
        slug == 'coolant' ||
        slug == 'final_drive_oil') {
      final qty = int.tryParse(_quantity.text.trim()) ?? 1;
      final cost = Money.tryParsePesos(_costPesos.text) ?? 0;
      if (_isReplacementAction) {
        err = await maintNotifier.addRecord(NewMaintenanceRecord(
          motorcycleId: bike.id,
          itemId: itemId,
          action: MaintenanceAction.replacement,
          date: _date,
          odometerKm: km,
          totalCostCentavos: cost,
          notes: [
            if (_condition.text.trim().isNotEmpty)
              'Condition: ${_condition.text.trim()}',
            if (_notes.text.trim().isNotEmpty) _notes.text.trim(),
          ].join(' · '),
          photoPaths: List.of(_photos),
          parts: [
            RecordPartInput(
              name: itemStatus.item.name,
              brand: _brand.text,
              specification: _spec.text,
              quantity: qty,
              unitCostCentavos: qty > 0 ? cost ~/ qty : cost,
              trackInstallation: true,
            ),
          ],
        ));
      }
      if (err == null &&
          (_condition.text.trim().isNotEmpty ||
              _spec.text.trim().isNotEmpty ||
              !_isReplacementAction)) {
        err = await compNotifier.addMeasurement(NewComponentMeasurement(
          motorcycleId: bike.id,
          itemId: itemId,
          measuredDate: _date,
          odometerKm: km,
          measurementType: MeasurementType.conditionObservation,
          brand: _brand.text,
          partNumber: _spec.text,
          visualCondition:
              _condition.text.trim().isEmpty ? 'Recorded' : _condition.text,
          notes: _notes.text,
          photoPaths: _isReplacementAction ? const [] : List.of(_photos),
        ));
      }
    }

    if (!mounted) return;
    if (err == null) {
      _value1.clear();
      _value2.clear();
      _condition.clear();
      _notes.clear();
      setState(() => _photos.clear());
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Component log saved')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final def = MonitoredComponentDef.bySlug(widget.slug);
    if (def == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Component')),
        body: const Center(child: Text('Unknown component')),
      );
    }
    final overviewAsync = ref.watch(maintenanceOverviewProvider);

    return Scaffold(
      appBar: AppBar(title: Text(def.title)),
      body: overviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (o) {
          final itemStatus = o.items
              .where((i) => def.matchesItemName(i.item.name))
              .firstOrNull;
          if (itemStatus == null) {
            return const Center(child: Text('Component item not found'));
          }
          if (_odometer.text.isEmpty && o.currentKm != null) {
            _odometer.text = '${o.currentKm}';
          }
          final itemId = itemStatus.item.id;
          final measurements =
              ref.watch(componentMeasurementsProvider(itemId)).valueOrNull ??
                  const [];
          final installations =
              ref.watch(installationsProvider(itemId)).valueOrNull ?? const [];
          final records =
              ref.watch(itemHistoryProvider(itemId)).valueOrNull ?? const [];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SpecificationBanner(status: itemStatus),
              const SizedBox(height: 8),
              ItemStatusCard(status: itemStatus),
              const SizedBox(height: 12),
              _buildCharts(measurements),
              const SizedBox(height: 12),
              _buildEntryForm(context, def, itemStatus),
              if (installations.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text('Installed / Replaced Parts Lifecycle',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                for (final inst in installations)
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      dense: true,
                      title: Text(
                        '${inst.part.name}'
                        '${inst.position == null ? '' : ' (${inst.position})'}'
                        ' · ${inst.isInstalled ? 'Currently Installed' : 'Replaced'}',
                      ),
                      subtitle: Text([
                        if (inst.part.brand != null)
                          'Brand: ${inst.part.brand}',
                        if (inst.part.partNumber != null)
                          'P/N: ${inst.part.partNumber}',
                        if (inst.part.specification != null)
                          'Spec: ${inst.part.specification}',
                        'Installed: ${AppDates.formatDate(inst.installedDate)} @ ${StatusText.km(inst.installedKm)}',
                        if (inst.removedDate != null && inst.removedKm != null)
                          'Replaced: ${AppDates.formatDate(inst.removedDate!)} @ ${StatusText.km(inst.removedKm!)}',
                      ].join(' · ')),
                    ),
                  ),
              ],
              if (measurements.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text('Recorded Measurements & Inspections',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                for (final m in measurements) _MeasurementTile(measurement: m),
              ],
              if (records.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text('Service Records',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                for (final r in records) MaintenanceRecordCard(record: r),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildCharts(List<ComponentMeasurement> measurements) {
    final slug = widget.slug;
    if (slug == 'cvt_belt') {
      final m = measurements
          .where((x) => x.measurementType == MeasurementType.thicknessMm)
          .toList();
      return MeasurementTrendChart(
          measurements: m, unit: 'mm', title: 'CVT Belt Thickness Trend');
    }
    if (slug == 'brake_pads') {
      final front = measurements
          .where((x) =>
              x.measurementType == MeasurementType.thicknessMm &&
              x.position == 'FRONT')
          .toList();
      final rear = measurements
          .where((x) =>
              x.measurementType == MeasurementType.thicknessMm &&
              x.position == 'REAR')
          .toList();
      return Column(
        children: [
          if (front.isNotEmpty)
            MeasurementTrendChart(
                measurements: front, unit: 'mm', title: 'Front Pad Thickness'),
          if (rear.isNotEmpty)
            MeasurementTrendChart(
                measurements: rear, unit: 'mm', title: 'Rear Pad Thickness'),
        ],
      );
    }
    if (slug == 'battery') {
      final v = measurements
          .where((x) => x.measurementType == MeasurementType.voltageV)
          .toList();
      return MeasurementTrendChart(
          measurements: v, unit: 'V', title: 'Battery Voltage Trend');
    }
    if (slug == 'tires') {
      final p = measurements
          .where((x) => x.measurementType == MeasurementType.pressureKpa)
          .toList();
      final t = measurements
          .where((x) => x.measurementType == MeasurementType.treadDepthMm)
          .toList();
      return Column(
        children: [
          if (p.isNotEmpty)
            MeasurementTrendChart(
                measurements: p, unit: 'kPa', title: 'Tire Pressure Trend'),
          if (t.isNotEmpty)
            MeasurementTrendChart(
                measurements: t, unit: 'mm', title: 'Tread Depth Trend'),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildEntryForm(
    BuildContext context,
    MonitoredComponentDef def,
    ItemStatus itemStatus,
  ) {
    final slug = widget.slug;
    final saving = ref.watch(componentsActionsProvider).isLoading ||
        ref.watch(maintenanceActionsProvider).isLoading ||
        ref.watch(partsActionsProvider).isLoading;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Log ${def.title} Data',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text(AppDates.formatDate(_date)),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: _pickDate,
              ),
              TextFormField(
                controller: _odometer,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Odometer (km)'),
                validator: (v) {
                  final n = int.tryParse((v ?? '').trim());
                  return (n == null || n < 0) ? 'Enter non-negative km' : null;
                },
              ),
              const SizedBox(height: 10),
              if (slug == 'brake_pads' || slug == 'tires') ...[
                DropdownButtonFormField<String>(
                  value: _position,
                  decoration:
                      const InputDecoration(labelText: 'Position (Front/Rear)'),
                  items: [
                    for (final p in ComponentPosition.values)
                      DropdownMenuItem(value: p.code, child: Text(p.label)),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _position = v);
                  },
                ),
                const SizedBox(height: 10),
              ],
              if (slug == 'cvt_belt' ||
                  slug == 'fuel_filter' ||
                  slug == 'battery' ||
                  slug == 'tires' ||
                  slug == 'coolant' ||
                  slug == 'final_drive_oil') ...[
                TextFormField(
                  controller: _brand,
                  decoration: const InputDecoration(labelText: 'Brand'),
                ),
                const SizedBox(height: 10),
              ],
              if (slug == 'cvt_belt' || slug == 'fuel_filter') ...[
                TextFormField(
                  controller: _partOrModel,
                  decoration: const InputDecoration(labelText: 'Part number'),
                ),
                const SizedBox(height: 10),
              ],
              if (slug == 'battery' || slug == 'tires') ...[
                TextFormField(
                  controller: _partOrModel,
                  decoration: const InputDecoration(labelText: 'Model'),
                ),
                const SizedBox(height: 10),
              ],
              if (slug == 'brake_fluid' ||
                  slug == 'coolant' ||
                  slug == 'final_drive_oil') ...[
                TextFormField(
                  controller: _spec,
                  decoration:
                      const InputDecoration(labelText: 'Fluid specification'),
                ),
                const SizedBox(height: 10),
              ],
              if (slug == 'cvt_belt' || slug == 'brake_pads') ...[
                TextFormField(
                  controller: _value1,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      labelText: 'Measured thickness (mm)'),
                  validator: _validatePositiveDecimal,
                ),
                const SizedBox(height: 10),
              ],
              if (slug == 'battery') ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _value1,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration:
                            const InputDecoration(labelText: 'Voltage (V)'),
                        validator: _validatePositiveDecimal,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _batteryContext,
                        decoration: const InputDecoration(
                            labelText: 'Measurement context'),
                        items: [
                          for (final c in BatteryMeasurementContext.values)
                            DropdownMenuItem(
                                value: c.code, child: Text(c.label)),
                        ],
                        onChanged: (v) {
                          if (v != null) setState(() => _batteryContext = v);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
              if (slug == 'tires') ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _value1,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'Tire pressure (kPa)'),
                        validator: _validatePositiveDecimal,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _value2,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'Tread depth (mm)'),
                        validator: _validatePositiveDecimal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
              if (slug == 'final_drive_oil') ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _quantity,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Quantity'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _costPesos,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration:
                            const InputDecoration(labelText: 'Cost (₱)'),
                        validator: (v) =>
                            Money.tryParsePesos(v) == null ? 'Invalid' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
              if (slug != 'fuel_filter' && slug != 'final_drive_oil') ...[
                TextFormField(
                  controller: _condition,
                  decoration: const InputDecoration(
                      labelText: 'Visual / observed condition'),
                ),
                const SizedBox(height: 10),
              ],
              if (slug == 'cvt_belt')
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Cracks or visible damage observed'),
                  value: _hasDamage,
                  onChanged: (v) => setState(() => _hasDamage = v),
                ),
              if (slug == 'fuel_filter' ||
                  slug == 'battery' ||
                  slug == 'tires' ||
                  slug == 'brake_fluid' ||
                  slug == 'coolant' ||
                  slug == 'final_drive_oil')
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                      'Record as component installation / replacement'),
                  value: _isReplacementAction,
                  onChanged: (v) => setState(() => _isReplacementAction = v),
                ),
              TextFormField(
                controller: _notes,
                maxLines: 2,
                decoration:
                    const InputDecoration(labelText: 'Inspection notes'),
              ),
              const SizedBox(height: 12),
              PhotoAttachmentsSection(
                newPaths: _photos,
                onAddPath: (p) => setState(() => _photos.add(p)),
                onRemoveNewAt: (idx) => setState(() => _photos.removeAt(idx)),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: saving ? null : () => _submit(itemStatus),
                  child: const Text('Save Component Entry'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String? _validatePositiveDecimal(String? v) {
    final d = double.tryParse((v ?? '').trim());
    if (d == null || d <= 0) return 'Enter a positive number';
    return null;
  }
}

/// Separate panel for verified specification limits so measurements and safety
/// limits are never conflated or invented.
class _SpecificationBanner extends StatelessWidget {
  const _SpecificationBanner({required this.status});
  final ItemStatus status;

  @override
  Widget build(BuildContext context) {
    final verifiedRules = status.evaluation.ruleEvaluations
        .where((r) => r.rule.isVerified && r.rule.isManufacturer)
        .toList();
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified_user_outlined,
                    size: 18, color: scheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Verified Specification Limits & Safety Notice',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              verifiedRules.isEmpty
                  ? 'No verified Honda wear/measurement limit is configured for '
                      '${status.item.name}. ADV-MON does not automatically '
                      'declare a component safe from mileage or measurements '
                      'alone—compare inspection results against the official '
                      '2023 Honda ADV160 Owner\'s Manual (32K0WA100).'
                  : 'Verified manual rule active. Always pair numerical readings '
                      'with physical inspection.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _MeasurementTile extends ConsumerWidget {
  const _MeasurementTile({required this.measurement});
  final ComponentMeasurement measurement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = measurement;
    final valText = m.value == null
        ? m.measurementType.label
        : '${m.measurementType.label}: ${m.value!.toStringAsFixed(2)} ${m.unit}';
    final posText = m.position == null ? '' : ' (${m.position})';
    final ctxText =
        m.measurementContext == null ? '' : ' [${m.measurementContext}]';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$valText$posText$ctxText',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  tooltip: 'Void entry',
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: () => ref
                      .read(componentsActionsProvider.notifier)
                      .voidMeasurement(m.id),
                ),
              ],
            ),
            Text([
              AppDates.formatDate(m.measuredDate),
              if (m.odometerKm != null) StatusText.km(m.odometerKm!),
              if (m.brand != null) 'Brand: ${m.brand}',
              if (m.partNumber != null) 'Ref: ${m.partNumber}',
              if (m.visualCondition != null) 'Condition: ${m.visualCondition}',
              if (m.hasDamage) 'Cracks/Damage reported',
            ].join(' · ')),
            if (m.notes != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(m.notes!,
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            AttachmentGalleryRow(attachments: m.attachments),
          ],
        ),
      ),
    );
  }
}
