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
  voltageV('VOLTAGE_V', 'V', 'Voltage'),
  pressureKpa('PRESSURE_KPA', 'kPa', 'Tire pressure'),
  treadDepthMm('TREAD_DEPTH_MM', 'mm', 'Tread depth'),
  conditionObservation('CONDITION_OBSERVATION', '', 'Condition observation');

  const MeasurementType(this.code, this.unit, this.label);
  final String code;
  final String unit;
  final String label;

  static MeasurementType fromCode(String code) =>
      values.firstWhere((e) => e.code == code,
          orElse: () => MeasurementType.conditionObservation);
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
  final String? position;
  final String? measurementContext;
  final String? brand;
  final String? partNumber;
  final String? visualCondition;
  final bool hasDamage;
  final String? notes;
  final List<String> photoPaths;
}
