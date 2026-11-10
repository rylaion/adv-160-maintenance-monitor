import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/cvt_models.dart';
import 'cvt_view_model.dart';

class CvtCompareScreen extends ConsumerStatefulWidget {
  const CvtCompareScreen({
    super.key,
    this.configurations,
    this.initialA,
    this.initialB,
  });

  final List<CvtConfigurationDetail>? configurations;
  final CvtConfigurationDetail? initialA;
  final CvtConfigurationDetail? initialB;

  @override
  ConsumerState<CvtCompareScreen> createState() => _CvtCompareScreenState();
}

class _CvtCompareScreenState extends ConsumerState<CvtCompareScreen> {
  CvtConfigurationDetail? _configA;
  CvtConfigurationDetail? _configB;

  @override
  void initState() {
    super.initState();
    final configs = widget.configurations;
    if (configs != null && configs.isNotEmpty) {
      _configA = widget.initialA ?? configs.first;
      if (configs.length > 1) {
        _configB = widget.initialB ?? configs[1];
      } else {
        _configB = widget.initialB;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allConfigs = widget.configurations ??
        ref.watch(cvtConfigurationsProvider).valueOrNull ??
        [];

    if (allConfigs.isNotEmpty && (_configA == null || _configB == null)) {
      _configA ??= widget.initialA ?? allConfigs.first;
      if (allConfigs.length > 1) {
        _configB ??= widget.initialB ?? allConfigs[1];
      }
    }

    if (allConfigs.length < 2) {
      return Scaffold(
        appBar: AppBar(title: const Text('Compare CVT Configurations')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'You need at least 2 saved CVT configurations to perform a side-by-side comparison.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare CVT Configurations'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _configA?.id,
                  decoration: const InputDecoration(
                    labelText: 'Setup A',
                    border: OutlineInputBorder(),
                  ),
                  items: allConfigs
                      .map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.name, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (id) {
                    if (id != null) {
                      setState(() {
                        _configA = allConfigs.firstWhere((c) => c.id == id);
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _configB?.id,
                  decoration: const InputDecoration(
                    labelText: 'Setup B',
                    border: OutlineInputBorder(),
                  ),
                  items: allConfigs
                      .map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.name, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (id) {
                    if (id != null) {
                      setState(() {
                        _configB = allConfigs.firstWhere((c) => c.id == id);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Specification Differences',
                      style: theme.textTheme.titleMedium),
                  const Divider(height: 20),
                  _CompareRow(
                    label: 'Status',
                    valA: _configA?.isActive == true ? 'Active' : 'Saved',
                    valB: _configB?.isActive == true ? 'Active' : 'Saved',
                  ),
                  _CompareRow(
                    label: 'Pulley Brand / Model',
                    valA: _configA?.pulleyBrandModel ?? 'Stock',
                    valB: _configB?.pulleyBrandModel ?? 'Stock',
                  ),
                  _CompareRow(
                    label: 'Flyball Weight',
                    valA: _configA?.flyballWeightGrams != null
                        ? '${_configA!.flyballWeightGrams}g'
                        : 'Stock (20g)',
                    valB: _configB?.flyballWeightGrams != null
                        ? '${_configB!.flyballWeightGrams}g'
                        : 'Stock (20g)',
                  ),
                  _CompareRow(
                    label: 'Flyball Arrangement',
                    valA: _configA?.flyballArrangement ?? 'Straight',
                    valB: _configB?.flyballArrangement ?? 'Straight',
                  ),
                  _CompareRow(
                    label: 'Center Spring',
                    valA: _configA?.centerSpringRpm != null
                        ? '${_configA!.centerSpringRpm} RPM'
                        : 'Stock (1000 RPM)',
                    valB: _configB?.centerSpringRpm != null
                        ? '${_configB!.centerSpringRpm} RPM'
                        : 'Stock (1000 RPM)',
                  ),
                  _CompareRow(
                    label: 'Clutch Springs',
                    valA: _configA?.clutchSpringRpm != null
                        ? '${_configA!.clutchSpringRpm} RPM'
                        : 'Stock',
                    valB: _configB?.clutchSpringRpm != null
                        ? '${_configB!.clutchSpringRpm} RPM'
                        : 'Stock',
                  ),
                  _CompareRow(
                    label: 'Drive Belt',
                    valA: _configA?.beltBrandPartNumber ??
                        'Honda OEM 23100-K0W-N01',
                    valB: _configB?.beltBrandPartNumber ??
                        'Honda OEM 23100-K0W-N01',
                  ),
                  _CompareRow(
                    label: 'Washer Thickness',
                    valA: _configA?.pulleyWasherThicknessMm != null
                        ? '${_configA!.pulleyWasherThicknessMm} mm'
                        : 'None',
                    valB: _configB?.pulleyWasherThicknessMm != null
                        ? '${_configB!.pulleyWasherThicknessMm} mm'
                        : 'None',
                  ),
                  _CompareRow(
                    label: 'Clutch / Bell',
                    valA: _configA?.clutchBellSpec ?? 'Stock',
                    valB: _configB?.clutchBellSpec ?? 'Stock',
                  ),
                  _CompareRow(
                    label: 'Exhaust',
                    valA: _configA?.exhaustSpec ?? 'Stock',
                    valB: _configB?.exhaustSpec ?? 'Stock',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: theme.colorScheme.surfaceContainerHighest,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Note: Performance varies depending on rider weight, road conditions, and tire pressure. Observations reflect user records.',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompareRow extends StatelessWidget {
  const _CompareRow({
    required this.label,
    required this.valA,
    required this.valB,
  });

  final String label;
  final String valA;
  final String valB;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDiff = valA != valB;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: theme.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  valA,
                  style: TextStyle(
                    color: isDiff ? theme.colorScheme.primary : null,
                    fontWeight: isDiff ? FontWeight.w600 : null,
                  ),
                ),
              ),
              const Text(' vs '),
              Expanded(
                child: Text(
                  valB,
                  style: TextStyle(
                    color: isDiff ? theme.colorScheme.primary : null,
                    fontWeight: isDiff ? FontWeight.w600 : null,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 12),
        ],
      ),
    );
  }
}
