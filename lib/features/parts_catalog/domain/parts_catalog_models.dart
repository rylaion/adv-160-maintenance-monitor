import '../../../core/database/app_database.dart';

class PartsCatalogItem {
  const PartsCatalogItem({
    required this.id,
    required this.partNumber,
    required this.officialName,
    this.description,
    required this.category,
    required this.assemblyName,
    this.diagramNumber,
    this.referenceNumber,
    this.standardQuantity = 1,
    this.supersededPartNumber,
    this.remarks,
    this.maintenanceItemId,
    this.imageAssetPath,
    required this.createdAt,
    this.compatibilities = const [],
  });

  final int id;
  final String partNumber;
  final String officialName;
  final String? description;
  final String category;
  final String assemblyName;
  final String? diagramNumber;
  final int? referenceNumber;
  final int standardQuantity;
  final String? supersededPartNumber;
  final String? remarks;
  final int? maintenanceItemId;
  final String? imageAssetPath;
  final DateTime createdAt;
  final List<PartsCatalogCompatibilityDetail> compatibilities;

  factory PartsCatalogItem.fromRow(
    PartsCatalogRow row, [
    List<PartsCatalogCompatibilityRow> compRows = const [],
  ]) {
    return PartsCatalogItem(
      id: row.id,
      partNumber: row.partNumber,
      officialName: row.officialName,
      description: row.description,
      category: row.category,
      assemblyName: row.assemblyName,
      diagramNumber: row.diagramNumber,
      referenceNumber: row.referenceNumber,
      standardQuantity: row.standardQuantity,
      supersededPartNumber: row.supersededPartNumber,
      remarks: row.remarks,
      maintenanceItemId: row.maintenanceItemId,
      imageAssetPath: row.imageAssetPath,
      createdAt: DateTime.tryParse(row.createdAt) ?? DateTime.now(),
      compatibilities:
          compRows.map(PartsCatalogCompatibilityDetail.fromRow).toList(),
    );
  }

  /// Formatted diagram reference (e.g. "Diagram E-17, Item #3")
  String get diagramReferenceLabel {
    if (diagramNumber == null) return 'No diagram assigned';
    if (referenceNumber == null) return 'Diagram $diagramNumber';
    return 'Diagram $diagramNumber, Item #$referenceNumber';
  }
}

class PartsCatalogCompatibilityDetail {
  const PartsCatalogCompatibilityDetail({
    required this.id,
    required this.partsCatalogId,
    required this.modelName,
    required this.modelCode,
    required this.startYear,
    this.endYear,
    required this.regionalVariant,
    this.notes,
  });

  final int id;
  final int partsCatalogId;
  final String modelName;
  final String modelCode;
  final int startYear;
  final int? endYear;
  final String regionalVariant;
  final String? notes;

  factory PartsCatalogCompatibilityDetail.fromRow(
      PartsCatalogCompatibilityRow row) {
    return PartsCatalogCompatibilityDetail(
      id: row.id,
      partsCatalogId: row.partsCatalogId,
      modelName: row.modelName,
      modelCode: row.modelCode,
      startYear: row.startYear,
      endYear: row.endYear,
      regionalVariant: row.regionalVariant,
      notes: row.notes,
    );
  }

  String get yearRangeLabel {
    if (endYear == null) return '$startYear–Present';
    if (startYear == endYear) return '$startYear';
    return '$startYear–$endYear';
  }
}

class PartsCatalogDiagramInfo {
  const PartsCatalogDiagramInfo({
    required this.id,
    required this.diagramCode,
    required this.title,
    required this.assemblyName,
    this.description,
    this.imageAssetPath,
  });

  final int id;
  final String diagramCode;
  final String title;
  final String assemblyName;
  final String? description;
  final String? imageAssetPath;

  factory PartsCatalogDiagramInfo.fromRow(PartsCatalogImageRow row) {
    return PartsCatalogDiagramInfo(
      id: row.id,
      diagramCode: row.diagramCode,
      title: row.title,
      assemblyName: row.assemblyName,
      description: row.description,
      imageAssetPath: row.imageAssetPath,
    );
  }
}
