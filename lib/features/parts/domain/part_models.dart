import '../../../core/exceptions/user_facing_exception.dart';

class PartsException implements UserFacingException {
  const PartsException(this.message);
  @override
  final String message;
  @override
  String toString() => message;
}

/// Part as stored (purchase information).
class PartInfo {
  const PartInfo({
    required this.id,
    required this.name,
    this.itemId,
    this.brand,
    this.partNumber,
    this.specification,
    this.purchasePriceCentavos = 0,
    this.purchaseDate,
    this.supplier,
    this.quantity = 1,
  });

  final int id;
  final int? itemId;
  final String name;
  final String? brand;
  final String? partNumber;
  final String? specification;
  final int purchasePriceCentavos;
  final DateTime? purchaseDate;
  final String? supplier;
  final int quantity;
}

/// Input for creating a part.
class NewPart {
  const NewPart({
    required this.name,
    this.itemId,
    this.brand,
    this.partNumber,
    this.specification,
    this.purchasePriceCentavos = 0,
    this.purchaseDate,
    this.supplier,
    this.quantity = 1,
  });

  final String name;
  final int? itemId;
  final String? brand;
  final String? partNumber;
  final String? specification;
  final int purchasePriceCentavos;
  final DateTime? purchaseDate;
  final String? supplier;
  final int quantity;
}

/// One lifecycle entry of a part on the motorcycle. Never overwritten:
/// replacing a part closes this entry (removed_*) and opens another.
class InstallationInfo {
  const InstallationInfo({
    required this.id,
    required this.part,
    required this.installedDate,
    required this.installedKm,
    this.itemName,
    this.position,
    this.removedDate,
    this.removedKm,
    this.notes,
  });

  final int id;
  final PartInfo part;
  final String? itemName;
  final String? position;
  final DateTime installedDate;
  final int installedKm;
  final DateTime? removedDate;
  final int? removedKm;
  final String? notes;

  bool get isInstalled => removedDate == null;

  /// Distance covered by this part; for the installed part pass the current
  /// odometer.
  int? distanceKm(int? currentKm) {
    final end = removedKm ?? currentKm;
    return end == null ? null : end - installedKm;
  }

  /// Days in service up to [today] (or removal).
  int daysInService(DateTime today) =>
      (removedDate ?? today).difference(installedDate).inDays;
}

/// A part line used in a service record.
class RecordPartInput {
  const RecordPartInput({
    this.existingPartId,
    this.name = '',
    this.brand,
    this.partNumber,
    this.specification,
    this.quantity = 1,
    this.unitCostCentavos = 0,
    this.position,
    this.trackInstallation = true,
  });

  /// Use an existing part from the parts list instead of creating one.
  final int? existingPartId;
  final String name;
  final String? brand;
  final String? partNumber;
  final String? specification;
  final int quantity;
  final int unitCostCentavos;

  /// FRONT / REAR when applicable (tires, brake pads).
  final String? position;

  /// For replacements: open an installation (and close the previous one).
  final bool trackInstallation;
}
