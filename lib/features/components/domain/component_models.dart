import '../../../core/exceptions/user_facing_exception.dart';
import '../../maintenance/domain/maintenance_record_detail.dart';

class ComponentException implements UserFacingException {
  const ComponentException(this.message);
  @override
  final String message;
  @override
  String toString() => message;
}

/// Kind of component measurement stored in `component_measurements`.
enum MeasurementType {
  thicknessMm('THICKNESS_MM', 'mm', 'Thickness'),
  discThicknessMm('DISC_THICKNESS_MM', 'mm', 'Brake disc thickness'),
  voltageV('VOLTAGE_V', 'V', 'Voltage'),
  pressureKpa('PRESSURE_KPA', 'kPa', 'Tire pressure'),
  treadDepthMm('TREAD_DEPTH_MM', 'mm', 'Tread depth'),
  freeplayMm('FREEPLAY_MM', 'mm', 'Freeplay'),
  clearanceMm('CLEARANCE_MM', 'mm', 'Clearance'),
  generalMeasurement('GENERAL_MEASUREMENT', 'mm', 'Measurement'),
  conditionObservation('CONDITION_OBSERVATION', '', 'Condition observation');

  const MeasurementType(this.code, this.unit, this.label);
  final String code;
  final String unit;
  final String label;

  static MeasurementType fromCode(String code) =>
      values.firstWhere((e) => e.code == code,
          orElse: () => MeasurementType.conditionObservation);
}

/// Status of a component measurement when compared against a verified or
/// user-defined wear limit.
enum ComponentSpecStatus {
  good('GOOD', 'Good'),
  monitor('MONITOR', 'Monitor'),
  replace('REPLACE', 'Replace'),
  notRecorded('NOT_RECORDED', 'Not recorded');

  const ComponentSpecStatus(this.code, this.label);
  final String code;
  final String label;
}

/// Wheel/brake position where applicable.
enum ComponentPosition {
  front('FRONT', 'Front'),
  rear('REAR', 'Rear');

  const ComponentPosition(this.code, this.label);
  final String code;
  final String label;

  static ComponentPosition? tryFromCode(String? code) {
    if (code == null) return null;
    for (final v in values) {
      if (v.code == code) return v;
    }
    return null;
  }
}

/// Battery measurement context.
enum BatteryMeasurementContext {
  engineOff('ENGINE_OFF', 'Engine off'),
  engineRunning('ENGINE_RUNNING', 'Engine running'),
  charging('CHARGING', 'Charging');

  const BatteryMeasurementContext(this.code, this.label);
  final String code;
  final String label;

  static BatteryMeasurementContext? tryFromCode(String? code) {
    if (code == null) return null;
    for (final v in values) {
      if (v.code == code) return v;
    }
    return null;
  }
}

/// Historical measurement or condition entry for a component.
///
/// IMPORTANT: Never automatically declares a component safe based on mileage or
/// measurement alone. Verified specification limits are only shown if verified
/// in the database; otherwise the UI states that no verified limit is configured.
class ComponentMeasurement {
  const ComponentMeasurement({
    required this.id,
    required this.motorcycleId,
    required this.itemId,
    required this.measuredDate,
    required this.measurementType,
    required this.unit,
    this.recordId,
    this.odometerKm,
    this.value,
    this.position,
    this.measurementContext,
    this.brand,
    this.partNumber,
    this.visualCondition,
    this.hasDamage = false,
    this.notes,
    this.attachments = const [],
  });

  final int id;
  final int motorcycleId;
  final int itemId;
  final int? recordId;
  final DateTime measuredDate;
  final int? odometerKm;
  final MeasurementType measurementType;
  final double? value;
  final String unit;
  final String? position;
  final String? measurementContext;
  final String? brand;
  final String? partNumber;
  final String? visualCondition;
  final bool hasDamage;
  final String? notes;
  final List<AttachmentInfo> attachments;
}

