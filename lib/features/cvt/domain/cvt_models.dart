import 'dart:convert';
import '../../../core/database/app_database.dart';

class CvtConfigurationDetail {
  const CvtConfigurationDetail({
    required this.id,
    required this.motorcycleId,
    required this.name,
    this.pulleyBrandModel,
    this.flyballWeightGrams,
    this.flyballArrangement,
    this.centerSpringRpm,
    this.clutchSpringRpm,
    this.beltBrandPartNumber,
    this.pulleyWasherThicknessMm,
    this.clutchBellSpec,
    this.exhaustSpec,
    this.otherMods,
    required this.installedDate,
    this.installedOdometerKm,
    required this.isActive,
    required this.isArchived,
    this.notes,
    this.photoPaths = const [],
    required this.createdAt,
    required this.updatedAt,
    this.performanceLogs = const [],
  });

  final int id;
  final int motorcycleId;
  final String name;
  final String? pulleyBrandModel;
  final double? flyballWeightGrams;
  final String? flyballArrangement;
  final int? centerSpringRpm;
  final int? clutchSpringRpm;
  final String? beltBrandPartNumber;
  final double? pulleyWasherThicknessMm;
  final String? clutchBellSpec;
  final String? exhaustSpec;
  final String? otherMods;
  final DateTime installedDate;
  final int? installedOdometerKm;
  final bool isActive;
  final bool isArchived;
  final String? notes;
  final List<String> photoPaths;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CvtPerformanceLogDetail> performanceLogs;

  factory CvtConfigurationDetail.fromRow(
    CvtConfiguration row, [
    List<CvtPerformanceLog> logs = const [],
  ]) {
    List<String> photos = [];
    if (row.photoPaths != null && row.photoPaths!.isNotEmpty) {
      try {
        final decoded = jsonDecode(row.photoPaths!);
        if (decoded is List) {
          photos = decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {}
    }

    return CvtConfigurationDetail(
      id: row.id,
      motorcycleId: row.motorcycleId,
      name: row.name,
      pulleyBrandModel: row.pulleyBrandModel,
      flyballWeightGrams: row.flyballWeightGrams,
      flyballArrangement: row.flyballArrangement,
      centerSpringRpm: row.centerSpringRpm,
      clutchSpringRpm: row.clutchSpringRpm,
      beltBrandPartNumber: row.beltBrandPartNumber,
      pulleyWasherThicknessMm: row.pulleyWasherThicknessMm,
      clutchBellSpec: row.clutchBellSpec,
      exhaustSpec: row.exhaustSpec,
      otherMods: row.otherMods,
      installedDate: row.installedDate,
      installedOdometerKm: row.installedOdometerKm,
      isActive: row.isActive,
      isArchived: row.isArchived,
      notes: row.notes,
      photoPaths: photos,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      performanceLogs: logs.map(CvtPerformanceLogDetail.fromRow).toList(),
    );
  }
}

class CvtPerformanceLogDetail {
  const CvtPerformanceLogDetail({
    required this.id,
    required this.configurationId,
    required this.logDate,
    this.odometerKm,
    this.accelerationRating,
    this.topSpeedKmh,
    this.rpmObserved,
    this.fuelConsumptionKpl,
    this.vibrationRating,
    this.comfortRating,
    this.overallAssessment,
    this.notes,
    required this.isMeasured,
    required this.createdAt,
  });

  final int id;
  final int configurationId;
  final DateTime logDate;
  final int? odometerKm;
  final int? accelerationRating;
  final double? topSpeedKmh;
  final int? rpmObserved;
  final double? fuelConsumptionKpl;
  final int? vibrationRating;
  final int? comfortRating;
  final String? overallAssessment;
  final String? notes;
  final bool isMeasured;
  final DateTime createdAt;

  factory CvtPerformanceLogDetail.fromRow(CvtPerformanceLog row) {
    return CvtPerformanceLogDetail(
      id: row.id,
      configurationId: row.configurationId,
      logDate: row.logDate,
      odometerKm: row.odometerKm,
      accelerationRating: row.accelerationRating,
      topSpeedKmh: row.topSpeedKmh,
      rpmObserved: row.rpmObserved,
      fuelConsumptionKpl: row.fuelConsumptionKpl,
      vibrationRating: row.vibrationRating,
      comfortRating: row.comfortRating,
      overallAssessment: row.overallAssessment,
      notes: row.notes,
      isMeasured: row.isMeasured,
      createdAt: row.createdAt,
    );
  }
}

class NewCvtConfigurationInput {
  const NewCvtConfigurationInput({
    required this.motorcycleId,
    required this.name,
    this.pulleyBrandModel,
    this.flyballWeightGrams,
    this.flyballArrangement,
    this.centerSpringRpm,
    this.clutchSpringRpm,
    this.beltBrandPartNumber,
    this.pulleyWasherThicknessMm,
    this.clutchBellSpec,
    this.exhaustSpec,
    this.otherMods,
    required this.installedDate,
    this.installedOdometerKm,
    this.isActive = false,
    this.notes,
    this.photoPaths = const [],
  });

  final int motorcycleId;
  final String name;
  final String? pulleyBrandModel;
  final double? flyballWeightGrams;
  final String? flyballArrangement;
  final int? centerSpringRpm;
  final int? clutchSpringRpm;
  final String? beltBrandPartNumber;
  final double? pulleyWasherThicknessMm;
  final String? clutchBellSpec;
  final String? exhaustSpec;
  final String? otherMods;
  final DateTime installedDate;
  final int? installedOdometerKm;
  final bool isActive;
  final String? notes;
  final List<String> photoPaths;
}

class NewCvtPerformanceLogInput {
  const NewCvtPerformanceLogInput({
    required this.configurationId,
    required this.logDate,
    this.odometerKm,
    this.accelerationRating,
    this.topSpeedKmh,
    this.rpmObserved,
    this.fuelConsumptionKpl,
    this.vibrationRating,
    this.comfortRating,
    this.overallAssessment,
    this.notes,
    this.isMeasured = false,
  });

  final int configurationId;
  final DateTime logDate;
  final int? odometerKm;
  final int? accelerationRating;
  final double? topSpeedKmh;
  final int? rpmObserved;
  final double? fuelConsumptionKpl;
  final int? vibrationRating;
  final int? comfortRating;
  final String? overallAssessment;
  final String? notes;
  final bool isMeasured;
}
