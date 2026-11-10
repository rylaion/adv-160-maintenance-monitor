import '../../motorcycle/domain/motorcycle.dart';
import '../../../core/enums/enums.dart';
import 'maintenance_models.dart';

class CategoryInfo {
  const CategoryInfo({required this.id, required this.name});
  final int id;
  final String name;
}

class ItemInfo {
  const ItemInfo({
    required this.id,
    required this.name,
    required this.categoryId,
    this.instructions,
    this.isUserDefined = false,
  });
  final int id;
  final String name;
  final int categoryId;
  final String? instructions;
  final bool isUserDefined;
}

/// A non-voided maintenance record.
class RecordInfo {
  const RecordInfo({
    required this.id,
    required this.itemId,
    required this.action,
    required this.date,
    required this.odometerKm,
    required this.totalCostCentavos,
  });
  final int id;
  final int itemId;
  final MaintenanceAction action;
  final DateTime date;
  final int odometerKm;
  final int totalCostCentavos;

  ServiceEvent toEvent() =>
      ServiceEvent(date: date, odometerKm: odometerKm, action: action);
}

/// Everything the calculator needs, loaded from the database in one pass.
class MaintenanceSnapshot {
  const MaintenanceSnapshot({
    required this.motorcycle,
    required this.categories,
    required this.items,
    required this.rules,
    required this.records,
    this.currentKm,
    this.baselineKm,
    this.firstLogDate,
  });

  final Motorcycle? motorcycle;
  final List<CategoryInfo> categories;
  final List<ItemInfo> items;
  final List<RuleDef> rules;
  final List<RecordInfo> records;

  /// Highest confirmed odometer reading.
  final int? currentKm;

  /// Lowest confirmed reading: where tracking began.
  final int? baselineKm;
  final DateTime? firstLogDate;
}