/// Input for recording one component measurement / inspection.
class NewComponentMeasurement {
  const NewComponentMeasurement({
    required this.motorcycleId,
    required this.itemId,
    required this.measuredDate,
    required this.measurementType,
    this.recordId,
    this.odometerKm,
    this.value,
    this.unitOverride,
    this.position,
    this.measurementContext,
    this.brand,
    this.partNumber,
    this.visualCondition,
    this.hasDamage = false,
    this.notes,
    this.photoPaths = const [],
  });

  final int motorcycleId;
  final int itemId;
  final int? recordId;
  final DateTime measuredDate;
  final int? odometerKm;
  final MeasurementType measurementType;
  final double? value;
  final String? unitOverride;
  final String? position;
  final String? measurementContext;
  final String? brand;
  final String? partNumber;
  final String? visualCondition;
  final bool hasDamage;
  final String? notes;
  final List<String> photoPaths;

  String get effectiveUnit =>
      (unitOverride != null && unitOverride!.trim().isNotEmpty)
          ? unitOverride!.trim()
          : (measurementType.unit.isEmpty ? 'mm' : measurementType.unit);
}

/// User-defined custom measurement limit stored in `component_specs`.
class UserComponentSpec {
  const UserComponentSpec({
    required this.specKey,
    required this.itemId,
    this.customStandardValue,
    this.customServiceLimit,
    this.unit = 'mm',
  });

  final String specKey;
  final int itemId;
  final double? customStandardValue;
  final double? customServiceLimit;
  final String unit;
}

/// Official / user-definable specification descriptor for a measurable
/// motorcycle component.
///
/// Strictly adheres to 2023 Honda ADV160 documentation (`32K0WA100`):
/// - Never invents or estimates Honda specifications.
/// - Marks unverified specifications as "Not available in verified manual."
/// - Clearly distinguishes Honda-specified values from User-defined values.
class ComponentSpecDefinition {
  const ComponentSpecDefinition({
    required this.specKey,
    required this.componentName,
    required this.itemNames,
    required this.measurementType,
    required this.sourceNote,
    this.position,
    this.unit = 'mm',
    this.hondaStandard,
    this.hondaStandardMin,
    this.hondaStandardMax,
    this.hondaServiceLimit,
    this.isHondaVerified = false,
    this.sourceDocument,
  });

  final String specKey;
  final String componentName;
  final List<String> itemNames;
  final MeasurementType measurementType;
  final String? position;
  final String unit;

  /// Single Honda-verified standard measurement, if published in verified manual.
  final double? hondaStandard;

  /// Honda-verified standard range (e.g. Throttle freeplay 2.0–6.0 mm).
  final double? hondaStandardMin;
  final double? hondaStandardMax;

  /// Honda-verified minimum service / replacement limit, if published.
  final double? hondaServiceLimit;

  final bool isHondaVerified;
  final String? sourceDocument;
  final String sourceNote;

  bool matchesItemName(String name) => itemNames.contains(name);

  static const String notAvailableText = 'Not available in verified manual';

