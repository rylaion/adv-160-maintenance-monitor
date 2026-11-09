import '../../../core/database/app_database.dart';

/// Domain model for the owner's motorcycle.
class Motorcycle {
  const Motorcycle({
    required this.id,
    required this.brand,
    required this.model,
    required this.modelYear,
    this.plateNumber,
    this.chassisNumber,
    this.engineNumber,
    this.purchaseDate,
    this.photoPath,
  });

  final int id;
  final String brand;
  final String model;
  final int modelYear;
  final String? plateNumber;
  final String? chassisNumber;
  final String? engineNumber;

  /// Date only (no time component).
  final DateTime? purchaseDate;
  final String? photoPath;

  String get displayName => '$brand $model';

  factory Motorcycle.fromRow(MotorcycleRow r) => Motorcycle(
        id: r.id,
        brand: r.brand,
        model: r.model,
        modelYear: r.modelYear,
        plateNumber: r.plateNumber,
        chassisNumber: r.chassisNumber,
        engineNumber: r.engineNumber,
        purchaseDate:
            r.purchaseDate == null ? null : DateTime.tryParse(r.purchaseDate!),
        photoPath: r.photoPath,
      );
}

/// Validation for motorcycle profile input. Returns an error message or null.
class MotorcycleValidator {
  static String? requiredText(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? '$label is required' : null;

  static String? modelYear(String? v) {
    final year = int.tryParse((v ?? '').trim());
    if (year == null) return 'Enter a valid year';
    final max = DateTime.now().year + 1;
    if (year < 1990 || year > max) return 'Year must be between 1990 and $max';
    return null;
  }
}
