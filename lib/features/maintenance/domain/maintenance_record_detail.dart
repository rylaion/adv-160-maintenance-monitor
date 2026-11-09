import '../../../core/enums/enums.dart';
import '../../parts/domain/part_models.dart';

/// Photo attachment linked to a record or measurement.
class AttachmentInfo {
  const AttachmentInfo({
    required this.id,
    required this.filePath,
    this.mimeType,
    this.caption,
  });

  final int id;
  final String filePath;
  final String? mimeType;
  final String? caption;
}

/// One part line used in a service record.
class RecordPartDetail {
  const RecordPartDetail({
    required this.id,
    required this.part,
    required this.quantity,
    required this.unitCostCentavos,
  });

  final int id;
  final PartInfo part;
  final int quantity;
  final int unitCostCentavos;

  int get lineTotalCentavos => quantity * unitCostCentavos;
}

/// Full maintenance record for the history list and edit screen.
class MaintenanceRecordDetail {
  const MaintenanceRecordDetail({
    required this.id,
    required this.motorcycleId,
    required this.itemId,
    required this.itemName,
    required this.categoryId,
    required this.categoryName,
    required this.action,
    required this.performedDate,
    required this.odometerKm,
    required this.laborCostCentavos,
    required this.totalCostCentavos,
    this.serviceProvider,
    this.notes,
    this.supersedesRecordId,
    this.parts = const [],
    this.attachments = const [],
  });

  final int id;
  final int motorcycleId;
  final int itemId;
  final String itemName;
  final int categoryId;
  final String categoryName;
  final MaintenanceAction action;
  final DateTime performedDate;
  final int odometerKm;
  final int laborCostCentavos;
  final int totalCostCentavos;
  final String? serviceProvider;
  final String? notes;
  final int? supersedesRecordId;
  final List<RecordPartDetail> parts;
  final List<AttachmentInfo> attachments;

  int get partsCostCentavos =>
      parts.fold<int>(0, (sum, p) => sum + p.lineTotalCentavos);
}

/// Filter options for maintenance history.
class MaintenanceHistoryFilter {
  const MaintenanceHistoryFilter({
    this.categoryId,
    this.itemId,
    this.fromDate,
    this.toDate,
  });

  final int? categoryId;
  final int? itemId;
  final DateTime? fromDate;
  final DateTime? toDate;

  bool matches(MaintenanceRecordDetail r) {
    if (categoryId != null && r.categoryId != categoryId) return false;
    if (itemId != null && r.itemId != itemId) return false;
    if (fromDate != null && r.performedDate.isBefore(fromDate!)) return false;
    if (toDate != null && r.performedDate.isAfter(toDate!)) return false;
    return true;
  }
}