  /// Catalog of investigated 2023 Honda ADV160 measurable component specs.
  static const List<ComponentSpecDefinition> catalog = [
    ComponentSpecDefinition(
      specKey: 'drive_belt_width',
      componentName: 'Drive Belt (Width / Thickness)',
      itemNames: ['Drive Belt', 'CVT Drive Belt'],
      measurementType: MeasurementType.thicknessMm,
      unit: 'mm',
      isHondaVerified: false,
      sourceNote:
          'Not available in verified manual (Owner\'s Manual 32K0WA100 p. 89 '
          'specifies Inspection at 12,000 km & 36,000 km and Replacement every '
          '24,000 km; numeric belt width limit requires Honda Service Manual '
          'or a user-defined limit).',
    ),
    ComponentSpecDefinition(
      specKey: 'front_brake_pad',
      componentName: 'Front Brake Pad Lining',
      itemNames: ['Brake Pads Wear', 'Brake Pads'],
      measurementType: MeasurementType.thicknessMm,
      position: 'FRONT',
      unit: 'mm',
      isHondaVerified: false,
      sourceNote:
          'Not available in verified manual (Owner\'s Manual 32K0WA100 p. 108 '
          'specifies replacing pads when worn to the visual wear indicator '
          'groove; numeric mm limit can be set as a user-defined limit).',
    ),
    ComponentSpecDefinition(
      specKey: 'rear_brake_pad',
      componentName: 'Rear Brake Pad Lining',
      itemNames: ['Brake Pads Wear', 'Brake Pads'],
      measurementType: MeasurementType.thicknessMm,
      position: 'REAR',
      unit: 'mm',
      isHondaVerified: false,
      sourceNote:
          'Not available in verified manual (Owner\'s Manual 32K0WA100 p. 108 '
          'specifies replacing pads when worn to the visual wear indicator '
          'groove; numeric mm limit can be set as a user-defined limit).',
    ),
    ComponentSpecDefinition(
      specKey: 'front_brake_disc',
      componentName: 'Front Brake Disc Thickness',
      itemNames: ['Brake System', 'Brake Pads Wear', 'Brake Pads'],
      measurementType: MeasurementType.discThicknessMm,
      position: 'FRONT',
      unit: 'mm',
      isHondaVerified: false,
      sourceNote: 'Not available in verified manual (Owner\'s Manual 32K0WA100 '
          'pp. 107–108 does not list numeric rotor thickness; check MIN. TH. '
          'stamped on the front disc or enter a user-defined limit).',
    ),
    ComponentSpecDefinition(
      specKey: 'rear_brake_disc',
      componentName: 'Rear Brake Disc Thickness',
      itemNames: ['Brake System', 'Brake Pads Wear', 'Brake Pads'],
      measurementType: MeasurementType.discThicknessMm,
      position: 'REAR',
      unit: 'mm',
      isHondaVerified: false,
      sourceNote: 'Not available in verified manual (Owner\'s Manual 32K0WA100 '
          'pp. 107–108 does not list numeric rotor thickness; check MIN. TH. '
          'stamped on the rear disc or enter a user-defined limit).',
    ),
    ComponentSpecDefinition(
      specKey: 'front_tire_tread',
      componentName: 'Front Tire Tread Depth',
      itemNames: ['Wheels/Tyres', 'Tire'],
      measurementType: MeasurementType.treadDepthMm,
      position: 'FRONT',
      unit: 'mm',
      hondaServiceLimit: 1.5,
      isHondaVerified: true,
      sourceDocument:
          'Honda ADV160 2023 Owner\'s Manual (32K0WA100), pp. 96 & 142',
      sourceNote:
          'Honda-specified minimum tread depth: 1.5 mm (0.06 in) for Front '
          'tire (Owner\'s Manual 32K0WA100, pp. 96 & 142).',
    ),
    ComponentSpecDefinition(
      specKey: 'rear_tire_tread',
      componentName: 'Rear Tire Tread Depth',
      itemNames: ['Wheels/Tyres', 'Tire'],
      measurementType: MeasurementType.treadDepthMm,
      position: 'REAR',
      unit: 'mm',
      hondaServiceLimit: 2.0,
      isHondaVerified: true,
      sourceDocument:
          'Honda ADV160 2023 Owner\'s Manual (32K0WA100), pp. 96 & 142',
      sourceNote:
          'Honda-specified minimum tread depth: 2.0 mm (0.08 in) for Rear '
          'tire (Owner\'s Manual 32K0WA100, pp. 96 & 142).',
    ),
    ComponentSpecDefinition(
      specKey: 'throttle_freeplay',
      componentName: 'Throttle Grip Freeplay',
      itemNames: ['Throttle Operation'],
      measurementType: MeasurementType.freeplayMm,
      unit: 'mm',
      hondaStandardMin: 2.0,
      hondaStandardMax: 6.0,
      hondaServiceLimit: 6.0,
      isHondaVerified: true,
      sourceDocument: 'Honda ADV160 2023 Owner\'s Manual (32K0WA100), p. 110',
      sourceNote: 'Honda-specified standard freeplay at throttle grip flange: '
          '2.0 – 6.0 mm (Owner\'s Manual 32K0WA100, p. 110).',
    ),
  ];

