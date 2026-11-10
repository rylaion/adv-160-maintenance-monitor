import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/date_utils.dart';
import '../../../core/utils/money.dart';
import '../../../shared/providers/providers.dart';
import '../../maintenance/presentation/maintenance_view_model.dart';
import '../../maintenance/presentation/status_text.dart';
import '../domain/part_models.dart';
import 'parts_view_model.dart';

/// Parts Management screen (Module G): inventory, purchase details, and full
/// installation/removal lifecycle tracking.
class PartsScreen extends ConsumerStatefulWidget {
  const PartsScreen({super.key});

  @override
  ConsumerState<PartsScreen> createState() => _PartsScreenState();
}

class _PartsScreenState extends ConsumerState<PartsScreen> {
  Future<void> _showAddPartDialog() async {
    final overview = ref.read(maintenanceOverviewProvider).valueOrNull;
    final items = overview?.snapshot.items ?? const [];
    final today = AppDates.todayManila(ref.read(clockProvider)());

    final nameCtl = TextEditingController();
    final brandCtl = TextEditingController();
    final partNoCtl = TextEditingController();
    final specCtl = TextEditingController();
    final priceCtl = TextEditingController(text: '0');
    final supplierCtl = TextEditingController();
    final qtyCtl = TextEditingController(text: '1');
    final installKmCtl =
        TextEditingController(text: '${overview?.currentKm ?? 0}');
    final installNotesCtl = TextEditingController();

    int? itemId;
    DateTime? purchaseDate = today;
    var installNow = false;
    DateTime installDate = today;
    String? position;
    final key = GlobalKey<FormState>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Add Part'),
          content: SingleChildScrollView(
            child: Form(
              key: key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                    controller: nameCtl,
                    decoration: const InputDecoration(labelText: 'Part name'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Part name is required'
                        : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: brandCtl,
                    decoration: const InputDecoration(labelText: 'Brand'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: partNoCtl,
                    decoration: const InputDecoration(labelText: 'Part number'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: specCtl,
                    decoration:
                        const InputDecoration(labelText: 'Specification'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: priceCtl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                              labelText: 'Purchase price (₱)'),
                          validator: (v) => Money.tryParsePesos(v) == null
                              ? 'Invalid price'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: qtyCtl,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Quantity'),
                          validator: (v) {
                            final q = int.tryParse((v ?? '').trim());
                            return (q == null || q < 1) ? 'Min 1' : null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: supplierCtl,
                    decoration: const InputDecoration(labelText: 'Supplier'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Purchase date'),
                    subtitle: Text(purchaseDate == null
                        ? 'Not set'
                        : AppDates.formatDate(purchaseDate!)),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: () async {
                      final d = await showDatePicker(
                        context: ctx,
                        initialDate: purchaseDate ?? today,
                        firstDate: DateTime(2000),
                        lastDate: today,
                      );
                      if (d != null) setState(() => purchaseDate = d);
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Install on motorcycle now'),
                    value: installNow,
                    onChanged: (v) => setState(() => installNow = v),
                  ),
                  if (installNow) ...[
                    TextFormField(
                      controller: installKmCtl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Installation odometer (km)'),
                      validator: (v) {
                        final km = int.tryParse((v ?? '').trim());
                        return (km == null || km < 0) ? 'Invalid' : null;
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String?>(
                      value: position,
                      decoration: const InputDecoration(
                          labelText: 'Position (optional)'),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('N/A')),
                        DropdownMenuItem(value: 'FRONT', child: Text('Front')),
                        DropdownMenuItem(value: 'REAR', child: Text('Rear')),
                      ],
                      onChanged: (v) => setState(() => position = v),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Installation date'),
                      subtitle: Text(AppDates.formatDate(installDate)),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final d = await showDatePicker(
                          context: ctx,
                          initialDate: installDate,
                          firstDate: DateTime(2000),
                          lastDate: today,
                        );
                        if (d != null) setState(() => installDate = d);
                      },
                    ),
                    TextFormField(
                      controller: installNotesCtl,
                      decoration: const InputDecoration(
                          labelText: 'Installation notes'),
                    ),
                  ],
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
                child: const Text('Save Part')),
          ],
        ),
      ),
    );
    if (confirmed != true) return;
    final err = await ref.read(partsActionsProvider.notifier).addPart(
          part: NewPart(
            itemId: itemId,
            name: nameCtl.text,
            brand: brandCtl.text,
            partNumber: partNoCtl.text,
            specification: specCtl.text,
            purchasePriceCentavos: Money.tryParsePesos(priceCtl.text) ?? 0,
            purchaseDate: purchaseDate,
            supplier: supplierCtl.text,
            quantity: int.parse(qtyCtl.text.trim()),
          ),
          installDate: installNow ? installDate : null,
          installOdometerKm:
              installNow ? int.parse(installKmCtl.text.trim()) : null,
          position: position,
          installNotes: installNotesCtl.text,
        );
    if (mounted && err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  Future<void> _showRemoveDialog(InstallationInfo inst) async {
    final overview = ref.read(maintenanceOverviewProvider).valueOrNull;
    final today = AppDates.todayManila(ref.read(clockProvider)());
    final kmCtl = TextEditingController(
        text: '${overview?.currentKm ?? inst.installedKm}');
    var date = today;
    final key = GlobalKey<FormState>();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text('Remove ${inst.part.name}?'),
          content: Form(
            key: key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: kmCtl,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Removal odometer (km)'),
                  validator: (v) {
                    final n = int.tryParse((v ?? '').trim());
                    return (n == null || n < 0) ? 'Invalid' : null;
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Removal date'),
                  subtitle: Text(AppDates.formatDate(date)),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: date,
                      firstDate: inst.installedDate,
                      lastDate: today,
                    );
                    if (d != null) setState(() => date = d);
                  },
                ),
              ],
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
                child: const Text('Confirm Removal')),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final err = await ref.read(partsActionsProvider.notifier).remove(
          installationId: inst.id,
          date: date,
          odometerKm: int.parse(kmCtl.text.trim()),
        );
    if (mounted && err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  Future<void> _showInstallPartDialog(PartInfo part) async {
    final overview = ref.read(maintenanceOverviewProvider).valueOrNull;
    final today = AppDates.todayManila(ref.read(clockProvider)());
    final kmCtl = TextEditingController(text: '${overview?.currentKm ?? 0}');
    final notesCtl = TextEditingController();
    var date = today;
    String? position;
    final key = GlobalKey<FormState>();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text('Install ${part.name}'),
          content: Form(
            key: key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: kmCtl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Installation odometer (km)'),
                  validator: (v) {
                    final n = int.tryParse((v ?? '').trim());
                    return (n == null || n < 0) ? 'Invalid' : null;
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  value: position,
                  decoration:
                      const InputDecoration(labelText: 'Position (optional)'),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('N/A')),
                    DropdownMenuItem(value: 'FRONT', child: Text('Front')),
                    DropdownMenuItem(value: 'REAR', child: Text('Rear')),
                  ],
                  onChanged: (v) => setState(() => position = v),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Installation date'),
                  subtitle: Text(AppDates.formatDate(date)),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: date,
                      firstDate: DateTime(2000),
                      lastDate: today,
                    );
                    if (d != null) setState(() => date = d);
                  },
                ),
                TextFormField(
                  controller: notesCtl,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
              ],
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
                child: const Text('Install')),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final err = await ref.read(partsActionsProvider.notifier).install(
          partId: part.id,
          date: date,
          odometerKm: int.parse(kmCtl.text.trim()),
          position: position,
          notes: notesCtl.text,
        );
    if (mounted && err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final partsAsync = ref.watch(partsListProvider);
    final instAsync = ref.watch(installationsProvider(null));
    final currentKm =
        ref.watch(maintenanceOverviewProvider).valueOrNull?.currentKm;
    final today = AppDates.todayManila(ref.read(clockProvider)());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Parts Management'),
          actions: [
            TextButton.icon(
              onPressed: () => context.push('/parts'),
              icon: const Icon(Icons.auto_stories_outlined, size: 18),
              label: const Text('OEM Catalogue'),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Installed Lifecycle'),
              Tab(text: 'Parts Catalog'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddPartDialog,
          icon: const Icon(Icons.add),
          label: const Text('Add Part'),
        ),
        body: TabBarView(
          children: [
            instAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (list) => list.isEmpty
                  ? const Center(child: Text('No installed parts recorded'))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        final inst = list[i];
                        final dist = inst.distanceKm(currentKm);
                        final days = inst.daysInService(today);
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            title: Text(
                              '${inst.part.name}'
                              '${inst.position == null ? '' : ' (${inst.position})'}'
                              ' · ${inst.isInstalled ? 'Installed' : 'Removed'}',
                            ),
                            subtitle: Text([
                              if (inst.itemName != null) inst.itemName!,
                              if (inst.part.brand != null)
                                'Brand: ${inst.part.brand}',
                              if (inst.part.partNumber != null)
                                'P/N: ${inst.part.partNumber}',
                              'Installed ${AppDates.formatDate(inst.installedDate)} @ ${StatusText.km(inst.installedKm)}',
                              if (inst.removedDate != null &&
                                  inst.removedKm != null)
                                'Replaced/Removed ${AppDates.formatDate(inst.removedDate!)} @ ${StatusText.km(inst.removedKm!)}',
                              if (dist != null)
                                'Lifecycle: ${StatusText.km(dist)} ($days days)',
                            ].join('\n')),
                            isThreeLine: true,
                            trailing: inst.isInstalled
                                ? IconButton(
                                    tooltip: 'Mark removed',
                                    icon:
                                        const Icon(Icons.remove_circle_outline),
                                    onPressed: () => _showRemoveDialog(inst),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
            ),
            partsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (parts) => parts.isEmpty
                  ? const Center(child: Text('No parts recorded'))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
                      itemCount: parts.length,
                      itemBuilder: (_, i) {
                        final p = parts[i];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            title: Text(
                              '${p.name} × ${p.quantity} · '
                              '${StatusText.pesos(p.purchasePriceCentavos)}',
                            ),
                            subtitle: Text([
                              if (p.brand != null) 'Brand: ${p.brand}',
                              if (p.partNumber != null) 'P/N: ${p.partNumber}',
                              if (p.specification != null)
                                'Spec: ${p.specification}',
                              if (p.supplier != null) 'Supplier: ${p.supplier}',
                              if (p.purchaseDate != null)
                                'Purchased: ${AppDates.formatDate(p.purchaseDate!)}',
                            ].join(' · ')),
                            trailing: IconButton(
                              tooltip: 'Install part',
                              icon: const Icon(Icons.build_circle_outlined),
                              onPressed: () => _showInstallPartDialog(p),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
