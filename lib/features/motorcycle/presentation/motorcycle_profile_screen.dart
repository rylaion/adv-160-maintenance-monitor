import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/date_utils.dart';
import '../../../features/maintenance/presentation/maintenance_view_model.dart';
import '../../maintenance/presentation/status_text.dart';
import '../domain/motorcycle.dart';
import 'motorcycle_view_model.dart';

/// Read-only motorcycle profile.
class MotorcycleProfileScreen extends ConsumerWidget {
  const MotorcycleProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(primaryMotorcycleProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motorcycle Profile'),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: async.valueOrNull == null
                ? null
                : () => context.push('/motorcycle/edit'),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load profile: $e')),
        data: (m) => m == null
            ? const Center(child: Text('No motorcycle found'))
            : _ProfileBody(
                m: m,
                currentKm: ref
                    .watch(maintenanceOverviewProvider)
                    .valueOrNull
                    ?.currentKm,
              ),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.m, this.currentKm});
  final Motorcycle m;
  final int? currentKm;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    String v(String? s) => (s == null || s.isEmpty) ? '—' : s;
    final photo = m.photoPath;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: photo != null && File(photo).existsSync()
                ? Image.file(File(photo), fit: BoxFit.cover)
                : ColoredBox(
                    color: scheme.surfaceContainerHighest,
                    child: Icon(Icons.two_wheeler,
                        size: 72, color: scheme.onSurfaceVariant),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(children: [
            _row('Brand', m.brand),
            _row('Model', m.model),
            _row('Model year', '${m.modelYear}'),
            _row('Plate number', v(m.plateNumber)),
            _row('Chassis number', v(m.chassisNumber)),
            _row('Engine number', v(m.engineNumber)),
            _row(
                'Purchase date',
                m.purchaseDate == null
                    ? '—'
                    : AppDates.formatDate(m.purchaseDate!)),
            _row('Current odometer',
                currentKm == null ? 'Not recorded' : StatusText.km(currentKm!)),
          ]),
        ),
      ],
    );
  }

  Widget _row(String label, String value) => ListTile(
        dense: true,
        title: Text(label),
        trailing: Text(value),
      );
}