  /// Returns the applicable component specifications for a maintenance item.
  /// If the item is not in the primary wear catalog, returns a single
  /// user-definable specification marked "Not available in verified manual."
  static List<ComponentSpecDefinition> specsForItem({
    required int itemId,
    required String itemName,
  }) {
    final matched = catalog.where((c) => c.matchesItemName(itemName)).toList();
    if (matched.isNotEmpty) return matched;
    return [
      ComponentSpecDefinition(
        specKey: 'item_$itemId',
        componentName: itemName,
        itemNames: [itemName],
        measurementType: MeasurementType.generalMeasurement,
        unit: 'mm',
        isHondaVerified: false,
        sourceNote:
            'Not available in verified manual (Owner\'s Manual 32K0WA100 '
            'uses scheduled inspection/service for $itemName; you may enter a '
            'user-defined measurement or limit if applicable).',
      ),
    ];
  }
}

/// Computed evaluation of one component specification against its latest
/// recorded measurement and verified/user-defined limits.
class EvaluatedComponentSpec {
  const EvaluatedComponentSpec({
    required this.definition,
    required this.status,
    required this.standardDisplay,
    required this.serviceLimitDisplay,
    required this.sourceLabel,
    this.userSpec,
    this.latestMeasurement,
    this.effectiveStandard,
    this.effectiveServiceLimit,
    this.isHondaLimit = false,
    this.isUserDefinedLimit = false,
  });

  final ComponentSpecDefinition definition;
  final UserComponentSpec? userSpec;
  final ComponentMeasurement? latestMeasurement;
  final ComponentSpecStatus status;
  final String standardDisplay;
  final String serviceLimitDisplay;
  final String sourceLabel;
  final double? effectiveStandard;
  final double? effectiveServiceLimit;
  final bool isHondaLimit;
  final bool isUserDefinedLimit;

  double? get currentActualValue => latestMeasurement?.value;
  String get unit => latestMeasurement?.unit.isNotEmpty == true
      ? latestMeasurement!.unit
      : (userSpec?.unit ?? definition.unit);
  DateTime? get lastInspectionDate => latestMeasurement?.measuredDate;
  int? get lastRecordedOdometer => latestMeasurement?.odometerKm;

  /// Pure evaluation of a [ComponentSpecDefinition].
  ///
  /// Missing specifications are NEVER treated as zero.
  static EvaluatedComponentSpec evaluate({
    required ComponentSpecDefinition definition,
    UserComponentSpec? userSpec,
    required List<ComponentMeasurement> itemMeasurements,
  }) {
    // Find latest numeric measurement matching this spec's type & position.
    ComponentMeasurement? latest;
    for (final m in itemMeasurements) {
      if (m.value == null) continue;
      final typeMatches = m.measurementType == definition.measurementType ||
          (definition.measurementType == MeasurementType.generalMeasurement);
      if (!typeMatches) continue;
      if (definition.position != null) {
        if (m.position != null && m.position != definition.position) {
          continue;
        }
        if (m.position == null && definition.position != 'FRONT') {
          continue;
        }
      }
      latest = m;
      break;
    }

    final customStd = userSpec?.customStandardValue;
    final customLim = userSpec?.customServiceLimit;
    final unit = userSpec?.unit ?? definition.unit;

    final String standardDisplay;
    double? effectiveStandard;
    if (customStd != null) {
      effectiveStandard = customStd;
      standardDisplay = '${customStd.toStringAsFixed(2)} $unit (User-defined)';
    } else if (definition.hondaStandardMin != null &&
        definition.hondaStandardMax != null) {
      standardDisplay = '${definition.hondaStandardMin!.toStringAsFixed(1)} – '
          '${definition.hondaStandardMax!.toStringAsFixed(1)} $unit (Honda-specified)';
    } else if (definition.hondaStandard != null) {
      effectiveStandard = definition.hondaStandard;
      standardDisplay =
          '${definition.hondaStandard!.toStringAsFixed(2)} $unit (Honda-specified)';
    } else {
      standardDisplay = ComponentSpecDefinition.notAvailableText;
    }

    final String serviceLimitDisplay;
    double? effectiveLimit;
    var isHondaLimit = false;
    var isUserDefinedLimit = false;

    if (customLim != null) {
      effectiveLimit = customLim;
      isUserDefinedLimit = true;
      serviceLimitDisplay =
          '${customLim.toStringAsFixed(2)} $unit (User-defined)';
    } else if (definition.hondaStandardMin != null &&
        definition.hondaStandardMax != null) {
      effectiveLimit = definition.hondaServiceLimit;
      isHondaLimit = true;
      serviceLimitDisplay =
          '${definition.hondaStandardMin!.toStringAsFixed(1)} – '
          '${definition.hondaStandardMax!.toStringAsFixed(1)} $unit (Honda-specified)';
    } else if (definition.hondaServiceLimit != null) {
      effectiveLimit = definition.hondaServiceLimit;
      isHondaLimit = true;
      serviceLimitDisplay =
          '${definition.hondaServiceLimit!.toStringAsFixed(2)} $unit (Honda-specified)';
    } else {
      effectiveLimit = null;
      serviceLimitDisplay = ComponentSpecDefinition.notAvailableText;
    }

    final String sourceLabel;
    if (isUserDefinedLimit || customStd != null) {
      sourceLabel = 'User-defined custom specification';
    } else if (definition.isHondaVerified) {
      sourceLabel =
          'Honda-specified (${definition.sourceDocument ?? 'Owner\'s Manual 32K0WA100'})';
    } else {
      sourceLabel = ComponentSpecDefinition.notAvailableText;
    }

    // Status calculation: never treat a missing limit as 0!
    final ComponentSpecStatus status;
    if (latest == null || latest.value == null) {
      status = ComponentSpecStatus.notRecorded;
    } else {
      final actual = latest.value!;
      if (latest.hasDamage) {
        status = ComponentSpecStatus.replace;
      } else if (customLim == null &&
          definition.hondaStandardMin != null &&
          definition.hondaStandardMax != null) {
        final min = definition.hondaStandardMin!;
        final max = definition.hondaStandardMax!;
        if (actual < min || actual > max) {
          status = ComponentSpecStatus.replace;
        } else if (actual <= min + 0.5 || actual >= max - 0.5) {
          status = ComponentSpecStatus.monitor;
        } else {
          status = ComponentSpecStatus.good;
        }
      } else if (effectiveLimit != null) {
        if (actual <= effectiveLimit) {
          status = ComponentSpecStatus.replace;
        } else {
          final margin = (effectiveStandard != null &&
                  effectiveStandard > effectiveLimit)
              ? ((effectiveStandard - effectiveLimit) * 0.25).clamp(0.3, 2.0)
              : 0.5;
          if (actual <= effectiveLimit + margin) {
            status = ComponentSpecStatus.monitor;
          } else {
            status = ComponentSpecStatus.good;
          }
        }
      } else {
        // Measurement recorded, but no verified or user-defined limit exists.
        status = ComponentSpecStatus.monitor;
      }
    }

    return EvaluatedComponentSpec(
      definition: definition,
      userSpec: userSpec,
      latestMeasurement: latest,
      status: status,
      standardDisplay: standardDisplay,
      serviceLimitDisplay: serviceLimitDisplay,
      sourceLabel: sourceLabel,
      effectiveStandard: effectiveStandard,
      effectiveServiceLimit: effectiveLimit,
      isHondaLimit: isHondaLimit,
      isUserDefinedLimit: isUserDefinedLimit,
    );
  }
}
