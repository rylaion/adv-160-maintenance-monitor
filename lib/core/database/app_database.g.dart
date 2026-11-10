// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MotorcyclesTable extends Motorcycles
    with TableInfo<$MotorcyclesTable, MotorcycleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MotorcyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _modelYearMeta =
      const VerificationMeta('modelYear');
  @override
  late final GeneratedColumn<int> modelYear = GeneratedColumn<int>(
      'model_year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _plateNumberMeta =
      const VerificationMeta('plateNumber');
  @override
  late final GeneratedColumn<String> plateNumber = GeneratedColumn<String>(
      'plate_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _chassisNumberMeta =
      const VerificationMeta('chassisNumber');
  @override
  late final GeneratedColumn<String> chassisNumber = GeneratedColumn<String>(
      'chassis_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _engineNumberMeta =
      const VerificationMeta('engineNumber');
  @override
  late final GeneratedColumn<String> engineNumber = GeneratedColumn<String>(
      'engine_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purchaseDateMeta =
      const VerificationMeta('purchaseDate');
  @override
  late final GeneratedColumn<String> purchaseDate = GeneratedColumn<String>(
      'purchase_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        brand,
        model,
        modelYear,
        plateNumber,
        chassisNumber,
        engineNumber,
        purchaseDate,
        photoPath,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'motorcycles';
  @override
  VerificationContext validateIntegrity(Insertable<MotorcycleRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('model_year')) {
      context.handle(_modelYearMeta,
          modelYear.isAcceptableOrUnknown(data['model_year']!, _modelYearMeta));
    } else if (isInserting) {
      context.missing(_modelYearMeta);
    }
    if (data.containsKey('plate_number')) {
      context.handle(
          _plateNumberMeta,
          plateNumber.isAcceptableOrUnknown(
              data['plate_number']!, _plateNumberMeta));
    }
    if (data.containsKey('chassis_number')) {
      context.handle(
          _chassisNumberMeta,
          chassisNumber.isAcceptableOrUnknown(
              data['chassis_number']!, _chassisNumberMeta));
    }
    if (data.containsKey('engine_number')) {
      context.handle(
          _engineNumberMeta,
          engineNumber.isAcceptableOrUnknown(
              data['engine_number']!, _engineNumberMeta));
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
          _purchaseDateMeta,
          purchaseDate.isAcceptableOrUnknown(
              data['purchase_date']!, _purchaseDateMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MotorcycleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MotorcycleRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand'])!,
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model'])!,
      modelYear: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}model_year'])!,
      plateNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plate_number']),
      chassisNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chassis_number']),
      engineNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}engine_number']),
      purchaseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purchase_date']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MotorcyclesTable createAlias(String alias) {
    return $MotorcyclesTable(attachedDatabase, alias);
  }
}

class MotorcycleRow extends DataClass implements Insertable<MotorcycleRow> {
  final int id;
  final String brand;
  final String model;
  final int modelYear;
  final String? plateNumber;
  final String? chassisNumber;
  final String? engineNumber;
  final String? purchaseDate;
  final String? photoPath;
  final String createdAt;
  final String updatedAt;
  const MotorcycleRow(
      {required this.id,
      required this.brand,
      required this.model,
      required this.modelYear,
      this.plateNumber,
      this.chassisNumber,
      this.engineNumber,
      this.purchaseDate,
      this.photoPath,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['brand'] = Variable<String>(brand);
    map['model'] = Variable<String>(model);
    map['model_year'] = Variable<int>(modelYear);
    if (!nullToAbsent || plateNumber != null) {
      map['plate_number'] = Variable<String>(plateNumber);
    }
    if (!nullToAbsent || chassisNumber != null) {
      map['chassis_number'] = Variable<String>(chassisNumber);
    }
    if (!nullToAbsent || engineNumber != null) {
      map['engine_number'] = Variable<String>(engineNumber);
    }
    if (!nullToAbsent || purchaseDate != null) {
      map['purchase_date'] = Variable<String>(purchaseDate);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  MotorcyclesCompanion toCompanion(bool nullToAbsent) {
    return MotorcyclesCompanion(
      id: Value(id),
      brand: Value(brand),
      model: Value(model),
      modelYear: Value(modelYear),
      plateNumber: plateNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(plateNumber),
      chassisNumber: chassisNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(chassisNumber),
      engineNumber: engineNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(engineNumber),
      purchaseDate: purchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseDate),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MotorcycleRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MotorcycleRow(
      id: serializer.fromJson<int>(json['id']),
      brand: serializer.fromJson<String>(json['brand']),
      model: serializer.fromJson<String>(json['model']),
      modelYear: serializer.fromJson<int>(json['modelYear']),
      plateNumber: serializer.fromJson<String?>(json['plateNumber']),
      chassisNumber: serializer.fromJson<String?>(json['chassisNumber']),
      engineNumber: serializer.fromJson<String?>(json['engineNumber']),
      purchaseDate: serializer.fromJson<String?>(json['purchaseDate']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'brand': serializer.toJson<String>(brand),
      'model': serializer.toJson<String>(model),
      'modelYear': serializer.toJson<int>(modelYear),
      'plateNumber': serializer.toJson<String?>(plateNumber),
      'chassisNumber': serializer.toJson<String?>(chassisNumber),
      'engineNumber': serializer.toJson<String?>(engineNumber),
      'purchaseDate': serializer.toJson<String?>(purchaseDate),
      'photoPath': serializer.toJson<String?>(photoPath),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  MotorcycleRow copyWith(
          {int? id,
          String? brand,
          String? model,
          int? modelYear,
          Value<String?> plateNumber = const Value.absent(),
          Value<String?> chassisNumber = const Value.absent(),
          Value<String?> engineNumber = const Value.absent(),
          Value<String?> purchaseDate = const Value.absent(),
          Value<String?> photoPath = const Value.absent(),
          String? createdAt,
          String? updatedAt}) =>
      MotorcycleRow(
        id: id ?? this.id,
        brand: brand ?? this.brand,
        model: model ?? this.model,
        modelYear: modelYear ?? this.modelYear,
        plateNumber: plateNumber.present ? plateNumber.value : this.plateNumber,
        chassisNumber:
            chassisNumber.present ? chassisNumber.value : this.chassisNumber,
        engineNumber:
            engineNumber.present ? engineNumber.value : this.engineNumber,
        purchaseDate:
            purchaseDate.present ? purchaseDate.value : this.purchaseDate,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MotorcycleRow copyWithCompanion(MotorcyclesCompanion data) {
    return MotorcycleRow(
      id: data.id.present ? data.id.value : this.id,
      brand: data.brand.present ? data.brand.value : this.brand,
      model: data.model.present ? data.model.value : this.model,
      modelYear: data.modelYear.present ? data.modelYear.value : this.modelYear,
      plateNumber:
          data.plateNumber.present ? data.plateNumber.value : this.plateNumber,
      chassisNumber: data.chassisNumber.present
          ? data.chassisNumber.value
          : this.chassisNumber,
      engineNumber: data.engineNumber.present
          ? data.engineNumber.value
          : this.engineNumber,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MotorcycleRow(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('modelYear: $modelYear, ')
          ..write('plateNumber: $plateNumber, ')
          ..write('chassisNumber: $chassisNumber, ')
          ..write('engineNumber: $engineNumber, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      brand,
      model,
      modelYear,
      plateNumber,
      chassisNumber,
      engineNumber,
      purchaseDate,
      photoPath,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MotorcycleRow &&
          other.id == this.id &&
          other.brand == this.brand &&
          other.model == this.model &&
          other.modelYear == this.modelYear &&
          other.plateNumber == this.plateNumber &&
          other.chassisNumber == this.chassisNumber &&
          other.engineNumber == this.engineNumber &&
          other.purchaseDate == this.purchaseDate &&
          other.photoPath == this.photoPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MotorcyclesCompanion extends UpdateCompanion<MotorcycleRow> {
  final Value<int> id;
  final Value<String> brand;
  final Value<String> model;
  final Value<int> modelYear;
  final Value<String?> plateNumber;
  final Value<String?> chassisNumber;
  final Value<String?> engineNumber;
  final Value<String?> purchaseDate;
  final Value<String?> photoPath;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const MotorcyclesCompanion({
    this.id = const Value.absent(),
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.modelYear = const Value.absent(),
    this.plateNumber = const Value.absent(),
    this.chassisNumber = const Value.absent(),
    this.engineNumber = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MotorcyclesCompanion.insert({
    this.id = const Value.absent(),
    required String brand,
    required String model,
    required int modelYear,
    this.plateNumber = const Value.absent(),
    this.chassisNumber = const Value.absent(),
    this.engineNumber = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.photoPath = const Value.absent(),
    required String createdAt,
    required String updatedAt,
  })  : brand = Value(brand),
        model = Value(model),
        modelYear = Value(modelYear),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<MotorcycleRow> custom({
    Expression<int>? id,
    Expression<String>? brand,
    Expression<String>? model,
    Expression<int>? modelYear,
    Expression<String>? plateNumber,
    Expression<String>? chassisNumber,
    Expression<String>? engineNumber,
    Expression<String>? purchaseDate,
    Expression<String>? photoPath,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (modelYear != null) 'model_year': modelYear,
      if (plateNumber != null) 'plate_number': plateNumber,
      if (chassisNumber != null) 'chassis_number': chassisNumber,
      if (engineNumber != null) 'engine_number': engineNumber,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (photoPath != null) 'photo_path': photoPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MotorcyclesCompanion copyWith(
      {Value<int>? id,
      Value<String>? brand,
      Value<String>? model,
      Value<int>? modelYear,
      Value<String?>? plateNumber,
      Value<String?>? chassisNumber,
      Value<String?>? engineNumber,
      Value<String?>? purchaseDate,
      Value<String?>? photoPath,
      Value<String>? createdAt,
      Value<String>? updatedAt}) {
    return MotorcyclesCompanion(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      modelYear: modelYear ?? this.modelYear,
      plateNumber: plateNumber ?? this.plateNumber,
      chassisNumber: chassisNumber ?? this.chassisNumber,
      engineNumber: engineNumber ?? this.engineNumber,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (modelYear.present) {
      map['model_year'] = Variable<int>(modelYear.value);
    }
    if (plateNumber.present) {
      map['plate_number'] = Variable<String>(plateNumber.value);
    }
    if (chassisNumber.present) {
      map['chassis_number'] = Variable<String>(chassisNumber.value);
    }
    if (engineNumber.present) {
      map['engine_number'] = Variable<String>(engineNumber.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<String>(purchaseDate.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MotorcyclesCompanion(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('modelYear: $modelYear, ')
          ..write('plateNumber: $plateNumber, ')
          ..write('chassisNumber: $chassisNumber, ')
          ..write('engineNumber: $engineNumber, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceCategoriesTable extends MaintenanceCategories
    with TableInfo<$MaintenanceCategoriesTable, MaintenanceCategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, name, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_categories';
  @override
  VerificationContext validateIntegrity(
      Insertable<MaintenanceCategoryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceCategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceCategoryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $MaintenanceCategoriesTable createAlias(String alias) {
    return $MaintenanceCategoriesTable(attachedDatabase, alias);
  }
}

class MaintenanceCategoryRow extends DataClass
    implements Insertable<MaintenanceCategoryRow> {
  final int id;
  final String name;
  final int sortOrder;
  const MaintenanceCategoryRow(
      {required this.id, required this.name, required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  MaintenanceCategoriesCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      sortOrder: Value(sortOrder),
    );
  }

  factory MaintenanceCategoryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceCategoryRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  MaintenanceCategoryRow copyWith({int? id, String? name, int? sortOrder}) =>
      MaintenanceCategoryRow(
        id: id ?? this.id,
        name: name ?? this.name,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  MaintenanceCategoryRow copyWithCompanion(
      MaintenanceCategoriesCompanion data) {
    return MaintenanceCategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceCategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceCategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder);
}

class MaintenanceCategoriesCompanion
    extends UpdateCompanion<MaintenanceCategoryRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> sortOrder;
  const MaintenanceCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  MaintenanceCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.sortOrder = const Value.absent(),
  }) : name = Value(name);
  static Insertable<MaintenanceCategoryRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  MaintenanceCategoriesCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? sortOrder}) {
    return MaintenanceCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceItemsTable extends MaintenanceItems
    with TableInfo<$MaintenanceItemsTable, MaintenanceItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES maintenance_categories (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _instructionsMeta =
      const VerificationMeta('instructions');
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
      'instructions', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isUserDefinedMeta =
      const VerificationMeta('isUserDefined');
  @override
  late final GeneratedColumn<bool> isUserDefined = GeneratedColumn<bool>(
      'is_user_defined', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_user_defined" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, categoryId, name, instructions, sortOrder, isActive, isUserDefined];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_items';
  @override
  VerificationContext validateIntegrity(Insertable<MaintenanceItemRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('instructions')) {
      context.handle(
          _instructionsMeta,
          instructions.isAcceptableOrUnknown(
              data['instructions']!, _instructionsMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('is_user_defined')) {
      context.handle(
          _isUserDefinedMeta,
          isUserDefined.isAcceptableOrUnknown(
              data['is_user_defined']!, _isUserDefinedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceItemRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      instructions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instructions']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      isUserDefined: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_user_defined'])!,
    );
  }

  @override
  $MaintenanceItemsTable createAlias(String alias) {
    return $MaintenanceItemsTable(attachedDatabase, alias);
  }
}

class MaintenanceItemRow extends DataClass
    implements Insertable<MaintenanceItemRow> {
  final int id;
  final int categoryId;
  final String name;
  final String? instructions;
  final int sortOrder;
  final bool isActive;
  final bool isUserDefined;
  const MaintenanceItemRow(
      {required this.id,
      required this.categoryId,
      required this.name,
      this.instructions,
      required this.sortOrder,
      required this.isActive,
      required this.isUserDefined});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || instructions != null) {
      map['instructions'] = Variable<String>(instructions);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    map['is_user_defined'] = Variable<bool>(isUserDefined);
    return map;
  }

  MaintenanceItemsCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceItemsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      name: Value(name),
      instructions: instructions == null && nullToAbsent
          ? const Value.absent()
          : Value(instructions),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
      isUserDefined: Value(isUserDefined),
    );
  }

  factory MaintenanceItemRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceItemRow(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      instructions: serializer.fromJson<String?>(json['instructions']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isUserDefined: serializer.fromJson<bool>(json['isUserDefined']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'name': serializer.toJson<String>(name),
      'instructions': serializer.toJson<String?>(instructions),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
      'isUserDefined': serializer.toJson<bool>(isUserDefined),
    };
  }

  MaintenanceItemRow copyWith(
          {int? id,
          int? categoryId,
          String? name,
          Value<String?> instructions = const Value.absent(),
          int? sortOrder,
          bool? isActive,
          bool? isUserDefined}) =>
      MaintenanceItemRow(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        name: name ?? this.name,
        instructions:
            instructions.present ? instructions.value : this.instructions,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
        isUserDefined: isUserDefined ?? this.isUserDefined,
      );
  MaintenanceItemRow copyWithCompanion(MaintenanceItemsCompanion data) {
    return MaintenanceItemRow(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isUserDefined: data.isUserDefined.present
          ? data.isUserDefined.value
          : this.isUserDefined,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceItemRow(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('instructions: $instructions, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('isUserDefined: $isUserDefined')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, categoryId, name, instructions, sortOrder, isActive, isUserDefined);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceItemRow &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.instructions == this.instructions &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive &&
          other.isUserDefined == this.isUserDefined);
}

class MaintenanceItemsCompanion extends UpdateCompanion<MaintenanceItemRow> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<String> name;
  final Value<String?> instructions;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<bool> isUserDefined;
  const MaintenanceItemsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.instructions = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isUserDefined = const Value.absent(),
  });
  MaintenanceItemsCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required String name,
    this.instructions = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isUserDefined = const Value.absent(),
  })  : categoryId = Value(categoryId),
        name = Value(name);
  static Insertable<MaintenanceItemRow> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<String>? name,
    Expression<String>? instructions,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<bool>? isUserDefined,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (instructions != null) 'instructions': instructions,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (isUserDefined != null) 'is_user_defined': isUserDefined,
    });
  }

  MaintenanceItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? categoryId,
      Value<String>? name,
      Value<String?>? instructions,
      Value<int>? sortOrder,
      Value<bool>? isActive,
      Value<bool>? isUserDefined}) {
    return MaintenanceItemsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      instructions: instructions ?? this.instructions,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      isUserDefined: isUserDefined ?? this.isUserDefined,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isUserDefined.present) {
      map['is_user_defined'] = Variable<bool>(isUserDefined.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceItemsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('instructions: $instructions, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('isUserDefined: $isUserDefined')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceRulesTable extends MaintenanceRules
    with TableInfo<$MaintenanceRulesTable, MaintenanceRuleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _motorcycleIdMeta =
      const VerificationMeta('motorcycleId');
  @override
  late final GeneratedColumn<int> motorcycleId = GeneratedColumn<int>(
      'motorcycle_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES motorcycles (id)'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES maintenance_items (id)'));
  static const VerificationMeta _ruleTypeMeta =
      const VerificationMeta('ruleType');
  @override
  late final GeneratedColumn<String> ruleType = GeneratedColumn<String>(
      'rule_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actionCodeMeta =
      const VerificationMeta('actionCode');
  @override
  late final GeneratedColumn<String> actionCode = GeneratedColumn<String>(
      'action_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceDocumentMeta =
      const VerificationMeta('sourceDocument');
  @override
  late final GeneratedColumn<String> sourceDocument = GeneratedColumn<String>(
      'source_document', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourcePageMeta =
      const VerificationMeta('sourcePage');
  @override
  late final GeneratedColumn<int> sourcePage = GeneratedColumn<int>(
      'source_page', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _intervalKmMeta =
      const VerificationMeta('intervalKm');
  @override
  late final GeneratedColumn<int> intervalKm = GeneratedColumn<int>(
      'interval_km', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _intervalMonthsMeta =
      const VerificationMeta('intervalMonths');
  @override
  late final GeneratedColumn<int> intervalMonths = GeneratedColumn<int>(
      'interval_months', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _warningKmMeta =
      const VerificationMeta('warningKm');
  @override
  late final GeneratedColumn<int> warningKm = GeneratedColumn<int>(
      'warning_km', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _warningDaysMeta =
      const VerificationMeta('warningDays');
  @override
  late final GeneratedColumn<int> warningDays = GeneratedColumn<int>(
      'warning_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastCompletedKmMeta =
      const VerificationMeta('lastCompletedKm');
  @override
  late final GeneratedColumn<int> lastCompletedKm = GeneratedColumn<int>(
      'last_completed_km', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastCompletedDateMeta =
      const VerificationMeta('lastCompletedDate');
  @override
  late final GeneratedColumn<String> lastCompletedDate =
      GeneratedColumn<String>('last_completed_date', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isVerifiedMeta =
      const VerificationMeta('isVerified');
  @override
  late final GeneratedColumn<bool> isVerified = GeneratedColumn<bool>(
      'is_verified', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_verified" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        motorcycleId,
        itemId,
        ruleType,
        actionCode,
        source,
        sourceDocument,
        sourcePage,
        intervalKm,
        intervalMonths,
        warningKm,
        warningDays,
        lastCompletedKm,
        lastCompletedDate,
        isVerified,
        isActive,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_rules';
  @override
  VerificationContext validateIntegrity(Insertable<MaintenanceRuleRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('motorcycle_id')) {
      context.handle(
          _motorcycleIdMeta,
          motorcycleId.isAcceptableOrUnknown(
              data['motorcycle_id']!, _motorcycleIdMeta));
    } else if (isInserting) {
      context.missing(_motorcycleIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('rule_type')) {
      context.handle(_ruleTypeMeta,
          ruleType.isAcceptableOrUnknown(data['rule_type']!, _ruleTypeMeta));
    } else if (isInserting) {
      context.missing(_ruleTypeMeta);
    }
    if (data.containsKey('action_code')) {
      context.handle(
          _actionCodeMeta,
          actionCode.isAcceptableOrUnknown(
              data['action_code']!, _actionCodeMeta));
    } else if (isInserting) {
      context.missing(_actionCodeMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('source_document')) {
      context.handle(
          _sourceDocumentMeta,
          sourceDocument.isAcceptableOrUnknown(
              data['source_document']!, _sourceDocumentMeta));
    }
    if (data.containsKey('source_page')) {
      context.handle(
          _sourcePageMeta,
          sourcePage.isAcceptableOrUnknown(
              data['source_page']!, _sourcePageMeta));
    }
    if (data.containsKey('interval_km')) {
      context.handle(
          _intervalKmMeta,
          intervalKm.isAcceptableOrUnknown(
              data['interval_km']!, _intervalKmMeta));
    }
    if (data.containsKey('interval_months')) {
      context.handle(
          _intervalMonthsMeta,
          intervalMonths.isAcceptableOrUnknown(
              data['interval_months']!, _intervalMonthsMeta));
    }
    if (data.containsKey('warning_km')) {
      context.handle(_warningKmMeta,
          warningKm.isAcceptableOrUnknown(data['warning_km']!, _warningKmMeta));
    }
    if (data.containsKey('warning_days')) {
      context.handle(
          _warningDaysMeta,
          warningDays.isAcceptableOrUnknown(
              data['warning_days']!, _warningDaysMeta));
    }
    if (data.containsKey('last_completed_km')) {
      context.handle(
          _lastCompletedKmMeta,
          lastCompletedKm.isAcceptableOrUnknown(
              data['last_completed_km']!, _lastCompletedKmMeta));
    }
    if (data.containsKey('last_completed_date')) {
      context.handle(
          _lastCompletedDateMeta,
          lastCompletedDate.isAcceptableOrUnknown(
              data['last_completed_date']!, _lastCompletedDateMeta));
    }
    if (data.containsKey('is_verified')) {
      context.handle(
          _isVerifiedMeta,
          isVerified.isAcceptableOrUnknown(
              data['is_verified']!, _isVerifiedMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceRuleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceRuleRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      motorcycleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}motorcycle_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      ruleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rule_type'])!,
      actionCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action_code'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      sourceDocument: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_document']),
      sourcePage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_page']),
      intervalKm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_km']),
      intervalMonths: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_months']),
      warningKm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}warning_km']),
      warningDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}warning_days']),
      lastCompletedKm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_completed_km']),
      lastCompletedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_completed_date']),
      isVerified: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_verified'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $MaintenanceRulesTable createAlias(String alias) {
    return $MaintenanceRulesTable(attachedDatabase, alias);
  }
}

class MaintenanceRuleRow extends DataClass
    implements Insertable<MaintenanceRuleRow> {
  final int id;
  final int motorcycleId;
  final int itemId;

  /// MILEAGE | DATE | COMBINED | CONDITION | CUSTOM
  final String ruleType;

  /// I | R | C
  final String actionCode;

  /// HONDA_MANUAL | SERVICE_MANUAL | CUSTOM
  final String source;
  final String? sourceDocument;
  final int? sourcePage;

  /// Simple recurring intervals (steps table holds explicit checkpoints).
  final int? intervalKm;
  final int? intervalMonths;

  /// Optional per-rule warning thresholds and baseline completion for custom rules.
  final int? warningKm;
  final int? warningDays;
  final int? lastCompletedKm;
  final String? lastCompletedDate;

  /// False until the entry is confirmed against the official manual.
  final bool isVerified;
  final bool isActive;
  final String? notes;
  const MaintenanceRuleRow(
      {required this.id,
      required this.motorcycleId,
      required this.itemId,
      required this.ruleType,
      required this.actionCode,
      required this.source,
      this.sourceDocument,
      this.sourcePage,
      this.intervalKm,
      this.intervalMonths,
      this.warningKm,
      this.warningDays,
      this.lastCompletedKm,
      this.lastCompletedDate,
      required this.isVerified,
      required this.isActive,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['motorcycle_id'] = Variable<int>(motorcycleId);
    map['item_id'] = Variable<int>(itemId);
    map['rule_type'] = Variable<String>(ruleType);
    map['action_code'] = Variable<String>(actionCode);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || sourceDocument != null) {
      map['source_document'] = Variable<String>(sourceDocument);
    }
    if (!nullToAbsent || sourcePage != null) {
      map['source_page'] = Variable<int>(sourcePage);
    }
    if (!nullToAbsent || intervalKm != null) {
      map['interval_km'] = Variable<int>(intervalKm);
    }
    if (!nullToAbsent || intervalMonths != null) {
      map['interval_months'] = Variable<int>(intervalMonths);
    }
    if (!nullToAbsent || warningKm != null) {
      map['warning_km'] = Variable<int>(warningKm);
    }
    if (!nullToAbsent || warningDays != null) {
      map['warning_days'] = Variable<int>(warningDays);
    }
    if (!nullToAbsent || lastCompletedKm != null) {
      map['last_completed_km'] = Variable<int>(lastCompletedKm);
    }
    if (!nullToAbsent || lastCompletedDate != null) {
      map['last_completed_date'] = Variable<String>(lastCompletedDate);
    }
    map['is_verified'] = Variable<bool>(isVerified);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  MaintenanceRulesCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceRulesCompanion(
      id: Value(id),
      motorcycleId: Value(motorcycleId),
      itemId: Value(itemId),
      ruleType: Value(ruleType),
      actionCode: Value(actionCode),
      source: Value(source),
      sourceDocument: sourceDocument == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceDocument),
      sourcePage: sourcePage == null && nullToAbsent
          ? const Value.absent()
          : Value(sourcePage),
      intervalKm: intervalKm == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalKm),
      intervalMonths: intervalMonths == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalMonths),
      warningKm: warningKm == null && nullToAbsent
          ? const Value.absent()
          : Value(warningKm),
      warningDays: warningDays == null && nullToAbsent
          ? const Value.absent()
          : Value(warningDays),
      lastCompletedKm: lastCompletedKm == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletedKm),
      lastCompletedDate: lastCompletedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletedDate),
      isVerified: Value(isVerified),
      isActive: Value(isActive),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory MaintenanceRuleRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceRuleRow(
      id: serializer.fromJson<int>(json['id']),
      motorcycleId: serializer.fromJson<int>(json['motorcycleId']),
      itemId: serializer.fromJson<int>(json['itemId']),
      ruleType: serializer.fromJson<String>(json['ruleType']),
      actionCode: serializer.fromJson<String>(json['actionCode']),
      source: serializer.fromJson<String>(json['source']),
      sourceDocument: serializer.fromJson<String?>(json['sourceDocument']),
      sourcePage: serializer.fromJson<int?>(json['sourcePage']),
      intervalKm: serializer.fromJson<int?>(json['intervalKm']),
      intervalMonths: serializer.fromJson<int?>(json['intervalMonths']),
      warningKm: serializer.fromJson<int?>(json['warningKm']),
      warningDays: serializer.fromJson<int?>(json['warningDays']),
      lastCompletedKm: serializer.fromJson<int?>(json['lastCompletedKm']),
      lastCompletedDate:
          serializer.fromJson<String?>(json['lastCompletedDate']),
      isVerified: serializer.fromJson<bool>(json['isVerified']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'motorcycleId': serializer.toJson<int>(motorcycleId),
      'itemId': serializer.toJson<int>(itemId),
      'ruleType': serializer.toJson<String>(ruleType),
      'actionCode': serializer.toJson<String>(actionCode),
      'source': serializer.toJson<String>(source),
      'sourceDocument': serializer.toJson<String?>(sourceDocument),
      'sourcePage': serializer.toJson<int?>(sourcePage),
      'intervalKm': serializer.toJson<int?>(intervalKm),
      'intervalMonths': serializer.toJson<int?>(intervalMonths),
      'warningKm': serializer.toJson<int?>(warningKm),
      'warningDays': serializer.toJson<int?>(warningDays),
      'lastCompletedKm': serializer.toJson<int?>(lastCompletedKm),
      'lastCompletedDate': serializer.toJson<String?>(lastCompletedDate),
      'isVerified': serializer.toJson<bool>(isVerified),
      'isActive': serializer.toJson<bool>(isActive),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  MaintenanceRuleRow copyWith(
          {int? id,
          int? motorcycleId,
          int? itemId,
          String? ruleType,
          String? actionCode,
          String? source,
          Value<String?> sourceDocument = const Value.absent(),
          Value<int?> sourcePage = const Value.absent(),
          Value<int?> intervalKm = const Value.absent(),
          Value<int?> intervalMonths = const Value.absent(),
          Value<int?> warningKm = const Value.absent(),
          Value<int?> warningDays = const Value.absent(),
          Value<int?> lastCompletedKm = const Value.absent(),
          Value<String?> lastCompletedDate = const Value.absent(),
          bool? isVerified,
          bool? isActive,
          Value<String?> notes = const Value.absent()}) =>
      MaintenanceRuleRow(
        id: id ?? this.id,
        motorcycleId: motorcycleId ?? this.motorcycleId,
        itemId: itemId ?? this.itemId,
        ruleType: ruleType ?? this.ruleType,
        actionCode: actionCode ?? this.actionCode,
        source: source ?? this.source,
        sourceDocument:
            sourceDocument.present ? sourceDocument.value : this.sourceDocument,
        sourcePage: sourcePage.present ? sourcePage.value : this.sourcePage,
        intervalKm: intervalKm.present ? intervalKm.value : this.intervalKm,
        intervalMonths:
            intervalMonths.present ? intervalMonths.value : this.intervalMonths,
        warningKm: warningKm.present ? warningKm.value : this.warningKm,
        warningDays: warningDays.present ? warningDays.value : this.warningDays,
        lastCompletedKm: lastCompletedKm.present
            ? lastCompletedKm.value
            : this.lastCompletedKm,
        lastCompletedDate: lastCompletedDate.present
            ? lastCompletedDate.value
            : this.lastCompletedDate,
        isVerified: isVerified ?? this.isVerified,
        isActive: isActive ?? this.isActive,
        notes: notes.present ? notes.value : this.notes,
      );
  MaintenanceRuleRow copyWithCompanion(MaintenanceRulesCompanion data) {
    return MaintenanceRuleRow(
      id: data.id.present ? data.id.value : this.id,
      motorcycleId: data.motorcycleId.present
          ? data.motorcycleId.value
          : this.motorcycleId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      ruleType: data.ruleType.present ? data.ruleType.value : this.ruleType,
      actionCode:
          data.actionCode.present ? data.actionCode.value : this.actionCode,
      source: data.source.present ? data.source.value : this.source,
      sourceDocument: data.sourceDocument.present
          ? data.sourceDocument.value
          : this.sourceDocument,
      sourcePage:
          data.sourcePage.present ? data.sourcePage.value : this.sourcePage,
      intervalKm:
          data.intervalKm.present ? data.intervalKm.value : this.intervalKm,
      intervalMonths: data.intervalMonths.present
          ? data.intervalMonths.value
          : this.intervalMonths,
      warningKm: data.warningKm.present ? data.warningKm.value : this.warningKm,
      warningDays:
          data.warningDays.present ? data.warningDays.value : this.warningDays,
      lastCompletedKm: data.lastCompletedKm.present
          ? data.lastCompletedKm.value
          : this.lastCompletedKm,
      lastCompletedDate: data.lastCompletedDate.present
          ? data.lastCompletedDate.value
          : this.lastCompletedDate,
      isVerified:
          data.isVerified.present ? data.isVerified.value : this.isVerified,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceRuleRow(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('itemId: $itemId, ')
          ..write('ruleType: $ruleType, ')
          ..write('actionCode: $actionCode, ')
          ..write('source: $source, ')
          ..write('sourceDocument: $sourceDocument, ')
          ..write('sourcePage: $sourcePage, ')
          ..write('intervalKm: $intervalKm, ')
          ..write('intervalMonths: $intervalMonths, ')
          ..write('warningKm: $warningKm, ')
          ..write('warningDays: $warningDays, ')
          ..write('lastCompletedKm: $lastCompletedKm, ')
          ..write('lastCompletedDate: $lastCompletedDate, ')
          ..write('isVerified: $isVerified, ')
          ..write('isActive: $isActive, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      motorcycleId,
      itemId,
      ruleType,
      actionCode,
      source,
      sourceDocument,
      sourcePage,
      intervalKm,
      intervalMonths,
      warningKm,
      warningDays,
      lastCompletedKm,
      lastCompletedDate,
      isVerified,
      isActive,
      notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceRuleRow &&
          other.id == this.id &&
          other.motorcycleId == this.motorcycleId &&
          other.itemId == this.itemId &&
          other.ruleType == this.ruleType &&
          other.actionCode == this.actionCode &&
          other.source == this.source &&
          other.sourceDocument == this.sourceDocument &&
          other.sourcePage == this.sourcePage &&
          other.intervalKm == this.intervalKm &&
          other.intervalMonths == this.intervalMonths &&
          other.warningKm == this.warningKm &&
          other.warningDays == this.warningDays &&
          other.lastCompletedKm == this.lastCompletedKm &&
          other.lastCompletedDate == this.lastCompletedDate &&
          other.isVerified == this.isVerified &&
          other.isActive == this.isActive &&
          other.notes == this.notes);
}

class MaintenanceRulesCompanion extends UpdateCompanion<MaintenanceRuleRow> {
  final Value<int> id;
  final Value<int> motorcycleId;
  final Value<int> itemId;
  final Value<String> ruleType;
  final Value<String> actionCode;
  final Value<String> source;
  final Value<String?> sourceDocument;
  final Value<int?> sourcePage;
  final Value<int?> intervalKm;
  final Value<int?> intervalMonths;
  final Value<int?> warningKm;
  final Value<int?> warningDays;
  final Value<int?> lastCompletedKm;
  final Value<String?> lastCompletedDate;
  final Value<bool> isVerified;
  final Value<bool> isActive;
  final Value<String?> notes;
  const MaintenanceRulesCompanion({
    this.id = const Value.absent(),
    this.motorcycleId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.ruleType = const Value.absent(),
    this.actionCode = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceDocument = const Value.absent(),
    this.sourcePage = const Value.absent(),
    this.intervalKm = const Value.absent(),
    this.intervalMonths = const Value.absent(),
    this.warningKm = const Value.absent(),
    this.warningDays = const Value.absent(),
    this.lastCompletedKm = const Value.absent(),
    this.lastCompletedDate = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notes = const Value.absent(),
  });
  MaintenanceRulesCompanion.insert({
    this.id = const Value.absent(),
    required int motorcycleId,
    required int itemId,
    required String ruleType,
    required String actionCode,
    required String source,
    this.sourceDocument = const Value.absent(),
    this.sourcePage = const Value.absent(),
    this.intervalKm = const Value.absent(),
    this.intervalMonths = const Value.absent(),
    this.warningKm = const Value.absent(),
    this.warningDays = const Value.absent(),
    this.lastCompletedKm = const Value.absent(),
    this.lastCompletedDate = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notes = const Value.absent(),
  })  : motorcycleId = Value(motorcycleId),
        itemId = Value(itemId),
        ruleType = Value(ruleType),
        actionCode = Value(actionCode),
        source = Value(source);
  static Insertable<MaintenanceRuleRow> custom({
    Expression<int>? id,
    Expression<int>? motorcycleId,
    Expression<int>? itemId,
    Expression<String>? ruleType,
    Expression<String>? actionCode,
    Expression<String>? source,
    Expression<String>? sourceDocument,
    Expression<int>? sourcePage,
    Expression<int>? intervalKm,
    Expression<int>? intervalMonths,
    Expression<int>? warningKm,
    Expression<int>? warningDays,
    Expression<int>? lastCompletedKm,
    Expression<String>? lastCompletedDate,
    Expression<bool>? isVerified,
    Expression<bool>? isActive,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (motorcycleId != null) 'motorcycle_id': motorcycleId,
      if (itemId != null) 'item_id': itemId,
      if (ruleType != null) 'rule_type': ruleType,
      if (actionCode != null) 'action_code': actionCode,
      if (source != null) 'source': source,
      if (sourceDocument != null) 'source_document': sourceDocument,
      if (sourcePage != null) 'source_page': sourcePage,
      if (intervalKm != null) 'interval_km': intervalKm,
      if (intervalMonths != null) 'interval_months': intervalMonths,
      if (warningKm != null) 'warning_km': warningKm,
      if (warningDays != null) 'warning_days': warningDays,
      if (lastCompletedKm != null) 'last_completed_km': lastCompletedKm,
      if (lastCompletedDate != null) 'last_completed_date': lastCompletedDate,
      if (isVerified != null) 'is_verified': isVerified,
      if (isActive != null) 'is_active': isActive,
      if (notes != null) 'notes': notes,
    });
  }

  MaintenanceRulesCompanion copyWith(
      {Value<int>? id,
      Value<int>? motorcycleId,
      Value<int>? itemId,
      Value<String>? ruleType,
      Value<String>? actionCode,
      Value<String>? source,
      Value<String?>? sourceDocument,
      Value<int?>? sourcePage,
      Value<int?>? intervalKm,
      Value<int?>? intervalMonths,
      Value<int?>? warningKm,
      Value<int?>? warningDays,
      Value<int?>? lastCompletedKm,
      Value<String?>? lastCompletedDate,
      Value<bool>? isVerified,
      Value<bool>? isActive,
      Value<String?>? notes}) {
    return MaintenanceRulesCompanion(
      id: id ?? this.id,
      motorcycleId: motorcycleId ?? this.motorcycleId,
      itemId: itemId ?? this.itemId,
      ruleType: ruleType ?? this.ruleType,
      actionCode: actionCode ?? this.actionCode,
      source: source ?? this.source,
      sourceDocument: sourceDocument ?? this.sourceDocument,
      sourcePage: sourcePage ?? this.sourcePage,
      intervalKm: intervalKm ?? this.intervalKm,
      intervalMonths: intervalMonths ?? this.intervalMonths,
      warningKm: warningKm ?? this.warningKm,
      warningDays: warningDays ?? this.warningDays,
      lastCompletedKm: lastCompletedKm ?? this.lastCompletedKm,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (motorcycleId.present) {
      map['motorcycle_id'] = Variable<int>(motorcycleId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (ruleType.present) {
      map['rule_type'] = Variable<String>(ruleType.value);
    }
    if (actionCode.present) {
      map['action_code'] = Variable<String>(actionCode.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (sourceDocument.present) {
      map['source_document'] = Variable<String>(sourceDocument.value);
    }
    if (sourcePage.present) {
      map['source_page'] = Variable<int>(sourcePage.value);
    }
    if (intervalKm.present) {
      map['interval_km'] = Variable<int>(intervalKm.value);
    }
    if (intervalMonths.present) {
      map['interval_months'] = Variable<int>(intervalMonths.value);
    }
    if (warningKm.present) {
      map['warning_km'] = Variable<int>(warningKm.value);
    }
    if (warningDays.present) {
      map['warning_days'] = Variable<int>(warningDays.value);
    }
    if (lastCompletedKm.present) {
      map['last_completed_km'] = Variable<int>(lastCompletedKm.value);
    }
    if (lastCompletedDate.present) {
      map['last_completed_date'] = Variable<String>(lastCompletedDate.value);
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<bool>(isVerified.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceRulesCompanion(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('itemId: $itemId, ')
          ..write('ruleType: $ruleType, ')
          ..write('actionCode: $actionCode, ')
          ..write('source: $source, ')
          ..write('sourceDocument: $sourceDocument, ')
          ..write('sourcePage: $sourcePage, ')
          ..write('intervalKm: $intervalKm, ')
          ..write('intervalMonths: $intervalMonths, ')
          ..write('warningKm: $warningKm, ')
          ..write('warningDays: $warningDays, ')
          ..write('lastCompletedKm: $lastCompletedKm, ')
          ..write('lastCompletedDate: $lastCompletedDate, ')
          ..write('isVerified: $isVerified, ')
          ..write('isActive: $isActive, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceRuleStepsTable extends MaintenanceRuleSteps
    with TableInfo<$MaintenanceRuleStepsTable, MaintenanceRuleStepRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceRuleStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<int> ruleId = GeneratedColumn<int>(
      'rule_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES maintenance_rules (id)'));
  static const VerificationMeta _stepOrderMeta =
      const VerificationMeta('stepOrder');
  @override
  late final GeneratedColumn<int> stepOrder = GeneratedColumn<int>(
      'step_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _actionCodeMeta =
      const VerificationMeta('actionCode');
  @override
  late final GeneratedColumn<String> actionCode = GeneratedColumn<String>(
      'action_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _atKmMeta = const VerificationMeta('atKm');
  @override
  late final GeneratedColumn<int> atKm = GeneratedColumn<int>(
      'at_km', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _atMonthsMeta =
      const VerificationMeta('atMonths');
  @override
  late final GeneratedColumn<int> atMonths = GeneratedColumn<int>(
      'at_months', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _repeatEveryKmMeta =
      const VerificationMeta('repeatEveryKm');
  @override
  late final GeneratedColumn<int> repeatEveryKm = GeneratedColumn<int>(
      'repeat_every_km', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _repeatEveryMonthsMeta =
      const VerificationMeta('repeatEveryMonths');
  @override
  late final GeneratedColumn<int> repeatEveryMonths = GeneratedColumn<int>(
      'repeat_every_months', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        ruleId,
        stepOrder,
        actionCode,
        atKm,
        atMonths,
        repeatEveryKm,
        repeatEveryMonths,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_rule_steps';
  @override
  VerificationContext validateIntegrity(
      Insertable<MaintenanceRuleStepRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('rule_id')) {
      context.handle(_ruleIdMeta,
          ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta));
    } else if (isInserting) {
      context.missing(_ruleIdMeta);
    }
    if (data.containsKey('step_order')) {
      context.handle(_stepOrderMeta,
          stepOrder.isAcceptableOrUnknown(data['step_order']!, _stepOrderMeta));
    } else if (isInserting) {
      context.missing(_stepOrderMeta);
    }
    if (data.containsKey('action_code')) {
      context.handle(
          _actionCodeMeta,
          actionCode.isAcceptableOrUnknown(
              data['action_code']!, _actionCodeMeta));
    } else if (isInserting) {
      context.missing(_actionCodeMeta);
    }
    if (data.containsKey('at_km')) {
      context.handle(
          _atKmMeta, atKm.isAcceptableOrUnknown(data['at_km']!, _atKmMeta));
    }
    if (data.containsKey('at_months')) {
      context.handle(_atMonthsMeta,
          atMonths.isAcceptableOrUnknown(data['at_months']!, _atMonthsMeta));
    }
    if (data.containsKey('repeat_every_km')) {
      context.handle(
          _repeatEveryKmMeta,
          repeatEveryKm.isAcceptableOrUnknown(
              data['repeat_every_km']!, _repeatEveryKmMeta));
    }
    if (data.containsKey('repeat_every_months')) {
      context.handle(
          _repeatEveryMonthsMeta,
          repeatEveryMonths.isAcceptableOrUnknown(
              data['repeat_every_months']!, _repeatEveryMonthsMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceRuleStepRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceRuleStepRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      ruleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rule_id'])!,
      stepOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}step_order'])!,
      actionCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action_code'])!,
      atKm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}at_km']),
      atMonths: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}at_months']),
      repeatEveryKm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}repeat_every_km']),
      repeatEveryMonths: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}repeat_every_months']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $MaintenanceRuleStepsTable createAlias(String alias) {
    return $MaintenanceRuleStepsTable(attachedDatabase, alias);
  }
}

class MaintenanceRuleStepRow extends DataClass
    implements Insertable<MaintenanceRuleStepRow> {
  final int id;
  final int ruleId;
  final int stepOrder;

  /// I | R | C
  final String actionCode;
  final int? atKm;
  final int? atMonths;
  final int? repeatEveryKm;
  final int? repeatEveryMonths;
  final String? notes;
  const MaintenanceRuleStepRow(
      {required this.id,
      required this.ruleId,
      required this.stepOrder,
      required this.actionCode,
      this.atKm,
      this.atMonths,
      this.repeatEveryKm,
      this.repeatEveryMonths,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['rule_id'] = Variable<int>(ruleId);
    map['step_order'] = Variable<int>(stepOrder);
    map['action_code'] = Variable<String>(actionCode);
    if (!nullToAbsent || atKm != null) {
      map['at_km'] = Variable<int>(atKm);
    }
    if (!nullToAbsent || atMonths != null) {
      map['at_months'] = Variable<int>(atMonths);
    }
    if (!nullToAbsent || repeatEveryKm != null) {
      map['repeat_every_km'] = Variable<int>(repeatEveryKm);
    }
    if (!nullToAbsent || repeatEveryMonths != null) {
      map['repeat_every_months'] = Variable<int>(repeatEveryMonths);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  MaintenanceRuleStepsCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceRuleStepsCompanion(
      id: Value(id),
      ruleId: Value(ruleId),
      stepOrder: Value(stepOrder),
      actionCode: Value(actionCode),
      atKm: atKm == null && nullToAbsent ? const Value.absent() : Value(atKm),
      atMonths: atMonths == null && nullToAbsent
          ? const Value.absent()
          : Value(atMonths),
      repeatEveryKm: repeatEveryKm == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatEveryKm),
      repeatEveryMonths: repeatEveryMonths == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatEveryMonths),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory MaintenanceRuleStepRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceRuleStepRow(
      id: serializer.fromJson<int>(json['id']),
      ruleId: serializer.fromJson<int>(json['ruleId']),
      stepOrder: serializer.fromJson<int>(json['stepOrder']),
      actionCode: serializer.fromJson<String>(json['actionCode']),
      atKm: serializer.fromJson<int?>(json['atKm']),
      atMonths: serializer.fromJson<int?>(json['atMonths']),
      repeatEveryKm: serializer.fromJson<int?>(json['repeatEveryKm']),
      repeatEveryMonths: serializer.fromJson<int?>(json['repeatEveryMonths']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ruleId': serializer.toJson<int>(ruleId),
      'stepOrder': serializer.toJson<int>(stepOrder),
      'actionCode': serializer.toJson<String>(actionCode),
      'atKm': serializer.toJson<int?>(atKm),
      'atMonths': serializer.toJson<int?>(atMonths),
      'repeatEveryKm': serializer.toJson<int?>(repeatEveryKm),
      'repeatEveryMonths': serializer.toJson<int?>(repeatEveryMonths),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  MaintenanceRuleStepRow copyWith(
          {int? id,
          int? ruleId,
          int? stepOrder,
          String? actionCode,
          Value<int?> atKm = const Value.absent(),
          Value<int?> atMonths = const Value.absent(),
          Value<int?> repeatEveryKm = const Value.absent(),
          Value<int?> repeatEveryMonths = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      MaintenanceRuleStepRow(
        id: id ?? this.id,
        ruleId: ruleId ?? this.ruleId,
        stepOrder: stepOrder ?? this.stepOrder,
        actionCode: actionCode ?? this.actionCode,
        atKm: atKm.present ? atKm.value : this.atKm,
        atMonths: atMonths.present ? atMonths.value : this.atMonths,
        repeatEveryKm:
            repeatEveryKm.present ? repeatEveryKm.value : this.repeatEveryKm,
        repeatEveryMonths: repeatEveryMonths.present
            ? repeatEveryMonths.value
            : this.repeatEveryMonths,
        notes: notes.present ? notes.value : this.notes,
      );
  MaintenanceRuleStepRow copyWithCompanion(MaintenanceRuleStepsCompanion data) {
    return MaintenanceRuleStepRow(
      id: data.id.present ? data.id.value : this.id,
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      stepOrder: data.stepOrder.present ? data.stepOrder.value : this.stepOrder,
      actionCode:
          data.actionCode.present ? data.actionCode.value : this.actionCode,
      atKm: data.atKm.present ? data.atKm.value : this.atKm,
      atMonths: data.atMonths.present ? data.atMonths.value : this.atMonths,
      repeatEveryKm: data.repeatEveryKm.present
          ? data.repeatEveryKm.value
          : this.repeatEveryKm,
      repeatEveryMonths: data.repeatEveryMonths.present
          ? data.repeatEveryMonths.value
          : this.repeatEveryMonths,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceRuleStepRow(')
          ..write('id: $id, ')
          ..write('ruleId: $ruleId, ')
          ..write('stepOrder: $stepOrder, ')
          ..write('actionCode: $actionCode, ')
          ..write('atKm: $atKm, ')
          ..write('atMonths: $atMonths, ')
          ..write('repeatEveryKm: $repeatEveryKm, ')
          ..write('repeatEveryMonths: $repeatEveryMonths, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ruleId, stepOrder, actionCode, atKm,
      atMonths, repeatEveryKm, repeatEveryMonths, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceRuleStepRow &&
          other.id == this.id &&
          other.ruleId == this.ruleId &&
          other.stepOrder == this.stepOrder &&
          other.actionCode == this.actionCode &&
          other.atKm == this.atKm &&
          other.atMonths == this.atMonths &&
          other.repeatEveryKm == this.repeatEveryKm &&
          other.repeatEveryMonths == this.repeatEveryMonths &&
          other.notes == this.notes);
}

class MaintenanceRuleStepsCompanion
    extends UpdateCompanion<MaintenanceRuleStepRow> {
  final Value<int> id;
  final Value<int> ruleId;
  final Value<int> stepOrder;
  final Value<String> actionCode;
  final Value<int?> atKm;
  final Value<int?> atMonths;
  final Value<int?> repeatEveryKm;
  final Value<int?> repeatEveryMonths;
  final Value<String?> notes;
  const MaintenanceRuleStepsCompanion({
    this.id = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.stepOrder = const Value.absent(),
    this.actionCode = const Value.absent(),
    this.atKm = const Value.absent(),
    this.atMonths = const Value.absent(),
    this.repeatEveryKm = const Value.absent(),
    this.repeatEveryMonths = const Value.absent(),
    this.notes = const Value.absent(),
  });
  MaintenanceRuleStepsCompanion.insert({
    this.id = const Value.absent(),
    required int ruleId,
    required int stepOrder,
    required String actionCode,
    this.atKm = const Value.absent(),
    this.atMonths = const Value.absent(),
    this.repeatEveryKm = const Value.absent(),
    this.repeatEveryMonths = const Value.absent(),
    this.notes = const Value.absent(),
  })  : ruleId = Value(ruleId),
        stepOrder = Value(stepOrder),
        actionCode = Value(actionCode);
  static Insertable<MaintenanceRuleStepRow> custom({
    Expression<int>? id,
    Expression<int>? ruleId,
    Expression<int>? stepOrder,
    Expression<String>? actionCode,
    Expression<int>? atKm,
    Expression<int>? atMonths,
    Expression<int>? repeatEveryKm,
    Expression<int>? repeatEveryMonths,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ruleId != null) 'rule_id': ruleId,
      if (stepOrder != null) 'step_order': stepOrder,
      if (actionCode != null) 'action_code': actionCode,
      if (atKm != null) 'at_km': atKm,
      if (atMonths != null) 'at_months': atMonths,
      if (repeatEveryKm != null) 'repeat_every_km': repeatEveryKm,
      if (repeatEveryMonths != null) 'repeat_every_months': repeatEveryMonths,
      if (notes != null) 'notes': notes,
    });
  }

  MaintenanceRuleStepsCompanion copyWith(
      {Value<int>? id,
      Value<int>? ruleId,
      Value<int>? stepOrder,
      Value<String>? actionCode,
      Value<int?>? atKm,
      Value<int?>? atMonths,
      Value<int?>? repeatEveryKm,
      Value<int?>? repeatEveryMonths,
      Value<String?>? notes}) {
    return MaintenanceRuleStepsCompanion(
      id: id ?? this.id,
      ruleId: ruleId ?? this.ruleId,
      stepOrder: stepOrder ?? this.stepOrder,
      actionCode: actionCode ?? this.actionCode,
      atKm: atKm ?? this.atKm,
      atMonths: atMonths ?? this.atMonths,
      repeatEveryKm: repeatEveryKm ?? this.repeatEveryKm,
      repeatEveryMonths: repeatEveryMonths ?? this.repeatEveryMonths,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<int>(ruleId.value);
    }
    if (stepOrder.present) {
      map['step_order'] = Variable<int>(stepOrder.value);
    }
    if (actionCode.present) {
      map['action_code'] = Variable<String>(actionCode.value);
    }
    if (atKm.present) {
      map['at_km'] = Variable<int>(atKm.value);
    }
    if (atMonths.present) {
      map['at_months'] = Variable<int>(atMonths.value);
    }
    if (repeatEveryKm.present) {
      map['repeat_every_km'] = Variable<int>(repeatEveryKm.value);
    }
    if (repeatEveryMonths.present) {
      map['repeat_every_months'] = Variable<int>(repeatEveryMonths.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceRuleStepsCompanion(')
          ..write('id: $id, ')
          ..write('ruleId: $ruleId, ')
          ..write('stepOrder: $stepOrder, ')
          ..write('actionCode: $actionCode, ')
          ..write('atKm: $atKm, ')
          ..write('atMonths: $atMonths, ')
          ..write('repeatEveryKm: $repeatEveryKm, ')
          ..write('repeatEveryMonths: $repeatEveryMonths, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceRecordsTable extends MaintenanceRecords
    with TableInfo<$MaintenanceRecordsTable, MaintenanceRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _motorcycleIdMeta =
      const VerificationMeta('motorcycleId');
  @override
  late final GeneratedColumn<int> motorcycleId = GeneratedColumn<int>(
      'motorcycle_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES motorcycles (id)'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES maintenance_items (id)'));
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _performedDateMeta =
      const VerificationMeta('performedDate');
  @override
  late final GeneratedColumn<String> performedDate = GeneratedColumn<String>(
      'performed_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _odometerKmMeta =
      const VerificationMeta('odometerKm');
  @override
  late final GeneratedColumn<int> odometerKm = GeneratedColumn<int>(
      'odometer_km', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _laborCostCentavosMeta =
      const VerificationMeta('laborCostCentavos');
  @override
  late final GeneratedColumn<int> laborCostCentavos = GeneratedColumn<int>(
      'labor_cost_centavos', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalCostCentavosMeta =
      const VerificationMeta('totalCostCentavos');
  @override
  late final GeneratedColumn<int> totalCostCentavos = GeneratedColumn<int>(
      'total_cost_centavos', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _serviceProviderMeta =
      const VerificationMeta('serviceProvider');
  @override
  late final GeneratedColumn<String> serviceProvider = GeneratedColumn<String>(
      'service_provider', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _voidedAtMeta =
      const VerificationMeta('voidedAt');
  @override
  late final GeneratedColumn<String> voidedAt = GeneratedColumn<String>(
      'voided_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _supersedesRecordIdMeta =
      const VerificationMeta('supersedesRecordId');
  @override
  late final GeneratedColumn<int> supersedesRecordId = GeneratedColumn<int>(
      'supersedes_record_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES maintenance_records (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        motorcycleId,
        itemId,
        action,
        performedDate,
        odometerKm,
        laborCostCentavos,
        totalCostCentavos,
        serviceProvider,
        notes,
        voidedAt,
        supersedesRecordId,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_records';
  @override
  VerificationContext validateIntegrity(
      Insertable<MaintenanceRecordRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('motorcycle_id')) {
      context.handle(
          _motorcycleIdMeta,
          motorcycleId.isAcceptableOrUnknown(
              data['motorcycle_id']!, _motorcycleIdMeta));
    } else if (isInserting) {
      context.missing(_motorcycleIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('performed_date')) {
      context.handle(
          _performedDateMeta,
          performedDate.isAcceptableOrUnknown(
              data['performed_date']!, _performedDateMeta));
    } else if (isInserting) {
      context.missing(_performedDateMeta);
    }
    if (data.containsKey('odometer_km')) {
      context.handle(
          _odometerKmMeta,
          odometerKm.isAcceptableOrUnknown(
              data['odometer_km']!, _odometerKmMeta));
    } else if (isInserting) {
      context.missing(_odometerKmMeta);
    }
    if (data.containsKey('labor_cost_centavos')) {
      context.handle(
          _laborCostCentavosMeta,
          laborCostCentavos.isAcceptableOrUnknown(
              data['labor_cost_centavos']!, _laborCostCentavosMeta));
    }
    if (data.containsKey('total_cost_centavos')) {
      context.handle(
          _totalCostCentavosMeta,
          totalCostCentavos.isAcceptableOrUnknown(
              data['total_cost_centavos']!, _totalCostCentavosMeta));
    }
    if (data.containsKey('service_provider')) {
      context.handle(
          _serviceProviderMeta,
          serviceProvider.isAcceptableOrUnknown(
              data['service_provider']!, _serviceProviderMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('voided_at')) {
      context.handle(_voidedAtMeta,
          voidedAt.isAcceptableOrUnknown(data['voided_at']!, _voidedAtMeta));
    }
    if (data.containsKey('supersedes_record_id')) {
      context.handle(
          _supersedesRecordIdMeta,
          supersedesRecordId.isAcceptableOrUnknown(
              data['supersedes_record_id']!, _supersedesRecordIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceRecordRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      motorcycleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}motorcycle_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      performedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}performed_date'])!,
      odometerKm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}odometer_km'])!,
      laborCostCentavos: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}labor_cost_centavos'])!,
      totalCostCentavos: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_cost_centavos'])!,
      serviceProvider: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}service_provider']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      voidedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}voided_at']),
      supersedesRecordId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}supersedes_record_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $MaintenanceRecordsTable createAlias(String alias) {
    return $MaintenanceRecordsTable(attachedDatabase, alias);
  }
}

class MaintenanceRecordRow extends DataClass
    implements Insertable<MaintenanceRecordRow> {
  final int id;
  final int motorcycleId;
  final int itemId;

  /// INSPECTION | CLEANING | ADJUSTMENT | REPLACEMENT | LUBRICATION
  final String action;
  final String performedDate;
  final int odometerKm;
  final int laborCostCentavos;
  final int totalCostCentavos;
  final String? serviceProvider;
  final String? notes;
  final String? voidedAt;

  /// When this record is an edited version, the record it replaces. The old
  /// record is kept (voided) so history is never overwritten.
  final int? supersedesRecordId;
  final String createdAt;
  const MaintenanceRecordRow(
      {required this.id,
      required this.motorcycleId,
      required this.itemId,
      required this.action,
      required this.performedDate,
      required this.odometerKm,
      required this.laborCostCentavos,
      required this.totalCostCentavos,
      this.serviceProvider,
      this.notes,
      this.voidedAt,
      this.supersedesRecordId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['motorcycle_id'] = Variable<int>(motorcycleId);
    map['item_id'] = Variable<int>(itemId);
    map['action'] = Variable<String>(action);
    map['performed_date'] = Variable<String>(performedDate);
    map['odometer_km'] = Variable<int>(odometerKm);
    map['labor_cost_centavos'] = Variable<int>(laborCostCentavos);
    map['total_cost_centavos'] = Variable<int>(totalCostCentavos);
    if (!nullToAbsent || serviceProvider != null) {
      map['service_provider'] = Variable<String>(serviceProvider);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || voidedAt != null) {
      map['voided_at'] = Variable<String>(voidedAt);
    }
    if (!nullToAbsent || supersedesRecordId != null) {
      map['supersedes_record_id'] = Variable<int>(supersedesRecordId);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  MaintenanceRecordsCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceRecordsCompanion(
      id: Value(id),
      motorcycleId: Value(motorcycleId),
      itemId: Value(itemId),
      action: Value(action),
      performedDate: Value(performedDate),
      odometerKm: Value(odometerKm),
      laborCostCentavos: Value(laborCostCentavos),
      totalCostCentavos: Value(totalCostCentavos),
      serviceProvider: serviceProvider == null && nullToAbsent
          ? const Value.absent()
          : Value(serviceProvider),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      voidedAt: voidedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(voidedAt),
      supersedesRecordId: supersedesRecordId == null && nullToAbsent
          ? const Value.absent()
          : Value(supersedesRecordId),
      createdAt: Value(createdAt),
    );
  }

  factory MaintenanceRecordRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceRecordRow(
      id: serializer.fromJson<int>(json['id']),
      motorcycleId: serializer.fromJson<int>(json['motorcycleId']),
      itemId: serializer.fromJson<int>(json['itemId']),
      action: serializer.fromJson<String>(json['action']),
      performedDate: serializer.fromJson<String>(json['performedDate']),
      odometerKm: serializer.fromJson<int>(json['odometerKm']),
      laborCostCentavos: serializer.fromJson<int>(json['laborCostCentavos']),
      totalCostCentavos: serializer.fromJson<int>(json['totalCostCentavos']),
      serviceProvider: serializer.fromJson<String?>(json['serviceProvider']),
      notes: serializer.fromJson<String?>(json['notes']),
      voidedAt: serializer.fromJson<String?>(json['voidedAt']),
      supersedesRecordId: serializer.fromJson<int?>(json['supersedesRecordId']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'motorcycleId': serializer.toJson<int>(motorcycleId),
      'itemId': serializer.toJson<int>(itemId),
      'action': serializer.toJson<String>(action),
      'performedDate': serializer.toJson<String>(performedDate),
      'odometerKm': serializer.toJson<int>(odometerKm),
      'laborCostCentavos': serializer.toJson<int>(laborCostCentavos),
      'totalCostCentavos': serializer.toJson<int>(totalCostCentavos),
      'serviceProvider': serializer.toJson<String?>(serviceProvider),
      'notes': serializer.toJson<String?>(notes),
      'voidedAt': serializer.toJson<String?>(voidedAt),
      'supersedesRecordId': serializer.toJson<int?>(supersedesRecordId),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  MaintenanceRecordRow copyWith(
          {int? id,
          int? motorcycleId,
          int? itemId,
          String? action,
          String? performedDate,
          int? odometerKm,
          int? laborCostCentavos,
          int? totalCostCentavos,
          Value<String?> serviceProvider = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<String?> voidedAt = const Value.absent(),
          Value<int?> supersedesRecordId = const Value.absent(),
          String? createdAt}) =>
      MaintenanceRecordRow(
        id: id ?? this.id,
        motorcycleId: motorcycleId ?? this.motorcycleId,
        itemId: itemId ?? this.itemId,
        action: action ?? this.action,
        performedDate: performedDate ?? this.performedDate,
        odometerKm: odometerKm ?? this.odometerKm,
        laborCostCentavos: laborCostCentavos ?? this.laborCostCentavos,
        totalCostCentavos: totalCostCentavos ?? this.totalCostCentavos,
        serviceProvider: serviceProvider.present
            ? serviceProvider.value
            : this.serviceProvider,
        notes: notes.present ? notes.value : this.notes,
        voidedAt: voidedAt.present ? voidedAt.value : this.voidedAt,
        supersedesRecordId: supersedesRecordId.present
            ? supersedesRecordId.value
            : this.supersedesRecordId,
        createdAt: createdAt ?? this.createdAt,
      );
  MaintenanceRecordRow copyWithCompanion(MaintenanceRecordsCompanion data) {
    return MaintenanceRecordRow(
      id: data.id.present ? data.id.value : this.id,
      motorcycleId: data.motorcycleId.present
          ? data.motorcycleId.value
          : this.motorcycleId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      action: data.action.present ? data.action.value : this.action,
      performedDate: data.performedDate.present
          ? data.performedDate.value
          : this.performedDate,
      odometerKm:
          data.odometerKm.present ? data.odometerKm.value : this.odometerKm,
      laborCostCentavos: data.laborCostCentavos.present
          ? data.laborCostCentavos.value
          : this.laborCostCentavos,
      totalCostCentavos: data.totalCostCentavos.present
          ? data.totalCostCentavos.value
          : this.totalCostCentavos,
      serviceProvider: data.serviceProvider.present
          ? data.serviceProvider.value
          : this.serviceProvider,
      notes: data.notes.present ? data.notes.value : this.notes,
      voidedAt: data.voidedAt.present ? data.voidedAt.value : this.voidedAt,
      supersedesRecordId: data.supersedesRecordId.present
          ? data.supersedesRecordId.value
          : this.supersedesRecordId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceRecordRow(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('itemId: $itemId, ')
          ..write('action: $action, ')
          ..write('performedDate: $performedDate, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('laborCostCentavos: $laborCostCentavos, ')
          ..write('totalCostCentavos: $totalCostCentavos, ')
          ..write('serviceProvider: $serviceProvider, ')
          ..write('notes: $notes, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('supersedesRecordId: $supersedesRecordId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      motorcycleId,
      itemId,
      action,
      performedDate,
      odometerKm,
      laborCostCentavos,
      totalCostCentavos,
      serviceProvider,
      notes,
      voidedAt,
      supersedesRecordId,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceRecordRow &&
          other.id == this.id &&
          other.motorcycleId == this.motorcycleId &&
          other.itemId == this.itemId &&
          other.action == this.action &&
          other.performedDate == this.performedDate &&
          other.odometerKm == this.odometerKm &&
          other.laborCostCentavos == this.laborCostCentavos &&
          other.totalCostCentavos == this.totalCostCentavos &&
          other.serviceProvider == this.serviceProvider &&
          other.notes == this.notes &&
          other.voidedAt == this.voidedAt &&
          other.supersedesRecordId == this.supersedesRecordId &&
          other.createdAt == this.createdAt);
}

class MaintenanceRecordsCompanion
    extends UpdateCompanion<MaintenanceRecordRow> {
  final Value<int> id;
  final Value<int> motorcycleId;
  final Value<int> itemId;
  final Value<String> action;
  final Value<String> performedDate;
  final Value<int> odometerKm;
  final Value<int> laborCostCentavos;
  final Value<int> totalCostCentavos;
  final Value<String?> serviceProvider;
  final Value<String?> notes;
  final Value<String?> voidedAt;
  final Value<int?> supersedesRecordId;
  final Value<String> createdAt;
  const MaintenanceRecordsCompanion({
    this.id = const Value.absent(),
    this.motorcycleId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.action = const Value.absent(),
    this.performedDate = const Value.absent(),
    this.odometerKm = const Value.absent(),
    this.laborCostCentavos = const Value.absent(),
    this.totalCostCentavos = const Value.absent(),
    this.serviceProvider = const Value.absent(),
    this.notes = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.supersedesRecordId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MaintenanceRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int motorcycleId,
    required int itemId,
    required String action,
    required String performedDate,
    required int odometerKm,
    this.laborCostCentavos = const Value.absent(),
    this.totalCostCentavos = const Value.absent(),
    this.serviceProvider = const Value.absent(),
    this.notes = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.supersedesRecordId = const Value.absent(),
    required String createdAt,
  })  : motorcycleId = Value(motorcycleId),
        itemId = Value(itemId),
        action = Value(action),
        performedDate = Value(performedDate),
        odometerKm = Value(odometerKm),
        createdAt = Value(createdAt);
  static Insertable<MaintenanceRecordRow> custom({
    Expression<int>? id,
    Expression<int>? motorcycleId,
    Expression<int>? itemId,
    Expression<String>? action,
    Expression<String>? performedDate,
    Expression<int>? odometerKm,
    Expression<int>? laborCostCentavos,
    Expression<int>? totalCostCentavos,
    Expression<String>? serviceProvider,
    Expression<String>? notes,
    Expression<String>? voidedAt,
    Expression<int>? supersedesRecordId,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (motorcycleId != null) 'motorcycle_id': motorcycleId,
      if (itemId != null) 'item_id': itemId,
      if (action != null) 'action': action,
      if (performedDate != null) 'performed_date': performedDate,
      if (odometerKm != null) 'odometer_km': odometerKm,
      if (laborCostCentavos != null) 'labor_cost_centavos': laborCostCentavos,
      if (totalCostCentavos != null) 'total_cost_centavos': totalCostCentavos,
      if (serviceProvider != null) 'service_provider': serviceProvider,
      if (notes != null) 'notes': notes,
      if (voidedAt != null) 'voided_at': voidedAt,
      if (supersedesRecordId != null)
        'supersedes_record_id': supersedesRecordId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MaintenanceRecordsCompanion copyWith(
      {Value<int>? id,
      Value<int>? motorcycleId,
      Value<int>? itemId,
      Value<String>? action,
      Value<String>? performedDate,
      Value<int>? odometerKm,
      Value<int>? laborCostCentavos,
      Value<int>? totalCostCentavos,
      Value<String?>? serviceProvider,
      Value<String?>? notes,
      Value<String?>? voidedAt,
      Value<int?>? supersedesRecordId,
      Value<String>? createdAt}) {
    return MaintenanceRecordsCompanion(
      id: id ?? this.id,
      motorcycleId: motorcycleId ?? this.motorcycleId,
      itemId: itemId ?? this.itemId,
      action: action ?? this.action,
      performedDate: performedDate ?? this.performedDate,
      odometerKm: odometerKm ?? this.odometerKm,
      laborCostCentavos: laborCostCentavos ?? this.laborCostCentavos,
      totalCostCentavos: totalCostCentavos ?? this.totalCostCentavos,
      serviceProvider: serviceProvider ?? this.serviceProvider,
      notes: notes ?? this.notes,
      voidedAt: voidedAt ?? this.voidedAt,
      supersedesRecordId: supersedesRecordId ?? this.supersedesRecordId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (motorcycleId.present) {
      map['motorcycle_id'] = Variable<int>(motorcycleId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (performedDate.present) {
      map['performed_date'] = Variable<String>(performedDate.value);
    }
    if (odometerKm.present) {
      map['odometer_km'] = Variable<int>(odometerKm.value);
    }
    if (laborCostCentavos.present) {
      map['labor_cost_centavos'] = Variable<int>(laborCostCentavos.value);
    }
    if (totalCostCentavos.present) {
      map['total_cost_centavos'] = Variable<int>(totalCostCentavos.value);
    }
    if (serviceProvider.present) {
      map['service_provider'] = Variable<String>(serviceProvider.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (voidedAt.present) {
      map['voided_at'] = Variable<String>(voidedAt.value);
    }
    if (supersedesRecordId.present) {
      map['supersedes_record_id'] = Variable<int>(supersedesRecordId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('itemId: $itemId, ')
          ..write('action: $action, ')
          ..write('performedDate: $performedDate, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('laborCostCentavos: $laborCostCentavos, ')
          ..write('totalCostCentavos: $totalCostCentavos, ')
          ..write('serviceProvider: $serviceProvider, ')
          ..write('notes: $notes, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('supersedesRecordId: $supersedesRecordId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $OdometerLogsTable extends OdometerLogs
    with TableInfo<$OdometerLogsTable, OdometerLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OdometerLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _motorcycleIdMeta =
      const VerificationMeta('motorcycleId');
  @override
  late final GeneratedColumn<int> motorcycleId = GeneratedColumn<int>(
      'motorcycle_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES motorcycles (id)'));
  static const VerificationMeta _readingKmMeta =
      const VerificationMeta('readingKm');
  @override
  late final GeneratedColumn<int> readingKm = GeneratedColumn<int>(
      'reading_km', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL CHECK (reading_km >= 0)');
  static const VerificationMeta _recordedDateMeta =
      const VerificationMeta('recordedDate');
  @override
  late final GeneratedColumn<String> recordedDate = GeneratedColumn<String>(
      'recorded_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CONFIRMED'));
  static const VerificationMeta _supersedesLogIdMeta =
      const VerificationMeta('supersedesLogId');
  @override
  late final GeneratedColumn<int> supersedesLogId = GeneratedColumn<int>(
      'supersedes_log_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES odometer_logs (id)'));
  static const VerificationMeta _correctionReasonMeta =
      const VerificationMeta('correctionReason');
  @override
  late final GeneratedColumn<String> correctionReason = GeneratedColumn<String>(
      'correction_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        motorcycleId,
        readingKm,
        recordedDate,
        notes,
        status,
        supersedesLogId,
        correctionReason,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'odometer_logs';
  @override
  VerificationContext validateIntegrity(Insertable<OdometerLogRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('motorcycle_id')) {
      context.handle(
          _motorcycleIdMeta,
          motorcycleId.isAcceptableOrUnknown(
              data['motorcycle_id']!, _motorcycleIdMeta));
    } else if (isInserting) {
      context.missing(_motorcycleIdMeta);
    }
    if (data.containsKey('reading_km')) {
      context.handle(_readingKmMeta,
          readingKm.isAcceptableOrUnknown(data['reading_km']!, _readingKmMeta));
    } else if (isInserting) {
      context.missing(_readingKmMeta);
    }
    if (data.containsKey('recorded_date')) {
      context.handle(
          _recordedDateMeta,
          recordedDate.isAcceptableOrUnknown(
              data['recorded_date']!, _recordedDateMeta));
    } else if (isInserting) {
      context.missing(_recordedDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('supersedes_log_id')) {
      context.handle(
          _supersedesLogIdMeta,
          supersedesLogId.isAcceptableOrUnknown(
              data['supersedes_log_id']!, _supersedesLogIdMeta));
    }
    if (data.containsKey('correction_reason')) {
      context.handle(
          _correctionReasonMeta,
          correctionReason.isAcceptableOrUnknown(
              data['correction_reason']!, _correctionReasonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OdometerLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OdometerLogRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      motorcycleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}motorcycle_id'])!,
      readingKm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reading_km'])!,
      recordedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recorded_date'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      supersedesLogId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}supersedes_log_id']),
      correctionReason: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}correction_reason']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $OdometerLogsTable createAlias(String alias) {
    return $OdometerLogsTable(attachedDatabase, alias);
  }
}

class OdometerLogRow extends DataClass implements Insertable<OdometerLogRow> {
  final int id;
  final int motorcycleId;
  final int readingKm;
  final String recordedDate;
  final String? notes;

  /// CONFIRMED | CORRECTED | VOIDED
  final String status;
  final int? supersedesLogId;
  final String? correctionReason;
  final String createdAt;
  const OdometerLogRow(
      {required this.id,
      required this.motorcycleId,
      required this.readingKm,
      required this.recordedDate,
      this.notes,
      required this.status,
      this.supersedesLogId,
      this.correctionReason,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['motorcycle_id'] = Variable<int>(motorcycleId);
    map['reading_km'] = Variable<int>(readingKm);
    map['recorded_date'] = Variable<String>(recordedDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || supersedesLogId != null) {
      map['supersedes_log_id'] = Variable<int>(supersedesLogId);
    }
    if (!nullToAbsent || correctionReason != null) {
      map['correction_reason'] = Variable<String>(correctionReason);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  OdometerLogsCompanion toCompanion(bool nullToAbsent) {
    return OdometerLogsCompanion(
      id: Value(id),
      motorcycleId: Value(motorcycleId),
      readingKm: Value(readingKm),
      recordedDate: Value(recordedDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      status: Value(status),
      supersedesLogId: supersedesLogId == null && nullToAbsent
          ? const Value.absent()
          : Value(supersedesLogId),
      correctionReason: correctionReason == null && nullToAbsent
          ? const Value.absent()
          : Value(correctionReason),
      createdAt: Value(createdAt),
    );
  }

  factory OdometerLogRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OdometerLogRow(
      id: serializer.fromJson<int>(json['id']),
      motorcycleId: serializer.fromJson<int>(json['motorcycleId']),
      readingKm: serializer.fromJson<int>(json['readingKm']),
      recordedDate: serializer.fromJson<String>(json['recordedDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
      supersedesLogId: serializer.fromJson<int?>(json['supersedesLogId']),
      correctionReason: serializer.fromJson<String?>(json['correctionReason']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'motorcycleId': serializer.toJson<int>(motorcycleId),
      'readingKm': serializer.toJson<int>(readingKm),
      'recordedDate': serializer.toJson<String>(recordedDate),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String>(status),
      'supersedesLogId': serializer.toJson<int?>(supersedesLogId),
      'correctionReason': serializer.toJson<String?>(correctionReason),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  OdometerLogRow copyWith(
          {int? id,
          int? motorcycleId,
          int? readingKm,
          String? recordedDate,
          Value<String?> notes = const Value.absent(),
          String? status,
          Value<int?> supersedesLogId = const Value.absent(),
          Value<String?> correctionReason = const Value.absent(),
          String? createdAt}) =>
      OdometerLogRow(
        id: id ?? this.id,
        motorcycleId: motorcycleId ?? this.motorcycleId,
        readingKm: readingKm ?? this.readingKm,
        recordedDate: recordedDate ?? this.recordedDate,
        notes: notes.present ? notes.value : this.notes,
        status: status ?? this.status,
        supersedesLogId: supersedesLogId.present
            ? supersedesLogId.value
            : this.supersedesLogId,
        correctionReason: correctionReason.present
            ? correctionReason.value
            : this.correctionReason,
        createdAt: createdAt ?? this.createdAt,
      );
  OdometerLogRow copyWithCompanion(OdometerLogsCompanion data) {
    return OdometerLogRow(
      id: data.id.present ? data.id.value : this.id,
      motorcycleId: data.motorcycleId.present
          ? data.motorcycleId.value
          : this.motorcycleId,
      readingKm: data.readingKm.present ? data.readingKm.value : this.readingKm,
      recordedDate: data.recordedDate.present
          ? data.recordedDate.value
          : this.recordedDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      supersedesLogId: data.supersedesLogId.present
          ? data.supersedesLogId.value
          : this.supersedesLogId,
      correctionReason: data.correctionReason.present
          ? data.correctionReason.value
          : this.correctionReason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OdometerLogRow(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('readingKm: $readingKm, ')
          ..write('recordedDate: $recordedDate, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('supersedesLogId: $supersedesLogId, ')
          ..write('correctionReason: $correctionReason, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, motorcycleId, readingKm, recordedDate,
      notes, status, supersedesLogId, correctionReason, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OdometerLogRow &&
          other.id == this.id &&
          other.motorcycleId == this.motorcycleId &&
          other.readingKm == this.readingKm &&
          other.recordedDate == this.recordedDate &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.supersedesLogId == this.supersedesLogId &&
          other.correctionReason == this.correctionReason &&
          other.createdAt == this.createdAt);
}

class OdometerLogsCompanion extends UpdateCompanion<OdometerLogRow> {
  final Value<int> id;
  final Value<int> motorcycleId;
  final Value<int> readingKm;
  final Value<String> recordedDate;
  final Value<String?> notes;
  final Value<String> status;
  final Value<int?> supersedesLogId;
  final Value<String?> correctionReason;
  final Value<String> createdAt;
  const OdometerLogsCompanion({
    this.id = const Value.absent(),
    this.motorcycleId = const Value.absent(),
    this.readingKm = const Value.absent(),
    this.recordedDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.supersedesLogId = const Value.absent(),
    this.correctionReason = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OdometerLogsCompanion.insert({
    this.id = const Value.absent(),
    required int motorcycleId,
    required int readingKm,
    required String recordedDate,
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.supersedesLogId = const Value.absent(),
    this.correctionReason = const Value.absent(),
    required String createdAt,
  })  : motorcycleId = Value(motorcycleId),
        readingKm = Value(readingKm),
        recordedDate = Value(recordedDate),
        createdAt = Value(createdAt);
  static Insertable<OdometerLogRow> custom({
    Expression<int>? id,
    Expression<int>? motorcycleId,
    Expression<int>? readingKm,
    Expression<String>? recordedDate,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<int>? supersedesLogId,
    Expression<String>? correctionReason,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (motorcycleId != null) 'motorcycle_id': motorcycleId,
      if (readingKm != null) 'reading_km': readingKm,
      if (recordedDate != null) 'recorded_date': recordedDate,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (supersedesLogId != null) 'supersedes_log_id': supersedesLogId,
      if (correctionReason != null) 'correction_reason': correctionReason,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OdometerLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? motorcycleId,
      Value<int>? readingKm,
      Value<String>? recordedDate,
      Value<String?>? notes,
      Value<String>? status,
      Value<int?>? supersedesLogId,
      Value<String?>? correctionReason,
      Value<String>? createdAt}) {
    return OdometerLogsCompanion(
      id: id ?? this.id,
      motorcycleId: motorcycleId ?? this.motorcycleId,
      readingKm: readingKm ?? this.readingKm,
      recordedDate: recordedDate ?? this.recordedDate,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      supersedesLogId: supersedesLogId ?? this.supersedesLogId,
      correctionReason: correctionReason ?? this.correctionReason,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (motorcycleId.present) {
      map['motorcycle_id'] = Variable<int>(motorcycleId.value);
    }
    if (readingKm.present) {
      map['reading_km'] = Variable<int>(readingKm.value);
    }
    if (recordedDate.present) {
      map['recorded_date'] = Variable<String>(recordedDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (supersedesLogId.present) {
      map['supersedes_log_id'] = Variable<int>(supersedesLogId.value);
    }
    if (correctionReason.present) {
      map['correction_reason'] = Variable<String>(correctionReason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OdometerLogsCompanion(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('readingKm: $readingKm, ')
          ..write('recordedDate: $recordedDate, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('supersedesLogId: $supersedesLogId, ')
          ..write('correctionReason: $correctionReason, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ComponentMeasurementsTable extends ComponentMeasurements
    with TableInfo<$ComponentMeasurementsTable, ComponentMeasurementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComponentMeasurementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _motorcycleIdMeta =
      const VerificationMeta('motorcycleId');
  @override
  late final GeneratedColumn<int> motorcycleId = GeneratedColumn<int>(
      'motorcycle_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES motorcycles (id)'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES maintenance_items (id)'));
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<int> recordId = GeneratedColumn<int>(
      'record_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES maintenance_records (id)'));
  static const VerificationMeta _measuredDateMeta =
      const VerificationMeta('measuredDate');
  @override
  late final GeneratedColumn<String> measuredDate = GeneratedColumn<String>(
      'measured_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _odometerKmMeta =
      const VerificationMeta('odometerKm');
  @override
  late final GeneratedColumn<int> odometerKm = GeneratedColumn<int>(
      'odometer_km', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _measurementTypeMeta =
      const VerificationMeta('measurementType');
  @override
  late final GeneratedColumn<String> measurementType = GeneratedColumn<String>(
      'measurement_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<String> position = GeneratedColumn<String>(
      'position', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _measurementContextMeta =
      const VerificationMeta('measurementContext');
  @override
  late final GeneratedColumn<String> measurementContext =
      GeneratedColumn<String>('measurement_context', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _partNumberMeta =
      const VerificationMeta('partNumber');
  @override
  late final GeneratedColumn<String> partNumber = GeneratedColumn<String>(
      'part_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _visualConditionMeta =
      const VerificationMeta('visualCondition');
  @override
  late final GeneratedColumn<String> visualCondition = GeneratedColumn<String>(
      'visual_condition', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hasDamageMeta =
      const VerificationMeta('hasDamage');
  @override
  late final GeneratedColumn<bool> hasDamage = GeneratedColumn<bool>(
      'has_damage', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("has_damage" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _voidedAtMeta =
      const VerificationMeta('voidedAt');
  @override
  late final GeneratedColumn<String> voidedAt = GeneratedColumn<String>(
      'voided_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        motorcycleId,
        itemId,
        recordId,
        measuredDate,
        odometerKm,
        measurementType,
        value,
        unit,
        position,
        measurementContext,
        brand,
        partNumber,
        visualCondition,
        hasDamage,
        notes,
        voidedAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'component_measurements';
  @override
  VerificationContext validateIntegrity(
      Insertable<ComponentMeasurementRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('motorcycle_id')) {
      context.handle(
          _motorcycleIdMeta,
          motorcycleId.isAcceptableOrUnknown(
              data['motorcycle_id']!, _motorcycleIdMeta));
    } else if (isInserting) {
      context.missing(_motorcycleIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    }
    if (data.containsKey('measured_date')) {
      context.handle(
          _measuredDateMeta,
          measuredDate.isAcceptableOrUnknown(
              data['measured_date']!, _measuredDateMeta));
    } else if (isInserting) {
      context.missing(_measuredDateMeta);
    }
    if (data.containsKey('odometer_km')) {
      context.handle(
          _odometerKmMeta,
          odometerKm.isAcceptableOrUnknown(
              data['odometer_km']!, _odometerKmMeta));
    }
    if (data.containsKey('measurement_type')) {
      context.handle(
          _measurementTypeMeta,
          measurementType.isAcceptableOrUnknown(
              data['measurement_type']!, _measurementTypeMeta));
    } else if (isInserting) {
      context.missing(_measurementTypeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    }
    if (data.containsKey('measurement_context')) {
      context.handle(
          _measurementContextMeta,
          measurementContext.isAcceptableOrUnknown(
              data['measurement_context']!, _measurementContextMeta));
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    }
    if (data.containsKey('part_number')) {
      context.handle(
          _partNumberMeta,
          partNumber.isAcceptableOrUnknown(
              data['part_number']!, _partNumberMeta));
    }
    if (data.containsKey('visual_condition')) {
      context.handle(
          _visualConditionMeta,
          visualCondition.isAcceptableOrUnknown(
              data['visual_condition']!, _visualConditionMeta));
    }
    if (data.containsKey('has_damage')) {
      context.handle(_hasDamageMeta,
          hasDamage.isAcceptableOrUnknown(data['has_damage']!, _hasDamageMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('voided_at')) {
      context.handle(_voidedAtMeta,
          voidedAt.isAcceptableOrUnknown(data['voided_at']!, _voidedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ComponentMeasurementRow map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ComponentMeasurementRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      motorcycleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}motorcycle_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}record_id']),
      measuredDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}measured_date'])!,
      odometerKm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}odometer_km']),
      measurementType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}measurement_type'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}position']),
      measurementContext: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}measurement_context']),
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand']),
      partNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}part_number']),
      visualCondition: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}visual_condition']),
      hasDamage: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_damage'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      voidedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}voided_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ComponentMeasurementsTable createAlias(String alias) {
    return $ComponentMeasurementsTable(attachedDatabase, alias);
  }
}

class ComponentMeasurementRow extends DataClass
    implements Insertable<ComponentMeasurementRow> {
  final int id;
  final int motorcycleId;
  final int itemId;
  final int? recordId;
  final String measuredDate;
  final int? odometerKm;

  /// e.g. THICKNESS_MM, VOLTAGE_V, PRESSURE_KPA, TREAD_DEPTH_MM
  final String measurementType;

  /// Null for condition-only observations (no numeric reading).
  final double? value;
  final String unit;

  /// FRONT | REAR (nullable when not applicable)
  final String? position;

  /// e.g. ENGINE_OFF | ENGINE_RUNNING | CHARGING for battery readings
  final String? measurementContext;
  final String? brand;
  final String? partNumber;
  final String? visualCondition;
  final bool hasDamage;
  final String? notes;

  /// Soft delete: measurements are never physically removed.
  final String? voidedAt;
  final String createdAt;
  const ComponentMeasurementRow(
      {required this.id,
      required this.motorcycleId,
      required this.itemId,
      this.recordId,
      required this.measuredDate,
      this.odometerKm,
      required this.measurementType,
      this.value,
      required this.unit,
      this.position,
      this.measurementContext,
      this.brand,
      this.partNumber,
      this.visualCondition,
      required this.hasDamage,
      this.notes,
      this.voidedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['motorcycle_id'] = Variable<int>(motorcycleId);
    map['item_id'] = Variable<int>(itemId);
    if (!nullToAbsent || recordId != null) {
      map['record_id'] = Variable<int>(recordId);
    }
    map['measured_date'] = Variable<String>(measuredDate);
    if (!nullToAbsent || odometerKm != null) {
      map['odometer_km'] = Variable<int>(odometerKm);
    }
    map['measurement_type'] = Variable<String>(measurementType);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<double>(value);
    }
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || position != null) {
      map['position'] = Variable<String>(position);
    }
    if (!nullToAbsent || measurementContext != null) {
      map['measurement_context'] = Variable<String>(measurementContext);
    }
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || partNumber != null) {
      map['part_number'] = Variable<String>(partNumber);
    }
    if (!nullToAbsent || visualCondition != null) {
      map['visual_condition'] = Variable<String>(visualCondition);
    }
    map['has_damage'] = Variable<bool>(hasDamage);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || voidedAt != null) {
      map['voided_at'] = Variable<String>(voidedAt);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  ComponentMeasurementsCompanion toCompanion(bool nullToAbsent) {
    return ComponentMeasurementsCompanion(
      id: Value(id),
      motorcycleId: Value(motorcycleId),
      itemId: Value(itemId),
      recordId: recordId == null && nullToAbsent
          ? const Value.absent()
          : Value(recordId),
      measuredDate: Value(measuredDate),
      odometerKm: odometerKm == null && nullToAbsent
          ? const Value.absent()
          : Value(odometerKm),
      measurementType: Value(measurementType),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      unit: Value(unit),
      position: position == null && nullToAbsent
          ? const Value.absent()
          : Value(position),
      measurementContext: measurementContext == null && nullToAbsent
          ? const Value.absent()
          : Value(measurementContext),
      brand:
          brand == null && nullToAbsent ? const Value.absent() : Value(brand),
      partNumber: partNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(partNumber),
      visualCondition: visualCondition == null && nullToAbsent
          ? const Value.absent()
          : Value(visualCondition),
      hasDamage: Value(hasDamage),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      voidedAt: voidedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(voidedAt),
      createdAt: Value(createdAt),
    );
  }

  factory ComponentMeasurementRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ComponentMeasurementRow(
      id: serializer.fromJson<int>(json['id']),
      motorcycleId: serializer.fromJson<int>(json['motorcycleId']),
      itemId: serializer.fromJson<int>(json['itemId']),
      recordId: serializer.fromJson<int?>(json['recordId']),
      measuredDate: serializer.fromJson<String>(json['measuredDate']),
      odometerKm: serializer.fromJson<int?>(json['odometerKm']),
      measurementType: serializer.fromJson<String>(json['measurementType']),
      value: serializer.fromJson<double?>(json['value']),
      unit: serializer.fromJson<String>(json['unit']),
      position: serializer.fromJson<String?>(json['position']),
      measurementContext:
          serializer.fromJson<String?>(json['measurementContext']),
      brand: serializer.fromJson<String?>(json['brand']),
      partNumber: serializer.fromJson<String?>(json['partNumber']),
      visualCondition: serializer.fromJson<String?>(json['visualCondition']),
      hasDamage: serializer.fromJson<bool>(json['hasDamage']),
      notes: serializer.fromJson<String?>(json['notes']),
      voidedAt: serializer.fromJson<String?>(json['voidedAt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'motorcycleId': serializer.toJson<int>(motorcycleId),
      'itemId': serializer.toJson<int>(itemId),
      'recordId': serializer.toJson<int?>(recordId),
      'measuredDate': serializer.toJson<String>(measuredDate),
      'odometerKm': serializer.toJson<int?>(odometerKm),
      'measurementType': serializer.toJson<String>(measurementType),
      'value': serializer.toJson<double?>(value),
      'unit': serializer.toJson<String>(unit),
      'position': serializer.toJson<String?>(position),
      'measurementContext': serializer.toJson<String?>(measurementContext),
      'brand': serializer.toJson<String?>(brand),
      'partNumber': serializer.toJson<String?>(partNumber),
      'visualCondition': serializer.toJson<String?>(visualCondition),
      'hasDamage': serializer.toJson<bool>(hasDamage),
      'notes': serializer.toJson<String?>(notes),
      'voidedAt': serializer.toJson<String?>(voidedAt),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  ComponentMeasurementRow copyWith(
          {int? id,
          int? motorcycleId,
          int? itemId,
          Value<int?> recordId = const Value.absent(),
          String? measuredDate,
          Value<int?> odometerKm = const Value.absent(),
          String? measurementType,
          Value<double?> value = const Value.absent(),
          String? unit,
          Value<String?> position = const Value.absent(),
          Value<String?> measurementContext = const Value.absent(),
          Value<String?> brand = const Value.absent(),
          Value<String?> partNumber = const Value.absent(),
          Value<String?> visualCondition = const Value.absent(),
          bool? hasDamage,
          Value<String?> notes = const Value.absent(),
          Value<String?> voidedAt = const Value.absent(),
          String? createdAt}) =>
      ComponentMeasurementRow(
        id: id ?? this.id,
        motorcycleId: motorcycleId ?? this.motorcycleId,
        itemId: itemId ?? this.itemId,
        recordId: recordId.present ? recordId.value : this.recordId,
        measuredDate: measuredDate ?? this.measuredDate,
        odometerKm: odometerKm.present ? odometerKm.value : this.odometerKm,
        measurementType: measurementType ?? this.measurementType,
        value: value.present ? value.value : this.value,
        unit: unit ?? this.unit,
        position: position.present ? position.value : this.position,
        measurementContext: measurementContext.present
            ? measurementContext.value
            : this.measurementContext,
        brand: brand.present ? brand.value : this.brand,
        partNumber: partNumber.present ? partNumber.value : this.partNumber,
        visualCondition: visualCondition.present
            ? visualCondition.value
            : this.visualCondition,
        hasDamage: hasDamage ?? this.hasDamage,
        notes: notes.present ? notes.value : this.notes,
        voidedAt: voidedAt.present ? voidedAt.value : this.voidedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  ComponentMeasurementRow copyWithCompanion(
      ComponentMeasurementsCompanion data) {
    return ComponentMeasurementRow(
      id: data.id.present ? data.id.value : this.id,
      motorcycleId: data.motorcycleId.present
          ? data.motorcycleId.value
          : this.motorcycleId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      measuredDate: data.measuredDate.present
          ? data.measuredDate.value
          : this.measuredDate,
      odometerKm:
          data.odometerKm.present ? data.odometerKm.value : this.odometerKm,
      measurementType: data.measurementType.present
          ? data.measurementType.value
          : this.measurementType,
      value: data.value.present ? data.value.value : this.value,
      unit: data.unit.present ? data.unit.value : this.unit,
      position: data.position.present ? data.position.value : this.position,
      measurementContext: data.measurementContext.present
          ? data.measurementContext.value
          : this.measurementContext,
      brand: data.brand.present ? data.brand.value : this.brand,
      partNumber:
          data.partNumber.present ? data.partNumber.value : this.partNumber,
      visualCondition: data.visualCondition.present
          ? data.visualCondition.value
          : this.visualCondition,
      hasDamage: data.hasDamage.present ? data.hasDamage.value : this.hasDamage,
      notes: data.notes.present ? data.notes.value : this.notes,
      voidedAt: data.voidedAt.present ? data.voidedAt.value : this.voidedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ComponentMeasurementRow(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('itemId: $itemId, ')
          ..write('recordId: $recordId, ')
          ..write('measuredDate: $measuredDate, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('measurementType: $measurementType, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('position: $position, ')
          ..write('measurementContext: $measurementContext, ')
          ..write('brand: $brand, ')
          ..write('partNumber: $partNumber, ')
          ..write('visualCondition: $visualCondition, ')
          ..write('hasDamage: $hasDamage, ')
          ..write('notes: $notes, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      motorcycleId,
      itemId,
      recordId,
      measuredDate,
      odometerKm,
      measurementType,
      value,
      unit,
      position,
      measurementContext,
      brand,
      partNumber,
      visualCondition,
      hasDamage,
      notes,
      voidedAt,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ComponentMeasurementRow &&
          other.id == this.id &&
          other.motorcycleId == this.motorcycleId &&
          other.itemId == this.itemId &&
          other.recordId == this.recordId &&
          other.measuredDate == this.measuredDate &&
          other.odometerKm == this.odometerKm &&
          other.measurementType == this.measurementType &&
          other.value == this.value &&
          other.unit == this.unit &&
          other.position == this.position &&
          other.measurementContext == this.measurementContext &&
          other.brand == this.brand &&
          other.partNumber == this.partNumber &&
          other.visualCondition == this.visualCondition &&
          other.hasDamage == this.hasDamage &&
          other.notes == this.notes &&
          other.voidedAt == this.voidedAt &&
          other.createdAt == this.createdAt);
}

class ComponentMeasurementsCompanion
    extends UpdateCompanion<ComponentMeasurementRow> {
  final Value<int> id;
  final Value<int> motorcycleId;
  final Value<int> itemId;
  final Value<int?> recordId;
  final Value<String> measuredDate;
  final Value<int?> odometerKm;
  final Value<String> measurementType;
  final Value<double?> value;
  final Value<String> unit;
  final Value<String?> position;
  final Value<String?> measurementContext;
  final Value<String?> brand;
  final Value<String?> partNumber;
  final Value<String?> visualCondition;
  final Value<bool> hasDamage;
  final Value<String?> notes;
  final Value<String?> voidedAt;
  final Value<String> createdAt;
  const ComponentMeasurementsCompanion({
    this.id = const Value.absent(),
    this.motorcycleId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.recordId = const Value.absent(),
    this.measuredDate = const Value.absent(),
    this.odometerKm = const Value.absent(),
    this.measurementType = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.position = const Value.absent(),
    this.measurementContext = const Value.absent(),
    this.brand = const Value.absent(),
    this.partNumber = const Value.absent(),
    this.visualCondition = const Value.absent(),
    this.hasDamage = const Value.absent(),
    this.notes = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ComponentMeasurementsCompanion.insert({
    this.id = const Value.absent(),
    required int motorcycleId,
    required int itemId,
    this.recordId = const Value.absent(),
    required String measuredDate,
    this.odometerKm = const Value.absent(),
    required String measurementType,
    this.value = const Value.absent(),
    required String unit,
    this.position = const Value.absent(),
    this.measurementContext = const Value.absent(),
    this.brand = const Value.absent(),
    this.partNumber = const Value.absent(),
    this.visualCondition = const Value.absent(),
    this.hasDamage = const Value.absent(),
    this.notes = const Value.absent(),
    this.voidedAt = const Value.absent(),
    required String createdAt,
  })  : motorcycleId = Value(motorcycleId),
        itemId = Value(itemId),
        measuredDate = Value(measuredDate),
        measurementType = Value(measurementType),
        unit = Value(unit),
        createdAt = Value(createdAt);
  static Insertable<ComponentMeasurementRow> custom({
    Expression<int>? id,
    Expression<int>? motorcycleId,
    Expression<int>? itemId,
    Expression<int>? recordId,
    Expression<String>? measuredDate,
    Expression<int>? odometerKm,
    Expression<String>? measurementType,
    Expression<double>? value,
    Expression<String>? unit,
    Expression<String>? position,
    Expression<String>? measurementContext,
    Expression<String>? brand,
    Expression<String>? partNumber,
    Expression<String>? visualCondition,
    Expression<bool>? hasDamage,
    Expression<String>? notes,
    Expression<String>? voidedAt,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (motorcycleId != null) 'motorcycle_id': motorcycleId,
      if (itemId != null) 'item_id': itemId,
      if (recordId != null) 'record_id': recordId,
      if (measuredDate != null) 'measured_date': measuredDate,
      if (odometerKm != null) 'odometer_km': odometerKm,
      if (measurementType != null) 'measurement_type': measurementType,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (position != null) 'position': position,
      if (measurementContext != null) 'measurement_context': measurementContext,
      if (brand != null) 'brand': brand,
      if (partNumber != null) 'part_number': partNumber,
      if (visualCondition != null) 'visual_condition': visualCondition,
      if (hasDamage != null) 'has_damage': hasDamage,
      if (notes != null) 'notes': notes,
      if (voidedAt != null) 'voided_at': voidedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ComponentMeasurementsCompanion copyWith(
      {Value<int>? id,
      Value<int>? motorcycleId,
      Value<int>? itemId,
      Value<int?>? recordId,
      Value<String>? measuredDate,
      Value<int?>? odometerKm,
      Value<String>? measurementType,
      Value<double?>? value,
      Value<String>? unit,
      Value<String?>? position,
      Value<String?>? measurementContext,
      Value<String?>? brand,
      Value<String?>? partNumber,
      Value<String?>? visualCondition,
      Value<bool>? hasDamage,
      Value<String?>? notes,
      Value<String?>? voidedAt,
      Value<String>? createdAt}) {
    return ComponentMeasurementsCompanion(
      id: id ?? this.id,
      motorcycleId: motorcycleId ?? this.motorcycleId,
      itemId: itemId ?? this.itemId,
      recordId: recordId ?? this.recordId,
      measuredDate: measuredDate ?? this.measuredDate,
      odometerKm: odometerKm ?? this.odometerKm,
      measurementType: measurementType ?? this.measurementType,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      position: position ?? this.position,
      measurementContext: measurementContext ?? this.measurementContext,
      brand: brand ?? this.brand,
      partNumber: partNumber ?? this.partNumber,
      visualCondition: visualCondition ?? this.visualCondition,
      hasDamage: hasDamage ?? this.hasDamage,
      notes: notes ?? this.notes,
      voidedAt: voidedAt ?? this.voidedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (motorcycleId.present) {
      map['motorcycle_id'] = Variable<int>(motorcycleId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<int>(recordId.value);
    }
    if (measuredDate.present) {
      map['measured_date'] = Variable<String>(measuredDate.value);
    }
    if (odometerKm.present) {
      map['odometer_km'] = Variable<int>(odometerKm.value);
    }
    if (measurementType.present) {
      map['measurement_type'] = Variable<String>(measurementType.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(position.value);
    }
    if (measurementContext.present) {
      map['measurement_context'] = Variable<String>(measurementContext.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (partNumber.present) {
      map['part_number'] = Variable<String>(partNumber.value);
    }
    if (visualCondition.present) {
      map['visual_condition'] = Variable<String>(visualCondition.value);
    }
    if (hasDamage.present) {
      map['has_damage'] = Variable<bool>(hasDamage.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (voidedAt.present) {
      map['voided_at'] = Variable<String>(voidedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComponentMeasurementsCompanion(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('itemId: $itemId, ')
          ..write('recordId: $recordId, ')
          ..write('measuredDate: $measuredDate, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('measurementType: $measurementType, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('position: $position, ')
          ..write('measurementContext: $measurementContext, ')
          ..write('brand: $brand, ')
          ..write('partNumber: $partNumber, ')
          ..write('visualCondition: $visualCondition, ')
          ..write('hasDamage: $hasDamage, ')
          ..write('notes: $notes, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ComponentSpecsTable extends ComponentSpecs
    with TableInfo<$ComponentSpecsTable, ComponentSpecRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComponentSpecsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _specKeyMeta =
      const VerificationMeta('specKey');
  @override
  late final GeneratedColumn<String> specKey = GeneratedColumn<String>(
      'spec_key', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES maintenance_items (id)'));
  static const VerificationMeta _customStandardValueMeta =
      const VerificationMeta('customStandardValue');
  @override
  late final GeneratedColumn<double> customStandardValue =
      GeneratedColumn<double>('custom_standard_value', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _customServiceLimitMeta =
      const VerificationMeta('customServiceLimit');
  @override
  late final GeneratedColumn<double> customServiceLimit =
      GeneratedColumn<double>('custom_service_limit', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('mm'));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        specKey,
        itemId,
        customStandardValue,
        customServiceLimit,
        unit,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'component_specs';
  @override
  VerificationContext validateIntegrity(Insertable<ComponentSpecRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('spec_key')) {
      context.handle(_specKeyMeta,
          specKey.isAcceptableOrUnknown(data['spec_key']!, _specKeyMeta));
    } else if (isInserting) {
      context.missing(_specKeyMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('custom_standard_value')) {
      context.handle(
          _customStandardValueMeta,
          customStandardValue.isAcceptableOrUnknown(
              data['custom_standard_value']!, _customStandardValueMeta));
    }
    if (data.containsKey('custom_service_limit')) {
      context.handle(
          _customServiceLimitMeta,
          customServiceLimit.isAcceptableOrUnknown(
              data['custom_service_limit']!, _customServiceLimitMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ComponentSpecRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ComponentSpecRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      specKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}spec_key'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      customStandardValue: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}custom_standard_value']),
      customServiceLimit: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}custom_service_limit']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ComponentSpecsTable createAlias(String alias) {
    return $ComponentSpecsTable(attachedDatabase, alias);
  }
}

class ComponentSpecRow extends DataClass
    implements Insertable<ComponentSpecRow> {
  final int id;
  final String specKey;
  final int itemId;
  final double? customStandardValue;
  final double? customServiceLimit;
  final String unit;
  final String updatedAt;
  const ComponentSpecRow(
      {required this.id,
      required this.specKey,
      required this.itemId,
      this.customStandardValue,
      this.customServiceLimit,
      required this.unit,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['spec_key'] = Variable<String>(specKey);
    map['item_id'] = Variable<int>(itemId);
    if (!nullToAbsent || customStandardValue != null) {
      map['custom_standard_value'] = Variable<double>(customStandardValue);
    }
    if (!nullToAbsent || customServiceLimit != null) {
      map['custom_service_limit'] = Variable<double>(customServiceLimit);
    }
    map['unit'] = Variable<String>(unit);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  ComponentSpecsCompanion toCompanion(bool nullToAbsent) {
    return ComponentSpecsCompanion(
      id: Value(id),
      specKey: Value(specKey),
      itemId: Value(itemId),
      customStandardValue: customStandardValue == null && nullToAbsent
          ? const Value.absent()
          : Value(customStandardValue),
      customServiceLimit: customServiceLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(customServiceLimit),
      unit: Value(unit),
      updatedAt: Value(updatedAt),
    );
  }

  factory ComponentSpecRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ComponentSpecRow(
      id: serializer.fromJson<int>(json['id']),
      specKey: serializer.fromJson<String>(json['specKey']),
      itemId: serializer.fromJson<int>(json['itemId']),
      customStandardValue:
          serializer.fromJson<double?>(json['customStandardValue']),
      customServiceLimit:
          serializer.fromJson<double?>(json['customServiceLimit']),
      unit: serializer.fromJson<String>(json['unit']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'specKey': serializer.toJson<String>(specKey),
      'itemId': serializer.toJson<int>(itemId),
      'customStandardValue': serializer.toJson<double?>(customStandardValue),
      'customServiceLimit': serializer.toJson<double?>(customServiceLimit),
      'unit': serializer.toJson<String>(unit),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  ComponentSpecRow copyWith(
          {int? id,
          String? specKey,
          int? itemId,
          Value<double?> customStandardValue = const Value.absent(),
          Value<double?> customServiceLimit = const Value.absent(),
          String? unit,
          String? updatedAt}) =>
      ComponentSpecRow(
        id: id ?? this.id,
        specKey: specKey ?? this.specKey,
        itemId: itemId ?? this.itemId,
        customStandardValue: customStandardValue.present
            ? customStandardValue.value
            : this.customStandardValue,
        customServiceLimit: customServiceLimit.present
            ? customServiceLimit.value
            : this.customServiceLimit,
        unit: unit ?? this.unit,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ComponentSpecRow copyWithCompanion(ComponentSpecsCompanion data) {
    return ComponentSpecRow(
      id: data.id.present ? data.id.value : this.id,
      specKey: data.specKey.present ? data.specKey.value : this.specKey,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      customStandardValue: data.customStandardValue.present
          ? data.customStandardValue.value
          : this.customStandardValue,
      customServiceLimit: data.customServiceLimit.present
          ? data.customServiceLimit.value
          : this.customServiceLimit,
      unit: data.unit.present ? data.unit.value : this.unit,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ComponentSpecRow(')
          ..write('id: $id, ')
          ..write('specKey: $specKey, ')
          ..write('itemId: $itemId, ')
          ..write('customStandardValue: $customStandardValue, ')
          ..write('customServiceLimit: $customServiceLimit, ')
          ..write('unit: $unit, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, specKey, itemId, customStandardValue,
      customServiceLimit, unit, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ComponentSpecRow &&
          other.id == this.id &&
          other.specKey == this.specKey &&
          other.itemId == this.itemId &&
          other.customStandardValue == this.customStandardValue &&
          other.customServiceLimit == this.customServiceLimit &&
          other.unit == this.unit &&
          other.updatedAt == this.updatedAt);
}

class ComponentSpecsCompanion extends UpdateCompanion<ComponentSpecRow> {
  final Value<int> id;
  final Value<String> specKey;
  final Value<int> itemId;
  final Value<double?> customStandardValue;
  final Value<double?> customServiceLimit;
  final Value<String> unit;
  final Value<String> updatedAt;
  const ComponentSpecsCompanion({
    this.id = const Value.absent(),
    this.specKey = const Value.absent(),
    this.itemId = const Value.absent(),
    this.customStandardValue = const Value.absent(),
    this.customServiceLimit = const Value.absent(),
    this.unit = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ComponentSpecsCompanion.insert({
    this.id = const Value.absent(),
    required String specKey,
    required int itemId,
    this.customStandardValue = const Value.absent(),
    this.customServiceLimit = const Value.absent(),
    this.unit = const Value.absent(),
    required String updatedAt,
  })  : specKey = Value(specKey),
        itemId = Value(itemId),
        updatedAt = Value(updatedAt);
  static Insertable<ComponentSpecRow> custom({
    Expression<int>? id,
    Expression<String>? specKey,
    Expression<int>? itemId,
    Expression<double>? customStandardValue,
    Expression<double>? customServiceLimit,
    Expression<String>? unit,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (specKey != null) 'spec_key': specKey,
      if (itemId != null) 'item_id': itemId,
      if (customStandardValue != null)
        'custom_standard_value': customStandardValue,
      if (customServiceLimit != null)
        'custom_service_limit': customServiceLimit,
      if (unit != null) 'unit': unit,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ComponentSpecsCompanion copyWith(
      {Value<int>? id,
      Value<String>? specKey,
      Value<int>? itemId,
      Value<double?>? customStandardValue,
      Value<double?>? customServiceLimit,
      Value<String>? unit,
      Value<String>? updatedAt}) {
    return ComponentSpecsCompanion(
      id: id ?? this.id,
      specKey: specKey ?? this.specKey,
      itemId: itemId ?? this.itemId,
      customStandardValue: customStandardValue ?? this.customStandardValue,
      customServiceLimit: customServiceLimit ?? this.customServiceLimit,
      unit: unit ?? this.unit,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (specKey.present) {
      map['spec_key'] = Variable<String>(specKey.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (customStandardValue.present) {
      map['custom_standard_value'] =
          Variable<double>(customStandardValue.value);
    }
    if (customServiceLimit.present) {
      map['custom_service_limit'] = Variable<double>(customServiceLimit.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComponentSpecsCompanion(')
          ..write('id: $id, ')
          ..write('specKey: $specKey, ')
          ..write('itemId: $itemId, ')
          ..write('customStandardValue: $customStandardValue, ')
          ..write('customServiceLimit: $customServiceLimit, ')
          ..write('unit: $unit, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PartsTable extends Parts with TableInfo<$PartsTable, PartRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES maintenance_items (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _partNumberMeta =
      const VerificationMeta('partNumber');
  @override
  late final GeneratedColumn<String> partNumber = GeneratedColumn<String>(
      'part_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _specificationMeta =
      const VerificationMeta('specification');
  @override
  late final GeneratedColumn<String> specification = GeneratedColumn<String>(
      'specification', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purchasePriceCentavosMeta =
      const VerificationMeta('purchasePriceCentavos');
  @override
  late final GeneratedColumn<int> purchasePriceCentavos = GeneratedColumn<int>(
      'purchase_price_centavos', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _purchaseDateMeta =
      const VerificationMeta('purchaseDate');
  @override
  late final GeneratedColumn<String> purchaseDate = GeneratedColumn<String>(
      'purchase_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _supplierMeta =
      const VerificationMeta('supplier');
  @override
  late final GeneratedColumn<String> supplier = GeneratedColumn<String>(
      'supplier', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        itemId,
        name,
        brand,
        partNumber,
        specification,
        purchasePriceCentavos,
        purchaseDate,
        supplier,
        quantity,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parts';
  @override
  VerificationContext validateIntegrity(Insertable<PartRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    }
    if (data.containsKey('part_number')) {
      context.handle(
          _partNumberMeta,
          partNumber.isAcceptableOrUnknown(
              data['part_number']!, _partNumberMeta));
    }
    if (data.containsKey('specification')) {
      context.handle(
          _specificationMeta,
          specification.isAcceptableOrUnknown(
              data['specification']!, _specificationMeta));
    }
    if (data.containsKey('purchase_price_centavos')) {
      context.handle(
          _purchasePriceCentavosMeta,
          purchasePriceCentavos.isAcceptableOrUnknown(
              data['purchase_price_centavos']!, _purchasePriceCentavosMeta));
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
          _purchaseDateMeta,
          purchaseDate.isAcceptableOrUnknown(
              data['purchase_date']!, _purchaseDateMeta));
    }
    if (data.containsKey('supplier')) {
      context.handle(_supplierMeta,
          supplier.isAcceptableOrUnknown(data['supplier']!, _supplierMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand']),
      partNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}part_number']),
      specification: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}specification']),
      purchasePriceCentavos: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}purchase_price_centavos'])!,
      purchaseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purchase_date']),
      supplier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PartsTable createAlias(String alias) {
    return $PartsTable(attachedDatabase, alias);
  }
}

class PartRow extends DataClass implements Insertable<PartRow> {
  final int id;
  final int? itemId;
  final String name;
  final String? brand;
  final String? partNumber;
  final String? specification;
  final int purchasePriceCentavos;
  final String? purchaseDate;
  final String? supplier;
  final int quantity;
  final String createdAt;
  const PartRow(
      {required this.id,
      this.itemId,
      required this.name,
      this.brand,
      this.partNumber,
      this.specification,
      required this.purchasePriceCentavos,
      this.purchaseDate,
      this.supplier,
      required this.quantity,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || itemId != null) {
      map['item_id'] = Variable<int>(itemId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || partNumber != null) {
      map['part_number'] = Variable<String>(partNumber);
    }
    if (!nullToAbsent || specification != null) {
      map['specification'] = Variable<String>(specification);
    }
    map['purchase_price_centavos'] = Variable<int>(purchasePriceCentavos);
    if (!nullToAbsent || purchaseDate != null) {
      map['purchase_date'] = Variable<String>(purchaseDate);
    }
    if (!nullToAbsent || supplier != null) {
      map['supplier'] = Variable<String>(supplier);
    }
    map['quantity'] = Variable<int>(quantity);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  PartsCompanion toCompanion(bool nullToAbsent) {
    return PartsCompanion(
      id: Value(id),
      itemId:
          itemId == null && nullToAbsent ? const Value.absent() : Value(itemId),
      name: Value(name),
      brand:
          brand == null && nullToAbsent ? const Value.absent() : Value(brand),
      partNumber: partNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(partNumber),
      specification: specification == null && nullToAbsent
          ? const Value.absent()
          : Value(specification),
      purchasePriceCentavos: Value(purchasePriceCentavos),
      purchaseDate: purchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseDate),
      supplier: supplier == null && nullToAbsent
          ? const Value.absent()
          : Value(supplier),
      quantity: Value(quantity),
      createdAt: Value(createdAt),
    );
  }

  factory PartRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartRow(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int?>(json['itemId']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      partNumber: serializer.fromJson<String?>(json['partNumber']),
      specification: serializer.fromJson<String?>(json['specification']),
      purchasePriceCentavos:
          serializer.fromJson<int>(json['purchasePriceCentavos']),
      purchaseDate: serializer.fromJson<String?>(json['purchaseDate']),
      supplier: serializer.fromJson<String?>(json['supplier']),
      quantity: serializer.fromJson<int>(json['quantity']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int?>(itemId),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'partNumber': serializer.toJson<String?>(partNumber),
      'specification': serializer.toJson<String?>(specification),
      'purchasePriceCentavos': serializer.toJson<int>(purchasePriceCentavos),
      'purchaseDate': serializer.toJson<String?>(purchaseDate),
      'supplier': serializer.toJson<String?>(supplier),
      'quantity': serializer.toJson<int>(quantity),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  PartRow copyWith(
          {int? id,
          Value<int?> itemId = const Value.absent(),
          String? name,
          Value<String?> brand = const Value.absent(),
          Value<String?> partNumber = const Value.absent(),
          Value<String?> specification = const Value.absent(),
          int? purchasePriceCentavos,
          Value<String?> purchaseDate = const Value.absent(),
          Value<String?> supplier = const Value.absent(),
          int? quantity,
          String? createdAt}) =>
      PartRow(
        id: id ?? this.id,
        itemId: itemId.present ? itemId.value : this.itemId,
        name: name ?? this.name,
        brand: brand.present ? brand.value : this.brand,
        partNumber: partNumber.present ? partNumber.value : this.partNumber,
        specification:
            specification.present ? specification.value : this.specification,
        purchasePriceCentavos:
            purchasePriceCentavos ?? this.purchasePriceCentavos,
        purchaseDate:
            purchaseDate.present ? purchaseDate.value : this.purchaseDate,
        supplier: supplier.present ? supplier.value : this.supplier,
        quantity: quantity ?? this.quantity,
        createdAt: createdAt ?? this.createdAt,
      );
  PartRow copyWithCompanion(PartsCompanion data) {
    return PartRow(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      partNumber:
          data.partNumber.present ? data.partNumber.value : this.partNumber,
      specification: data.specification.present
          ? data.specification.value
          : this.specification,
      purchasePriceCentavos: data.purchasePriceCentavos.present
          ? data.purchasePriceCentavos.value
          : this.purchasePriceCentavos,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      supplier: data.supplier.present ? data.supplier.value : this.supplier,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartRow(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('partNumber: $partNumber, ')
          ..write('specification: $specification, ')
          ..write('purchasePriceCentavos: $purchasePriceCentavos, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('supplier: $supplier, ')
          ..write('quantity: $quantity, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      itemId,
      name,
      brand,
      partNumber,
      specification,
      purchasePriceCentavos,
      purchaseDate,
      supplier,
      quantity,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartRow &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.partNumber == this.partNumber &&
          other.specification == this.specification &&
          other.purchasePriceCentavos == this.purchasePriceCentavos &&
          other.purchaseDate == this.purchaseDate &&
          other.supplier == this.supplier &&
          other.quantity == this.quantity &&
          other.createdAt == this.createdAt);
}

class PartsCompanion extends UpdateCompanion<PartRow> {
  final Value<int> id;
  final Value<int?> itemId;
  final Value<String> name;
  final Value<String?> brand;
  final Value<String?> partNumber;
  final Value<String?> specification;
  final Value<int> purchasePriceCentavos;
  final Value<String?> purchaseDate;
  final Value<String?> supplier;
  final Value<int> quantity;
  final Value<String> createdAt;
  const PartsCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.partNumber = const Value.absent(),
    this.specification = const Value.absent(),
    this.purchasePriceCentavos = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.supplier = const Value.absent(),
    this.quantity = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PartsCompanion.insert({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    required String name,
    this.brand = const Value.absent(),
    this.partNumber = const Value.absent(),
    this.specification = const Value.absent(),
    this.purchasePriceCentavos = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.supplier = const Value.absent(),
    this.quantity = const Value.absent(),
    required String createdAt,
  })  : name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<PartRow> custom({
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? partNumber,
    Expression<String>? specification,
    Expression<int>? purchasePriceCentavos,
    Expression<String>? purchaseDate,
    Expression<String>? supplier,
    Expression<int>? quantity,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (partNumber != null) 'part_number': partNumber,
      if (specification != null) 'specification': specification,
      if (purchasePriceCentavos != null)
        'purchase_price_centavos': purchasePriceCentavos,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (supplier != null) 'supplier': supplier,
      if (quantity != null) 'quantity': quantity,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PartsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? itemId,
      Value<String>? name,
      Value<String?>? brand,
      Value<String?>? partNumber,
      Value<String?>? specification,
      Value<int>? purchasePriceCentavos,
      Value<String?>? purchaseDate,
      Value<String?>? supplier,
      Value<int>? quantity,
      Value<String>? createdAt}) {
    return PartsCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      partNumber: partNumber ?? this.partNumber,
      specification: specification ?? this.specification,
      purchasePriceCentavos:
          purchasePriceCentavos ?? this.purchasePriceCentavos,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      supplier: supplier ?? this.supplier,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (partNumber.present) {
      map['part_number'] = Variable<String>(partNumber.value);
    }
    if (specification.present) {
      map['specification'] = Variable<String>(specification.value);
    }
    if (purchasePriceCentavos.present) {
      map['purchase_price_centavos'] =
          Variable<int>(purchasePriceCentavos.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<String>(purchaseDate.value);
    }
    if (supplier.present) {
      map['supplier'] = Variable<String>(supplier.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartsCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('partNumber: $partNumber, ')
          ..write('specification: $specification, ')
          ..write('purchasePriceCentavos: $purchasePriceCentavos, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('supplier: $supplier, ')
          ..write('quantity: $quantity, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceRecordPartsTable extends MaintenanceRecordParts
    with TableInfo<$MaintenanceRecordPartsTable, MaintenanceRecordPartRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceRecordPartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<int> recordId = GeneratedColumn<int>(
      'record_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES maintenance_records (id)'));
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<int> partId = GeneratedColumn<int>(
      'part_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES parts (id)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _unitCostCentavosMeta =
      const VerificationMeta('unitCostCentavos');
  @override
  late final GeneratedColumn<int> unitCostCentavos = GeneratedColumn<int>(
      'unit_cost_centavos', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, recordId, partId, quantity, unitCostCentavos];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_record_parts';
  @override
  VerificationContext validateIntegrity(
      Insertable<MaintenanceRecordPartRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('part_id')) {
      context.handle(_partIdMeta,
          partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta));
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('unit_cost_centavos')) {
      context.handle(
          _unitCostCentavosMeta,
          unitCostCentavos.isAcceptableOrUnknown(
              data['unit_cost_centavos']!, _unitCostCentavosMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceRecordPartRow map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceRecordPartRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}record_id'])!,
      partId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}part_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      unitCostCentavos: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}unit_cost_centavos'])!,
    );
  }

  @override
  $MaintenanceRecordPartsTable createAlias(String alias) {
    return $MaintenanceRecordPartsTable(attachedDatabase, alias);
  }
}

class MaintenanceRecordPartRow extends DataClass
    implements Insertable<MaintenanceRecordPartRow> {
  final int id;
  final int recordId;
  final int partId;
  final int quantity;
  final int unitCostCentavos;
  const MaintenanceRecordPartRow(
      {required this.id,
      required this.recordId,
      required this.partId,
      required this.quantity,
      required this.unitCostCentavos});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_id'] = Variable<int>(recordId);
    map['part_id'] = Variable<int>(partId);
    map['quantity'] = Variable<int>(quantity);
    map['unit_cost_centavos'] = Variable<int>(unitCostCentavos);
    return map;
  }

  MaintenanceRecordPartsCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceRecordPartsCompanion(
      id: Value(id),
      recordId: Value(recordId),
      partId: Value(partId),
      quantity: Value(quantity),
      unitCostCentavos: Value(unitCostCentavos),
    );
  }

  factory MaintenanceRecordPartRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceRecordPartRow(
      id: serializer.fromJson<int>(json['id']),
      recordId: serializer.fromJson<int>(json['recordId']),
      partId: serializer.fromJson<int>(json['partId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitCostCentavos: serializer.fromJson<int>(json['unitCostCentavos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordId': serializer.toJson<int>(recordId),
      'partId': serializer.toJson<int>(partId),
      'quantity': serializer.toJson<int>(quantity),
      'unitCostCentavos': serializer.toJson<int>(unitCostCentavos),
    };
  }

  MaintenanceRecordPartRow copyWith(
          {int? id,
          int? recordId,
          int? partId,
          int? quantity,
          int? unitCostCentavos}) =>
      MaintenanceRecordPartRow(
        id: id ?? this.id,
        recordId: recordId ?? this.recordId,
        partId: partId ?? this.partId,
        quantity: quantity ?? this.quantity,
        unitCostCentavos: unitCostCentavos ?? this.unitCostCentavos,
      );
  MaintenanceRecordPartRow copyWithCompanion(
      MaintenanceRecordPartsCompanion data) {
    return MaintenanceRecordPartRow(
      id: data.id.present ? data.id.value : this.id,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      partId: data.partId.present ? data.partId.value : this.partId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitCostCentavos: data.unitCostCentavos.present
          ? data.unitCostCentavos.value
          : this.unitCostCentavos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceRecordPartRow(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('partId: $partId, ')
          ..write('quantity: $quantity, ')
          ..write('unitCostCentavos: $unitCostCentavos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recordId, partId, quantity, unitCostCentavos);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceRecordPartRow &&
          other.id == this.id &&
          other.recordId == this.recordId &&
          other.partId == this.partId &&
          other.quantity == this.quantity &&
          other.unitCostCentavos == this.unitCostCentavos);
}

class MaintenanceRecordPartsCompanion
    extends UpdateCompanion<MaintenanceRecordPartRow> {
  final Value<int> id;
  final Value<int> recordId;
  final Value<int> partId;
  final Value<int> quantity;
  final Value<int> unitCostCentavos;
  const MaintenanceRecordPartsCompanion({
    this.id = const Value.absent(),
    this.recordId = const Value.absent(),
    this.partId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitCostCentavos = const Value.absent(),
  });
  MaintenanceRecordPartsCompanion.insert({
    this.id = const Value.absent(),
    required int recordId,
    required int partId,
    this.quantity = const Value.absent(),
    this.unitCostCentavos = const Value.absent(),
  })  : recordId = Value(recordId),
        partId = Value(partId);
  static Insertable<MaintenanceRecordPartRow> custom({
    Expression<int>? id,
    Expression<int>? recordId,
    Expression<int>? partId,
    Expression<int>? quantity,
    Expression<int>? unitCostCentavos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordId != null) 'record_id': recordId,
      if (partId != null) 'part_id': partId,
      if (quantity != null) 'quantity': quantity,
      if (unitCostCentavos != null) 'unit_cost_centavos': unitCostCentavos,
    });
  }

  MaintenanceRecordPartsCompanion copyWith(
      {Value<int>? id,
      Value<int>? recordId,
      Value<int>? partId,
      Value<int>? quantity,
      Value<int>? unitCostCentavos}) {
    return MaintenanceRecordPartsCompanion(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      partId: partId ?? this.partId,
      quantity: quantity ?? this.quantity,
      unitCostCentavos: unitCostCentavos ?? this.unitCostCentavos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<int>(recordId.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<int>(partId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitCostCentavos.present) {
      map['unit_cost_centavos'] = Variable<int>(unitCostCentavos.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceRecordPartsCompanion(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('partId: $partId, ')
          ..write('quantity: $quantity, ')
          ..write('unitCostCentavos: $unitCostCentavos')
          ..write(')'))
        .toString();
  }
}

class $PartInstallationsTable extends PartInstallations
    with TableInfo<$PartInstallationsTable, PartInstallationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartInstallationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<int> partId = GeneratedColumn<int>(
      'part_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES parts (id)'));
  static const VerificationMeta _motorcycleIdMeta =
      const VerificationMeta('motorcycleId');
  @override
  late final GeneratedColumn<int> motorcycleId = GeneratedColumn<int>(
      'motorcycle_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES motorcycles (id)'));
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<int> recordId = GeneratedColumn<int>(
      'record_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES maintenance_records (id)'));
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<String> position = GeneratedColumn<String>(
      'position', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _installedDateMeta =
      const VerificationMeta('installedDate');
  @override
  late final GeneratedColumn<String> installedDate = GeneratedColumn<String>(
      'installed_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _installedOdometerKmMeta =
      const VerificationMeta('installedOdometerKm');
  @override
  late final GeneratedColumn<int> installedOdometerKm = GeneratedColumn<int>(
      'installed_odometer_km', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _removedDateMeta =
      const VerificationMeta('removedDate');
  @override
  late final GeneratedColumn<String> removedDate = GeneratedColumn<String>(
      'removed_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _removedOdometerKmMeta =
      const VerificationMeta('removedOdometerKm');
  @override
  late final GeneratedColumn<int> removedOdometerKm = GeneratedColumn<int>(
      'removed_odometer_km', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        partId,
        motorcycleId,
        recordId,
        position,
        installedDate,
        installedOdometerKm,
        removedDate,
        removedOdometerKm,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'part_installations';
  @override
  VerificationContext validateIntegrity(
      Insertable<PartInstallationRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('part_id')) {
      context.handle(_partIdMeta,
          partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta));
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('motorcycle_id')) {
      context.handle(
          _motorcycleIdMeta,
          motorcycleId.isAcceptableOrUnknown(
              data['motorcycle_id']!, _motorcycleIdMeta));
    } else if (isInserting) {
      context.missing(_motorcycleIdMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    }
    if (data.containsKey('installed_date')) {
      context.handle(
          _installedDateMeta,
          installedDate.isAcceptableOrUnknown(
              data['installed_date']!, _installedDateMeta));
    } else if (isInserting) {
      context.missing(_installedDateMeta);
    }
    if (data.containsKey('installed_odometer_km')) {
      context.handle(
          _installedOdometerKmMeta,
          installedOdometerKm.isAcceptableOrUnknown(
              data['installed_odometer_km']!, _installedOdometerKmMeta));
    } else if (isInserting) {
      context.missing(_installedOdometerKmMeta);
    }
    if (data.containsKey('removed_date')) {
      context.handle(
          _removedDateMeta,
          removedDate.isAcceptableOrUnknown(
              data['removed_date']!, _removedDateMeta));
    }
    if (data.containsKey('removed_odometer_km')) {
      context.handle(
          _removedOdometerKmMeta,
          removedOdometerKm.isAcceptableOrUnknown(
              data['removed_odometer_km']!, _removedOdometerKmMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartInstallationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartInstallationRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      partId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}part_id'])!,
      motorcycleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}motorcycle_id'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}record_id']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}position']),
      installedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}installed_date'])!,
      installedOdometerKm: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}installed_odometer_km'])!,
      removedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}removed_date']),
      removedOdometerKm: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}removed_odometer_km']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $PartInstallationsTable createAlias(String alias) {
    return $PartInstallationsTable(attachedDatabase, alias);
  }
}

class PartInstallationRow extends DataClass
    implements Insertable<PartInstallationRow> {
  final int id;
  final int partId;
  final int motorcycleId;
  final int? recordId;

  /// FRONT | REAR (nullable when not applicable)
  final String? position;
  final String installedDate;
  final int installedOdometerKm;
  final String? removedDate;
  final int? removedOdometerKm;
  final String? notes;
  const PartInstallationRow(
      {required this.id,
      required this.partId,
      required this.motorcycleId,
      this.recordId,
      this.position,
      required this.installedDate,
      required this.installedOdometerKm,
      this.removedDate,
      this.removedOdometerKm,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['part_id'] = Variable<int>(partId);
    map['motorcycle_id'] = Variable<int>(motorcycleId);
    if (!nullToAbsent || recordId != null) {
      map['record_id'] = Variable<int>(recordId);
    }
    if (!nullToAbsent || position != null) {
      map['position'] = Variable<String>(position);
    }
    map['installed_date'] = Variable<String>(installedDate);
    map['installed_odometer_km'] = Variable<int>(installedOdometerKm);
    if (!nullToAbsent || removedDate != null) {
      map['removed_date'] = Variable<String>(removedDate);
    }
    if (!nullToAbsent || removedOdometerKm != null) {
      map['removed_odometer_km'] = Variable<int>(removedOdometerKm);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PartInstallationsCompanion toCompanion(bool nullToAbsent) {
    return PartInstallationsCompanion(
      id: Value(id),
      partId: Value(partId),
      motorcycleId: Value(motorcycleId),
      recordId: recordId == null && nullToAbsent
          ? const Value.absent()
          : Value(recordId),
      position: position == null && nullToAbsent
          ? const Value.absent()
          : Value(position),
      installedDate: Value(installedDate),
      installedOdometerKm: Value(installedOdometerKm),
      removedDate: removedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(removedDate),
      removedOdometerKm: removedOdometerKm == null && nullToAbsent
          ? const Value.absent()
          : Value(removedOdometerKm),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory PartInstallationRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartInstallationRow(
      id: serializer.fromJson<int>(json['id']),
      partId: serializer.fromJson<int>(json['partId']),
      motorcycleId: serializer.fromJson<int>(json['motorcycleId']),
      recordId: serializer.fromJson<int?>(json['recordId']),
      position: serializer.fromJson<String?>(json['position']),
      installedDate: serializer.fromJson<String>(json['installedDate']),
      installedOdometerKm:
          serializer.fromJson<int>(json['installedOdometerKm']),
      removedDate: serializer.fromJson<String?>(json['removedDate']),
      removedOdometerKm: serializer.fromJson<int?>(json['removedOdometerKm']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'partId': serializer.toJson<int>(partId),
      'motorcycleId': serializer.toJson<int>(motorcycleId),
      'recordId': serializer.toJson<int?>(recordId),
      'position': serializer.toJson<String?>(position),
      'installedDate': serializer.toJson<String>(installedDate),
      'installedOdometerKm': serializer.toJson<int>(installedOdometerKm),
      'removedDate': serializer.toJson<String?>(removedDate),
      'removedOdometerKm': serializer.toJson<int?>(removedOdometerKm),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  PartInstallationRow copyWith(
          {int? id,
          int? partId,
          int? motorcycleId,
          Value<int?> recordId = const Value.absent(),
          Value<String?> position = const Value.absent(),
          String? installedDate,
          int? installedOdometerKm,
          Value<String?> removedDate = const Value.absent(),
          Value<int?> removedOdometerKm = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      PartInstallationRow(
        id: id ?? this.id,
        partId: partId ?? this.partId,
        motorcycleId: motorcycleId ?? this.motorcycleId,
        recordId: recordId.present ? recordId.value : this.recordId,
        position: position.present ? position.value : this.position,
        installedDate: installedDate ?? this.installedDate,
        installedOdometerKm: installedOdometerKm ?? this.installedOdometerKm,
        removedDate: removedDate.present ? removedDate.value : this.removedDate,
        removedOdometerKm: removedOdometerKm.present
            ? removedOdometerKm.value
            : this.removedOdometerKm,
        notes: notes.present ? notes.value : this.notes,
      );
  PartInstallationRow copyWithCompanion(PartInstallationsCompanion data) {
    return PartInstallationRow(
      id: data.id.present ? data.id.value : this.id,
      partId: data.partId.present ? data.partId.value : this.partId,
      motorcycleId: data.motorcycleId.present
          ? data.motorcycleId.value
          : this.motorcycleId,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      position: data.position.present ? data.position.value : this.position,
      installedDate: data.installedDate.present
          ? data.installedDate.value
          : this.installedDate,
      installedOdometerKm: data.installedOdometerKm.present
          ? data.installedOdometerKm.value
          : this.installedOdometerKm,
      removedDate:
          data.removedDate.present ? data.removedDate.value : this.removedDate,
      removedOdometerKm: data.removedOdometerKm.present
          ? data.removedOdometerKm.value
          : this.removedOdometerKm,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartInstallationRow(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('recordId: $recordId, ')
          ..write('position: $position, ')
          ..write('installedDate: $installedDate, ')
          ..write('installedOdometerKm: $installedOdometerKm, ')
          ..write('removedDate: $removedDate, ')
          ..write('removedOdometerKm: $removedOdometerKm, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      partId,
      motorcycleId,
      recordId,
      position,
      installedDate,
      installedOdometerKm,
      removedDate,
      removedOdometerKm,
      notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartInstallationRow &&
          other.id == this.id &&
          other.partId == this.partId &&
          other.motorcycleId == this.motorcycleId &&
          other.recordId == this.recordId &&
          other.position == this.position &&
          other.installedDate == this.installedDate &&
          other.installedOdometerKm == this.installedOdometerKm &&
          other.removedDate == this.removedDate &&
          other.removedOdometerKm == this.removedOdometerKm &&
          other.notes == this.notes);
}

class PartInstallationsCompanion extends UpdateCompanion<PartInstallationRow> {
  final Value<int> id;
  final Value<int> partId;
  final Value<int> motorcycleId;
  final Value<int?> recordId;
  final Value<String?> position;
  final Value<String> installedDate;
  final Value<int> installedOdometerKm;
  final Value<String?> removedDate;
  final Value<int?> removedOdometerKm;
  final Value<String?> notes;
  const PartInstallationsCompanion({
    this.id = const Value.absent(),
    this.partId = const Value.absent(),
    this.motorcycleId = const Value.absent(),
    this.recordId = const Value.absent(),
    this.position = const Value.absent(),
    this.installedDate = const Value.absent(),
    this.installedOdometerKm = const Value.absent(),
    this.removedDate = const Value.absent(),
    this.removedOdometerKm = const Value.absent(),
    this.notes = const Value.absent(),
  });
  PartInstallationsCompanion.insert({
    this.id = const Value.absent(),
    required int partId,
    required int motorcycleId,
    this.recordId = const Value.absent(),
    this.position = const Value.absent(),
    required String installedDate,
    required int installedOdometerKm,
    this.removedDate = const Value.absent(),
    this.removedOdometerKm = const Value.absent(),
    this.notes = const Value.absent(),
  })  : partId = Value(partId),
        motorcycleId = Value(motorcycleId),
        installedDate = Value(installedDate),
        installedOdometerKm = Value(installedOdometerKm);
  static Insertable<PartInstallationRow> custom({
    Expression<int>? id,
    Expression<int>? partId,
    Expression<int>? motorcycleId,
    Expression<int>? recordId,
    Expression<String>? position,
    Expression<String>? installedDate,
    Expression<int>? installedOdometerKm,
    Expression<String>? removedDate,
    Expression<int>? removedOdometerKm,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partId != null) 'part_id': partId,
      if (motorcycleId != null) 'motorcycle_id': motorcycleId,
      if (recordId != null) 'record_id': recordId,
      if (position != null) 'position': position,
      if (installedDate != null) 'installed_date': installedDate,
      if (installedOdometerKm != null)
        'installed_odometer_km': installedOdometerKm,
      if (removedDate != null) 'removed_date': removedDate,
      if (removedOdometerKm != null) 'removed_odometer_km': removedOdometerKm,
      if (notes != null) 'notes': notes,
    });
  }

  PartInstallationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? partId,
      Value<int>? motorcycleId,
      Value<int?>? recordId,
      Value<String?>? position,
      Value<String>? installedDate,
      Value<int>? installedOdometerKm,
      Value<String?>? removedDate,
      Value<int?>? removedOdometerKm,
      Value<String?>? notes}) {
    return PartInstallationsCompanion(
      id: id ?? this.id,
      partId: partId ?? this.partId,
      motorcycleId: motorcycleId ?? this.motorcycleId,
      recordId: recordId ?? this.recordId,
      position: position ?? this.position,
      installedDate: installedDate ?? this.installedDate,
      installedOdometerKm: installedOdometerKm ?? this.installedOdometerKm,
      removedDate: removedDate ?? this.removedDate,
      removedOdometerKm: removedOdometerKm ?? this.removedOdometerKm,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<int>(partId.value);
    }
    if (motorcycleId.present) {
      map['motorcycle_id'] = Variable<int>(motorcycleId.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<int>(recordId.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(position.value);
    }
    if (installedDate.present) {
      map['installed_date'] = Variable<String>(installedDate.value);
    }
    if (installedOdometerKm.present) {
      map['installed_odometer_km'] = Variable<int>(installedOdometerKm.value);
    }
    if (removedDate.present) {
      map['removed_date'] = Variable<String>(removedDate.value);
    }
    if (removedOdometerKm.present) {
      map['removed_odometer_km'] = Variable<int>(removedOdometerKm.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartInstallationsCompanion(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('recordId: $recordId, ')
          ..write('position: $position, ')
          ..write('installedDate: $installedDate, ')
          ..write('installedOdometerKm: $installedOdometerKm, ')
          ..write('removedDate: $removedDate, ')
          ..write('removedOdometerKm: $removedOdometerKm, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceRemindersTable extends MaintenanceReminders
    with TableInfo<$MaintenanceRemindersTable, MaintenanceReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _motorcycleIdMeta =
      const VerificationMeta('motorcycleId');
  @override
  late final GeneratedColumn<int> motorcycleId = GeneratedColumn<int>(
      'motorcycle_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES motorcycles (id)'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES maintenance_items (id)'));
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<int> ruleId = GeneratedColumn<int>(
      'rule_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES maintenance_rules (id)'));
  static const VerificationMeta _reminderTypeMeta =
      const VerificationMeta('reminderType');
  @override
  late final GeneratedColumn<String> reminderType = GeneratedColumn<String>(
      'reminder_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
      'due_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dueOdometerKmMeta =
      const VerificationMeta('dueOdometerKm');
  @override
  late final GeneratedColumn<int> dueOdometerKm = GeneratedColumn<int>(
      'due_odometer_km', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dedupeKeyMeta =
      const VerificationMeta('dedupeKey');
  @override
  late final GeneratedColumn<String> dedupeKey = GeneratedColumn<String>(
      'dedupe_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PENDING'));
  static const VerificationMeta _notifiedAtMeta =
      const VerificationMeta('notifiedAt');
  @override
  late final GeneratedColumn<String> notifiedAt = GeneratedColumn<String>(
      'notified_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        motorcycleId,
        itemId,
        ruleId,
        reminderType,
        title,
        body,
        dueDate,
        dueOdometerKm,
        dedupeKey,
        status,
        notifiedAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_reminders';
  @override
  VerificationContext validateIntegrity(
      Insertable<MaintenanceReminderRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('motorcycle_id')) {
      context.handle(
          _motorcycleIdMeta,
          motorcycleId.isAcceptableOrUnknown(
              data['motorcycle_id']!, _motorcycleIdMeta));
    } else if (isInserting) {
      context.missing(_motorcycleIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    }
    if (data.containsKey('rule_id')) {
      context.handle(_ruleIdMeta,
          ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta));
    }
    if (data.containsKey('reminder_type')) {
      context.handle(
          _reminderTypeMeta,
          reminderType.isAcceptableOrUnknown(
              data['reminder_type']!, _reminderTypeMeta));
    } else if (isInserting) {
      context.missing(_reminderTypeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('due_odometer_km')) {
      context.handle(
          _dueOdometerKmMeta,
          dueOdometerKm.isAcceptableOrUnknown(
              data['due_odometer_km']!, _dueOdometerKmMeta));
    }
    if (data.containsKey('dedupe_key')) {
      context.handle(_dedupeKeyMeta,
          dedupeKey.isAcceptableOrUnknown(data['dedupe_key']!, _dedupeKeyMeta));
    } else if (isInserting) {
      context.missing(_dedupeKeyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('notified_at')) {
      context.handle(
          _notifiedAtMeta,
          notifiedAt.isAcceptableOrUnknown(
              data['notified_at']!, _notifiedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceReminderRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      motorcycleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}motorcycle_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id']),
      ruleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rule_id']),
      reminderType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_type'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body']),
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}due_date']),
      dueOdometerKm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}due_odometer_km']),
      dedupeKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dedupe_key'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notifiedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notified_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $MaintenanceRemindersTable createAlias(String alias) {
    return $MaintenanceRemindersTable(attachedDatabase, alias);
  }
}

class MaintenanceReminderRow extends DataClass
    implements Insertable<MaintenanceReminderRow> {
  final int id;
  final int motorcycleId;
  final int? itemId;
  final int? ruleId;

  /// UPCOMING | DUE | OVERDUE | DATE_BASED | CUSTOM
  final String reminderType;
  final String title;
  final String? body;
  final String? dueDate;
  final int? dueOdometerKm;

  /// Unique key (e.g. rule + checkpoint + type) preventing duplicate reminders.
  final String dedupeKey;

  /// PENDING | NOTIFIED | DISMISSED
  final String status;
  final String? notifiedAt;
  final String createdAt;
  const MaintenanceReminderRow(
      {required this.id,
      required this.motorcycleId,
      this.itemId,
      this.ruleId,
      required this.reminderType,
      required this.title,
      this.body,
      this.dueDate,
      this.dueOdometerKm,
      required this.dedupeKey,
      required this.status,
      this.notifiedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['motorcycle_id'] = Variable<int>(motorcycleId);
    if (!nullToAbsent || itemId != null) {
      map['item_id'] = Variable<int>(itemId);
    }
    if (!nullToAbsent || ruleId != null) {
      map['rule_id'] = Variable<int>(ruleId);
    }
    map['reminder_type'] = Variable<String>(reminderType);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    if (!nullToAbsent || dueOdometerKm != null) {
      map['due_odometer_km'] = Variable<int>(dueOdometerKm);
    }
    map['dedupe_key'] = Variable<String>(dedupeKey);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notifiedAt != null) {
      map['notified_at'] = Variable<String>(notifiedAt);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  MaintenanceRemindersCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceRemindersCompanion(
      id: Value(id),
      motorcycleId: Value(motorcycleId),
      itemId:
          itemId == null && nullToAbsent ? const Value.absent() : Value(itemId),
      ruleId:
          ruleId == null && nullToAbsent ? const Value.absent() : Value(ruleId),
      reminderType: Value(reminderType),
      title: Value(title),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      dueOdometerKm: dueOdometerKm == null && nullToAbsent
          ? const Value.absent()
          : Value(dueOdometerKm),
      dedupeKey: Value(dedupeKey),
      status: Value(status),
      notifiedAt: notifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(notifiedAt),
      createdAt: Value(createdAt),
    );
  }

  factory MaintenanceReminderRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceReminderRow(
      id: serializer.fromJson<int>(json['id']),
      motorcycleId: serializer.fromJson<int>(json['motorcycleId']),
      itemId: serializer.fromJson<int?>(json['itemId']),
      ruleId: serializer.fromJson<int?>(json['ruleId']),
      reminderType: serializer.fromJson<String>(json['reminderType']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String?>(json['body']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      dueOdometerKm: serializer.fromJson<int?>(json['dueOdometerKm']),
      dedupeKey: serializer.fromJson<String>(json['dedupeKey']),
      status: serializer.fromJson<String>(json['status']),
      notifiedAt: serializer.fromJson<String?>(json['notifiedAt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'motorcycleId': serializer.toJson<int>(motorcycleId),
      'itemId': serializer.toJson<int?>(itemId),
      'ruleId': serializer.toJson<int?>(ruleId),
      'reminderType': serializer.toJson<String>(reminderType),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String?>(body),
      'dueDate': serializer.toJson<String?>(dueDate),
      'dueOdometerKm': serializer.toJson<int?>(dueOdometerKm),
      'dedupeKey': serializer.toJson<String>(dedupeKey),
      'status': serializer.toJson<String>(status),
      'notifiedAt': serializer.toJson<String?>(notifiedAt),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  MaintenanceReminderRow copyWith(
          {int? id,
          int? motorcycleId,
          Value<int?> itemId = const Value.absent(),
          Value<int?> ruleId = const Value.absent(),
          String? reminderType,
          String? title,
          Value<String?> body = const Value.absent(),
          Value<String?> dueDate = const Value.absent(),
          Value<int?> dueOdometerKm = const Value.absent(),
          String? dedupeKey,
          String? status,
          Value<String?> notifiedAt = const Value.absent(),
          String? createdAt}) =>
      MaintenanceReminderRow(
        id: id ?? this.id,
        motorcycleId: motorcycleId ?? this.motorcycleId,
        itemId: itemId.present ? itemId.value : this.itemId,
        ruleId: ruleId.present ? ruleId.value : this.ruleId,
        reminderType: reminderType ?? this.reminderType,
        title: title ?? this.title,
        body: body.present ? body.value : this.body,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        dueOdometerKm:
            dueOdometerKm.present ? dueOdometerKm.value : this.dueOdometerKm,
        dedupeKey: dedupeKey ?? this.dedupeKey,
        status: status ?? this.status,
        notifiedAt: notifiedAt.present ? notifiedAt.value : this.notifiedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  MaintenanceReminderRow copyWithCompanion(MaintenanceRemindersCompanion data) {
    return MaintenanceReminderRow(
      id: data.id.present ? data.id.value : this.id,
      motorcycleId: data.motorcycleId.present
          ? data.motorcycleId.value
          : this.motorcycleId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      reminderType: data.reminderType.present
          ? data.reminderType.value
          : this.reminderType,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      dueOdometerKm: data.dueOdometerKm.present
          ? data.dueOdometerKm.value
          : this.dueOdometerKm,
      dedupeKey: data.dedupeKey.present ? data.dedupeKey.value : this.dedupeKey,
      status: data.status.present ? data.status.value : this.status,
      notifiedAt:
          data.notifiedAt.present ? data.notifiedAt.value : this.notifiedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceReminderRow(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('itemId: $itemId, ')
          ..write('ruleId: $ruleId, ')
          ..write('reminderType: $reminderType, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueOdometerKm: $dueOdometerKm, ')
          ..write('dedupeKey: $dedupeKey, ')
          ..write('status: $status, ')
          ..write('notifiedAt: $notifiedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      motorcycleId,
      itemId,
      ruleId,
      reminderType,
      title,
      body,
      dueDate,
      dueOdometerKm,
      dedupeKey,
      status,
      notifiedAt,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceReminderRow &&
          other.id == this.id &&
          other.motorcycleId == this.motorcycleId &&
          other.itemId == this.itemId &&
          other.ruleId == this.ruleId &&
          other.reminderType == this.reminderType &&
          other.title == this.title &&
          other.body == this.body &&
          other.dueDate == this.dueDate &&
          other.dueOdometerKm == this.dueOdometerKm &&
          other.dedupeKey == this.dedupeKey &&
          other.status == this.status &&
          other.notifiedAt == this.notifiedAt &&
          other.createdAt == this.createdAt);
}

class MaintenanceRemindersCompanion
    extends UpdateCompanion<MaintenanceReminderRow> {
  final Value<int> id;
  final Value<int> motorcycleId;
  final Value<int?> itemId;
  final Value<int?> ruleId;
  final Value<String> reminderType;
  final Value<String> title;
  final Value<String?> body;
  final Value<String?> dueDate;
  final Value<int?> dueOdometerKm;
  final Value<String> dedupeKey;
  final Value<String> status;
  final Value<String?> notifiedAt;
  final Value<String> createdAt;
  const MaintenanceRemindersCompanion({
    this.id = const Value.absent(),
    this.motorcycleId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.reminderType = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueOdometerKm = const Value.absent(),
    this.dedupeKey = const Value.absent(),
    this.status = const Value.absent(),
    this.notifiedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MaintenanceRemindersCompanion.insert({
    this.id = const Value.absent(),
    required int motorcycleId,
    this.itemId = const Value.absent(),
    this.ruleId = const Value.absent(),
    required String reminderType,
    required String title,
    this.body = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueOdometerKm = const Value.absent(),
    required String dedupeKey,
    this.status = const Value.absent(),
    this.notifiedAt = const Value.absent(),
    required String createdAt,
  })  : motorcycleId = Value(motorcycleId),
        reminderType = Value(reminderType),
        title = Value(title),
        dedupeKey = Value(dedupeKey),
        createdAt = Value(createdAt);
  static Insertable<MaintenanceReminderRow> custom({
    Expression<int>? id,
    Expression<int>? motorcycleId,
    Expression<int>? itemId,
    Expression<int>? ruleId,
    Expression<String>? reminderType,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? dueDate,
    Expression<int>? dueOdometerKm,
    Expression<String>? dedupeKey,
    Expression<String>? status,
    Expression<String>? notifiedAt,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (motorcycleId != null) 'motorcycle_id': motorcycleId,
      if (itemId != null) 'item_id': itemId,
      if (ruleId != null) 'rule_id': ruleId,
      if (reminderType != null) 'reminder_type': reminderType,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (dueDate != null) 'due_date': dueDate,
      if (dueOdometerKm != null) 'due_odometer_km': dueOdometerKm,
      if (dedupeKey != null) 'dedupe_key': dedupeKey,
      if (status != null) 'status': status,
      if (notifiedAt != null) 'notified_at': notifiedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MaintenanceRemindersCompanion copyWith(
      {Value<int>? id,
      Value<int>? motorcycleId,
      Value<int?>? itemId,
      Value<int?>? ruleId,
      Value<String>? reminderType,
      Value<String>? title,
      Value<String?>? body,
      Value<String?>? dueDate,
      Value<int?>? dueOdometerKm,
      Value<String>? dedupeKey,
      Value<String>? status,
      Value<String?>? notifiedAt,
      Value<String>? createdAt}) {
    return MaintenanceRemindersCompanion(
      id: id ?? this.id,
      motorcycleId: motorcycleId ?? this.motorcycleId,
      itemId: itemId ?? this.itemId,
      ruleId: ruleId ?? this.ruleId,
      reminderType: reminderType ?? this.reminderType,
      title: title ?? this.title,
      body: body ?? this.body,
      dueDate: dueDate ?? this.dueDate,
      dueOdometerKm: dueOdometerKm ?? this.dueOdometerKm,
      dedupeKey: dedupeKey ?? this.dedupeKey,
      status: status ?? this.status,
      notifiedAt: notifiedAt ?? this.notifiedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (motorcycleId.present) {
      map['motorcycle_id'] = Variable<int>(motorcycleId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<int>(ruleId.value);
    }
    if (reminderType.present) {
      map['reminder_type'] = Variable<String>(reminderType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (dueOdometerKm.present) {
      map['due_odometer_km'] = Variable<int>(dueOdometerKm.value);
    }
    if (dedupeKey.present) {
      map['dedupe_key'] = Variable<String>(dedupeKey.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notifiedAt.present) {
      map['notified_at'] = Variable<String>(notifiedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceRemindersCompanion(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('itemId: $itemId, ')
          ..write('ruleId: $ruleId, ')
          ..write('reminderType: $reminderType, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueOdometerKm: $dueOdometerKm, ')
          ..write('dedupeKey: $dedupeKey, ')
          ..write('status: $status, ')
          ..write('notifiedAt: $notifiedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AttachmentsTable extends Attachments
    with TableInfo<$AttachmentsTable, AttachmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<int> recordId = GeneratedColumn<int>(
      'record_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES maintenance_records (id)'));
  static const VerificationMeta _measurementIdMeta =
      const VerificationMeta('measurementId');
  @override
  late final GeneratedColumn<int> measurementId = GeneratedColumn<int>(
      'measurement_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES component_measurements (id)'));
  static const VerificationMeta _motorcycleIdMeta =
      const VerificationMeta('motorcycleId');
  @override
  late final GeneratedColumn<int> motorcycleId = GeneratedColumn<int>(
      'motorcycle_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES motorcycles (id)'));
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mimeTypeMeta =
      const VerificationMeta('mimeType');
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
      'mime_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _captionMeta =
      const VerificationMeta('caption');
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
      'caption', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        recordId,
        measurementId,
        motorcycleId,
        filePath,
        mimeType,
        caption,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachments';
  @override
  VerificationContext validateIntegrity(Insertable<AttachmentRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    }
    if (data.containsKey('measurement_id')) {
      context.handle(
          _measurementIdMeta,
          measurementId.isAcceptableOrUnknown(
              data['measurement_id']!, _measurementIdMeta));
    }
    if (data.containsKey('motorcycle_id')) {
      context.handle(
          _motorcycleIdMeta,
          motorcycleId.isAcceptableOrUnknown(
              data['motorcycle_id']!, _motorcycleIdMeta));
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(_mimeTypeMeta,
          mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta));
    }
    if (data.containsKey('caption')) {
      context.handle(_captionMeta,
          caption.isAcceptableOrUnknown(data['caption']!, _captionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttachmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttachmentRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}record_id']),
      measurementId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}measurement_id']),
      motorcycleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}motorcycle_id']),
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      mimeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mime_type']),
      caption: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}caption']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AttachmentsTable createAlias(String alias) {
    return $AttachmentsTable(attachedDatabase, alias);
  }
}

class AttachmentRow extends DataClass implements Insertable<AttachmentRow> {
  final int id;
  final int? recordId;
  final int? measurementId;
  final int? motorcycleId;
  final String filePath;
  final String? mimeType;
  final String? caption;
  final String createdAt;
  const AttachmentRow(
      {required this.id,
      this.recordId,
      this.measurementId,
      this.motorcycleId,
      required this.filePath,
      this.mimeType,
      this.caption,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || recordId != null) {
      map['record_id'] = Variable<int>(recordId);
    }
    if (!nullToAbsent || measurementId != null) {
      map['measurement_id'] = Variable<int>(measurementId);
    }
    if (!nullToAbsent || motorcycleId != null) {
      map['motorcycle_id'] = Variable<int>(motorcycleId);
    }
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  AttachmentsCompanion toCompanion(bool nullToAbsent) {
    return AttachmentsCompanion(
      id: Value(id),
      recordId: recordId == null && nullToAbsent
          ? const Value.absent()
          : Value(recordId),
      measurementId: measurementId == null && nullToAbsent
          ? const Value.absent()
          : Value(measurementId),
      motorcycleId: motorcycleId == null && nullToAbsent
          ? const Value.absent()
          : Value(motorcycleId),
      filePath: Value(filePath),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      createdAt: Value(createdAt),
    );
  }

  factory AttachmentRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttachmentRow(
      id: serializer.fromJson<int>(json['id']),
      recordId: serializer.fromJson<int?>(json['recordId']),
      measurementId: serializer.fromJson<int?>(json['measurementId']),
      motorcycleId: serializer.fromJson<int?>(json['motorcycleId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      caption: serializer.fromJson<String?>(json['caption']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordId': serializer.toJson<int?>(recordId),
      'measurementId': serializer.toJson<int?>(measurementId),
      'motorcycleId': serializer.toJson<int?>(motorcycleId),
      'filePath': serializer.toJson<String>(filePath),
      'mimeType': serializer.toJson<String?>(mimeType),
      'caption': serializer.toJson<String?>(caption),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  AttachmentRow copyWith(
          {int? id,
          Value<int?> recordId = const Value.absent(),
          Value<int?> measurementId = const Value.absent(),
          Value<int?> motorcycleId = const Value.absent(),
          String? filePath,
          Value<String?> mimeType = const Value.absent(),
          Value<String?> caption = const Value.absent(),
          String? createdAt}) =>
      AttachmentRow(
        id: id ?? this.id,
        recordId: recordId.present ? recordId.value : this.recordId,
        measurementId:
            measurementId.present ? measurementId.value : this.measurementId,
        motorcycleId:
            motorcycleId.present ? motorcycleId.value : this.motorcycleId,
        filePath: filePath ?? this.filePath,
        mimeType: mimeType.present ? mimeType.value : this.mimeType,
        caption: caption.present ? caption.value : this.caption,
        createdAt: createdAt ?? this.createdAt,
      );
  AttachmentRow copyWithCompanion(AttachmentsCompanion data) {
    return AttachmentRow(
      id: data.id.present ? data.id.value : this.id,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      measurementId: data.measurementId.present
          ? data.measurementId.value
          : this.measurementId,
      motorcycleId: data.motorcycleId.present
          ? data.motorcycleId.value
          : this.motorcycleId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      caption: data.caption.present ? data.caption.value : this.caption,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentRow(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('measurementId: $measurementId, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('filePath: $filePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('caption: $caption, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recordId, measurementId, motorcycleId,
      filePath, mimeType, caption, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttachmentRow &&
          other.id == this.id &&
          other.recordId == this.recordId &&
          other.measurementId == this.measurementId &&
          other.motorcycleId == this.motorcycleId &&
          other.filePath == this.filePath &&
          other.mimeType == this.mimeType &&
          other.caption == this.caption &&
          other.createdAt == this.createdAt);
}

class AttachmentsCompanion extends UpdateCompanion<AttachmentRow> {
  final Value<int> id;
  final Value<int?> recordId;
  final Value<int?> measurementId;
  final Value<int?> motorcycleId;
  final Value<String> filePath;
  final Value<String?> mimeType;
  final Value<String?> caption;
  final Value<String> createdAt;
  const AttachmentsCompanion({
    this.id = const Value.absent(),
    this.recordId = const Value.absent(),
    this.measurementId = const Value.absent(),
    this.motorcycleId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.caption = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AttachmentsCompanion.insert({
    this.id = const Value.absent(),
    this.recordId = const Value.absent(),
    this.measurementId = const Value.absent(),
    this.motorcycleId = const Value.absent(),
    required String filePath,
    this.mimeType = const Value.absent(),
    this.caption = const Value.absent(),
    required String createdAt,
  })  : filePath = Value(filePath),
        createdAt = Value(createdAt);
  static Insertable<AttachmentRow> custom({
    Expression<int>? id,
    Expression<int>? recordId,
    Expression<int>? measurementId,
    Expression<int>? motorcycleId,
    Expression<String>? filePath,
    Expression<String>? mimeType,
    Expression<String>? caption,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordId != null) 'record_id': recordId,
      if (measurementId != null) 'measurement_id': measurementId,
      if (motorcycleId != null) 'motorcycle_id': motorcycleId,
      if (filePath != null) 'file_path': filePath,
      if (mimeType != null) 'mime_type': mimeType,
      if (caption != null) 'caption': caption,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AttachmentsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? recordId,
      Value<int?>? measurementId,
      Value<int?>? motorcycleId,
      Value<String>? filePath,
      Value<String?>? mimeType,
      Value<String?>? caption,
      Value<String>? createdAt}) {
    return AttachmentsCompanion(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      measurementId: measurementId ?? this.measurementId,
      motorcycleId: motorcycleId ?? this.motorcycleId,
      filePath: filePath ?? this.filePath,
      mimeType: mimeType ?? this.mimeType,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<int>(recordId.value);
    }
    if (measurementId.present) {
      map['measurement_id'] = Variable<int>(measurementId.value);
    }
    if (motorcycleId.present) {
      map['motorcycle_id'] = Variable<int>(motorcycleId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('measurementId: $measurementId, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('filePath: $filePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('caption: $caption, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TripsTable extends Trips with TableInfo<$TripsTable, Trip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _motorcycleIdMeta =
      const VerificationMeta('motorcycleId');
  @override
  late final GeneratedColumn<int> motorcycleId = GeneratedColumn<int>(
      'motorcycle_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES motorcycles (id) ON DELETE CASCADE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
      'origin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _destinationMeta =
      const VerificationMeta('destination');
  @override
  late final GeneratedColumn<String> destination = GeneratedColumn<String>(
      'destination', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startOdometerKmMeta =
      const VerificationMeta('startOdometerKm');
  @override
  late final GeneratedColumn<int> startOdometerKm = GeneratedColumn<int>(
      'start_odometer_km', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _endOdometerKmMeta =
      const VerificationMeta('endOdometerKm');
  @override
  late final GeneratedColumn<int> endOdometerKm = GeneratedColumn<int>(
      'end_odometer_km', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _distanceKmMeta =
      const VerificationMeta('distanceKm');
  @override
  late final GeneratedColumn<double> distanceKm = GeneratedColumn<double>(
      'distance_km', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _avgSpeedKmhMeta =
      const VerificationMeta('avgSpeedKmh');
  @override
  late final GeneratedColumn<double> avgSpeedKmh = GeneratedColumn<double>(
      'avg_speed_kmh', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _maxSpeedKmhMeta =
      const VerificationMeta('maxSpeedKmh');
  @override
  late final GeneratedColumn<double> maxSpeedKmh = GeneratedColumn<double>(
      'max_speed_kmh', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isGpsTrackedMeta =
      const VerificationMeta('isGpsTracked');
  @override
  late final GeneratedColumn<bool> isGpsTracked = GeneratedColumn<bool>(
      'is_gps_tracked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_gps_tracked" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoPathsMeta =
      const VerificationMeta('photoPaths');
  @override
  late final GeneratedColumn<String> photoPaths = GeneratedColumn<String>(
      'photo_paths', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        motorcycleId,
        title,
        category,
        origin,
        destination,
        startOdometerKm,
        endOdometerKm,
        distanceKm,
        startTime,
        endTime,
        durationSeconds,
        avgSpeedKmh,
        maxSpeedKmh,
        isGpsTracked,
        notes,
        photoPaths,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trips';
  @override
  VerificationContext validateIntegrity(Insertable<Trip> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('motorcycle_id')) {
      context.handle(
          _motorcycleIdMeta,
          motorcycleId.isAcceptableOrUnknown(
              data['motorcycle_id']!, _motorcycleIdMeta));
    } else if (isInserting) {
      context.missing(_motorcycleIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('origin')) {
      context.handle(_originMeta,
          origin.isAcceptableOrUnknown(data['origin']!, _originMeta));
    }
    if (data.containsKey('destination')) {
      context.handle(
          _destinationMeta,
          destination.isAcceptableOrUnknown(
              data['destination']!, _destinationMeta));
    }
    if (data.containsKey('start_odometer_km')) {
      context.handle(
          _startOdometerKmMeta,
          startOdometerKm.isAcceptableOrUnknown(
              data['start_odometer_km']!, _startOdometerKmMeta));
    }
    if (data.containsKey('end_odometer_km')) {
      context.handle(
          _endOdometerKmMeta,
          endOdometerKm.isAcceptableOrUnknown(
              data['end_odometer_km']!, _endOdometerKmMeta));
    }
    if (data.containsKey('distance_km')) {
      context.handle(
          _distanceKmMeta,
          distanceKm.isAcceptableOrUnknown(
              data['distance_km']!, _distanceKmMeta));
    } else if (isInserting) {
      context.missing(_distanceKmMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    }
    if (data.containsKey('avg_speed_kmh')) {
      context.handle(
          _avgSpeedKmhMeta,
          avgSpeedKmh.isAcceptableOrUnknown(
              data['avg_speed_kmh']!, _avgSpeedKmhMeta));
    }
    if (data.containsKey('max_speed_kmh')) {
      context.handle(
          _maxSpeedKmhMeta,
          maxSpeedKmh.isAcceptableOrUnknown(
              data['max_speed_kmh']!, _maxSpeedKmhMeta));
    }
    if (data.containsKey('is_gps_tracked')) {
      context.handle(
          _isGpsTrackedMeta,
          isGpsTracked.isAcceptableOrUnknown(
              data['is_gps_tracked']!, _isGpsTrackedMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('photo_paths')) {
      context.handle(
          _photoPathsMeta,
          photoPaths.isAcceptableOrUnknown(
              data['photo_paths']!, _photoPathsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Trip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trip(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      motorcycleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}motorcycle_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      origin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}origin']),
      destination: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}destination']),
      startOdometerKm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_odometer_km']),
      endOdometerKm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_odometer_km']),
      distanceKm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}distance_km'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time']),
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds'])!,
      avgSpeedKmh: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_speed_kmh']),
      maxSpeedKmh: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_speed_kmh']),
      isGpsTracked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_gps_tracked'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      photoPaths: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_paths']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TripsTable createAlias(String alias) {
    return $TripsTable(attachedDatabase, alias);
  }
}

class Trip extends DataClass implements Insertable<Trip> {
  final int id;
  final int motorcycleId;
  final String title;
  final String category;
  final String? origin;
  final String? destination;
  final int? startOdometerKm;
  final int? endOdometerKm;
  final double distanceKm;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationSeconds;
  final double? avgSpeedKmh;
  final double? maxSpeedKmh;
  final bool isGpsTracked;
  final String? notes;
  final String? photoPaths;
  final DateTime createdAt;
  const Trip(
      {required this.id,
      required this.motorcycleId,
      required this.title,
      required this.category,
      this.origin,
      this.destination,
      this.startOdometerKm,
      this.endOdometerKm,
      required this.distanceKm,
      required this.startTime,
      this.endTime,
      required this.durationSeconds,
      this.avgSpeedKmh,
      this.maxSpeedKmh,
      required this.isGpsTracked,
      this.notes,
      this.photoPaths,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['motorcycle_id'] = Variable<int>(motorcycleId);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || origin != null) {
      map['origin'] = Variable<String>(origin);
    }
    if (!nullToAbsent || destination != null) {
      map['destination'] = Variable<String>(destination);
    }
    if (!nullToAbsent || startOdometerKm != null) {
      map['start_odometer_km'] = Variable<int>(startOdometerKm);
    }
    if (!nullToAbsent || endOdometerKm != null) {
      map['end_odometer_km'] = Variable<int>(endOdometerKm);
    }
    map['distance_km'] = Variable<double>(distanceKm);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['duration_seconds'] = Variable<int>(durationSeconds);
    if (!nullToAbsent || avgSpeedKmh != null) {
      map['avg_speed_kmh'] = Variable<double>(avgSpeedKmh);
    }
    if (!nullToAbsent || maxSpeedKmh != null) {
      map['max_speed_kmh'] = Variable<double>(maxSpeedKmh);
    }
    map['is_gps_tracked'] = Variable<bool>(isGpsTracked);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || photoPaths != null) {
      map['photo_paths'] = Variable<String>(photoPaths);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TripsCompanion toCompanion(bool nullToAbsent) {
    return TripsCompanion(
      id: Value(id),
      motorcycleId: Value(motorcycleId),
      title: Value(title),
      category: Value(category),
      origin:
          origin == null && nullToAbsent ? const Value.absent() : Value(origin),
      destination: destination == null && nullToAbsent
          ? const Value.absent()
          : Value(destination),
      startOdometerKm: startOdometerKm == null && nullToAbsent
          ? const Value.absent()
          : Value(startOdometerKm),
      endOdometerKm: endOdometerKm == null && nullToAbsent
          ? const Value.absent()
          : Value(endOdometerKm),
      distanceKm: Value(distanceKm),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      durationSeconds: Value(durationSeconds),
      avgSpeedKmh: avgSpeedKmh == null && nullToAbsent
          ? const Value.absent()
          : Value(avgSpeedKmh),
      maxSpeedKmh: maxSpeedKmh == null && nullToAbsent
          ? const Value.absent()
          : Value(maxSpeedKmh),
      isGpsTracked: Value(isGpsTracked),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      photoPaths: photoPaths == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPaths),
      createdAt: Value(createdAt),
    );
  }

  factory Trip.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trip(
      id: serializer.fromJson<int>(json['id']),
      motorcycleId: serializer.fromJson<int>(json['motorcycleId']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      origin: serializer.fromJson<String?>(json['origin']),
      destination: serializer.fromJson<String?>(json['destination']),
      startOdometerKm: serializer.fromJson<int?>(json['startOdometerKm']),
      endOdometerKm: serializer.fromJson<int?>(json['endOdometerKm']),
      distanceKm: serializer.fromJson<double>(json['distanceKm']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      avgSpeedKmh: serializer.fromJson<double?>(json['avgSpeedKmh']),
      maxSpeedKmh: serializer.fromJson<double?>(json['maxSpeedKmh']),
      isGpsTracked: serializer.fromJson<bool>(json['isGpsTracked']),
      notes: serializer.fromJson<String?>(json['notes']),
      photoPaths: serializer.fromJson<String?>(json['photoPaths']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'motorcycleId': serializer.toJson<int>(motorcycleId),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'origin': serializer.toJson<String?>(origin),
      'destination': serializer.toJson<String?>(destination),
      'startOdometerKm': serializer.toJson<int?>(startOdometerKm),
      'endOdometerKm': serializer.toJson<int?>(endOdometerKm),
      'distanceKm': serializer.toJson<double>(distanceKm),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'avgSpeedKmh': serializer.toJson<double?>(avgSpeedKmh),
      'maxSpeedKmh': serializer.toJson<double?>(maxSpeedKmh),
      'isGpsTracked': serializer.toJson<bool>(isGpsTracked),
      'notes': serializer.toJson<String?>(notes),
      'photoPaths': serializer.toJson<String?>(photoPaths),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Trip copyWith(
          {int? id,
          int? motorcycleId,
          String? title,
          String? category,
          Value<String?> origin = const Value.absent(),
          Value<String?> destination = const Value.absent(),
          Value<int?> startOdometerKm = const Value.absent(),
          Value<int?> endOdometerKm = const Value.absent(),
          double? distanceKm,
          DateTime? startTime,
          Value<DateTime?> endTime = const Value.absent(),
          int? durationSeconds,
          Value<double?> avgSpeedKmh = const Value.absent(),
          Value<double?> maxSpeedKmh = const Value.absent(),
          bool? isGpsTracked,
          Value<String?> notes = const Value.absent(),
          Value<String?> photoPaths = const Value.absent(),
          DateTime? createdAt}) =>
      Trip(
        id: id ?? this.id,
        motorcycleId: motorcycleId ?? this.motorcycleId,
        title: title ?? this.title,
        category: category ?? this.category,
        origin: origin.present ? origin.value : this.origin,
        destination: destination.present ? destination.value : this.destination,
        startOdometerKm: startOdometerKm.present
            ? startOdometerKm.value
            : this.startOdometerKm,
        endOdometerKm:
            endOdometerKm.present ? endOdometerKm.value : this.endOdometerKm,
        distanceKm: distanceKm ?? this.distanceKm,
        startTime: startTime ?? this.startTime,
        endTime: endTime.present ? endTime.value : this.endTime,
        durationSeconds: durationSeconds ?? this.durationSeconds,
        avgSpeedKmh: avgSpeedKmh.present ? avgSpeedKmh.value : this.avgSpeedKmh,
        maxSpeedKmh: maxSpeedKmh.present ? maxSpeedKmh.value : this.maxSpeedKmh,
        isGpsTracked: isGpsTracked ?? this.isGpsTracked,
        notes: notes.present ? notes.value : this.notes,
        photoPaths: photoPaths.present ? photoPaths.value : this.photoPaths,
        createdAt: createdAt ?? this.createdAt,
      );
  Trip copyWithCompanion(TripsCompanion data) {
    return Trip(
      id: data.id.present ? data.id.value : this.id,
      motorcycleId: data.motorcycleId.present
          ? data.motorcycleId.value
          : this.motorcycleId,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      origin: data.origin.present ? data.origin.value : this.origin,
      destination:
          data.destination.present ? data.destination.value : this.destination,
      startOdometerKm: data.startOdometerKm.present
          ? data.startOdometerKm.value
          : this.startOdometerKm,
      endOdometerKm: data.endOdometerKm.present
          ? data.endOdometerKm.value
          : this.endOdometerKm,
      distanceKm:
          data.distanceKm.present ? data.distanceKm.value : this.distanceKm,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      avgSpeedKmh:
          data.avgSpeedKmh.present ? data.avgSpeedKmh.value : this.avgSpeedKmh,
      maxSpeedKmh:
          data.maxSpeedKmh.present ? data.maxSpeedKmh.value : this.maxSpeedKmh,
      isGpsTracked: data.isGpsTracked.present
          ? data.isGpsTracked.value
          : this.isGpsTracked,
      notes: data.notes.present ? data.notes.value : this.notes,
      photoPaths:
          data.photoPaths.present ? data.photoPaths.value : this.photoPaths,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trip(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('origin: $origin, ')
          ..write('destination: $destination, ')
          ..write('startOdometerKm: $startOdometerKm, ')
          ..write('endOdometerKm: $endOdometerKm, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('avgSpeedKmh: $avgSpeedKmh, ')
          ..write('maxSpeedKmh: $maxSpeedKmh, ')
          ..write('isGpsTracked: $isGpsTracked, ')
          ..write('notes: $notes, ')
          ..write('photoPaths: $photoPaths, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      motorcycleId,
      title,
      category,
      origin,
      destination,
      startOdometerKm,
      endOdometerKm,
      distanceKm,
      startTime,
      endTime,
      durationSeconds,
      avgSpeedKmh,
      maxSpeedKmh,
      isGpsTracked,
      notes,
      photoPaths,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trip &&
          other.id == this.id &&
          other.motorcycleId == this.motorcycleId &&
          other.title == this.title &&
          other.category == this.category &&
          other.origin == this.origin &&
          other.destination == this.destination &&
          other.startOdometerKm == this.startOdometerKm &&
          other.endOdometerKm == this.endOdometerKm &&
          other.distanceKm == this.distanceKm &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.durationSeconds == this.durationSeconds &&
          other.avgSpeedKmh == this.avgSpeedKmh &&
          other.maxSpeedKmh == this.maxSpeedKmh &&
          other.isGpsTracked == this.isGpsTracked &&
          other.notes == this.notes &&
          other.photoPaths == this.photoPaths &&
          other.createdAt == this.createdAt);
}

class TripsCompanion extends UpdateCompanion<Trip> {
  final Value<int> id;
  final Value<int> motorcycleId;
  final Value<String> title;
  final Value<String> category;
  final Value<String?> origin;
  final Value<String?> destination;
  final Value<int?> startOdometerKm;
  final Value<int?> endOdometerKm;
  final Value<double> distanceKm;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<int> durationSeconds;
  final Value<double?> avgSpeedKmh;
  final Value<double?> maxSpeedKmh;
  final Value<bool> isGpsTracked;
  final Value<String?> notes;
  final Value<String?> photoPaths;
  final Value<DateTime> createdAt;
  const TripsCompanion({
    this.id = const Value.absent(),
    this.motorcycleId = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.origin = const Value.absent(),
    this.destination = const Value.absent(),
    this.startOdometerKm = const Value.absent(),
    this.endOdometerKm = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.avgSpeedKmh = const Value.absent(),
    this.maxSpeedKmh = const Value.absent(),
    this.isGpsTracked = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPaths = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TripsCompanion.insert({
    this.id = const Value.absent(),
    required int motorcycleId,
    required String title,
    required String category,
    this.origin = const Value.absent(),
    this.destination = const Value.absent(),
    this.startOdometerKm = const Value.absent(),
    this.endOdometerKm = const Value.absent(),
    required double distanceKm,
    required DateTime startTime,
    this.endTime = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.avgSpeedKmh = const Value.absent(),
    this.maxSpeedKmh = const Value.absent(),
    this.isGpsTracked = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPaths = const Value.absent(),
    required DateTime createdAt,
  })  : motorcycleId = Value(motorcycleId),
        title = Value(title),
        category = Value(category),
        distanceKm = Value(distanceKm),
        startTime = Value(startTime),
        createdAt = Value(createdAt);
  static Insertable<Trip> custom({
    Expression<int>? id,
    Expression<int>? motorcycleId,
    Expression<String>? title,
    Expression<String>? category,
    Expression<String>? origin,
    Expression<String>? destination,
    Expression<int>? startOdometerKm,
    Expression<int>? endOdometerKm,
    Expression<double>? distanceKm,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? durationSeconds,
    Expression<double>? avgSpeedKmh,
    Expression<double>? maxSpeedKmh,
    Expression<bool>? isGpsTracked,
    Expression<String>? notes,
    Expression<String>? photoPaths,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (motorcycleId != null) 'motorcycle_id': motorcycleId,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (origin != null) 'origin': origin,
      if (destination != null) 'destination': destination,
      if (startOdometerKm != null) 'start_odometer_km': startOdometerKm,
      if (endOdometerKm != null) 'end_odometer_km': endOdometerKm,
      if (distanceKm != null) 'distance_km': distanceKm,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (avgSpeedKmh != null) 'avg_speed_kmh': avgSpeedKmh,
      if (maxSpeedKmh != null) 'max_speed_kmh': maxSpeedKmh,
      if (isGpsTracked != null) 'is_gps_tracked': isGpsTracked,
      if (notes != null) 'notes': notes,
      if (photoPaths != null) 'photo_paths': photoPaths,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TripsCompanion copyWith(
      {Value<int>? id,
      Value<int>? motorcycleId,
      Value<String>? title,
      Value<String>? category,
      Value<String?>? origin,
      Value<String?>? destination,
      Value<int?>? startOdometerKm,
      Value<int?>? endOdometerKm,
      Value<double>? distanceKm,
      Value<DateTime>? startTime,
      Value<DateTime?>? endTime,
      Value<int>? durationSeconds,
      Value<double?>? avgSpeedKmh,
      Value<double?>? maxSpeedKmh,
      Value<bool>? isGpsTracked,
      Value<String?>? notes,
      Value<String?>? photoPaths,
      Value<DateTime>? createdAt}) {
    return TripsCompanion(
      id: id ?? this.id,
      motorcycleId: motorcycleId ?? this.motorcycleId,
      title: title ?? this.title,
      category: category ?? this.category,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      startOdometerKm: startOdometerKm ?? this.startOdometerKm,
      endOdometerKm: endOdometerKm ?? this.endOdometerKm,
      distanceKm: distanceKm ?? this.distanceKm,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      avgSpeedKmh: avgSpeedKmh ?? this.avgSpeedKmh,
      maxSpeedKmh: maxSpeedKmh ?? this.maxSpeedKmh,
      isGpsTracked: isGpsTracked ?? this.isGpsTracked,
      notes: notes ?? this.notes,
      photoPaths: photoPaths ?? this.photoPaths,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (motorcycleId.present) {
      map['motorcycle_id'] = Variable<int>(motorcycleId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (startOdometerKm.present) {
      map['start_odometer_km'] = Variable<int>(startOdometerKm.value);
    }
    if (endOdometerKm.present) {
      map['end_odometer_km'] = Variable<int>(endOdometerKm.value);
    }
    if (distanceKm.present) {
      map['distance_km'] = Variable<double>(distanceKm.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (avgSpeedKmh.present) {
      map['avg_speed_kmh'] = Variable<double>(avgSpeedKmh.value);
    }
    if (maxSpeedKmh.present) {
      map['max_speed_kmh'] = Variable<double>(maxSpeedKmh.value);
    }
    if (isGpsTracked.present) {
      map['is_gps_tracked'] = Variable<bool>(isGpsTracked.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (photoPaths.present) {
      map['photo_paths'] = Variable<String>(photoPaths.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripsCompanion(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('origin: $origin, ')
          ..write('destination: $destination, ')
          ..write('startOdometerKm: $startOdometerKm, ')
          ..write('endOdometerKm: $endOdometerKm, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('avgSpeedKmh: $avgSpeedKmh, ')
          ..write('maxSpeedKmh: $maxSpeedKmh, ')
          ..write('isGpsTracked: $isGpsTracked, ')
          ..write('notes: $notes, ')
          ..write('photoPaths: $photoPaths, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TripWaypointsTable extends TripWaypoints
    with TableInfo<$TripWaypointsTable, TripWaypoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripWaypointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
      'trip_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES trips (id) ON DELETE CASCADE'));
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _altitudeMeta =
      const VerificationMeta('altitude');
  @override
  late final GeneratedColumn<double> altitude = GeneratedColumn<double>(
      'altitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _speedKmhMeta =
      const VerificationMeta('speedKmh');
  @override
  late final GeneratedColumn<double> speedKmh = GeneratedColumn<double>(
      'speed_kmh', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _headingMeta =
      const VerificationMeta('heading');
  @override
  late final GeneratedColumn<double> heading = GeneratedColumn<double>(
      'heading', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _accuracyMetersMeta =
      const VerificationMeta('accuracyMeters');
  @override
  late final GeneratedColumn<double> accuracyMeters = GeneratedColumn<double>(
      'accuracy_meters', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sequenceMeta =
      const VerificationMeta('sequence');
  @override
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
      'sequence', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tripId,
        latitude,
        longitude,
        altitude,
        speedKmh,
        heading,
        accuracyMeters,
        recordedAt,
        sequence
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trip_waypoints';
  @override
  VerificationContext validateIntegrity(Insertable<TripWaypoint> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('trip_id')) {
      context.handle(_tripIdMeta,
          tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta));
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('altitude')) {
      context.handle(_altitudeMeta,
          altitude.isAcceptableOrUnknown(data['altitude']!, _altitudeMeta));
    }
    if (data.containsKey('speed_kmh')) {
      context.handle(_speedKmhMeta,
          speedKmh.isAcceptableOrUnknown(data['speed_kmh']!, _speedKmhMeta));
    }
    if (data.containsKey('heading')) {
      context.handle(_headingMeta,
          heading.isAcceptableOrUnknown(data['heading']!, _headingMeta));
    }
    if (data.containsKey('accuracy_meters')) {
      context.handle(
          _accuracyMetersMeta,
          accuracyMeters.isAcceptableOrUnknown(
              data['accuracy_meters']!, _accuracyMetersMeta));
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('sequence')) {
      context.handle(_sequenceMeta,
          sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta));
    } else if (isInserting) {
      context.missing(_sequenceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TripWaypoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TripWaypoint(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tripId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}trip_id'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      altitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}altitude']),
      speedKmh: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}speed_kmh']),
      heading: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}heading']),
      accuracyMeters: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}accuracy_meters']),
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at'])!,
      sequence: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sequence'])!,
    );
  }

  @override
  $TripWaypointsTable createAlias(String alias) {
    return $TripWaypointsTable(attachedDatabase, alias);
  }
}

class TripWaypoint extends DataClass implements Insertable<TripWaypoint> {
  final int id;
  final int tripId;
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? speedKmh;
  final double? heading;
  final double? accuracyMeters;
  final DateTime recordedAt;
  final int sequence;
  const TripWaypoint(
      {required this.id,
      required this.tripId,
      required this.latitude,
      required this.longitude,
      this.altitude,
      this.speedKmh,
      this.heading,
      this.accuracyMeters,
      required this.recordedAt,
      required this.sequence});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['trip_id'] = Variable<int>(tripId);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || altitude != null) {
      map['altitude'] = Variable<double>(altitude);
    }
    if (!nullToAbsent || speedKmh != null) {
      map['speed_kmh'] = Variable<double>(speedKmh);
    }
    if (!nullToAbsent || heading != null) {
      map['heading'] = Variable<double>(heading);
    }
    if (!nullToAbsent || accuracyMeters != null) {
      map['accuracy_meters'] = Variable<double>(accuracyMeters);
    }
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['sequence'] = Variable<int>(sequence);
    return map;
  }

  TripWaypointsCompanion toCompanion(bool nullToAbsent) {
    return TripWaypointsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      latitude: Value(latitude),
      longitude: Value(longitude),
      altitude: altitude == null && nullToAbsent
          ? const Value.absent()
          : Value(altitude),
      speedKmh: speedKmh == null && nullToAbsent
          ? const Value.absent()
          : Value(speedKmh),
      heading: heading == null && nullToAbsent
          ? const Value.absent()
          : Value(heading),
      accuracyMeters: accuracyMeters == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracyMeters),
      recordedAt: Value(recordedAt),
      sequence: Value(sequence),
    );
  }

  factory TripWaypoint.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TripWaypoint(
      id: serializer.fromJson<int>(json['id']),
      tripId: serializer.fromJson<int>(json['tripId']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      altitude: serializer.fromJson<double?>(json['altitude']),
      speedKmh: serializer.fromJson<double?>(json['speedKmh']),
      heading: serializer.fromJson<double?>(json['heading']),
      accuracyMeters: serializer.fromJson<double?>(json['accuracyMeters']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      sequence: serializer.fromJson<int>(json['sequence']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tripId': serializer.toJson<int>(tripId),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'altitude': serializer.toJson<double?>(altitude),
      'speedKmh': serializer.toJson<double?>(speedKmh),
      'heading': serializer.toJson<double?>(heading),
      'accuracyMeters': serializer.toJson<double?>(accuracyMeters),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'sequence': serializer.toJson<int>(sequence),
    };
  }

  TripWaypoint copyWith(
          {int? id,
          int? tripId,
          double? latitude,
          double? longitude,
          Value<double?> altitude = const Value.absent(),
          Value<double?> speedKmh = const Value.absent(),
          Value<double?> heading = const Value.absent(),
          Value<double?> accuracyMeters = const Value.absent(),
          DateTime? recordedAt,
          int? sequence}) =>
      TripWaypoint(
        id: id ?? this.id,
        tripId: tripId ?? this.tripId,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        altitude: altitude.present ? altitude.value : this.altitude,
        speedKmh: speedKmh.present ? speedKmh.value : this.speedKmh,
        heading: heading.present ? heading.value : this.heading,
        accuracyMeters:
            accuracyMeters.present ? accuracyMeters.value : this.accuracyMeters,
        recordedAt: recordedAt ?? this.recordedAt,
        sequence: sequence ?? this.sequence,
      );
  TripWaypoint copyWithCompanion(TripWaypointsCompanion data) {
    return TripWaypoint(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      altitude: data.altitude.present ? data.altitude.value : this.altitude,
      speedKmh: data.speedKmh.present ? data.speedKmh.value : this.speedKmh,
      heading: data.heading.present ? data.heading.value : this.heading,
      accuracyMeters: data.accuracyMeters.present
          ? data.accuracyMeters.value
          : this.accuracyMeters,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TripWaypoint(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitude: $altitude, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('heading: $heading, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('sequence: $sequence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tripId, latitude, longitude, altitude,
      speedKmh, heading, accuracyMeters, recordedAt, sequence);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TripWaypoint &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.altitude == this.altitude &&
          other.speedKmh == this.speedKmh &&
          other.heading == this.heading &&
          other.accuracyMeters == this.accuracyMeters &&
          other.recordedAt == this.recordedAt &&
          other.sequence == this.sequence);
}

class TripWaypointsCompanion extends UpdateCompanion<TripWaypoint> {
  final Value<int> id;
  final Value<int> tripId;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double?> altitude;
  final Value<double?> speedKmh;
  final Value<double?> heading;
  final Value<double?> accuracyMeters;
  final Value<DateTime> recordedAt;
  final Value<int> sequence;
  const TripWaypointsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.altitude = const Value.absent(),
    this.speedKmh = const Value.absent(),
    this.heading = const Value.absent(),
    this.accuracyMeters = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.sequence = const Value.absent(),
  });
  TripWaypointsCompanion.insert({
    this.id = const Value.absent(),
    required int tripId,
    required double latitude,
    required double longitude,
    this.altitude = const Value.absent(),
    this.speedKmh = const Value.absent(),
    this.heading = const Value.absent(),
    this.accuracyMeters = const Value.absent(),
    required DateTime recordedAt,
    required int sequence,
  })  : tripId = Value(tripId),
        latitude = Value(latitude),
        longitude = Value(longitude),
        recordedAt = Value(recordedAt),
        sequence = Value(sequence);
  static Insertable<TripWaypoint> custom({
    Expression<int>? id,
    Expression<int>? tripId,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? altitude,
    Expression<double>? speedKmh,
    Expression<double>? heading,
    Expression<double>? accuracyMeters,
    Expression<DateTime>? recordedAt,
    Expression<int>? sequence,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (altitude != null) 'altitude': altitude,
      if (speedKmh != null) 'speed_kmh': speedKmh,
      if (heading != null) 'heading': heading,
      if (accuracyMeters != null) 'accuracy_meters': accuracyMeters,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (sequence != null) 'sequence': sequence,
    });
  }

  TripWaypointsCompanion copyWith(
      {Value<int>? id,
      Value<int>? tripId,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<double?>? altitude,
      Value<double?>? speedKmh,
      Value<double?>? heading,
      Value<double?>? accuracyMeters,
      Value<DateTime>? recordedAt,
      Value<int>? sequence}) {
    return TripWaypointsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      speedKmh: speedKmh ?? this.speedKmh,
      heading: heading ?? this.heading,
      accuracyMeters: accuracyMeters ?? this.accuracyMeters,
      recordedAt: recordedAt ?? this.recordedAt,
      sequence: sequence ?? this.sequence,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (altitude.present) {
      map['altitude'] = Variable<double>(altitude.value);
    }
    if (speedKmh.present) {
      map['speed_kmh'] = Variable<double>(speedKmh.value);
    }
    if (heading.present) {
      map['heading'] = Variable<double>(heading.value);
    }
    if (accuracyMeters.present) {
      map['accuracy_meters'] = Variable<double>(accuracyMeters.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripWaypointsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitude: $altitude, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('heading: $heading, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('sequence: $sequence')
          ..write(')'))
        .toString();
  }
}

class $SavedLocationsTable extends SavedLocations
    with TableInfo<$SavedLocationsTable, SavedLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, category, latitude, longitude, address, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_locations';
  @override
  VerificationContext validateIntegrity(Insertable<SavedLocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedLocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SavedLocationsTable createAlias(String alias) {
    return $SavedLocationsTable(attachedDatabase, alias);
  }
}

class SavedLocation extends DataClass implements Insertable<SavedLocation> {
  final int id;
  final String name;
  final String category;
  final double latitude;
  final double longitude;
  final String? address;
  final DateTime createdAt;
  const SavedLocation(
      {required this.id,
      required this.name,
      required this.category,
      required this.latitude,
      required this.longitude,
      this.address,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SavedLocationsCompanion toCompanion(bool nullToAbsent) {
    return SavedLocationsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      latitude: Value(latitude),
      longitude: Value(longitude),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      createdAt: Value(createdAt),
    );
  }

  factory SavedLocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedLocation(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      address: serializer.fromJson<String?>(json['address']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'address': serializer.toJson<String?>(address),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SavedLocation copyWith(
          {int? id,
          String? name,
          String? category,
          double? latitude,
          double? longitude,
          Value<String?> address = const Value.absent(),
          DateTime? createdAt}) =>
      SavedLocation(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        address: address.present ? address.value : this.address,
        createdAt: createdAt ?? this.createdAt,
      );
  SavedLocation copyWithCompanion(SavedLocationsCompanion data) {
    return SavedLocation(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      address: data.address.present ? data.address.value : this.address,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedLocation(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('address: $address, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, category, latitude, longitude, address, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedLocation &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.address == this.address &&
          other.createdAt == this.createdAt);
}

class SavedLocationsCompanion extends UpdateCompanion<SavedLocation> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> category;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String?> address;
  final Value<DateTime> createdAt;
  const SavedLocationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.address = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SavedLocationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String category,
    required double latitude,
    required double longitude,
    this.address = const Value.absent(),
    required DateTime createdAt,
  })  : name = Value(name),
        category = Value(category),
        latitude = Value(latitude),
        longitude = Value(longitude),
        createdAt = Value(createdAt);
  static Insertable<SavedLocation> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? address,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (address != null) 'address': address,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SavedLocationsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? category,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<String?>? address,
      Value<DateTime>? createdAt}) {
    return SavedLocationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedLocationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('address: $address, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SavedRoutesTable extends SavedRoutes
    with TableInfo<$SavedRoutesTable, SavedRoute> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedRoutesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _motorcycleIdMeta =
      const VerificationMeta('motorcycleId');
  @override
  late final GeneratedColumn<int> motorcycleId = GeneratedColumn<int>(
      'motorcycle_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES motorcycles (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _originNameMeta =
      const VerificationMeta('originName');
  @override
  late final GeneratedColumn<String> originName = GeneratedColumn<String>(
      'origin_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _destinationNameMeta =
      const VerificationMeta('destinationName');
  @override
  late final GeneratedColumn<String> destinationName = GeneratedColumn<String>(
      'destination_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _originLatMeta =
      const VerificationMeta('originLat');
  @override
  late final GeneratedColumn<double> originLat = GeneratedColumn<double>(
      'origin_lat', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _originLngMeta =
      const VerificationMeta('originLng');
  @override
  late final GeneratedColumn<double> originLng = GeneratedColumn<double>(
      'origin_lng', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _destLatMeta =
      const VerificationMeta('destLat');
  @override
  late final GeneratedColumn<double> destLat = GeneratedColumn<double>(
      'dest_lat', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _destLngMeta =
      const VerificationMeta('destLng');
  @override
  late final GeneratedColumn<double> destLng = GeneratedColumn<double>(
      'dest_lng', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _waypointsJsonMeta =
      const VerificationMeta('waypointsJson');
  @override
  late final GeneratedColumn<String> waypointsJson = GeneratedColumn<String>(
      'waypoints_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _distanceKmMeta =
      const VerificationMeta('distanceKm');
  @override
  late final GeneratedColumn<double> distanceKm = GeneratedColumn<double>(
      'distance_km', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _durationMinutesMeta =
      const VerificationMeta('durationMinutes');
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
      'duration_minutes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        motorcycleId,
        name,
        originName,
        destinationName,
        originLat,
        originLng,
        destLat,
        destLng,
        waypointsJson,
        distanceKm,
        durationMinutes,
        notes,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_routes';
  @override
  VerificationContext validateIntegrity(Insertable<SavedRoute> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('motorcycle_id')) {
      context.handle(
          _motorcycleIdMeta,
          motorcycleId.isAcceptableOrUnknown(
              data['motorcycle_id']!, _motorcycleIdMeta));
    } else if (isInserting) {
      context.missing(_motorcycleIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('origin_name')) {
      context.handle(
          _originNameMeta,
          originName.isAcceptableOrUnknown(
              data['origin_name']!, _originNameMeta));
    }
    if (data.containsKey('destination_name')) {
      context.handle(
          _destinationNameMeta,
          destinationName.isAcceptableOrUnknown(
              data['destination_name']!, _destinationNameMeta));
    }
    if (data.containsKey('origin_lat')) {
      context.handle(_originLatMeta,
          originLat.isAcceptableOrUnknown(data['origin_lat']!, _originLatMeta));
    } else if (isInserting) {
      context.missing(_originLatMeta);
    }
    if (data.containsKey('origin_lng')) {
      context.handle(_originLngMeta,
          originLng.isAcceptableOrUnknown(data['origin_lng']!, _originLngMeta));
    } else if (isInserting) {
      context.missing(_originLngMeta);
    }
    if (data.containsKey('dest_lat')) {
      context.handle(_destLatMeta,
          destLat.isAcceptableOrUnknown(data['dest_lat']!, _destLatMeta));
    } else if (isInserting) {
      context.missing(_destLatMeta);
    }
    if (data.containsKey('dest_lng')) {
      context.handle(_destLngMeta,
          destLng.isAcceptableOrUnknown(data['dest_lng']!, _destLngMeta));
    } else if (isInserting) {
      context.missing(_destLngMeta);
    }
    if (data.containsKey('waypoints_json')) {
      context.handle(
          _waypointsJsonMeta,
          waypointsJson.isAcceptableOrUnknown(
              data['waypoints_json']!, _waypointsJsonMeta));
    }
    if (data.containsKey('distance_km')) {
      context.handle(
          _distanceKmMeta,
          distanceKm.isAcceptableOrUnknown(
              data['distance_km']!, _distanceKmMeta));
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
          _durationMinutesMeta,
          durationMinutes.isAcceptableOrUnknown(
              data['duration_minutes']!, _durationMinutesMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedRoute map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedRoute(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      motorcycleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}motorcycle_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      originName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}origin_name']),
      destinationName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}destination_name']),
      originLat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}origin_lat'])!,
      originLng: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}origin_lng'])!,
      destLat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}dest_lat'])!,
      destLng: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}dest_lng'])!,
      waypointsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}waypoints_json']),
      distanceKm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}distance_km'])!,
      durationMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_minutes']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SavedRoutesTable createAlias(String alias) {
    return $SavedRoutesTable(attachedDatabase, alias);
  }
}

class SavedRoute extends DataClass implements Insertable<SavedRoute> {
  final int id;
  final int motorcycleId;
  final String name;
  final String? originName;
  final String? destinationName;
  final double originLat;
  final double originLng;
  final double destLat;
  final double destLng;
  final String? waypointsJson;
  final double distanceKm;
  final int? durationMinutes;
  final String? notes;
  final DateTime createdAt;
  const SavedRoute(
      {required this.id,
      required this.motorcycleId,
      required this.name,
      this.originName,
      this.destinationName,
      required this.originLat,
      required this.originLng,
      required this.destLat,
      required this.destLng,
      this.waypointsJson,
      required this.distanceKm,
      this.durationMinutes,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['motorcycle_id'] = Variable<int>(motorcycleId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || originName != null) {
      map['origin_name'] = Variable<String>(originName);
    }
    if (!nullToAbsent || destinationName != null) {
      map['destination_name'] = Variable<String>(destinationName);
    }
    map['origin_lat'] = Variable<double>(originLat);
    map['origin_lng'] = Variable<double>(originLng);
    map['dest_lat'] = Variable<double>(destLat);
    map['dest_lng'] = Variable<double>(destLng);
    if (!nullToAbsent || waypointsJson != null) {
      map['waypoints_json'] = Variable<String>(waypointsJson);
    }
    map['distance_km'] = Variable<double>(distanceKm);
    if (!nullToAbsent || durationMinutes != null) {
      map['duration_minutes'] = Variable<int>(durationMinutes);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SavedRoutesCompanion toCompanion(bool nullToAbsent) {
    return SavedRoutesCompanion(
      id: Value(id),
      motorcycleId: Value(motorcycleId),
      name: Value(name),
      originName: originName == null && nullToAbsent
          ? const Value.absent()
          : Value(originName),
      destinationName: destinationName == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationName),
      originLat: Value(originLat),
      originLng: Value(originLng),
      destLat: Value(destLat),
      destLng: Value(destLng),
      waypointsJson: waypointsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(waypointsJson),
      distanceKm: Value(distanceKm),
      durationMinutes: durationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMinutes),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory SavedRoute.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedRoute(
      id: serializer.fromJson<int>(json['id']),
      motorcycleId: serializer.fromJson<int>(json['motorcycleId']),
      name: serializer.fromJson<String>(json['name']),
      originName: serializer.fromJson<String?>(json['originName']),
      destinationName: serializer.fromJson<String?>(json['destinationName']),
      originLat: serializer.fromJson<double>(json['originLat']),
      originLng: serializer.fromJson<double>(json['originLng']),
      destLat: serializer.fromJson<double>(json['destLat']),
      destLng: serializer.fromJson<double>(json['destLng']),
      waypointsJson: serializer.fromJson<String?>(json['waypointsJson']),
      distanceKm: serializer.fromJson<double>(json['distanceKm']),
      durationMinutes: serializer.fromJson<int?>(json['durationMinutes']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'motorcycleId': serializer.toJson<int>(motorcycleId),
      'name': serializer.toJson<String>(name),
      'originName': serializer.toJson<String?>(originName),
      'destinationName': serializer.toJson<String?>(destinationName),
      'originLat': serializer.toJson<double>(originLat),
      'originLng': serializer.toJson<double>(originLng),
      'destLat': serializer.toJson<double>(destLat),
      'destLng': serializer.toJson<double>(destLng),
      'waypointsJson': serializer.toJson<String?>(waypointsJson),
      'distanceKm': serializer.toJson<double>(distanceKm),
      'durationMinutes': serializer.toJson<int?>(durationMinutes),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SavedRoute copyWith(
          {int? id,
          int? motorcycleId,
          String? name,
          Value<String?> originName = const Value.absent(),
          Value<String?> destinationName = const Value.absent(),
          double? originLat,
          double? originLng,
          double? destLat,
          double? destLng,
          Value<String?> waypointsJson = const Value.absent(),
          double? distanceKm,
          Value<int?> durationMinutes = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      SavedRoute(
        id: id ?? this.id,
        motorcycleId: motorcycleId ?? this.motorcycleId,
        name: name ?? this.name,
        originName: originName.present ? originName.value : this.originName,
        destinationName: destinationName.present
            ? destinationName.value
            : this.destinationName,
        originLat: originLat ?? this.originLat,
        originLng: originLng ?? this.originLng,
        destLat: destLat ?? this.destLat,
        destLng: destLng ?? this.destLng,
        waypointsJson:
            waypointsJson.present ? waypointsJson.value : this.waypointsJson,
        distanceKm: distanceKm ?? this.distanceKm,
        durationMinutes: durationMinutes.present
            ? durationMinutes.value
            : this.durationMinutes,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  SavedRoute copyWithCompanion(SavedRoutesCompanion data) {
    return SavedRoute(
      id: data.id.present ? data.id.value : this.id,
      motorcycleId: data.motorcycleId.present
          ? data.motorcycleId.value
          : this.motorcycleId,
      name: data.name.present ? data.name.value : this.name,
      originName:
          data.originName.present ? data.originName.value : this.originName,
      destinationName: data.destinationName.present
          ? data.destinationName.value
          : this.destinationName,
      originLat: data.originLat.present ? data.originLat.value : this.originLat,
      originLng: data.originLng.present ? data.originLng.value : this.originLng,
      destLat: data.destLat.present ? data.destLat.value : this.destLat,
      destLng: data.destLng.present ? data.destLng.value : this.destLng,
      waypointsJson: data.waypointsJson.present
          ? data.waypointsJson.value
          : this.waypointsJson,
      distanceKm:
          data.distanceKm.present ? data.distanceKm.value : this.distanceKm,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedRoute(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('name: $name, ')
          ..write('originName: $originName, ')
          ..write('destinationName: $destinationName, ')
          ..write('originLat: $originLat, ')
          ..write('originLng: $originLng, ')
          ..write('destLat: $destLat, ')
          ..write('destLng: $destLng, ')
          ..write('waypointsJson: $waypointsJson, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      motorcycleId,
      name,
      originName,
      destinationName,
      originLat,
      originLng,
      destLat,
      destLng,
      waypointsJson,
      distanceKm,
      durationMinutes,
      notes,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedRoute &&
          other.id == this.id &&
          other.motorcycleId == this.motorcycleId &&
          other.name == this.name &&
          other.originName == this.originName &&
          other.destinationName == this.destinationName &&
          other.originLat == this.originLat &&
          other.originLng == this.originLng &&
          other.destLat == this.destLat &&
          other.destLng == this.destLng &&
          other.waypointsJson == this.waypointsJson &&
          other.distanceKm == this.distanceKm &&
          other.durationMinutes == this.durationMinutes &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class SavedRoutesCompanion extends UpdateCompanion<SavedRoute> {
  final Value<int> id;
  final Value<int> motorcycleId;
  final Value<String> name;
  final Value<String?> originName;
  final Value<String?> destinationName;
  final Value<double> originLat;
  final Value<double> originLng;
  final Value<double> destLat;
  final Value<double> destLng;
  final Value<String?> waypointsJson;
  final Value<double> distanceKm;
  final Value<int?> durationMinutes;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const SavedRoutesCompanion({
    this.id = const Value.absent(),
    this.motorcycleId = const Value.absent(),
    this.name = const Value.absent(),
    this.originName = const Value.absent(),
    this.destinationName = const Value.absent(),
    this.originLat = const Value.absent(),
    this.originLng = const Value.absent(),
    this.destLat = const Value.absent(),
    this.destLng = const Value.absent(),
    this.waypointsJson = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SavedRoutesCompanion.insert({
    this.id = const Value.absent(),
    required int motorcycleId,
    required String name,
    this.originName = const Value.absent(),
    this.destinationName = const Value.absent(),
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    this.waypointsJson = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
  })  : motorcycleId = Value(motorcycleId),
        name = Value(name),
        originLat = Value(originLat),
        originLng = Value(originLng),
        destLat = Value(destLat),
        destLng = Value(destLng),
        createdAt = Value(createdAt);
  static Insertable<SavedRoute> custom({
    Expression<int>? id,
    Expression<int>? motorcycleId,
    Expression<String>? name,
    Expression<String>? originName,
    Expression<String>? destinationName,
    Expression<double>? originLat,
    Expression<double>? originLng,
    Expression<double>? destLat,
    Expression<double>? destLng,
    Expression<String>? waypointsJson,
    Expression<double>? distanceKm,
    Expression<int>? durationMinutes,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (motorcycleId != null) 'motorcycle_id': motorcycleId,
      if (name != null) 'name': name,
      if (originName != null) 'origin_name': originName,
      if (destinationName != null) 'destination_name': destinationName,
      if (originLat != null) 'origin_lat': originLat,
      if (originLng != null) 'origin_lng': originLng,
      if (destLat != null) 'dest_lat': destLat,
      if (destLng != null) 'dest_lng': destLng,
      if (waypointsJson != null) 'waypoints_json': waypointsJson,
      if (distanceKm != null) 'distance_km': distanceKm,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SavedRoutesCompanion copyWith(
      {Value<int>? id,
      Value<int>? motorcycleId,
      Value<String>? name,
      Value<String?>? originName,
      Value<String?>? destinationName,
      Value<double>? originLat,
      Value<double>? originLng,
      Value<double>? destLat,
      Value<double>? destLng,
      Value<String?>? waypointsJson,
      Value<double>? distanceKm,
      Value<int?>? durationMinutes,
      Value<String?>? notes,
      Value<DateTime>? createdAt}) {
    return SavedRoutesCompanion(
      id: id ?? this.id,
      motorcycleId: motorcycleId ?? this.motorcycleId,
      name: name ?? this.name,
      originName: originName ?? this.originName,
      destinationName: destinationName ?? this.destinationName,
      originLat: originLat ?? this.originLat,
      originLng: originLng ?? this.originLng,
      destLat: destLat ?? this.destLat,
      destLng: destLng ?? this.destLng,
      waypointsJson: waypointsJson ?? this.waypointsJson,
      distanceKm: distanceKm ?? this.distanceKm,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (motorcycleId.present) {
      map['motorcycle_id'] = Variable<int>(motorcycleId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (originName.present) {
      map['origin_name'] = Variable<String>(originName.value);
    }
    if (destinationName.present) {
      map['destination_name'] = Variable<String>(destinationName.value);
    }
    if (originLat.present) {
      map['origin_lat'] = Variable<double>(originLat.value);
    }
    if (originLng.present) {
      map['origin_lng'] = Variable<double>(originLng.value);
    }
    if (destLat.present) {
      map['dest_lat'] = Variable<double>(destLat.value);
    }
    if (destLng.present) {
      map['dest_lng'] = Variable<double>(destLng.value);
    }
    if (waypointsJson.present) {
      map['waypoints_json'] = Variable<String>(waypointsJson.value);
    }
    if (distanceKm.present) {
      map['distance_km'] = Variable<double>(distanceKm.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedRoutesCompanion(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('name: $name, ')
          ..write('originName: $originName, ')
          ..write('destinationName: $destinationName, ')
          ..write('originLat: $originLat, ')
          ..write('originLng: $originLng, ')
          ..write('destLat: $destLat, ')
          ..write('destLng: $destLng, ')
          ..write('waypointsJson: $waypointsJson, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CvtConfigurationsTable extends CvtConfigurations
    with TableInfo<$CvtConfigurationsTable, CvtConfiguration> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CvtConfigurationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _motorcycleIdMeta =
      const VerificationMeta('motorcycleId');
  @override
  late final GeneratedColumn<int> motorcycleId = GeneratedColumn<int>(
      'motorcycle_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES motorcycles (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _pulleyBrandModelMeta =
      const VerificationMeta('pulleyBrandModel');
  @override
  late final GeneratedColumn<String> pulleyBrandModel = GeneratedColumn<String>(
      'pulley_brand_model', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _flyballWeightGramsMeta =
      const VerificationMeta('flyballWeightGrams');
  @override
  late final GeneratedColumn<double> flyballWeightGrams =
      GeneratedColumn<double>('flyball_weight_grams', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _flyballArrangementMeta =
      const VerificationMeta('flyballArrangement');
  @override
  late final GeneratedColumn<String> flyballArrangement =
      GeneratedColumn<String>('flyball_arrangement', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _centerSpringRpmMeta =
      const VerificationMeta('centerSpringRpm');
  @override
  late final GeneratedColumn<int> centerSpringRpm = GeneratedColumn<int>(
      'center_spring_rpm', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _clutchSpringRpmMeta =
      const VerificationMeta('clutchSpringRpm');
  @override
  late final GeneratedColumn<int> clutchSpringRpm = GeneratedColumn<int>(
      'clutch_spring_rpm', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _beltBrandPartNumberMeta =
      const VerificationMeta('beltBrandPartNumber');
  @override
  late final GeneratedColumn<String> beltBrandPartNumber =
      GeneratedColumn<String>('belt_brand_part_number', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pulleyWasherThicknessMmMeta =
      const VerificationMeta('pulleyWasherThicknessMm');
  @override
  late final GeneratedColumn<double> pulleyWasherThicknessMm =
      GeneratedColumn<double>('pulley_washer_thickness_mm', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _clutchBellSpecMeta =
      const VerificationMeta('clutchBellSpec');
  @override
  late final GeneratedColumn<String> clutchBellSpec = GeneratedColumn<String>(
      'clutch_bell_spec', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _exhaustSpecMeta =
      const VerificationMeta('exhaustSpec');
  @override
  late final GeneratedColumn<String> exhaustSpec = GeneratedColumn<String>(
      'exhaust_spec', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _otherModsMeta =
      const VerificationMeta('otherMods');
  @override
  late final GeneratedColumn<String> otherMods = GeneratedColumn<String>(
      'other_mods', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _installedDateMeta =
      const VerificationMeta('installedDate');
  @override
  late final GeneratedColumn<DateTime> installedDate =
      GeneratedColumn<DateTime>('installed_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _installedOdometerKmMeta =
      const VerificationMeta('installedOdometerKm');
  @override
  late final GeneratedColumn<int> installedOdometerKm = GeneratedColumn<int>(
      'installed_odometer_km', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoPathsMeta =
      const VerificationMeta('photoPaths');
  @override
  late final GeneratedColumn<String> photoPaths = GeneratedColumn<String>(
      'photo_paths', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        motorcycleId,
        name,
        pulleyBrandModel,
        flyballWeightGrams,
        flyballArrangement,
        centerSpringRpm,
        clutchSpringRpm,
        beltBrandPartNumber,
        pulleyWasherThicknessMm,
        clutchBellSpec,
        exhaustSpec,
        otherMods,
        installedDate,
        installedOdometerKm,
        isActive,
        isArchived,
        notes,
        photoPaths,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cvt_configurations';
  @override
  VerificationContext validateIntegrity(Insertable<CvtConfiguration> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('motorcycle_id')) {
      context.handle(
          _motorcycleIdMeta,
          motorcycleId.isAcceptableOrUnknown(
              data['motorcycle_id']!, _motorcycleIdMeta));
    } else if (isInserting) {
      context.missing(_motorcycleIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('pulley_brand_model')) {
      context.handle(
          _pulleyBrandModelMeta,
          pulleyBrandModel.isAcceptableOrUnknown(
              data['pulley_brand_model']!, _pulleyBrandModelMeta));
    }
    if (data.containsKey('flyball_weight_grams')) {
      context.handle(
          _flyballWeightGramsMeta,
          flyballWeightGrams.isAcceptableOrUnknown(
              data['flyball_weight_grams']!, _flyballWeightGramsMeta));
    }
    if (data.containsKey('flyball_arrangement')) {
      context.handle(
          _flyballArrangementMeta,
          flyballArrangement.isAcceptableOrUnknown(
              data['flyball_arrangement']!, _flyballArrangementMeta));
    }
    if (data.containsKey('center_spring_rpm')) {
      context.handle(
          _centerSpringRpmMeta,
          centerSpringRpm.isAcceptableOrUnknown(
              data['center_spring_rpm']!, _centerSpringRpmMeta));
    }
    if (data.containsKey('clutch_spring_rpm')) {
      context.handle(
          _clutchSpringRpmMeta,
          clutchSpringRpm.isAcceptableOrUnknown(
              data['clutch_spring_rpm']!, _clutchSpringRpmMeta));
    }
    if (data.containsKey('belt_brand_part_number')) {
      context.handle(
          _beltBrandPartNumberMeta,
          beltBrandPartNumber.isAcceptableOrUnknown(
              data['belt_brand_part_number']!, _beltBrandPartNumberMeta));
    }
    if (data.containsKey('pulley_washer_thickness_mm')) {
      context.handle(
          _pulleyWasherThicknessMmMeta,
          pulleyWasherThicknessMm.isAcceptableOrUnknown(
              data['pulley_washer_thickness_mm']!,
              _pulleyWasherThicknessMmMeta));
    }
    if (data.containsKey('clutch_bell_spec')) {
      context.handle(
          _clutchBellSpecMeta,
          clutchBellSpec.isAcceptableOrUnknown(
              data['clutch_bell_spec']!, _clutchBellSpecMeta));
    }
    if (data.containsKey('exhaust_spec')) {
      context.handle(
          _exhaustSpecMeta,
          exhaustSpec.isAcceptableOrUnknown(
              data['exhaust_spec']!, _exhaustSpecMeta));
    }
    if (data.containsKey('other_mods')) {
      context.handle(_otherModsMeta,
          otherMods.isAcceptableOrUnknown(data['other_mods']!, _otherModsMeta));
    }
    if (data.containsKey('installed_date')) {
      context.handle(
          _installedDateMeta,
          installedDate.isAcceptableOrUnknown(
              data['installed_date']!, _installedDateMeta));
    } else if (isInserting) {
      context.missing(_installedDateMeta);
    }
    if (data.containsKey('installed_odometer_km')) {
      context.handle(
          _installedOdometerKmMeta,
          installedOdometerKm.isAcceptableOrUnknown(
              data['installed_odometer_km']!, _installedOdometerKmMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('photo_paths')) {
      context.handle(
          _photoPathsMeta,
          photoPaths.isAcceptableOrUnknown(
              data['photo_paths']!, _photoPathsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CvtConfiguration map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CvtConfiguration(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      motorcycleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}motorcycle_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      pulleyBrandModel: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}pulley_brand_model']),
      flyballWeightGrams: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}flyball_weight_grams']),
      flyballArrangement: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}flyball_arrangement']),
      centerSpringRpm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}center_spring_rpm']),
      clutchSpringRpm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}clutch_spring_rpm']),
      beltBrandPartNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}belt_brand_part_number']),
      pulleyWasherThicknessMm: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}pulley_washer_thickness_mm']),
      clutchBellSpec: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}clutch_bell_spec']),
      exhaustSpec: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exhaust_spec']),
      otherMods: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}other_mods']),
      installedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}installed_date'])!,
      installedOdometerKm: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}installed_odometer_km']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      photoPaths: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_paths']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CvtConfigurationsTable createAlias(String alias) {
    return $CvtConfigurationsTable(attachedDatabase, alias);
  }
}

class CvtConfiguration extends DataClass
    implements Insertable<CvtConfiguration> {
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
  final String? photoPaths;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CvtConfiguration(
      {required this.id,
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
      this.photoPaths,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['motorcycle_id'] = Variable<int>(motorcycleId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || pulleyBrandModel != null) {
      map['pulley_brand_model'] = Variable<String>(pulleyBrandModel);
    }
    if (!nullToAbsent || flyballWeightGrams != null) {
      map['flyball_weight_grams'] = Variable<double>(flyballWeightGrams);
    }
    if (!nullToAbsent || flyballArrangement != null) {
      map['flyball_arrangement'] = Variable<String>(flyballArrangement);
    }
    if (!nullToAbsent || centerSpringRpm != null) {
      map['center_spring_rpm'] = Variable<int>(centerSpringRpm);
    }
    if (!nullToAbsent || clutchSpringRpm != null) {
      map['clutch_spring_rpm'] = Variable<int>(clutchSpringRpm);
    }
    if (!nullToAbsent || beltBrandPartNumber != null) {
      map['belt_brand_part_number'] = Variable<String>(beltBrandPartNumber);
    }
    if (!nullToAbsent || pulleyWasherThicknessMm != null) {
      map['pulley_washer_thickness_mm'] =
          Variable<double>(pulleyWasherThicknessMm);
    }
    if (!nullToAbsent || clutchBellSpec != null) {
      map['clutch_bell_spec'] = Variable<String>(clutchBellSpec);
    }
    if (!nullToAbsent || exhaustSpec != null) {
      map['exhaust_spec'] = Variable<String>(exhaustSpec);
    }
    if (!nullToAbsent || otherMods != null) {
      map['other_mods'] = Variable<String>(otherMods);
    }
    map['installed_date'] = Variable<DateTime>(installedDate);
    if (!nullToAbsent || installedOdometerKm != null) {
      map['installed_odometer_km'] = Variable<int>(installedOdometerKm);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_archived'] = Variable<bool>(isArchived);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || photoPaths != null) {
      map['photo_paths'] = Variable<String>(photoPaths);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CvtConfigurationsCompanion toCompanion(bool nullToAbsent) {
    return CvtConfigurationsCompanion(
      id: Value(id),
      motorcycleId: Value(motorcycleId),
      name: Value(name),
      pulleyBrandModel: pulleyBrandModel == null && nullToAbsent
          ? const Value.absent()
          : Value(pulleyBrandModel),
      flyballWeightGrams: flyballWeightGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(flyballWeightGrams),
      flyballArrangement: flyballArrangement == null && nullToAbsent
          ? const Value.absent()
          : Value(flyballArrangement),
      centerSpringRpm: centerSpringRpm == null && nullToAbsent
          ? const Value.absent()
          : Value(centerSpringRpm),
      clutchSpringRpm: clutchSpringRpm == null && nullToAbsent
          ? const Value.absent()
          : Value(clutchSpringRpm),
      beltBrandPartNumber: beltBrandPartNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(beltBrandPartNumber),
      pulleyWasherThicknessMm: pulleyWasherThicknessMm == null && nullToAbsent
          ? const Value.absent()
          : Value(pulleyWasherThicknessMm),
      clutchBellSpec: clutchBellSpec == null && nullToAbsent
          ? const Value.absent()
          : Value(clutchBellSpec),
      exhaustSpec: exhaustSpec == null && nullToAbsent
          ? const Value.absent()
          : Value(exhaustSpec),
      otherMods: otherMods == null && nullToAbsent
          ? const Value.absent()
          : Value(otherMods),
      installedDate: Value(installedDate),
      installedOdometerKm: installedOdometerKm == null && nullToAbsent
          ? const Value.absent()
          : Value(installedOdometerKm),
      isActive: Value(isActive),
      isArchived: Value(isArchived),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      photoPaths: photoPaths == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPaths),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CvtConfiguration.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CvtConfiguration(
      id: serializer.fromJson<int>(json['id']),
      motorcycleId: serializer.fromJson<int>(json['motorcycleId']),
      name: serializer.fromJson<String>(json['name']),
      pulleyBrandModel: serializer.fromJson<String?>(json['pulleyBrandModel']),
      flyballWeightGrams:
          serializer.fromJson<double?>(json['flyballWeightGrams']),
      flyballArrangement:
          serializer.fromJson<String?>(json['flyballArrangement']),
      centerSpringRpm: serializer.fromJson<int?>(json['centerSpringRpm']),
      clutchSpringRpm: serializer.fromJson<int?>(json['clutchSpringRpm']),
      beltBrandPartNumber:
          serializer.fromJson<String?>(json['beltBrandPartNumber']),
      pulleyWasherThicknessMm:
          serializer.fromJson<double?>(json['pulleyWasherThicknessMm']),
      clutchBellSpec: serializer.fromJson<String?>(json['clutchBellSpec']),
      exhaustSpec: serializer.fromJson<String?>(json['exhaustSpec']),
      otherMods: serializer.fromJson<String?>(json['otherMods']),
      installedDate: serializer.fromJson<DateTime>(json['installedDate']),
      installedOdometerKm:
          serializer.fromJson<int?>(json['installedOdometerKm']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      notes: serializer.fromJson<String?>(json['notes']),
      photoPaths: serializer.fromJson<String?>(json['photoPaths']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'motorcycleId': serializer.toJson<int>(motorcycleId),
      'name': serializer.toJson<String>(name),
      'pulleyBrandModel': serializer.toJson<String?>(pulleyBrandModel),
      'flyballWeightGrams': serializer.toJson<double?>(flyballWeightGrams),
      'flyballArrangement': serializer.toJson<String?>(flyballArrangement),
      'centerSpringRpm': serializer.toJson<int?>(centerSpringRpm),
      'clutchSpringRpm': serializer.toJson<int?>(clutchSpringRpm),
      'beltBrandPartNumber': serializer.toJson<String?>(beltBrandPartNumber),
      'pulleyWasherThicknessMm':
          serializer.toJson<double?>(pulleyWasherThicknessMm),
      'clutchBellSpec': serializer.toJson<String?>(clutchBellSpec),
      'exhaustSpec': serializer.toJson<String?>(exhaustSpec),
      'otherMods': serializer.toJson<String?>(otherMods),
      'installedDate': serializer.toJson<DateTime>(installedDate),
      'installedOdometerKm': serializer.toJson<int?>(installedOdometerKm),
      'isActive': serializer.toJson<bool>(isActive),
      'isArchived': serializer.toJson<bool>(isArchived),
      'notes': serializer.toJson<String?>(notes),
      'photoPaths': serializer.toJson<String?>(photoPaths),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CvtConfiguration copyWith(
          {int? id,
          int? motorcycleId,
          String? name,
          Value<String?> pulleyBrandModel = const Value.absent(),
          Value<double?> flyballWeightGrams = const Value.absent(),
          Value<String?> flyballArrangement = const Value.absent(),
          Value<int?> centerSpringRpm = const Value.absent(),
          Value<int?> clutchSpringRpm = const Value.absent(),
          Value<String?> beltBrandPartNumber = const Value.absent(),
          Value<double?> pulleyWasherThicknessMm = const Value.absent(),
          Value<String?> clutchBellSpec = const Value.absent(),
          Value<String?> exhaustSpec = const Value.absent(),
          Value<String?> otherMods = const Value.absent(),
          DateTime? installedDate,
          Value<int?> installedOdometerKm = const Value.absent(),
          bool? isActive,
          bool? isArchived,
          Value<String?> notes = const Value.absent(),
          Value<String?> photoPaths = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      CvtConfiguration(
        id: id ?? this.id,
        motorcycleId: motorcycleId ?? this.motorcycleId,
        name: name ?? this.name,
        pulleyBrandModel: pulleyBrandModel.present
            ? pulleyBrandModel.value
            : this.pulleyBrandModel,
        flyballWeightGrams: flyballWeightGrams.present
            ? flyballWeightGrams.value
            : this.flyballWeightGrams,
        flyballArrangement: flyballArrangement.present
            ? flyballArrangement.value
            : this.flyballArrangement,
        centerSpringRpm: centerSpringRpm.present
            ? centerSpringRpm.value
            : this.centerSpringRpm,
        clutchSpringRpm: clutchSpringRpm.present
            ? clutchSpringRpm.value
            : this.clutchSpringRpm,
        beltBrandPartNumber: beltBrandPartNumber.present
            ? beltBrandPartNumber.value
            : this.beltBrandPartNumber,
        pulleyWasherThicknessMm: pulleyWasherThicknessMm.present
            ? pulleyWasherThicknessMm.value
            : this.pulleyWasherThicknessMm,
        clutchBellSpec:
            clutchBellSpec.present ? clutchBellSpec.value : this.clutchBellSpec,
        exhaustSpec: exhaustSpec.present ? exhaustSpec.value : this.exhaustSpec,
        otherMods: otherMods.present ? otherMods.value : this.otherMods,
        installedDate: installedDate ?? this.installedDate,
        installedOdometerKm: installedOdometerKm.present
            ? installedOdometerKm.value
            : this.installedOdometerKm,
        isActive: isActive ?? this.isActive,
        isArchived: isArchived ?? this.isArchived,
        notes: notes.present ? notes.value : this.notes,
        photoPaths: photoPaths.present ? photoPaths.value : this.photoPaths,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CvtConfiguration copyWithCompanion(CvtConfigurationsCompanion data) {
    return CvtConfiguration(
      id: data.id.present ? data.id.value : this.id,
      motorcycleId: data.motorcycleId.present
          ? data.motorcycleId.value
          : this.motorcycleId,
      name: data.name.present ? data.name.value : this.name,
      pulleyBrandModel: data.pulleyBrandModel.present
          ? data.pulleyBrandModel.value
          : this.pulleyBrandModel,
      flyballWeightGrams: data.flyballWeightGrams.present
          ? data.flyballWeightGrams.value
          : this.flyballWeightGrams,
      flyballArrangement: data.flyballArrangement.present
          ? data.flyballArrangement.value
          : this.flyballArrangement,
      centerSpringRpm: data.centerSpringRpm.present
          ? data.centerSpringRpm.value
          : this.centerSpringRpm,
      clutchSpringRpm: data.clutchSpringRpm.present
          ? data.clutchSpringRpm.value
          : this.clutchSpringRpm,
      beltBrandPartNumber: data.beltBrandPartNumber.present
          ? data.beltBrandPartNumber.value
          : this.beltBrandPartNumber,
      pulleyWasherThicknessMm: data.pulleyWasherThicknessMm.present
          ? data.pulleyWasherThicknessMm.value
          : this.pulleyWasherThicknessMm,
      clutchBellSpec: data.clutchBellSpec.present
          ? data.clutchBellSpec.value
          : this.clutchBellSpec,
      exhaustSpec:
          data.exhaustSpec.present ? data.exhaustSpec.value : this.exhaustSpec,
      otherMods: data.otherMods.present ? data.otherMods.value : this.otherMods,
      installedDate: data.installedDate.present
          ? data.installedDate.value
          : this.installedDate,
      installedOdometerKm: data.installedOdometerKm.present
          ? data.installedOdometerKm.value
          : this.installedOdometerKm,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      notes: data.notes.present ? data.notes.value : this.notes,
      photoPaths:
          data.photoPaths.present ? data.photoPaths.value : this.photoPaths,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CvtConfiguration(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('name: $name, ')
          ..write('pulleyBrandModel: $pulleyBrandModel, ')
          ..write('flyballWeightGrams: $flyballWeightGrams, ')
          ..write('flyballArrangement: $flyballArrangement, ')
          ..write('centerSpringRpm: $centerSpringRpm, ')
          ..write('clutchSpringRpm: $clutchSpringRpm, ')
          ..write('beltBrandPartNumber: $beltBrandPartNumber, ')
          ..write('pulleyWasherThicknessMm: $pulleyWasherThicknessMm, ')
          ..write('clutchBellSpec: $clutchBellSpec, ')
          ..write('exhaustSpec: $exhaustSpec, ')
          ..write('otherMods: $otherMods, ')
          ..write('installedDate: $installedDate, ')
          ..write('installedOdometerKm: $installedOdometerKm, ')
          ..write('isActive: $isActive, ')
          ..write('isArchived: $isArchived, ')
          ..write('notes: $notes, ')
          ..write('photoPaths: $photoPaths, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        motorcycleId,
        name,
        pulleyBrandModel,
        flyballWeightGrams,
        flyballArrangement,
        centerSpringRpm,
        clutchSpringRpm,
        beltBrandPartNumber,
        pulleyWasherThicknessMm,
        clutchBellSpec,
        exhaustSpec,
        otherMods,
        installedDate,
        installedOdometerKm,
        isActive,
        isArchived,
        notes,
        photoPaths,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CvtConfiguration &&
          other.id == this.id &&
          other.motorcycleId == this.motorcycleId &&
          other.name == this.name &&
          other.pulleyBrandModel == this.pulleyBrandModel &&
          other.flyballWeightGrams == this.flyballWeightGrams &&
          other.flyballArrangement == this.flyballArrangement &&
          other.centerSpringRpm == this.centerSpringRpm &&
          other.clutchSpringRpm == this.clutchSpringRpm &&
          other.beltBrandPartNumber == this.beltBrandPartNumber &&
          other.pulleyWasherThicknessMm == this.pulleyWasherThicknessMm &&
          other.clutchBellSpec == this.clutchBellSpec &&
          other.exhaustSpec == this.exhaustSpec &&
          other.otherMods == this.otherMods &&
          other.installedDate == this.installedDate &&
          other.installedOdometerKm == this.installedOdometerKm &&
          other.isActive == this.isActive &&
          other.isArchived == this.isArchived &&
          other.notes == this.notes &&
          other.photoPaths == this.photoPaths &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CvtConfigurationsCompanion extends UpdateCompanion<CvtConfiguration> {
  final Value<int> id;
  final Value<int> motorcycleId;
  final Value<String> name;
  final Value<String?> pulleyBrandModel;
  final Value<double?> flyballWeightGrams;
  final Value<String?> flyballArrangement;
  final Value<int?> centerSpringRpm;
  final Value<int?> clutchSpringRpm;
  final Value<String?> beltBrandPartNumber;
  final Value<double?> pulleyWasherThicknessMm;
  final Value<String?> clutchBellSpec;
  final Value<String?> exhaustSpec;
  final Value<String?> otherMods;
  final Value<DateTime> installedDate;
  final Value<int?> installedOdometerKm;
  final Value<bool> isActive;
  final Value<bool> isArchived;
  final Value<String?> notes;
  final Value<String?> photoPaths;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CvtConfigurationsCompanion({
    this.id = const Value.absent(),
    this.motorcycleId = const Value.absent(),
    this.name = const Value.absent(),
    this.pulleyBrandModel = const Value.absent(),
    this.flyballWeightGrams = const Value.absent(),
    this.flyballArrangement = const Value.absent(),
    this.centerSpringRpm = const Value.absent(),
    this.clutchSpringRpm = const Value.absent(),
    this.beltBrandPartNumber = const Value.absent(),
    this.pulleyWasherThicknessMm = const Value.absent(),
    this.clutchBellSpec = const Value.absent(),
    this.exhaustSpec = const Value.absent(),
    this.otherMods = const Value.absent(),
    this.installedDate = const Value.absent(),
    this.installedOdometerKm = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPaths = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CvtConfigurationsCompanion.insert({
    this.id = const Value.absent(),
    required int motorcycleId,
    required String name,
    this.pulleyBrandModel = const Value.absent(),
    this.flyballWeightGrams = const Value.absent(),
    this.flyballArrangement = const Value.absent(),
    this.centerSpringRpm = const Value.absent(),
    this.clutchSpringRpm = const Value.absent(),
    this.beltBrandPartNumber = const Value.absent(),
    this.pulleyWasherThicknessMm = const Value.absent(),
    this.clutchBellSpec = const Value.absent(),
    this.exhaustSpec = const Value.absent(),
    this.otherMods = const Value.absent(),
    required DateTime installedDate,
    this.installedOdometerKm = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPaths = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : motorcycleId = Value(motorcycleId),
        name = Value(name),
        installedDate = Value(installedDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CvtConfiguration> custom({
    Expression<int>? id,
    Expression<int>? motorcycleId,
    Expression<String>? name,
    Expression<String>? pulleyBrandModel,
    Expression<double>? flyballWeightGrams,
    Expression<String>? flyballArrangement,
    Expression<int>? centerSpringRpm,
    Expression<int>? clutchSpringRpm,
    Expression<String>? beltBrandPartNumber,
    Expression<double>? pulleyWasherThicknessMm,
    Expression<String>? clutchBellSpec,
    Expression<String>? exhaustSpec,
    Expression<String>? otherMods,
    Expression<DateTime>? installedDate,
    Expression<int>? installedOdometerKm,
    Expression<bool>? isActive,
    Expression<bool>? isArchived,
    Expression<String>? notes,
    Expression<String>? photoPaths,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (motorcycleId != null) 'motorcycle_id': motorcycleId,
      if (name != null) 'name': name,
      if (pulleyBrandModel != null) 'pulley_brand_model': pulleyBrandModel,
      if (flyballWeightGrams != null)
        'flyball_weight_grams': flyballWeightGrams,
      if (flyballArrangement != null) 'flyball_arrangement': flyballArrangement,
      if (centerSpringRpm != null) 'center_spring_rpm': centerSpringRpm,
      if (clutchSpringRpm != null) 'clutch_spring_rpm': clutchSpringRpm,
      if (beltBrandPartNumber != null)
        'belt_brand_part_number': beltBrandPartNumber,
      if (pulleyWasherThicknessMm != null)
        'pulley_washer_thickness_mm': pulleyWasherThicknessMm,
      if (clutchBellSpec != null) 'clutch_bell_spec': clutchBellSpec,
      if (exhaustSpec != null) 'exhaust_spec': exhaustSpec,
      if (otherMods != null) 'other_mods': otherMods,
      if (installedDate != null) 'installed_date': installedDate,
      if (installedOdometerKm != null)
        'installed_odometer_km': installedOdometerKm,
      if (isActive != null) 'is_active': isActive,
      if (isArchived != null) 'is_archived': isArchived,
      if (notes != null) 'notes': notes,
      if (photoPaths != null) 'photo_paths': photoPaths,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CvtConfigurationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? motorcycleId,
      Value<String>? name,
      Value<String?>? pulleyBrandModel,
      Value<double?>? flyballWeightGrams,
      Value<String?>? flyballArrangement,
      Value<int?>? centerSpringRpm,
      Value<int?>? clutchSpringRpm,
      Value<String?>? beltBrandPartNumber,
      Value<double?>? pulleyWasherThicknessMm,
      Value<String?>? clutchBellSpec,
      Value<String?>? exhaustSpec,
      Value<String?>? otherMods,
      Value<DateTime>? installedDate,
      Value<int?>? installedOdometerKm,
      Value<bool>? isActive,
      Value<bool>? isArchived,
      Value<String?>? notes,
      Value<String?>? photoPaths,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return CvtConfigurationsCompanion(
      id: id ?? this.id,
      motorcycleId: motorcycleId ?? this.motorcycleId,
      name: name ?? this.name,
      pulleyBrandModel: pulleyBrandModel ?? this.pulleyBrandModel,
      flyballWeightGrams: flyballWeightGrams ?? this.flyballWeightGrams,
      flyballArrangement: flyballArrangement ?? this.flyballArrangement,
      centerSpringRpm: centerSpringRpm ?? this.centerSpringRpm,
      clutchSpringRpm: clutchSpringRpm ?? this.clutchSpringRpm,
      beltBrandPartNumber: beltBrandPartNumber ?? this.beltBrandPartNumber,
      pulleyWasherThicknessMm:
          pulleyWasherThicknessMm ?? this.pulleyWasherThicknessMm,
      clutchBellSpec: clutchBellSpec ?? this.clutchBellSpec,
      exhaustSpec: exhaustSpec ?? this.exhaustSpec,
      otherMods: otherMods ?? this.otherMods,
      installedDate: installedDate ?? this.installedDate,
      installedOdometerKm: installedOdometerKm ?? this.installedOdometerKm,
      isActive: isActive ?? this.isActive,
      isArchived: isArchived ?? this.isArchived,
      notes: notes ?? this.notes,
      photoPaths: photoPaths ?? this.photoPaths,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (motorcycleId.present) {
      map['motorcycle_id'] = Variable<int>(motorcycleId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (pulleyBrandModel.present) {
      map['pulley_brand_model'] = Variable<String>(pulleyBrandModel.value);
    }
    if (flyballWeightGrams.present) {
      map['flyball_weight_grams'] = Variable<double>(flyballWeightGrams.value);
    }
    if (flyballArrangement.present) {
      map['flyball_arrangement'] = Variable<String>(flyballArrangement.value);
    }
    if (centerSpringRpm.present) {
      map['center_spring_rpm'] = Variable<int>(centerSpringRpm.value);
    }
    if (clutchSpringRpm.present) {
      map['clutch_spring_rpm'] = Variable<int>(clutchSpringRpm.value);
    }
    if (beltBrandPartNumber.present) {
      map['belt_brand_part_number'] =
          Variable<String>(beltBrandPartNumber.value);
    }
    if (pulleyWasherThicknessMm.present) {
      map['pulley_washer_thickness_mm'] =
          Variable<double>(pulleyWasherThicknessMm.value);
    }
    if (clutchBellSpec.present) {
      map['clutch_bell_spec'] = Variable<String>(clutchBellSpec.value);
    }
    if (exhaustSpec.present) {
      map['exhaust_spec'] = Variable<String>(exhaustSpec.value);
    }
    if (otherMods.present) {
      map['other_mods'] = Variable<String>(otherMods.value);
    }
    if (installedDate.present) {
      map['installed_date'] = Variable<DateTime>(installedDate.value);
    }
    if (installedOdometerKm.present) {
      map['installed_odometer_km'] = Variable<int>(installedOdometerKm.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (photoPaths.present) {
      map['photo_paths'] = Variable<String>(photoPaths.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CvtConfigurationsCompanion(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('name: $name, ')
          ..write('pulleyBrandModel: $pulleyBrandModel, ')
          ..write('flyballWeightGrams: $flyballWeightGrams, ')
          ..write('flyballArrangement: $flyballArrangement, ')
          ..write('centerSpringRpm: $centerSpringRpm, ')
          ..write('clutchSpringRpm: $clutchSpringRpm, ')
          ..write('beltBrandPartNumber: $beltBrandPartNumber, ')
          ..write('pulleyWasherThicknessMm: $pulleyWasherThicknessMm, ')
          ..write('clutchBellSpec: $clutchBellSpec, ')
          ..write('exhaustSpec: $exhaustSpec, ')
          ..write('otherMods: $otherMods, ')
          ..write('installedDate: $installedDate, ')
          ..write('installedOdometerKm: $installedOdometerKm, ')
          ..write('isActive: $isActive, ')
          ..write('isArchived: $isArchived, ')
          ..write('notes: $notes, ')
          ..write('photoPaths: $photoPaths, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CvtPerformanceLogsTable extends CvtPerformanceLogs
    with TableInfo<$CvtPerformanceLogsTable, CvtPerformanceLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CvtPerformanceLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _configurationIdMeta =
      const VerificationMeta('configurationId');
  @override
  late final GeneratedColumn<int> configurationId = GeneratedColumn<int>(
      'configuration_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cvt_configurations (id) ON DELETE CASCADE'));
  static const VerificationMeta _logDateMeta =
      const VerificationMeta('logDate');
  @override
  late final GeneratedColumn<DateTime> logDate = GeneratedColumn<DateTime>(
      'log_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _odometerKmMeta =
      const VerificationMeta('odometerKm');
  @override
  late final GeneratedColumn<int> odometerKm = GeneratedColumn<int>(
      'odometer_km', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _accelerationRatingMeta =
      const VerificationMeta('accelerationRating');
  @override
  late final GeneratedColumn<int> accelerationRating = GeneratedColumn<int>(
      'acceleration_rating', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _topSpeedKmhMeta =
      const VerificationMeta('topSpeedKmh');
  @override
  late final GeneratedColumn<double> topSpeedKmh = GeneratedColumn<double>(
      'top_speed_kmh', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _rpmObservedMeta =
      const VerificationMeta('rpmObserved');
  @override
  late final GeneratedColumn<int> rpmObserved = GeneratedColumn<int>(
      'rpm_observed', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _fuelConsumptionKplMeta =
      const VerificationMeta('fuelConsumptionKpl');
  @override
  late final GeneratedColumn<double> fuelConsumptionKpl =
      GeneratedColumn<double>('fuel_consumption_kpl', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _vibrationRatingMeta =
      const VerificationMeta('vibrationRating');
  @override
  late final GeneratedColumn<int> vibrationRating = GeneratedColumn<int>(
      'vibration_rating', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _comfortRatingMeta =
      const VerificationMeta('comfortRating');
  @override
  late final GeneratedColumn<int> comfortRating = GeneratedColumn<int>(
      'comfort_rating', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _overallAssessmentMeta =
      const VerificationMeta('overallAssessment');
  @override
  late final GeneratedColumn<String> overallAssessment =
      GeneratedColumn<String>('overall_assessment', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isMeasuredMeta =
      const VerificationMeta('isMeasured');
  @override
  late final GeneratedColumn<bool> isMeasured = GeneratedColumn<bool>(
      'is_measured', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_measured" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        configurationId,
        logDate,
        odometerKm,
        accelerationRating,
        topSpeedKmh,
        rpmObserved,
        fuelConsumptionKpl,
        vibrationRating,
        comfortRating,
        overallAssessment,
        notes,
        isMeasured,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cvt_performance_logs';
  @override
  VerificationContext validateIntegrity(Insertable<CvtPerformanceLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('configuration_id')) {
      context.handle(
          _configurationIdMeta,
          configurationId.isAcceptableOrUnknown(
              data['configuration_id']!, _configurationIdMeta));
    } else if (isInserting) {
      context.missing(_configurationIdMeta);
    }
    if (data.containsKey('log_date')) {
      context.handle(_logDateMeta,
          logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta));
    } else if (isInserting) {
      context.missing(_logDateMeta);
    }
    if (data.containsKey('odometer_km')) {
      context.handle(
          _odometerKmMeta,
          odometerKm.isAcceptableOrUnknown(
              data['odometer_km']!, _odometerKmMeta));
    }
    if (data.containsKey('acceleration_rating')) {
      context.handle(
          _accelerationRatingMeta,
          accelerationRating.isAcceptableOrUnknown(
              data['acceleration_rating']!, _accelerationRatingMeta));
    }
    if (data.containsKey('top_speed_kmh')) {
      context.handle(
          _topSpeedKmhMeta,
          topSpeedKmh.isAcceptableOrUnknown(
              data['top_speed_kmh']!, _topSpeedKmhMeta));
    }
    if (data.containsKey('rpm_observed')) {
      context.handle(
          _rpmObservedMeta,
          rpmObserved.isAcceptableOrUnknown(
              data['rpm_observed']!, _rpmObservedMeta));
    }
    if (data.containsKey('fuel_consumption_kpl')) {
      context.handle(
          _fuelConsumptionKplMeta,
          fuelConsumptionKpl.isAcceptableOrUnknown(
              data['fuel_consumption_kpl']!, _fuelConsumptionKplMeta));
    }
    if (data.containsKey('vibration_rating')) {
      context.handle(
          _vibrationRatingMeta,
          vibrationRating.isAcceptableOrUnknown(
              data['vibration_rating']!, _vibrationRatingMeta));
    }
    if (data.containsKey('comfort_rating')) {
      context.handle(
          _comfortRatingMeta,
          comfortRating.isAcceptableOrUnknown(
              data['comfort_rating']!, _comfortRatingMeta));
    }
    if (data.containsKey('overall_assessment')) {
      context.handle(
          _overallAssessmentMeta,
          overallAssessment.isAcceptableOrUnknown(
              data['overall_assessment']!, _overallAssessmentMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_measured')) {
      context.handle(
          _isMeasuredMeta,
          isMeasured.isAcceptableOrUnknown(
              data['is_measured']!, _isMeasuredMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CvtPerformanceLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CvtPerformanceLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      configurationId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}configuration_id'])!,
      logDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}log_date'])!,
      odometerKm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}odometer_km']),
      accelerationRating: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}acceleration_rating']),
      topSpeedKmh: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}top_speed_kmh']),
      rpmObserved: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rpm_observed']),
      fuelConsumptionKpl: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}fuel_consumption_kpl']),
      vibrationRating: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vibration_rating']),
      comfortRating: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}comfort_rating']),
      overallAssessment: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}overall_assessment']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isMeasured: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_measured'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CvtPerformanceLogsTable createAlias(String alias) {
    return $CvtPerformanceLogsTable(attachedDatabase, alias);
  }
}

class CvtPerformanceLog extends DataClass
    implements Insertable<CvtPerformanceLog> {
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
  const CvtPerformanceLog(
      {required this.id,
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
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['configuration_id'] = Variable<int>(configurationId);
    map['log_date'] = Variable<DateTime>(logDate);
    if (!nullToAbsent || odometerKm != null) {
      map['odometer_km'] = Variable<int>(odometerKm);
    }
    if (!nullToAbsent || accelerationRating != null) {
      map['acceleration_rating'] = Variable<int>(accelerationRating);
    }
    if (!nullToAbsent || topSpeedKmh != null) {
      map['top_speed_kmh'] = Variable<double>(topSpeedKmh);
    }
    if (!nullToAbsent || rpmObserved != null) {
      map['rpm_observed'] = Variable<int>(rpmObserved);
    }
    if (!nullToAbsent || fuelConsumptionKpl != null) {
      map['fuel_consumption_kpl'] = Variable<double>(fuelConsumptionKpl);
    }
    if (!nullToAbsent || vibrationRating != null) {
      map['vibration_rating'] = Variable<int>(vibrationRating);
    }
    if (!nullToAbsent || comfortRating != null) {
      map['comfort_rating'] = Variable<int>(comfortRating);
    }
    if (!nullToAbsent || overallAssessment != null) {
      map['overall_assessment'] = Variable<String>(overallAssessment);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_measured'] = Variable<bool>(isMeasured);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CvtPerformanceLogsCompanion toCompanion(bool nullToAbsent) {
    return CvtPerformanceLogsCompanion(
      id: Value(id),
      configurationId: Value(configurationId),
      logDate: Value(logDate),
      odometerKm: odometerKm == null && nullToAbsent
          ? const Value.absent()
          : Value(odometerKm),
      accelerationRating: accelerationRating == null && nullToAbsent
          ? const Value.absent()
          : Value(accelerationRating),
      topSpeedKmh: topSpeedKmh == null && nullToAbsent
          ? const Value.absent()
          : Value(topSpeedKmh),
      rpmObserved: rpmObserved == null && nullToAbsent
          ? const Value.absent()
          : Value(rpmObserved),
      fuelConsumptionKpl: fuelConsumptionKpl == null && nullToAbsent
          ? const Value.absent()
          : Value(fuelConsumptionKpl),
      vibrationRating: vibrationRating == null && nullToAbsent
          ? const Value.absent()
          : Value(vibrationRating),
      comfortRating: comfortRating == null && nullToAbsent
          ? const Value.absent()
          : Value(comfortRating),
      overallAssessment: overallAssessment == null && nullToAbsent
          ? const Value.absent()
          : Value(overallAssessment),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isMeasured: Value(isMeasured),
      createdAt: Value(createdAt),
    );
  }

  factory CvtPerformanceLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CvtPerformanceLog(
      id: serializer.fromJson<int>(json['id']),
      configurationId: serializer.fromJson<int>(json['configurationId']),
      logDate: serializer.fromJson<DateTime>(json['logDate']),
      odometerKm: serializer.fromJson<int?>(json['odometerKm']),
      accelerationRating: serializer.fromJson<int?>(json['accelerationRating']),
      topSpeedKmh: serializer.fromJson<double?>(json['topSpeedKmh']),
      rpmObserved: serializer.fromJson<int?>(json['rpmObserved']),
      fuelConsumptionKpl:
          serializer.fromJson<double?>(json['fuelConsumptionKpl']),
      vibrationRating: serializer.fromJson<int?>(json['vibrationRating']),
      comfortRating: serializer.fromJson<int?>(json['comfortRating']),
      overallAssessment:
          serializer.fromJson<String?>(json['overallAssessment']),
      notes: serializer.fromJson<String?>(json['notes']),
      isMeasured: serializer.fromJson<bool>(json['isMeasured']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'configurationId': serializer.toJson<int>(configurationId),
      'logDate': serializer.toJson<DateTime>(logDate),
      'odometerKm': serializer.toJson<int?>(odometerKm),
      'accelerationRating': serializer.toJson<int?>(accelerationRating),
      'topSpeedKmh': serializer.toJson<double?>(topSpeedKmh),
      'rpmObserved': serializer.toJson<int?>(rpmObserved),
      'fuelConsumptionKpl': serializer.toJson<double?>(fuelConsumptionKpl),
      'vibrationRating': serializer.toJson<int?>(vibrationRating),
      'comfortRating': serializer.toJson<int?>(comfortRating),
      'overallAssessment': serializer.toJson<String?>(overallAssessment),
      'notes': serializer.toJson<String?>(notes),
      'isMeasured': serializer.toJson<bool>(isMeasured),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CvtPerformanceLog copyWith(
          {int? id,
          int? configurationId,
          DateTime? logDate,
          Value<int?> odometerKm = const Value.absent(),
          Value<int?> accelerationRating = const Value.absent(),
          Value<double?> topSpeedKmh = const Value.absent(),
          Value<int?> rpmObserved = const Value.absent(),
          Value<double?> fuelConsumptionKpl = const Value.absent(),
          Value<int?> vibrationRating = const Value.absent(),
          Value<int?> comfortRating = const Value.absent(),
          Value<String?> overallAssessment = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? isMeasured,
          DateTime? createdAt}) =>
      CvtPerformanceLog(
        id: id ?? this.id,
        configurationId: configurationId ?? this.configurationId,
        logDate: logDate ?? this.logDate,
        odometerKm: odometerKm.present ? odometerKm.value : this.odometerKm,
        accelerationRating: accelerationRating.present
            ? accelerationRating.value
            : this.accelerationRating,
        topSpeedKmh: topSpeedKmh.present ? topSpeedKmh.value : this.topSpeedKmh,
        rpmObserved: rpmObserved.present ? rpmObserved.value : this.rpmObserved,
        fuelConsumptionKpl: fuelConsumptionKpl.present
            ? fuelConsumptionKpl.value
            : this.fuelConsumptionKpl,
        vibrationRating: vibrationRating.present
            ? vibrationRating.value
            : this.vibrationRating,
        comfortRating:
            comfortRating.present ? comfortRating.value : this.comfortRating,
        overallAssessment: overallAssessment.present
            ? overallAssessment.value
            : this.overallAssessment,
        notes: notes.present ? notes.value : this.notes,
        isMeasured: isMeasured ?? this.isMeasured,
        createdAt: createdAt ?? this.createdAt,
      );
  CvtPerformanceLog copyWithCompanion(CvtPerformanceLogsCompanion data) {
    return CvtPerformanceLog(
      id: data.id.present ? data.id.value : this.id,
      configurationId: data.configurationId.present
          ? data.configurationId.value
          : this.configurationId,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      odometerKm:
          data.odometerKm.present ? data.odometerKm.value : this.odometerKm,
      accelerationRating: data.accelerationRating.present
          ? data.accelerationRating.value
          : this.accelerationRating,
      topSpeedKmh:
          data.topSpeedKmh.present ? data.topSpeedKmh.value : this.topSpeedKmh,
      rpmObserved:
          data.rpmObserved.present ? data.rpmObserved.value : this.rpmObserved,
      fuelConsumptionKpl: data.fuelConsumptionKpl.present
          ? data.fuelConsumptionKpl.value
          : this.fuelConsumptionKpl,
      vibrationRating: data.vibrationRating.present
          ? data.vibrationRating.value
          : this.vibrationRating,
      comfortRating: data.comfortRating.present
          ? data.comfortRating.value
          : this.comfortRating,
      overallAssessment: data.overallAssessment.present
          ? data.overallAssessment.value
          : this.overallAssessment,
      notes: data.notes.present ? data.notes.value : this.notes,
      isMeasured:
          data.isMeasured.present ? data.isMeasured.value : this.isMeasured,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CvtPerformanceLog(')
          ..write('id: $id, ')
          ..write('configurationId: $configurationId, ')
          ..write('logDate: $logDate, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('accelerationRating: $accelerationRating, ')
          ..write('topSpeedKmh: $topSpeedKmh, ')
          ..write('rpmObserved: $rpmObserved, ')
          ..write('fuelConsumptionKpl: $fuelConsumptionKpl, ')
          ..write('vibrationRating: $vibrationRating, ')
          ..write('comfortRating: $comfortRating, ')
          ..write('overallAssessment: $overallAssessment, ')
          ..write('notes: $notes, ')
          ..write('isMeasured: $isMeasured, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      configurationId,
      logDate,
      odometerKm,
      accelerationRating,
      topSpeedKmh,
      rpmObserved,
      fuelConsumptionKpl,
      vibrationRating,
      comfortRating,
      overallAssessment,
      notes,
      isMeasured,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CvtPerformanceLog &&
          other.id == this.id &&
          other.configurationId == this.configurationId &&
          other.logDate == this.logDate &&
          other.odometerKm == this.odometerKm &&
          other.accelerationRating == this.accelerationRating &&
          other.topSpeedKmh == this.topSpeedKmh &&
          other.rpmObserved == this.rpmObserved &&
          other.fuelConsumptionKpl == this.fuelConsumptionKpl &&
          other.vibrationRating == this.vibrationRating &&
          other.comfortRating == this.comfortRating &&
          other.overallAssessment == this.overallAssessment &&
          other.notes == this.notes &&
          other.isMeasured == this.isMeasured &&
          other.createdAt == this.createdAt);
}

class CvtPerformanceLogsCompanion extends UpdateCompanion<CvtPerformanceLog> {
  final Value<int> id;
  final Value<int> configurationId;
  final Value<DateTime> logDate;
  final Value<int?> odometerKm;
  final Value<int?> accelerationRating;
  final Value<double?> topSpeedKmh;
  final Value<int?> rpmObserved;
  final Value<double?> fuelConsumptionKpl;
  final Value<int?> vibrationRating;
  final Value<int?> comfortRating;
  final Value<String?> overallAssessment;
  final Value<String?> notes;
  final Value<bool> isMeasured;
  final Value<DateTime> createdAt;
  const CvtPerformanceLogsCompanion({
    this.id = const Value.absent(),
    this.configurationId = const Value.absent(),
    this.logDate = const Value.absent(),
    this.odometerKm = const Value.absent(),
    this.accelerationRating = const Value.absent(),
    this.topSpeedKmh = const Value.absent(),
    this.rpmObserved = const Value.absent(),
    this.fuelConsumptionKpl = const Value.absent(),
    this.vibrationRating = const Value.absent(),
    this.comfortRating = const Value.absent(),
    this.overallAssessment = const Value.absent(),
    this.notes = const Value.absent(),
    this.isMeasured = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CvtPerformanceLogsCompanion.insert({
    this.id = const Value.absent(),
    required int configurationId,
    required DateTime logDate,
    this.odometerKm = const Value.absent(),
    this.accelerationRating = const Value.absent(),
    this.topSpeedKmh = const Value.absent(),
    this.rpmObserved = const Value.absent(),
    this.fuelConsumptionKpl = const Value.absent(),
    this.vibrationRating = const Value.absent(),
    this.comfortRating = const Value.absent(),
    this.overallAssessment = const Value.absent(),
    this.notes = const Value.absent(),
    this.isMeasured = const Value.absent(),
    required DateTime createdAt,
  })  : configurationId = Value(configurationId),
        logDate = Value(logDate),
        createdAt = Value(createdAt);
  static Insertable<CvtPerformanceLog> custom({
    Expression<int>? id,
    Expression<int>? configurationId,
    Expression<DateTime>? logDate,
    Expression<int>? odometerKm,
    Expression<int>? accelerationRating,
    Expression<double>? topSpeedKmh,
    Expression<int>? rpmObserved,
    Expression<double>? fuelConsumptionKpl,
    Expression<int>? vibrationRating,
    Expression<int>? comfortRating,
    Expression<String>? overallAssessment,
    Expression<String>? notes,
    Expression<bool>? isMeasured,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (configurationId != null) 'configuration_id': configurationId,
      if (logDate != null) 'log_date': logDate,
      if (odometerKm != null) 'odometer_km': odometerKm,
      if (accelerationRating != null) 'acceleration_rating': accelerationRating,
      if (topSpeedKmh != null) 'top_speed_kmh': topSpeedKmh,
      if (rpmObserved != null) 'rpm_observed': rpmObserved,
      if (fuelConsumptionKpl != null)
        'fuel_consumption_kpl': fuelConsumptionKpl,
      if (vibrationRating != null) 'vibration_rating': vibrationRating,
      if (comfortRating != null) 'comfort_rating': comfortRating,
      if (overallAssessment != null) 'overall_assessment': overallAssessment,
      if (notes != null) 'notes': notes,
      if (isMeasured != null) 'is_measured': isMeasured,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CvtPerformanceLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? configurationId,
      Value<DateTime>? logDate,
      Value<int?>? odometerKm,
      Value<int?>? accelerationRating,
      Value<double?>? topSpeedKmh,
      Value<int?>? rpmObserved,
      Value<double?>? fuelConsumptionKpl,
      Value<int?>? vibrationRating,
      Value<int?>? comfortRating,
      Value<String?>? overallAssessment,
      Value<String?>? notes,
      Value<bool>? isMeasured,
      Value<DateTime>? createdAt}) {
    return CvtPerformanceLogsCompanion(
      id: id ?? this.id,
      configurationId: configurationId ?? this.configurationId,
      logDate: logDate ?? this.logDate,
      odometerKm: odometerKm ?? this.odometerKm,
      accelerationRating: accelerationRating ?? this.accelerationRating,
      topSpeedKmh: topSpeedKmh ?? this.topSpeedKmh,
      rpmObserved: rpmObserved ?? this.rpmObserved,
      fuelConsumptionKpl: fuelConsumptionKpl ?? this.fuelConsumptionKpl,
      vibrationRating: vibrationRating ?? this.vibrationRating,
      comfortRating: comfortRating ?? this.comfortRating,
      overallAssessment: overallAssessment ?? this.overallAssessment,
      notes: notes ?? this.notes,
      isMeasured: isMeasured ?? this.isMeasured,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (configurationId.present) {
      map['configuration_id'] = Variable<int>(configurationId.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<DateTime>(logDate.value);
    }
    if (odometerKm.present) {
      map['odometer_km'] = Variable<int>(odometerKm.value);
    }
    if (accelerationRating.present) {
      map['acceleration_rating'] = Variable<int>(accelerationRating.value);
    }
    if (topSpeedKmh.present) {
      map['top_speed_kmh'] = Variable<double>(topSpeedKmh.value);
    }
    if (rpmObserved.present) {
      map['rpm_observed'] = Variable<int>(rpmObserved.value);
    }
    if (fuelConsumptionKpl.present) {
      map['fuel_consumption_kpl'] = Variable<double>(fuelConsumptionKpl.value);
    }
    if (vibrationRating.present) {
      map['vibration_rating'] = Variable<int>(vibrationRating.value);
    }
    if (comfortRating.present) {
      map['comfort_rating'] = Variable<int>(comfortRating.value);
    }
    if (overallAssessment.present) {
      map['overall_assessment'] = Variable<String>(overallAssessment.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isMeasured.present) {
      map['is_measured'] = Variable<bool>(isMeasured.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CvtPerformanceLogsCompanion(')
          ..write('id: $id, ')
          ..write('configurationId: $configurationId, ')
          ..write('logDate: $logDate, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('accelerationRating: $accelerationRating, ')
          ..write('topSpeedKmh: $topSpeedKmh, ')
          ..write('rpmObserved: $rpmObserved, ')
          ..write('fuelConsumptionKpl: $fuelConsumptionKpl, ')
          ..write('vibrationRating: $vibrationRating, ')
          ..write('comfortRating: $comfortRating, ')
          ..write('overallAssessment: $overallAssessment, ')
          ..write('notes: $notes, ')
          ..write('isMeasured: $isMeasured, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PartsCatalogTable extends PartsCatalog
    with TableInfo<$PartsCatalogTable, PartsCatalogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartsCatalogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _partNumberMeta =
      const VerificationMeta('partNumber');
  @override
  late final GeneratedColumn<String> partNumber = GeneratedColumn<String>(
      'part_number', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _officialNameMeta =
      const VerificationMeta('officialName');
  @override
  late final GeneratedColumn<String> officialName = GeneratedColumn<String>(
      'official_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 150),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _assemblyNameMeta =
      const VerificationMeta('assemblyName');
  @override
  late final GeneratedColumn<String> assemblyName = GeneratedColumn<String>(
      'assembly_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _diagramNumberMeta =
      const VerificationMeta('diagramNumber');
  @override
  late final GeneratedColumn<String> diagramNumber = GeneratedColumn<String>(
      'diagram_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referenceNumberMeta =
      const VerificationMeta('referenceNumber');
  @override
  late final GeneratedColumn<int> referenceNumber = GeneratedColumn<int>(
      'reference_number', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _standardQuantityMeta =
      const VerificationMeta('standardQuantity');
  @override
  late final GeneratedColumn<int> standardQuantity = GeneratedColumn<int>(
      'standard_quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _supersededPartNumberMeta =
      const VerificationMeta('supersededPartNumber');
  @override
  late final GeneratedColumn<String> supersededPartNumber =
      GeneratedColumn<String>('superseded_part_number', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _remarksMeta =
      const VerificationMeta('remarks');
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
      'remarks', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _maintenanceItemIdMeta =
      const VerificationMeta('maintenanceItemId');
  @override
  late final GeneratedColumn<int> maintenanceItemId = GeneratedColumn<int>(
      'maintenance_item_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES maintenance_items (id)'));
  static const VerificationMeta _imageAssetPathMeta =
      const VerificationMeta('imageAssetPath');
  @override
  late final GeneratedColumn<String> imageAssetPath = GeneratedColumn<String>(
      'image_asset_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        partNumber,
        officialName,
        description,
        category,
        assemblyName,
        diagramNumber,
        referenceNumber,
        standardQuantity,
        supersededPartNumber,
        remarks,
        maintenanceItemId,
        imageAssetPath,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parts_catalog';
  @override
  VerificationContext validateIntegrity(Insertable<PartsCatalogRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('part_number')) {
      context.handle(
          _partNumberMeta,
          partNumber.isAcceptableOrUnknown(
              data['part_number']!, _partNumberMeta));
    } else if (isInserting) {
      context.missing(_partNumberMeta);
    }
    if (data.containsKey('official_name')) {
      context.handle(
          _officialNameMeta,
          officialName.isAcceptableOrUnknown(
              data['official_name']!, _officialNameMeta));
    } else if (isInserting) {
      context.missing(_officialNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('assembly_name')) {
      context.handle(
          _assemblyNameMeta,
          assemblyName.isAcceptableOrUnknown(
              data['assembly_name']!, _assemblyNameMeta));
    } else if (isInserting) {
      context.missing(_assemblyNameMeta);
    }
    if (data.containsKey('diagram_number')) {
      context.handle(
          _diagramNumberMeta,
          diagramNumber.isAcceptableOrUnknown(
              data['diagram_number']!, _diagramNumberMeta));
    }
    if (data.containsKey('reference_number')) {
      context.handle(
          _referenceNumberMeta,
          referenceNumber.isAcceptableOrUnknown(
              data['reference_number']!, _referenceNumberMeta));
    }
    if (data.containsKey('standard_quantity')) {
      context.handle(
          _standardQuantityMeta,
          standardQuantity.isAcceptableOrUnknown(
              data['standard_quantity']!, _standardQuantityMeta));
    }
    if (data.containsKey('superseded_part_number')) {
      context.handle(
          _supersededPartNumberMeta,
          supersededPartNumber.isAcceptableOrUnknown(
              data['superseded_part_number']!, _supersededPartNumberMeta));
    }
    if (data.containsKey('remarks')) {
      context.handle(_remarksMeta,
          remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta));
    }
    if (data.containsKey('maintenance_item_id')) {
      context.handle(
          _maintenanceItemIdMeta,
          maintenanceItemId.isAcceptableOrUnknown(
              data['maintenance_item_id']!, _maintenanceItemIdMeta));
    }
    if (data.containsKey('image_asset_path')) {
      context.handle(
          _imageAssetPathMeta,
          imageAssetPath.isAcceptableOrUnknown(
              data['image_asset_path']!, _imageAssetPathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartsCatalogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartsCatalogRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      partNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}part_number'])!,
      officialName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}official_name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      assemblyName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}assembly_name'])!,
      diagramNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}diagram_number']),
      referenceNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reference_number']),
      standardQuantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}standard_quantity'])!,
      supersededPartNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}superseded_part_number']),
      remarks: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remarks']),
      maintenanceItemId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}maintenance_item_id']),
      imageAssetPath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}image_asset_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PartsCatalogTable createAlias(String alias) {
    return $PartsCatalogTable(attachedDatabase, alias);
  }
}

class PartsCatalogRow extends DataClass implements Insertable<PartsCatalogRow> {
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
  final String createdAt;
  const PartsCatalogRow(
      {required this.id,
      required this.partNumber,
      required this.officialName,
      this.description,
      required this.category,
      required this.assemblyName,
      this.diagramNumber,
      this.referenceNumber,
      required this.standardQuantity,
      this.supersededPartNumber,
      this.remarks,
      this.maintenanceItemId,
      this.imageAssetPath,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['part_number'] = Variable<String>(partNumber);
    map['official_name'] = Variable<String>(officialName);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['category'] = Variable<String>(category);
    map['assembly_name'] = Variable<String>(assemblyName);
    if (!nullToAbsent || diagramNumber != null) {
      map['diagram_number'] = Variable<String>(diagramNumber);
    }
    if (!nullToAbsent || referenceNumber != null) {
      map['reference_number'] = Variable<int>(referenceNumber);
    }
    map['standard_quantity'] = Variable<int>(standardQuantity);
    if (!nullToAbsent || supersededPartNumber != null) {
      map['superseded_part_number'] = Variable<String>(supersededPartNumber);
    }
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    if (!nullToAbsent || maintenanceItemId != null) {
      map['maintenance_item_id'] = Variable<int>(maintenanceItemId);
    }
    if (!nullToAbsent || imageAssetPath != null) {
      map['image_asset_path'] = Variable<String>(imageAssetPath);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  PartsCatalogCompanion toCompanion(bool nullToAbsent) {
    return PartsCatalogCompanion(
      id: Value(id),
      partNumber: Value(partNumber),
      officialName: Value(officialName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      category: Value(category),
      assemblyName: Value(assemblyName),
      diagramNumber: diagramNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(diagramNumber),
      referenceNumber: referenceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceNumber),
      standardQuantity: Value(standardQuantity),
      supersededPartNumber: supersededPartNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(supersededPartNumber),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      maintenanceItemId: maintenanceItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(maintenanceItemId),
      imageAssetPath: imageAssetPath == null && nullToAbsent
          ? const Value.absent()
          : Value(imageAssetPath),
      createdAt: Value(createdAt),
    );
  }

  factory PartsCatalogRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartsCatalogRow(
      id: serializer.fromJson<int>(json['id']),
      partNumber: serializer.fromJson<String>(json['partNumber']),
      officialName: serializer.fromJson<String>(json['officialName']),
      description: serializer.fromJson<String?>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      assemblyName: serializer.fromJson<String>(json['assemblyName']),
      diagramNumber: serializer.fromJson<String?>(json['diagramNumber']),
      referenceNumber: serializer.fromJson<int?>(json['referenceNumber']),
      standardQuantity: serializer.fromJson<int>(json['standardQuantity']),
      supersededPartNumber:
          serializer.fromJson<String?>(json['supersededPartNumber']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      maintenanceItemId: serializer.fromJson<int?>(json['maintenanceItemId']),
      imageAssetPath: serializer.fromJson<String?>(json['imageAssetPath']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'partNumber': serializer.toJson<String>(partNumber),
      'officialName': serializer.toJson<String>(officialName),
      'description': serializer.toJson<String?>(description),
      'category': serializer.toJson<String>(category),
      'assemblyName': serializer.toJson<String>(assemblyName),
      'diagramNumber': serializer.toJson<String?>(diagramNumber),
      'referenceNumber': serializer.toJson<int?>(referenceNumber),
      'standardQuantity': serializer.toJson<int>(standardQuantity),
      'supersededPartNumber': serializer.toJson<String?>(supersededPartNumber),
      'remarks': serializer.toJson<String?>(remarks),
      'maintenanceItemId': serializer.toJson<int?>(maintenanceItemId),
      'imageAssetPath': serializer.toJson<String?>(imageAssetPath),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  PartsCatalogRow copyWith(
          {int? id,
          String? partNumber,
          String? officialName,
          Value<String?> description = const Value.absent(),
          String? category,
          String? assemblyName,
          Value<String?> diagramNumber = const Value.absent(),
          Value<int?> referenceNumber = const Value.absent(),
          int? standardQuantity,
          Value<String?> supersededPartNumber = const Value.absent(),
          Value<String?> remarks = const Value.absent(),
          Value<int?> maintenanceItemId = const Value.absent(),
          Value<String?> imageAssetPath = const Value.absent(),
          String? createdAt}) =>
      PartsCatalogRow(
        id: id ?? this.id,
        partNumber: partNumber ?? this.partNumber,
        officialName: officialName ?? this.officialName,
        description: description.present ? description.value : this.description,
        category: category ?? this.category,
        assemblyName: assemblyName ?? this.assemblyName,
        diagramNumber:
            diagramNumber.present ? diagramNumber.value : this.diagramNumber,
        referenceNumber: referenceNumber.present
            ? referenceNumber.value
            : this.referenceNumber,
        standardQuantity: standardQuantity ?? this.standardQuantity,
        supersededPartNumber: supersededPartNumber.present
            ? supersededPartNumber.value
            : this.supersededPartNumber,
        remarks: remarks.present ? remarks.value : this.remarks,
        maintenanceItemId: maintenanceItemId.present
            ? maintenanceItemId.value
            : this.maintenanceItemId,
        imageAssetPath:
            imageAssetPath.present ? imageAssetPath.value : this.imageAssetPath,
        createdAt: createdAt ?? this.createdAt,
      );
  PartsCatalogRow copyWithCompanion(PartsCatalogCompanion data) {
    return PartsCatalogRow(
      id: data.id.present ? data.id.value : this.id,
      partNumber:
          data.partNumber.present ? data.partNumber.value : this.partNumber,
      officialName: data.officialName.present
          ? data.officialName.value
          : this.officialName,
      description:
          data.description.present ? data.description.value : this.description,
      category: data.category.present ? data.category.value : this.category,
      assemblyName: data.assemblyName.present
          ? data.assemblyName.value
          : this.assemblyName,
      diagramNumber: data.diagramNumber.present
          ? data.diagramNumber.value
          : this.diagramNumber,
      referenceNumber: data.referenceNumber.present
          ? data.referenceNumber.value
          : this.referenceNumber,
      standardQuantity: data.standardQuantity.present
          ? data.standardQuantity.value
          : this.standardQuantity,
      supersededPartNumber: data.supersededPartNumber.present
          ? data.supersededPartNumber.value
          : this.supersededPartNumber,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      maintenanceItemId: data.maintenanceItemId.present
          ? data.maintenanceItemId.value
          : this.maintenanceItemId,
      imageAssetPath: data.imageAssetPath.present
          ? data.imageAssetPath.value
          : this.imageAssetPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartsCatalogRow(')
          ..write('id: $id, ')
          ..write('partNumber: $partNumber, ')
          ..write('officialName: $officialName, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('assemblyName: $assemblyName, ')
          ..write('diagramNumber: $diagramNumber, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('standardQuantity: $standardQuantity, ')
          ..write('supersededPartNumber: $supersededPartNumber, ')
          ..write('remarks: $remarks, ')
          ..write('maintenanceItemId: $maintenanceItemId, ')
          ..write('imageAssetPath: $imageAssetPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      partNumber,
      officialName,
      description,
      category,
      assemblyName,
      diagramNumber,
      referenceNumber,
      standardQuantity,
      supersededPartNumber,
      remarks,
      maintenanceItemId,
      imageAssetPath,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartsCatalogRow &&
          other.id == this.id &&
          other.partNumber == this.partNumber &&
          other.officialName == this.officialName &&
          other.description == this.description &&
          other.category == this.category &&
          other.assemblyName == this.assemblyName &&
          other.diagramNumber == this.diagramNumber &&
          other.referenceNumber == this.referenceNumber &&
          other.standardQuantity == this.standardQuantity &&
          other.supersededPartNumber == this.supersededPartNumber &&
          other.remarks == this.remarks &&
          other.maintenanceItemId == this.maintenanceItemId &&
          other.imageAssetPath == this.imageAssetPath &&
          other.createdAt == this.createdAt);
}

class PartsCatalogCompanion extends UpdateCompanion<PartsCatalogRow> {
  final Value<int> id;
  final Value<String> partNumber;
  final Value<String> officialName;
  final Value<String?> description;
  final Value<String> category;
  final Value<String> assemblyName;
  final Value<String?> diagramNumber;
  final Value<int?> referenceNumber;
  final Value<int> standardQuantity;
  final Value<String?> supersededPartNumber;
  final Value<String?> remarks;
  final Value<int?> maintenanceItemId;
  final Value<String?> imageAssetPath;
  final Value<String> createdAt;
  const PartsCatalogCompanion({
    this.id = const Value.absent(),
    this.partNumber = const Value.absent(),
    this.officialName = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.assemblyName = const Value.absent(),
    this.diagramNumber = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.standardQuantity = const Value.absent(),
    this.supersededPartNumber = const Value.absent(),
    this.remarks = const Value.absent(),
    this.maintenanceItemId = const Value.absent(),
    this.imageAssetPath = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PartsCatalogCompanion.insert({
    this.id = const Value.absent(),
    required String partNumber,
    required String officialName,
    this.description = const Value.absent(),
    required String category,
    required String assemblyName,
    this.diagramNumber = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.standardQuantity = const Value.absent(),
    this.supersededPartNumber = const Value.absent(),
    this.remarks = const Value.absent(),
    this.maintenanceItemId = const Value.absent(),
    this.imageAssetPath = const Value.absent(),
    required String createdAt,
  })  : partNumber = Value(partNumber),
        officialName = Value(officialName),
        category = Value(category),
        assemblyName = Value(assemblyName),
        createdAt = Value(createdAt);
  static Insertable<PartsCatalogRow> custom({
    Expression<int>? id,
    Expression<String>? partNumber,
    Expression<String>? officialName,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? assemblyName,
    Expression<String>? diagramNumber,
    Expression<int>? referenceNumber,
    Expression<int>? standardQuantity,
    Expression<String>? supersededPartNumber,
    Expression<String>? remarks,
    Expression<int>? maintenanceItemId,
    Expression<String>? imageAssetPath,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partNumber != null) 'part_number': partNumber,
      if (officialName != null) 'official_name': officialName,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (assemblyName != null) 'assembly_name': assemblyName,
      if (diagramNumber != null) 'diagram_number': diagramNumber,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      if (standardQuantity != null) 'standard_quantity': standardQuantity,
      if (supersededPartNumber != null)
        'superseded_part_number': supersededPartNumber,
      if (remarks != null) 'remarks': remarks,
      if (maintenanceItemId != null) 'maintenance_item_id': maintenanceItemId,
      if (imageAssetPath != null) 'image_asset_path': imageAssetPath,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PartsCatalogCompanion copyWith(
      {Value<int>? id,
      Value<String>? partNumber,
      Value<String>? officialName,
      Value<String?>? description,
      Value<String>? category,
      Value<String>? assemblyName,
      Value<String?>? diagramNumber,
      Value<int?>? referenceNumber,
      Value<int>? standardQuantity,
      Value<String?>? supersededPartNumber,
      Value<String?>? remarks,
      Value<int?>? maintenanceItemId,
      Value<String?>? imageAssetPath,
      Value<String>? createdAt}) {
    return PartsCatalogCompanion(
      id: id ?? this.id,
      partNumber: partNumber ?? this.partNumber,
      officialName: officialName ?? this.officialName,
      description: description ?? this.description,
      category: category ?? this.category,
      assemblyName: assemblyName ?? this.assemblyName,
      diagramNumber: diagramNumber ?? this.diagramNumber,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      standardQuantity: standardQuantity ?? this.standardQuantity,
      supersededPartNumber: supersededPartNumber ?? this.supersededPartNumber,
      remarks: remarks ?? this.remarks,
      maintenanceItemId: maintenanceItemId ?? this.maintenanceItemId,
      imageAssetPath: imageAssetPath ?? this.imageAssetPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (partNumber.present) {
      map['part_number'] = Variable<String>(partNumber.value);
    }
    if (officialName.present) {
      map['official_name'] = Variable<String>(officialName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (assemblyName.present) {
      map['assembly_name'] = Variable<String>(assemblyName.value);
    }
    if (diagramNumber.present) {
      map['diagram_number'] = Variable<String>(diagramNumber.value);
    }
    if (referenceNumber.present) {
      map['reference_number'] = Variable<int>(referenceNumber.value);
    }
    if (standardQuantity.present) {
      map['standard_quantity'] = Variable<int>(standardQuantity.value);
    }
    if (supersededPartNumber.present) {
      map['superseded_part_number'] =
          Variable<String>(supersededPartNumber.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (maintenanceItemId.present) {
      map['maintenance_item_id'] = Variable<int>(maintenanceItemId.value);
    }
    if (imageAssetPath.present) {
      map['image_asset_path'] = Variable<String>(imageAssetPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartsCatalogCompanion(')
          ..write('id: $id, ')
          ..write('partNumber: $partNumber, ')
          ..write('officialName: $officialName, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('assemblyName: $assemblyName, ')
          ..write('diagramNumber: $diagramNumber, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('standardQuantity: $standardQuantity, ')
          ..write('supersededPartNumber: $supersededPartNumber, ')
          ..write('remarks: $remarks, ')
          ..write('maintenanceItemId: $maintenanceItemId, ')
          ..write('imageAssetPath: $imageAssetPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PartsCatalogImagesTable extends PartsCatalogImages
    with TableInfo<$PartsCatalogImagesTable, PartsCatalogImageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartsCatalogImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _diagramCodeMeta =
      const VerificationMeta('diagramCode');
  @override
  late final GeneratedColumn<String> diagramCode = GeneratedColumn<String>(
      'diagram_code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageAssetPathMeta =
      const VerificationMeta('imageAssetPath');
  @override
  late final GeneratedColumn<String> imageAssetPath = GeneratedColumn<String>(
      'image_asset_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _assemblyNameMeta =
      const VerificationMeta('assemblyName');
  @override
  late final GeneratedColumn<String> assemblyName = GeneratedColumn<String>(
      'assembly_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, diagramCode, title, description, imageAssetPath, assemblyName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parts_catalog_images';
  @override
  VerificationContext validateIntegrity(
      Insertable<PartsCatalogImageRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('diagram_code')) {
      context.handle(
          _diagramCodeMeta,
          diagramCode.isAcceptableOrUnknown(
              data['diagram_code']!, _diagramCodeMeta));
    } else if (isInserting) {
      context.missing(_diagramCodeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('image_asset_path')) {
      context.handle(
          _imageAssetPathMeta,
          imageAssetPath.isAcceptableOrUnknown(
              data['image_asset_path']!, _imageAssetPathMeta));
    }
    if (data.containsKey('assembly_name')) {
      context.handle(
          _assemblyNameMeta,
          assemblyName.isAcceptableOrUnknown(
              data['assembly_name']!, _assemblyNameMeta));
    } else if (isInserting) {
      context.missing(_assemblyNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartsCatalogImageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartsCatalogImageRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      diagramCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}diagram_code'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      imageAssetPath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}image_asset_path']),
      assemblyName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}assembly_name'])!,
    );
  }

  @override
  $PartsCatalogImagesTable createAlias(String alias) {
    return $PartsCatalogImagesTable(attachedDatabase, alias);
  }
}

class PartsCatalogImageRow extends DataClass
    implements Insertable<PartsCatalogImageRow> {
  final int id;
  final String diagramCode;
  final String title;
  final String? description;
  final String? imageAssetPath;
  final String assemblyName;
  const PartsCatalogImageRow(
      {required this.id,
      required this.diagramCode,
      required this.title,
      this.description,
      this.imageAssetPath,
      required this.assemblyName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['diagram_code'] = Variable<String>(diagramCode);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || imageAssetPath != null) {
      map['image_asset_path'] = Variable<String>(imageAssetPath);
    }
    map['assembly_name'] = Variable<String>(assemblyName);
    return map;
  }

  PartsCatalogImagesCompanion toCompanion(bool nullToAbsent) {
    return PartsCatalogImagesCompanion(
      id: Value(id),
      diagramCode: Value(diagramCode),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      imageAssetPath: imageAssetPath == null && nullToAbsent
          ? const Value.absent()
          : Value(imageAssetPath),
      assemblyName: Value(assemblyName),
    );
  }

  factory PartsCatalogImageRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartsCatalogImageRow(
      id: serializer.fromJson<int>(json['id']),
      diagramCode: serializer.fromJson<String>(json['diagramCode']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      imageAssetPath: serializer.fromJson<String?>(json['imageAssetPath']),
      assemblyName: serializer.fromJson<String>(json['assemblyName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'diagramCode': serializer.toJson<String>(diagramCode),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'imageAssetPath': serializer.toJson<String?>(imageAssetPath),
      'assemblyName': serializer.toJson<String>(assemblyName),
    };
  }

  PartsCatalogImageRow copyWith(
          {int? id,
          String? diagramCode,
          String? title,
          Value<String?> description = const Value.absent(),
          Value<String?> imageAssetPath = const Value.absent(),
          String? assemblyName}) =>
      PartsCatalogImageRow(
        id: id ?? this.id,
        diagramCode: diagramCode ?? this.diagramCode,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        imageAssetPath:
            imageAssetPath.present ? imageAssetPath.value : this.imageAssetPath,
        assemblyName: assemblyName ?? this.assemblyName,
      );
  PartsCatalogImageRow copyWithCompanion(PartsCatalogImagesCompanion data) {
    return PartsCatalogImageRow(
      id: data.id.present ? data.id.value : this.id,
      diagramCode:
          data.diagramCode.present ? data.diagramCode.value : this.diagramCode,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      imageAssetPath: data.imageAssetPath.present
          ? data.imageAssetPath.value
          : this.imageAssetPath,
      assemblyName: data.assemblyName.present
          ? data.assemblyName.value
          : this.assemblyName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartsCatalogImageRow(')
          ..write('id: $id, ')
          ..write('diagramCode: $diagramCode, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('imageAssetPath: $imageAssetPath, ')
          ..write('assemblyName: $assemblyName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, diagramCode, title, description, imageAssetPath, assemblyName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartsCatalogImageRow &&
          other.id == this.id &&
          other.diagramCode == this.diagramCode &&
          other.title == this.title &&
          other.description == this.description &&
          other.imageAssetPath == this.imageAssetPath &&
          other.assemblyName == this.assemblyName);
}

class PartsCatalogImagesCompanion
    extends UpdateCompanion<PartsCatalogImageRow> {
  final Value<int> id;
  final Value<String> diagramCode;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> imageAssetPath;
  final Value<String> assemblyName;
  const PartsCatalogImagesCompanion({
    this.id = const Value.absent(),
    this.diagramCode = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.imageAssetPath = const Value.absent(),
    this.assemblyName = const Value.absent(),
  });
  PartsCatalogImagesCompanion.insert({
    this.id = const Value.absent(),
    required String diagramCode,
    required String title,
    this.description = const Value.absent(),
    this.imageAssetPath = const Value.absent(),
    required String assemblyName,
  })  : diagramCode = Value(diagramCode),
        title = Value(title),
        assemblyName = Value(assemblyName);
  static Insertable<PartsCatalogImageRow> custom({
    Expression<int>? id,
    Expression<String>? diagramCode,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? imageAssetPath,
    Expression<String>? assemblyName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (diagramCode != null) 'diagram_code': diagramCode,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (imageAssetPath != null) 'image_asset_path': imageAssetPath,
      if (assemblyName != null) 'assembly_name': assemblyName,
    });
  }

  PartsCatalogImagesCompanion copyWith(
      {Value<int>? id,
      Value<String>? diagramCode,
      Value<String>? title,
      Value<String?>? description,
      Value<String?>? imageAssetPath,
      Value<String>? assemblyName}) {
    return PartsCatalogImagesCompanion(
      id: id ?? this.id,
      diagramCode: diagramCode ?? this.diagramCode,
      title: title ?? this.title,
      description: description ?? this.description,
      imageAssetPath: imageAssetPath ?? this.imageAssetPath,
      assemblyName: assemblyName ?? this.assemblyName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (diagramCode.present) {
      map['diagram_code'] = Variable<String>(diagramCode.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imageAssetPath.present) {
      map['image_asset_path'] = Variable<String>(imageAssetPath.value);
    }
    if (assemblyName.present) {
      map['assembly_name'] = Variable<String>(assemblyName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartsCatalogImagesCompanion(')
          ..write('id: $id, ')
          ..write('diagramCode: $diagramCode, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('imageAssetPath: $imageAssetPath, ')
          ..write('assemblyName: $assemblyName')
          ..write(')'))
        .toString();
  }
}

class $PartsCatalogCompatibilityTable extends PartsCatalogCompatibility
    with
        TableInfo<$PartsCatalogCompatibilityTable,
            PartsCatalogCompatibilityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartsCatalogCompatibilityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _partsCatalogIdMeta =
      const VerificationMeta('partsCatalogId');
  @override
  late final GeneratedColumn<int> partsCatalogId = GeneratedColumn<int>(
      'parts_catalog_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES parts_catalog (id)'));
  static const VerificationMeta _modelNameMeta =
      const VerificationMeta('modelName');
  @override
  late final GeneratedColumn<String> modelName = GeneratedColumn<String>(
      'model_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _modelCodeMeta =
      const VerificationMeta('modelCode');
  @override
  late final GeneratedColumn<String> modelCode = GeneratedColumn<String>(
      'model_code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _startYearMeta =
      const VerificationMeta('startYear');
  @override
  late final GeneratedColumn<int> startYear = GeneratedColumn<int>(
      'start_year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endYearMeta =
      const VerificationMeta('endYear');
  @override
  late final GeneratedColumn<int> endYear = GeneratedColumn<int>(
      'end_year', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _regionalVariantMeta =
      const VerificationMeta('regionalVariant');
  @override
  late final GeneratedColumn<String> regionalVariant = GeneratedColumn<String>(
      'regional_variant', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        partsCatalogId,
        modelName,
        modelCode,
        startYear,
        endYear,
        regionalVariant,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parts_catalog_compatibility';
  @override
  VerificationContext validateIntegrity(
      Insertable<PartsCatalogCompatibilityRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('parts_catalog_id')) {
      context.handle(
          _partsCatalogIdMeta,
          partsCatalogId.isAcceptableOrUnknown(
              data['parts_catalog_id']!, _partsCatalogIdMeta));
    } else if (isInserting) {
      context.missing(_partsCatalogIdMeta);
    }
    if (data.containsKey('model_name')) {
      context.handle(_modelNameMeta,
          modelName.isAcceptableOrUnknown(data['model_name']!, _modelNameMeta));
    } else if (isInserting) {
      context.missing(_modelNameMeta);
    }
    if (data.containsKey('model_code')) {
      context.handle(_modelCodeMeta,
          modelCode.isAcceptableOrUnknown(data['model_code']!, _modelCodeMeta));
    } else if (isInserting) {
      context.missing(_modelCodeMeta);
    }
    if (data.containsKey('start_year')) {
      context.handle(_startYearMeta,
          startYear.isAcceptableOrUnknown(data['start_year']!, _startYearMeta));
    } else if (isInserting) {
      context.missing(_startYearMeta);
    }
    if (data.containsKey('end_year')) {
      context.handle(_endYearMeta,
          endYear.isAcceptableOrUnknown(data['end_year']!, _endYearMeta));
    }
    if (data.containsKey('regional_variant')) {
      context.handle(
          _regionalVariantMeta,
          regionalVariant.isAcceptableOrUnknown(
              data['regional_variant']!, _regionalVariantMeta));
    } else if (isInserting) {
      context.missing(_regionalVariantMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartsCatalogCompatibilityRow map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartsCatalogCompatibilityRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      partsCatalogId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parts_catalog_id'])!,
      modelName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model_name'])!,
      modelCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model_code'])!,
      startYear: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_year'])!,
      endYear: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_year']),
      regionalVariant: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}regional_variant'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $PartsCatalogCompatibilityTable createAlias(String alias) {
    return $PartsCatalogCompatibilityTable(attachedDatabase, alias);
  }
}

class PartsCatalogCompatibilityRow extends DataClass
    implements Insertable<PartsCatalogCompatibilityRow> {
  final int id;
  final int partsCatalogId;
  final String modelName;
  final String modelCode;
  final int startYear;
  final int? endYear;
  final String regionalVariant;
  final String? notes;
  const PartsCatalogCompatibilityRow(
      {required this.id,
      required this.partsCatalogId,
      required this.modelName,
      required this.modelCode,
      required this.startYear,
      this.endYear,
      required this.regionalVariant,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['parts_catalog_id'] = Variable<int>(partsCatalogId);
    map['model_name'] = Variable<String>(modelName);
    map['model_code'] = Variable<String>(modelCode);
    map['start_year'] = Variable<int>(startYear);
    if (!nullToAbsent || endYear != null) {
      map['end_year'] = Variable<int>(endYear);
    }
    map['regional_variant'] = Variable<String>(regionalVariant);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PartsCatalogCompatibilityCompanion toCompanion(bool nullToAbsent) {
    return PartsCatalogCompatibilityCompanion(
      id: Value(id),
      partsCatalogId: Value(partsCatalogId),
      modelName: Value(modelName),
      modelCode: Value(modelCode),
      startYear: Value(startYear),
      endYear: endYear == null && nullToAbsent
          ? const Value.absent()
          : Value(endYear),
      regionalVariant: Value(regionalVariant),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory PartsCatalogCompatibilityRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartsCatalogCompatibilityRow(
      id: serializer.fromJson<int>(json['id']),
      partsCatalogId: serializer.fromJson<int>(json['partsCatalogId']),
      modelName: serializer.fromJson<String>(json['modelName']),
      modelCode: serializer.fromJson<String>(json['modelCode']),
      startYear: serializer.fromJson<int>(json['startYear']),
      endYear: serializer.fromJson<int?>(json['endYear']),
      regionalVariant: serializer.fromJson<String>(json['regionalVariant']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'partsCatalogId': serializer.toJson<int>(partsCatalogId),
      'modelName': serializer.toJson<String>(modelName),
      'modelCode': serializer.toJson<String>(modelCode),
      'startYear': serializer.toJson<int>(startYear),
      'endYear': serializer.toJson<int?>(endYear),
      'regionalVariant': serializer.toJson<String>(regionalVariant),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  PartsCatalogCompatibilityRow copyWith(
          {int? id,
          int? partsCatalogId,
          String? modelName,
          String? modelCode,
          int? startYear,
          Value<int?> endYear = const Value.absent(),
          String? regionalVariant,
          Value<String?> notes = const Value.absent()}) =>
      PartsCatalogCompatibilityRow(
        id: id ?? this.id,
        partsCatalogId: partsCatalogId ?? this.partsCatalogId,
        modelName: modelName ?? this.modelName,
        modelCode: modelCode ?? this.modelCode,
        startYear: startYear ?? this.startYear,
        endYear: endYear.present ? endYear.value : this.endYear,
        regionalVariant: regionalVariant ?? this.regionalVariant,
        notes: notes.present ? notes.value : this.notes,
      );
  PartsCatalogCompatibilityRow copyWithCompanion(
      PartsCatalogCompatibilityCompanion data) {
    return PartsCatalogCompatibilityRow(
      id: data.id.present ? data.id.value : this.id,
      partsCatalogId: data.partsCatalogId.present
          ? data.partsCatalogId.value
          : this.partsCatalogId,
      modelName: data.modelName.present ? data.modelName.value : this.modelName,
      modelCode: data.modelCode.present ? data.modelCode.value : this.modelCode,
      startYear: data.startYear.present ? data.startYear.value : this.startYear,
      endYear: data.endYear.present ? data.endYear.value : this.endYear,
      regionalVariant: data.regionalVariant.present
          ? data.regionalVariant.value
          : this.regionalVariant,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartsCatalogCompatibilityRow(')
          ..write('id: $id, ')
          ..write('partsCatalogId: $partsCatalogId, ')
          ..write('modelName: $modelName, ')
          ..write('modelCode: $modelCode, ')
          ..write('startYear: $startYear, ')
          ..write('endYear: $endYear, ')
          ..write('regionalVariant: $regionalVariant, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, partsCatalogId, modelName, modelCode,
      startYear, endYear, regionalVariant, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartsCatalogCompatibilityRow &&
          other.id == this.id &&
          other.partsCatalogId == this.partsCatalogId &&
          other.modelName == this.modelName &&
          other.modelCode == this.modelCode &&
          other.startYear == this.startYear &&
          other.endYear == this.endYear &&
          other.regionalVariant == this.regionalVariant &&
          other.notes == this.notes);
}

class PartsCatalogCompatibilityCompanion
    extends UpdateCompanion<PartsCatalogCompatibilityRow> {
  final Value<int> id;
  final Value<int> partsCatalogId;
  final Value<String> modelName;
  final Value<String> modelCode;
  final Value<int> startYear;
  final Value<int?> endYear;
  final Value<String> regionalVariant;
  final Value<String?> notes;
  const PartsCatalogCompatibilityCompanion({
    this.id = const Value.absent(),
    this.partsCatalogId = const Value.absent(),
    this.modelName = const Value.absent(),
    this.modelCode = const Value.absent(),
    this.startYear = const Value.absent(),
    this.endYear = const Value.absent(),
    this.regionalVariant = const Value.absent(),
    this.notes = const Value.absent(),
  });
  PartsCatalogCompatibilityCompanion.insert({
    this.id = const Value.absent(),
    required int partsCatalogId,
    required String modelName,
    required String modelCode,
    required int startYear,
    this.endYear = const Value.absent(),
    required String regionalVariant,
    this.notes = const Value.absent(),
  })  : partsCatalogId = Value(partsCatalogId),
        modelName = Value(modelName),
        modelCode = Value(modelCode),
        startYear = Value(startYear),
        regionalVariant = Value(regionalVariant);
  static Insertable<PartsCatalogCompatibilityRow> custom({
    Expression<int>? id,
    Expression<int>? partsCatalogId,
    Expression<String>? modelName,
    Expression<String>? modelCode,
    Expression<int>? startYear,
    Expression<int>? endYear,
    Expression<String>? regionalVariant,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partsCatalogId != null) 'parts_catalog_id': partsCatalogId,
      if (modelName != null) 'model_name': modelName,
      if (modelCode != null) 'model_code': modelCode,
      if (startYear != null) 'start_year': startYear,
      if (endYear != null) 'end_year': endYear,
      if (regionalVariant != null) 'regional_variant': regionalVariant,
      if (notes != null) 'notes': notes,
    });
  }

  PartsCatalogCompatibilityCompanion copyWith(
      {Value<int>? id,
      Value<int>? partsCatalogId,
      Value<String>? modelName,
      Value<String>? modelCode,
      Value<int>? startYear,
      Value<int?>? endYear,
      Value<String>? regionalVariant,
      Value<String?>? notes}) {
    return PartsCatalogCompatibilityCompanion(
      id: id ?? this.id,
      partsCatalogId: partsCatalogId ?? this.partsCatalogId,
      modelName: modelName ?? this.modelName,
      modelCode: modelCode ?? this.modelCode,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
      regionalVariant: regionalVariant ?? this.regionalVariant,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (partsCatalogId.present) {
      map['parts_catalog_id'] = Variable<int>(partsCatalogId.value);
    }
    if (modelName.present) {
      map['model_name'] = Variable<String>(modelName.value);
    }
    if (modelCode.present) {
      map['model_code'] = Variable<String>(modelCode.value);
    }
    if (startYear.present) {
      map['start_year'] = Variable<int>(startYear.value);
    }
    if (endYear.present) {
      map['end_year'] = Variable<int>(endYear.value);
    }
    if (regionalVariant.present) {
      map['regional_variant'] = Variable<String>(regionalVariant.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartsCatalogCompatibilityCompanion(')
          ..write('id: $id, ')
          ..write('partsCatalogId: $partsCatalogId, ')
          ..write('modelName: $modelName, ')
          ..write('modelCode: $modelCode, ')
          ..write('startYear: $startYear, ')
          ..write('endYear: $endYear, ')
          ..write('regionalVariant: $regionalVariant, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MotorcyclesTable motorcycles = $MotorcyclesTable(this);
  late final $MaintenanceCategoriesTable maintenanceCategories =
      $MaintenanceCategoriesTable(this);
  late final $MaintenanceItemsTable maintenanceItems =
      $MaintenanceItemsTable(this);
  late final $MaintenanceRulesTable maintenanceRules =
      $MaintenanceRulesTable(this);
  late final $MaintenanceRuleStepsTable maintenanceRuleSteps =
      $MaintenanceRuleStepsTable(this);
  late final $MaintenanceRecordsTable maintenanceRecords =
      $MaintenanceRecordsTable(this);
  late final $OdometerLogsTable odometerLogs = $OdometerLogsTable(this);
  late final $ComponentMeasurementsTable componentMeasurements =
      $ComponentMeasurementsTable(this);
  late final $ComponentSpecsTable componentSpecs = $ComponentSpecsTable(this);
  late final $PartsTable parts = $PartsTable(this);
  late final $MaintenanceRecordPartsTable maintenanceRecordParts =
      $MaintenanceRecordPartsTable(this);
  late final $PartInstallationsTable partInstallations =
      $PartInstallationsTable(this);
  late final $MaintenanceRemindersTable maintenanceReminders =
      $MaintenanceRemindersTable(this);
  late final $AttachmentsTable attachments = $AttachmentsTable(this);
  late final $TripsTable trips = $TripsTable(this);
  late final $TripWaypointsTable tripWaypoints = $TripWaypointsTable(this);
  late final $SavedLocationsTable savedLocations = $SavedLocationsTable(this);
  late final $SavedRoutesTable savedRoutes = $SavedRoutesTable(this);
  late final $CvtConfigurationsTable cvtConfigurations =
      $CvtConfigurationsTable(this);
  late final $CvtPerformanceLogsTable cvtPerformanceLogs =
      $CvtPerformanceLogsTable(this);
  late final $PartsCatalogTable partsCatalog = $PartsCatalogTable(this);
  late final $PartsCatalogImagesTable partsCatalogImages =
      $PartsCatalogImagesTable(this);
  late final $PartsCatalogCompatibilityTable partsCatalogCompatibility =
      $PartsCatalogCompatibilityTable(this);
  late final Index idxMaintenanceItemsCategory = Index(
      'idx_maintenance_items_category',
      'CREATE INDEX idx_maintenance_items_category ON maintenance_items (category_id)');
  late final Index idxRulesItem = Index('idx_rules_item',
      'CREATE INDEX idx_rules_item ON maintenance_rules (item_id)');
  late final Index idxRulesMotorcycle = Index('idx_rules_motorcycle',
      'CREATE INDEX idx_rules_motorcycle ON maintenance_rules (motorcycle_id)');
  late final Index idxRuleStepsRule = Index('idx_rule_steps_rule',
      'CREATE INDEX idx_rule_steps_rule ON maintenance_rule_steps (rule_id)');
  late final Index idxRecordsItemDate = Index('idx_records_item_date',
      'CREATE INDEX idx_records_item_date ON maintenance_records (item_id, performed_date)');
  late final Index idxRecordsMotorcycle = Index('idx_records_motorcycle',
      'CREATE INDEX idx_records_motorcycle ON maintenance_records (motorcycle_id)');
  late final Index idxOdometerMotorcycleDate = Index(
      'idx_odometer_motorcycle_date',
      'CREATE INDEX idx_odometer_motorcycle_date ON odometer_logs (motorcycle_id, recorded_date)');
  late final Index idxMeasurementsItemDate = Index('idx_measurements_item_date',
      'CREATE INDEX idx_measurements_item_date ON component_measurements (item_id, measured_date)');
  late final Index idxComponentSpecsItem = Index('idx_component_specs_item',
      'CREATE INDEX idx_component_specs_item ON component_specs (item_id)');
  late final Index idxPartsItem =
      Index('idx_parts_item', 'CREATE INDEX idx_parts_item ON parts (item_id)');
  late final Index idxRecordPartsRecord = Index('idx_record_parts_record',
      'CREATE INDEX idx_record_parts_record ON maintenance_record_parts (record_id)');
  late final Index idxRecordPartsPart = Index('idx_record_parts_part',
      'CREATE INDEX idx_record_parts_part ON maintenance_record_parts (part_id)');
  late final Index idxInstallationsPart = Index('idx_installations_part',
      'CREATE INDEX idx_installations_part ON part_installations (part_id)');
  late final Index idxInstallationsMotorcycle = Index(
      'idx_installations_motorcycle',
      'CREATE INDEX idx_installations_motorcycle ON part_installations (motorcycle_id)');
  late final Index idxRemindersStatusDue = Index('idx_reminders_status_due',
      'CREATE INDEX idx_reminders_status_due ON maintenance_reminders (status, due_date)');
  late final Index idxRemindersMotorcycle = Index('idx_reminders_motorcycle',
      'CREATE INDEX idx_reminders_motorcycle ON maintenance_reminders (motorcycle_id)');
  late final Index idxAttachmentsRecord = Index('idx_attachments_record',
      'CREATE INDEX idx_attachments_record ON attachments (record_id)');
  late final Index idxAttachmentsMeasurement = Index(
      'idx_attachments_measurement',
      'CREATE INDEX idx_attachments_measurement ON attachments (measurement_id)');
  late final Index idxPartsCatPartNo = Index('idx_parts_cat_part_no',
      'CREATE INDEX idx_parts_cat_part_no ON parts_catalog (part_number)');
  late final Index idxPartsCatCategory = Index('idx_parts_cat_category',
      'CREATE INDEX idx_parts_cat_category ON parts_catalog (category)');
  late final Index idxPartsCatAssembly = Index('idx_parts_cat_assembly',
      'CREATE INDEX idx_parts_cat_assembly ON parts_catalog (assembly_name)');
  late final Index idxPartsCatDiagram = Index('idx_parts_cat_diagram',
      'CREATE INDEX idx_parts_cat_diagram ON parts_catalog_images (diagram_code)');
  late final Index idxPartsCatCompatPart = Index('idx_parts_cat_compat_part',
      'CREATE INDEX idx_parts_cat_compat_part ON parts_catalog_compatibility (parts_catalog_id)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        motorcycles,
        maintenanceCategories,
        maintenanceItems,
        maintenanceRules,
        maintenanceRuleSteps,
        maintenanceRecords,
        odometerLogs,
        componentMeasurements,
        componentSpecs,
        parts,
        maintenanceRecordParts,
        partInstallations,
        maintenanceReminders,
        attachments,
        trips,
        tripWaypoints,
        savedLocations,
        savedRoutes,
        cvtConfigurations,
        cvtPerformanceLogs,
        partsCatalog,
        partsCatalogImages,
        partsCatalogCompatibility,
        idxMaintenanceItemsCategory,
        idxRulesItem,
        idxRulesMotorcycle,
        idxRuleStepsRule,
        idxRecordsItemDate,
        idxRecordsMotorcycle,
        idxOdometerMotorcycleDate,
        idxMeasurementsItemDate,
        idxComponentSpecsItem,
        idxPartsItem,
        idxRecordPartsRecord,
        idxRecordPartsPart,
        idxInstallationsPart,
        idxInstallationsMotorcycle,
        idxRemindersStatusDue,
        idxRemindersMotorcycle,
        idxAttachmentsRecord,
        idxAttachmentsMeasurement,
        idxPartsCatPartNo,
        idxPartsCatCategory,
        idxPartsCatAssembly,
        idxPartsCatDiagram,
        idxPartsCatCompatPart
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('motorcycles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('trips', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('trips',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('trip_waypoints', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('motorcycles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('saved_routes', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('motorcycles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('cvt_configurations', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('cvt_configurations',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('cvt_performance_logs', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$MotorcyclesTableCreateCompanionBuilder = MotorcyclesCompanion
    Function({
  Value<int> id,
  required String brand,
  required String model,
  required int modelYear,
  Value<String?> plateNumber,
  Value<String?> chassisNumber,
  Value<String?> engineNumber,
  Value<String?> purchaseDate,
  Value<String?> photoPath,
  required String createdAt,
  required String updatedAt,
});
typedef $$MotorcyclesTableUpdateCompanionBuilder = MotorcyclesCompanion
    Function({
  Value<int> id,
  Value<String> brand,
  Value<String> model,
  Value<int> modelYear,
  Value<String?> plateNumber,
  Value<String?> chassisNumber,
  Value<String?> engineNumber,
  Value<String?> purchaseDate,
  Value<String?> photoPath,
  Value<String> createdAt,
  Value<String> updatedAt,
});

final class $$MotorcyclesTableReferences
    extends BaseReferences<_$AppDatabase, $MotorcyclesTable, MotorcycleRow> {
  $$MotorcyclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MaintenanceRulesTable, List<MaintenanceRuleRow>>
      _maintenanceRulesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.maintenanceRules,
              aliasName: $_aliasNameGenerator(
                  db.motorcycles.id, db.maintenanceRules.motorcycleId));

  $$MaintenanceRulesTableProcessedTableManager get maintenanceRulesRefs {
    final manager =
        $$MaintenanceRulesTableTableManager($_db, $_db.maintenanceRules)
            .filter((f) => f.motorcycleId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_maintenanceRulesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MaintenanceRecordsTable,
      List<MaintenanceRecordRow>> _maintenanceRecordsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.maintenanceRecords,
          aliasName: $_aliasNameGenerator(
              db.motorcycles.id, db.maintenanceRecords.motorcycleId));

  $$MaintenanceRecordsTableProcessedTableManager get maintenanceRecordsRefs {
    final manager =
        $$MaintenanceRecordsTableTableManager($_db, $_db.maintenanceRecords)
            .filter((f) => f.motorcycleId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_maintenanceRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$OdometerLogsTable, List<OdometerLogRow>>
      _odometerLogsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.odometerLogs,
              aliasName: $_aliasNameGenerator(
                  db.motorcycles.id, db.odometerLogs.motorcycleId));

  $$OdometerLogsTableProcessedTableManager get odometerLogsRefs {
    final manager = $$OdometerLogsTableTableManager($_db, $_db.odometerLogs)
        .filter((f) => f.motorcycleId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_odometerLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ComponentMeasurementsTable,
      List<ComponentMeasurementRow>> _componentMeasurementsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.componentMeasurements,
          aliasName: $_aliasNameGenerator(
              db.motorcycles.id, db.componentMeasurements.motorcycleId));

  $$ComponentMeasurementsTableProcessedTableManager
      get componentMeasurementsRefs {
    final manager = $$ComponentMeasurementsTableTableManager(
            $_db, $_db.componentMeasurements)
        .filter((f) => f.motorcycleId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_componentMeasurementsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PartInstallationsTable, List<PartInstallationRow>>
      _partInstallationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.partInstallations,
              aliasName: $_aliasNameGenerator(
                  db.motorcycles.id, db.partInstallations.motorcycleId));

  $$PartInstallationsTableProcessedTableManager get partInstallationsRefs {
    final manager =
        $$PartInstallationsTableTableManager($_db, $_db.partInstallations)
            .filter((f) => f.motorcycleId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_partInstallationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MaintenanceRemindersTable,
      List<MaintenanceReminderRow>> _maintenanceRemindersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.maintenanceReminders,
          aliasName: $_aliasNameGenerator(
              db.motorcycles.id, db.maintenanceReminders.motorcycleId));

  $$MaintenanceRemindersTableProcessedTableManager
      get maintenanceRemindersRefs {
    final manager =
        $$MaintenanceRemindersTableTableManager($_db, $_db.maintenanceReminders)
            .filter((f) => f.motorcycleId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_maintenanceRemindersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AttachmentsTable, List<AttachmentRow>>
      _attachmentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.attachments,
              aliasName: $_aliasNameGenerator(
                  db.motorcycles.id, db.attachments.motorcycleId));

  $$AttachmentsTableProcessedTableManager get attachmentsRefs {
    final manager = $$AttachmentsTableTableManager($_db, $_db.attachments)
        .filter((f) => f.motorcycleId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_attachmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TripsTable, List<Trip>> _tripsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.trips,
          aliasName:
              $_aliasNameGenerator(db.motorcycles.id, db.trips.motorcycleId));

  $$TripsTableProcessedTableManager get tripsRefs {
    final manager = $$TripsTableTableManager($_db, $_db.trips)
        .filter((f) => f.motorcycleId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_tripsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SavedRoutesTable, List<SavedRoute>>
      _savedRoutesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.savedRoutes,
              aliasName: $_aliasNameGenerator(
                  db.motorcycles.id, db.savedRoutes.motorcycleId));

  $$SavedRoutesTableProcessedTableManager get savedRoutesRefs {
    final manager = $$SavedRoutesTableTableManager($_db, $_db.savedRoutes)
        .filter((f) => f.motorcycleId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_savedRoutesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CvtConfigurationsTable, List<CvtConfiguration>>
      _cvtConfigurationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.cvtConfigurations,
              aliasName: $_aliasNameGenerator(
                  db.motorcycles.id, db.cvtConfigurations.motorcycleId));

  $$CvtConfigurationsTableProcessedTableManager get cvtConfigurationsRefs {
    final manager =
        $$CvtConfigurationsTableTableManager($_db, $_db.cvtConfigurations)
            .filter((f) => f.motorcycleId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_cvtConfigurationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MotorcyclesTableFilterComposer
    extends Composer<_$AppDatabase, $MotorcyclesTable> {
  $$MotorcyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get modelYear => $composableBuilder(
      column: $table.modelYear, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get plateNumber => $composableBuilder(
      column: $table.plateNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chassisNumber => $composableBuilder(
      column: $table.chassisNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get engineNumber => $composableBuilder(
      column: $table.engineNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> maintenanceRulesRefs(
      Expression<bool> Function($$MaintenanceRulesTableFilterComposer f) f) {
    final $$MaintenanceRulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.maintenanceRules,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRulesTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> maintenanceRecordsRefs(
      Expression<bool> Function($$MaintenanceRecordsTableFilterComposer f) f) {
    final $$MaintenanceRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.maintenanceRecords,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRecordsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> odometerLogsRefs(
      Expression<bool> Function($$OdometerLogsTableFilterComposer f) f) {
    final $$OdometerLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.odometerLogs,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OdometerLogsTableFilterComposer(
              $db: $db,
              $table: $db.odometerLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> componentMeasurementsRefs(
      Expression<bool> Function($$ComponentMeasurementsTableFilterComposer f)
          f) {
    final $$ComponentMeasurementsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.componentMeasurements,
            getReferencedColumn: (t) => t.motorcycleId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ComponentMeasurementsTableFilterComposer(
                  $db: $db,
                  $table: $db.componentMeasurements,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> partInstallationsRefs(
      Expression<bool> Function($$PartInstallationsTableFilterComposer f) f) {
    final $$PartInstallationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.partInstallations,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartInstallationsTableFilterComposer(
              $db: $db,
              $table: $db.partInstallations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> maintenanceRemindersRefs(
      Expression<bool> Function($$MaintenanceRemindersTableFilterComposer f)
          f) {
    final $$MaintenanceRemindersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.maintenanceReminders,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRemindersTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceReminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> attachmentsRefs(
      Expression<bool> Function($$AttachmentsTableFilterComposer f) f) {
    final $$AttachmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attachments,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttachmentsTableFilterComposer(
              $db: $db,
              $table: $db.attachments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> tripsRefs(
      Expression<bool> Function($$TripsTableFilterComposer f) f) {
    final $$TripsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.trips,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TripsTableFilterComposer(
              $db: $db,
              $table: $db.trips,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> savedRoutesRefs(
      Expression<bool> Function($$SavedRoutesTableFilterComposer f) f) {
    final $$SavedRoutesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.savedRoutes,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SavedRoutesTableFilterComposer(
              $db: $db,
              $table: $db.savedRoutes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> cvtConfigurationsRefs(
      Expression<bool> Function($$CvtConfigurationsTableFilterComposer f) f) {
    final $$CvtConfigurationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.cvtConfigurations,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CvtConfigurationsTableFilterComposer(
              $db: $db,
              $table: $db.cvtConfigurations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MotorcyclesTableOrderingComposer
    extends Composer<_$AppDatabase, $MotorcyclesTable> {
  $$MotorcyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get modelYear => $composableBuilder(
      column: $table.modelYear, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get plateNumber => $composableBuilder(
      column: $table.plateNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chassisNumber => $composableBuilder(
      column: $table.chassisNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get engineNumber => $composableBuilder(
      column: $table.engineNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MotorcyclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MotorcyclesTable> {
  $$MotorcyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get modelYear =>
      $composableBuilder(column: $table.modelYear, builder: (column) => column);

  GeneratedColumn<String> get plateNumber => $composableBuilder(
      column: $table.plateNumber, builder: (column) => column);

  GeneratedColumn<String> get chassisNumber => $composableBuilder(
      column: $table.chassisNumber, builder: (column) => column);

  GeneratedColumn<String> get engineNumber => $composableBuilder(
      column: $table.engineNumber, builder: (column) => column);

  GeneratedColumn<String> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> maintenanceRulesRefs<T extends Object>(
      Expression<T> Function($$MaintenanceRulesTableAnnotationComposer a) f) {
    final $$MaintenanceRulesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.maintenanceRules,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRulesTableAnnotationComposer(
              $db: $db,
              $table: $db.maintenanceRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> maintenanceRecordsRefs<T extends Object>(
      Expression<T> Function($$MaintenanceRecordsTableAnnotationComposer a) f) {
    final $$MaintenanceRecordsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.maintenanceRecords,
            getReferencedColumn: (t) => t.motorcycleId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceRecordsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceRecords,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> odometerLogsRefs<T extends Object>(
      Expression<T> Function($$OdometerLogsTableAnnotationComposer a) f) {
    final $$OdometerLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.odometerLogs,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OdometerLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.odometerLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> componentMeasurementsRefs<T extends Object>(
      Expression<T> Function($$ComponentMeasurementsTableAnnotationComposer a)
          f) {
    final $$ComponentMeasurementsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.componentMeasurements,
            getReferencedColumn: (t) => t.motorcycleId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ComponentMeasurementsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.componentMeasurements,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> partInstallationsRefs<T extends Object>(
      Expression<T> Function($$PartInstallationsTableAnnotationComposer a) f) {
    final $$PartInstallationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.partInstallations,
            getReferencedColumn: (t) => t.motorcycleId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PartInstallationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.partInstallations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> maintenanceRemindersRefs<T extends Object>(
      Expression<T> Function($$MaintenanceRemindersTableAnnotationComposer a)
          f) {
    final $$MaintenanceRemindersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.maintenanceReminders,
            getReferencedColumn: (t) => t.motorcycleId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceRemindersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceReminders,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> attachmentsRefs<T extends Object>(
      Expression<T> Function($$AttachmentsTableAnnotationComposer a) f) {
    final $$AttachmentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attachments,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttachmentsTableAnnotationComposer(
              $db: $db,
              $table: $db.attachments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> tripsRefs<T extends Object>(
      Expression<T> Function($$TripsTableAnnotationComposer a) f) {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.trips,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TripsTableAnnotationComposer(
              $db: $db,
              $table: $db.trips,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> savedRoutesRefs<T extends Object>(
      Expression<T> Function($$SavedRoutesTableAnnotationComposer a) f) {
    final $$SavedRoutesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.savedRoutes,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SavedRoutesTableAnnotationComposer(
              $db: $db,
              $table: $db.savedRoutes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> cvtConfigurationsRefs<T extends Object>(
      Expression<T> Function($$CvtConfigurationsTableAnnotationComposer a) f) {
    final $$CvtConfigurationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.cvtConfigurations,
            getReferencedColumn: (t) => t.motorcycleId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CvtConfigurationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.cvtConfigurations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$MotorcyclesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MotorcyclesTable,
    MotorcycleRow,
    $$MotorcyclesTableFilterComposer,
    $$MotorcyclesTableOrderingComposer,
    $$MotorcyclesTableAnnotationComposer,
    $$MotorcyclesTableCreateCompanionBuilder,
    $$MotorcyclesTableUpdateCompanionBuilder,
    (MotorcycleRow, $$MotorcyclesTableReferences),
    MotorcycleRow,
    PrefetchHooks Function(
        {bool maintenanceRulesRefs,
        bool maintenanceRecordsRefs,
        bool odometerLogsRefs,
        bool componentMeasurementsRefs,
        bool partInstallationsRefs,
        bool maintenanceRemindersRefs,
        bool attachmentsRefs,
        bool tripsRefs,
        bool savedRoutesRefs,
        bool cvtConfigurationsRefs})> {
  $$MotorcyclesTableTableManager(_$AppDatabase db, $MotorcyclesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MotorcyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MotorcyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MotorcyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> brand = const Value.absent(),
            Value<String> model = const Value.absent(),
            Value<int> modelYear = const Value.absent(),
            Value<String?> plateNumber = const Value.absent(),
            Value<String?> chassisNumber = const Value.absent(),
            Value<String?> engineNumber = const Value.absent(),
            Value<String?> purchaseDate = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
          }) =>
              MotorcyclesCompanion(
            id: id,
            brand: brand,
            model: model,
            modelYear: modelYear,
            plateNumber: plateNumber,
            chassisNumber: chassisNumber,
            engineNumber: engineNumber,
            purchaseDate: purchaseDate,
            photoPath: photoPath,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String brand,
            required String model,
            required int modelYear,
            Value<String?> plateNumber = const Value.absent(),
            Value<String?> chassisNumber = const Value.absent(),
            Value<String?> engineNumber = const Value.absent(),
            Value<String?> purchaseDate = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            required String createdAt,
            required String updatedAt,
          }) =>
              MotorcyclesCompanion.insert(
            id: id,
            brand: brand,
            model: model,
            modelYear: modelYear,
            plateNumber: plateNumber,
            chassisNumber: chassisNumber,
            engineNumber: engineNumber,
            purchaseDate: purchaseDate,
            photoPath: photoPath,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MotorcyclesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {maintenanceRulesRefs = false,
              maintenanceRecordsRefs = false,
              odometerLogsRefs = false,
              componentMeasurementsRefs = false,
              partInstallationsRefs = false,
              maintenanceRemindersRefs = false,
              attachmentsRefs = false,
              tripsRefs = false,
              savedRoutesRefs = false,
              cvtConfigurationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (maintenanceRulesRefs) db.maintenanceRules,
                if (maintenanceRecordsRefs) db.maintenanceRecords,
                if (odometerLogsRefs) db.odometerLogs,
                if (componentMeasurementsRefs) db.componentMeasurements,
                if (partInstallationsRefs) db.partInstallations,
                if (maintenanceRemindersRefs) db.maintenanceReminders,
                if (attachmentsRefs) db.attachments,
                if (tripsRefs) db.trips,
                if (savedRoutesRefs) db.savedRoutes,
                if (cvtConfigurationsRefs) db.cvtConfigurations
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (maintenanceRulesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MotorcyclesTableReferences
                            ._maintenanceRulesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MotorcyclesTableReferences(db, table, p0)
                                .maintenanceRulesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.motorcycleId == item.id),
                        typedResults: items),
                  if (maintenanceRecordsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MotorcyclesTableReferences
                            ._maintenanceRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MotorcyclesTableReferences(db, table, p0)
                                .maintenanceRecordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.motorcycleId == item.id),
                        typedResults: items),
                  if (odometerLogsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MotorcyclesTableReferences
                            ._odometerLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MotorcyclesTableReferences(db, table, p0)
                                .odometerLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.motorcycleId == item.id),
                        typedResults: items),
                  if (componentMeasurementsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MotorcyclesTableReferences
                            ._componentMeasurementsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MotorcyclesTableReferences(db, table, p0)
                                .componentMeasurementsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.motorcycleId == item.id),
                        typedResults: items),
                  if (partInstallationsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MotorcyclesTableReferences
                            ._partInstallationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MotorcyclesTableReferences(db, table, p0)
                                .partInstallationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.motorcycleId == item.id),
                        typedResults: items),
                  if (maintenanceRemindersRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MotorcyclesTableReferences
                            ._maintenanceRemindersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MotorcyclesTableReferences(db, table, p0)
                                .maintenanceRemindersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.motorcycleId == item.id),
                        typedResults: items),
                  if (attachmentsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MotorcyclesTableReferences
                            ._attachmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MotorcyclesTableReferences(db, table, p0)
                                .attachmentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.motorcycleId == item.id),
                        typedResults: items),
                  if (tripsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$MotorcyclesTableReferences._tripsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MotorcyclesTableReferences(db, table, p0)
                                .tripsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.motorcycleId == item.id),
                        typedResults: items),
                  if (savedRoutesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MotorcyclesTableReferences
                            ._savedRoutesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MotorcyclesTableReferences(db, table, p0)
                                .savedRoutesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.motorcycleId == item.id),
                        typedResults: items),
                  if (cvtConfigurationsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MotorcyclesTableReferences
                            ._cvtConfigurationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MotorcyclesTableReferences(db, table, p0)
                                .cvtConfigurationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.motorcycleId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MotorcyclesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MotorcyclesTable,
    MotorcycleRow,
    $$MotorcyclesTableFilterComposer,
    $$MotorcyclesTableOrderingComposer,
    $$MotorcyclesTableAnnotationComposer,
    $$MotorcyclesTableCreateCompanionBuilder,
    $$MotorcyclesTableUpdateCompanionBuilder,
    (MotorcycleRow, $$MotorcyclesTableReferences),
    MotorcycleRow,
    PrefetchHooks Function(
        {bool maintenanceRulesRefs,
        bool maintenanceRecordsRefs,
        bool odometerLogsRefs,
        bool componentMeasurementsRefs,
        bool partInstallationsRefs,
        bool maintenanceRemindersRefs,
        bool attachmentsRefs,
        bool tripsRefs,
        bool savedRoutesRefs,
        bool cvtConfigurationsRefs})>;
typedef $$MaintenanceCategoriesTableCreateCompanionBuilder
    = MaintenanceCategoriesCompanion Function({
  Value<int> id,
  required String name,
  Value<int> sortOrder,
});
typedef $$MaintenanceCategoriesTableUpdateCompanionBuilder
    = MaintenanceCategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> sortOrder,
});

final class $$MaintenanceCategoriesTableReferences extends BaseReferences<
    _$AppDatabase, $MaintenanceCategoriesTable, MaintenanceCategoryRow> {
  $$MaintenanceCategoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MaintenanceItemsTable, List<MaintenanceItemRow>>
      _maintenanceItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.maintenanceItems,
              aliasName: $_aliasNameGenerator(
                  db.maintenanceCategories.id, db.maintenanceItems.categoryId));

  $$MaintenanceItemsTableProcessedTableManager get maintenanceItemsRefs {
    final manager =
        $$MaintenanceItemsTableTableManager($_db, $_db.maintenanceItems)
            .filter((f) => f.categoryId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_maintenanceItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MaintenanceCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceCategoriesTable> {
  $$MaintenanceCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  Expression<bool> maintenanceItemsRefs(
      Expression<bool> Function($$MaintenanceItemsTableFilterComposer f) f) {
    final $$MaintenanceItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MaintenanceCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceCategoriesTable> {
  $$MaintenanceCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$MaintenanceCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceCategoriesTable> {
  $$MaintenanceCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> maintenanceItemsRefs<T extends Object>(
      Expression<T> Function($$MaintenanceItemsTableAnnotationComposer a) f) {
    final $$MaintenanceItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MaintenanceCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MaintenanceCategoriesTable,
    MaintenanceCategoryRow,
    $$MaintenanceCategoriesTableFilterComposer,
    $$MaintenanceCategoriesTableOrderingComposer,
    $$MaintenanceCategoriesTableAnnotationComposer,
    $$MaintenanceCategoriesTableCreateCompanionBuilder,
    $$MaintenanceCategoriesTableUpdateCompanionBuilder,
    (MaintenanceCategoryRow, $$MaintenanceCategoriesTableReferences),
    MaintenanceCategoryRow,
    PrefetchHooks Function({bool maintenanceItemsRefs})> {
  $$MaintenanceCategoriesTableTableManager(
      _$AppDatabase db, $MaintenanceCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceCategoriesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceCategoriesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceCategoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              MaintenanceCategoriesCompanion(
            id: id,
            name: name,
            sortOrder: sortOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int> sortOrder = const Value.absent(),
          }) =>
              MaintenanceCategoriesCompanion.insert(
            id: id,
            name: name,
            sortOrder: sortOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MaintenanceCategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({maintenanceItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (maintenanceItemsRefs) db.maintenanceItems
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (maintenanceItemsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MaintenanceCategoriesTableReferences
                            ._maintenanceItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MaintenanceCategoriesTableReferences(
                                    db, table, p0)
                                .maintenanceItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MaintenanceCategoriesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $MaintenanceCategoriesTable,
        MaintenanceCategoryRow,
        $$MaintenanceCategoriesTableFilterComposer,
        $$MaintenanceCategoriesTableOrderingComposer,
        $$MaintenanceCategoriesTableAnnotationComposer,
        $$MaintenanceCategoriesTableCreateCompanionBuilder,
        $$MaintenanceCategoriesTableUpdateCompanionBuilder,
        (MaintenanceCategoryRow, $$MaintenanceCategoriesTableReferences),
        MaintenanceCategoryRow,
        PrefetchHooks Function({bool maintenanceItemsRefs})>;
typedef $$MaintenanceItemsTableCreateCompanionBuilder
    = MaintenanceItemsCompanion Function({
  Value<int> id,
  required int categoryId,
  required String name,
  Value<String?> instructions,
  Value<int> sortOrder,
  Value<bool> isActive,
  Value<bool> isUserDefined,
});
typedef $$MaintenanceItemsTableUpdateCompanionBuilder
    = MaintenanceItemsCompanion Function({
  Value<int> id,
  Value<int> categoryId,
  Value<String> name,
  Value<String?> instructions,
  Value<int> sortOrder,
  Value<bool> isActive,
  Value<bool> isUserDefined,
});

final class $$MaintenanceItemsTableReferences extends BaseReferences<
    _$AppDatabase, $MaintenanceItemsTable, MaintenanceItemRow> {
  $$MaintenanceItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MaintenanceCategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.maintenanceCategories.createAlias($_aliasNameGenerator(
          db.maintenanceItems.categoryId, db.maintenanceCategories.id));

  $$MaintenanceCategoriesTableProcessedTableManager? get categoryId {
    if ($_item.categoryId == null) return null;
    final manager = $$MaintenanceCategoriesTableTableManager(
            $_db, $_db.maintenanceCategories)
        .filter((f) => f.id($_item.categoryId!));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$MaintenanceRulesTable, List<MaintenanceRuleRow>>
      _maintenanceRulesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.maintenanceRules,
              aliasName: $_aliasNameGenerator(
                  db.maintenanceItems.id, db.maintenanceRules.itemId));

  $$MaintenanceRulesTableProcessedTableManager get maintenanceRulesRefs {
    final manager =
        $$MaintenanceRulesTableTableManager($_db, $_db.maintenanceRules)
            .filter((f) => f.itemId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_maintenanceRulesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MaintenanceRecordsTable,
      List<MaintenanceRecordRow>> _maintenanceRecordsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.maintenanceRecords,
          aliasName: $_aliasNameGenerator(
              db.maintenanceItems.id, db.maintenanceRecords.itemId));

  $$MaintenanceRecordsTableProcessedTableManager get maintenanceRecordsRefs {
    final manager =
        $$MaintenanceRecordsTableTableManager($_db, $_db.maintenanceRecords)
            .filter((f) => f.itemId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_maintenanceRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ComponentMeasurementsTable,
      List<ComponentMeasurementRow>> _componentMeasurementsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.componentMeasurements,
          aliasName: $_aliasNameGenerator(
              db.maintenanceItems.id, db.componentMeasurements.itemId));

  $$ComponentMeasurementsTableProcessedTableManager
      get componentMeasurementsRefs {
    final manager = $$ComponentMeasurementsTableTableManager(
            $_db, $_db.componentMeasurements)
        .filter((f) => f.itemId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_componentMeasurementsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ComponentSpecsTable, List<ComponentSpecRow>>
      _componentSpecsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.componentSpecs,
              aliasName: $_aliasNameGenerator(
                  db.maintenanceItems.id, db.componentSpecs.itemId));

  $$ComponentSpecsTableProcessedTableManager get componentSpecsRefs {
    final manager = $$ComponentSpecsTableTableManager($_db, $_db.componentSpecs)
        .filter((f) => f.itemId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_componentSpecsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PartsTable, List<PartRow>> _partsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.parts,
          aliasName:
              $_aliasNameGenerator(db.maintenanceItems.id, db.parts.itemId));

  $$PartsTableProcessedTableManager get partsRefs {
    final manager = $$PartsTableTableManager($_db, $_db.parts)
        .filter((f) => f.itemId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_partsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MaintenanceRemindersTable,
      List<MaintenanceReminderRow>> _maintenanceRemindersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.maintenanceReminders,
          aliasName: $_aliasNameGenerator(
              db.maintenanceItems.id, db.maintenanceReminders.itemId));

  $$MaintenanceRemindersTableProcessedTableManager
      get maintenanceRemindersRefs {
    final manager =
        $$MaintenanceRemindersTableTableManager($_db, $_db.maintenanceReminders)
            .filter((f) => f.itemId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_maintenanceRemindersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PartsCatalogTable, List<PartsCatalogRow>>
      _partsCatalogRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.partsCatalog,
              aliasName: $_aliasNameGenerator(
                  db.maintenanceItems.id, db.partsCatalog.maintenanceItemId));

  $$PartsCatalogTableProcessedTableManager get partsCatalogRefs {
    final manager = $$PartsCatalogTableTableManager($_db, $_db.partsCatalog)
        .filter((f) => f.maintenanceItemId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_partsCatalogRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MaintenanceItemsTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceItemsTable> {
  $$MaintenanceItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isUserDefined => $composableBuilder(
      column: $table.isUserDefined, builder: (column) => ColumnFilters(column));

  $$MaintenanceCategoriesTableFilterComposer get categoryId {
    final $$MaintenanceCategoriesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.categoryId,
            referencedTable: $db.maintenanceCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceCategoriesTableFilterComposer(
                  $db: $db,
                  $table: $db.maintenanceCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  Expression<bool> maintenanceRulesRefs(
      Expression<bool> Function($$MaintenanceRulesTableFilterComposer f) f) {
    final $$MaintenanceRulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.maintenanceRules,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRulesTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> maintenanceRecordsRefs(
      Expression<bool> Function($$MaintenanceRecordsTableFilterComposer f) f) {
    final $$MaintenanceRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.maintenanceRecords,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRecordsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> componentMeasurementsRefs(
      Expression<bool> Function($$ComponentMeasurementsTableFilterComposer f)
          f) {
    final $$ComponentMeasurementsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.componentMeasurements,
            getReferencedColumn: (t) => t.itemId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ComponentMeasurementsTableFilterComposer(
                  $db: $db,
                  $table: $db.componentMeasurements,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> componentSpecsRefs(
      Expression<bool> Function($$ComponentSpecsTableFilterComposer f) f) {
    final $$ComponentSpecsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.componentSpecs,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ComponentSpecsTableFilterComposer(
              $db: $db,
              $table: $db.componentSpecs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> partsRefs(
      Expression<bool> Function($$PartsTableFilterComposer f) f) {
    final $$PartsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableFilterComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> maintenanceRemindersRefs(
      Expression<bool> Function($$MaintenanceRemindersTableFilterComposer f)
          f) {
    final $$MaintenanceRemindersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.maintenanceReminders,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRemindersTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceReminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> partsCatalogRefs(
      Expression<bool> Function($$PartsCatalogTableFilterComposer f) f) {
    final $$PartsCatalogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.partsCatalog,
        getReferencedColumn: (t) => t.maintenanceItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsCatalogTableFilterComposer(
              $db: $db,
              $table: $db.partsCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MaintenanceItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceItemsTable> {
  $$MaintenanceItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructions => $composableBuilder(
      column: $table.instructions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isUserDefined => $composableBuilder(
      column: $table.isUserDefined,
      builder: (column) => ColumnOrderings(column));

  $$MaintenanceCategoriesTableOrderingComposer get categoryId {
    final $$MaintenanceCategoriesTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.categoryId,
            referencedTable: $db.maintenanceCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceCategoriesTableOrderingComposer(
                  $db: $db,
                  $table: $db.maintenanceCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$MaintenanceItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceItemsTable> {
  $$MaintenanceItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isUserDefined => $composableBuilder(
      column: $table.isUserDefined, builder: (column) => column);

  $$MaintenanceCategoriesTableAnnotationComposer get categoryId {
    final $$MaintenanceCategoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.categoryId,
            referencedTable: $db.maintenanceCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceCategoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  Expression<T> maintenanceRulesRefs<T extends Object>(
      Expression<T> Function($$MaintenanceRulesTableAnnotationComposer a) f) {
    final $$MaintenanceRulesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.maintenanceRules,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRulesTableAnnotationComposer(
              $db: $db,
              $table: $db.maintenanceRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> maintenanceRecordsRefs<T extends Object>(
      Expression<T> Function($$MaintenanceRecordsTableAnnotationComposer a) f) {
    final $$MaintenanceRecordsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.maintenanceRecords,
            getReferencedColumn: (t) => t.itemId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceRecordsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceRecords,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> componentMeasurementsRefs<T extends Object>(
      Expression<T> Function($$ComponentMeasurementsTableAnnotationComposer a)
          f) {
    final $$ComponentMeasurementsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.componentMeasurements,
            getReferencedColumn: (t) => t.itemId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ComponentMeasurementsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.componentMeasurements,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> componentSpecsRefs<T extends Object>(
      Expression<T> Function($$ComponentSpecsTableAnnotationComposer a) f) {
    final $$ComponentSpecsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.componentSpecs,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ComponentSpecsTableAnnotationComposer(
              $db: $db,
              $table: $db.componentSpecs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> partsRefs<T extends Object>(
      Expression<T> Function($$PartsTableAnnotationComposer a) f) {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableAnnotationComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> maintenanceRemindersRefs<T extends Object>(
      Expression<T> Function($$MaintenanceRemindersTableAnnotationComposer a)
          f) {
    final $$MaintenanceRemindersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.maintenanceReminders,
            getReferencedColumn: (t) => t.itemId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceRemindersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceReminders,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> partsCatalogRefs<T extends Object>(
      Expression<T> Function($$PartsCatalogTableAnnotationComposer a) f) {
    final $$PartsCatalogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.partsCatalog,
        getReferencedColumn: (t) => t.maintenanceItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsCatalogTableAnnotationComposer(
              $db: $db,
              $table: $db.partsCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MaintenanceItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MaintenanceItemsTable,
    MaintenanceItemRow,
    $$MaintenanceItemsTableFilterComposer,
    $$MaintenanceItemsTableOrderingComposer,
    $$MaintenanceItemsTableAnnotationComposer,
    $$MaintenanceItemsTableCreateCompanionBuilder,
    $$MaintenanceItemsTableUpdateCompanionBuilder,
    (MaintenanceItemRow, $$MaintenanceItemsTableReferences),
    MaintenanceItemRow,
    PrefetchHooks Function(
        {bool categoryId,
        bool maintenanceRulesRefs,
        bool maintenanceRecordsRefs,
        bool componentMeasurementsRefs,
        bool componentSpecsRefs,
        bool partsRefs,
        bool maintenanceRemindersRefs,
        bool partsCatalogRefs})> {
  $$MaintenanceItemsTableTableManager(
      _$AppDatabase db, $MaintenanceItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> instructions = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isUserDefined = const Value.absent(),
          }) =>
              MaintenanceItemsCompanion(
            id: id,
            categoryId: categoryId,
            name: name,
            instructions: instructions,
            sortOrder: sortOrder,
            isActive: isActive,
            isUserDefined: isUserDefined,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int categoryId,
            required String name,
            Value<String?> instructions = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isUserDefined = const Value.absent(),
          }) =>
              MaintenanceItemsCompanion.insert(
            id: id,
            categoryId: categoryId,
            name: name,
            instructions: instructions,
            sortOrder: sortOrder,
            isActive: isActive,
            isUserDefined: isUserDefined,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MaintenanceItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {categoryId = false,
              maintenanceRulesRefs = false,
              maintenanceRecordsRefs = false,
              componentMeasurementsRefs = false,
              componentSpecsRefs = false,
              partsRefs = false,
              maintenanceRemindersRefs = false,
              partsCatalogRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (maintenanceRulesRefs) db.maintenanceRules,
                if (maintenanceRecordsRefs) db.maintenanceRecords,
                if (componentMeasurementsRefs) db.componentMeasurements,
                if (componentSpecsRefs) db.componentSpecs,
                if (partsRefs) db.parts,
                if (maintenanceRemindersRefs) db.maintenanceReminders,
                if (partsCatalogRefs) db.partsCatalog
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$MaintenanceItemsTableReferences._categoryIdTable(db),
                    referencedColumn: $$MaintenanceItemsTableReferences
                        ._categoryIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (maintenanceRulesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MaintenanceItemsTableReferences
                            ._maintenanceRulesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MaintenanceItemsTableReferences(db, table, p0)
                                .maintenanceRulesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.itemId == item.id),
                        typedResults: items),
                  if (maintenanceRecordsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MaintenanceItemsTableReferences
                            ._maintenanceRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MaintenanceItemsTableReferences(db, table, p0)
                                .maintenanceRecordsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.itemId == item.id),
                        typedResults: items),
                  if (componentMeasurementsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MaintenanceItemsTableReferences
                            ._componentMeasurementsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MaintenanceItemsTableReferences(db, table, p0)
                                .componentMeasurementsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.itemId == item.id),
                        typedResults: items),
                  if (componentSpecsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MaintenanceItemsTableReferences
                            ._componentSpecsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MaintenanceItemsTableReferences(db, table, p0)
                                .componentSpecsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.itemId == item.id),
                        typedResults: items),
                  if (partsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MaintenanceItemsTableReferences
                            ._partsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MaintenanceItemsTableReferences(db, table, p0)
                                .partsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.itemId == item.id),
                        typedResults: items),
                  if (maintenanceRemindersRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MaintenanceItemsTableReferences
                            ._maintenanceRemindersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MaintenanceItemsTableReferences(db, table, p0)
                                .maintenanceRemindersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.itemId == item.id),
                        typedResults: items),
                  if (partsCatalogRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MaintenanceItemsTableReferences
                            ._partsCatalogRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MaintenanceItemsTableReferences(db, table, p0)
                                .partsCatalogRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.maintenanceItemId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MaintenanceItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MaintenanceItemsTable,
    MaintenanceItemRow,
    $$MaintenanceItemsTableFilterComposer,
    $$MaintenanceItemsTableOrderingComposer,
    $$MaintenanceItemsTableAnnotationComposer,
    $$MaintenanceItemsTableCreateCompanionBuilder,
    $$MaintenanceItemsTableUpdateCompanionBuilder,
    (MaintenanceItemRow, $$MaintenanceItemsTableReferences),
    MaintenanceItemRow,
    PrefetchHooks Function(
        {bool categoryId,
        bool maintenanceRulesRefs,
        bool maintenanceRecordsRefs,
        bool componentMeasurementsRefs,
        bool componentSpecsRefs,
        bool partsRefs,
        bool maintenanceRemindersRefs,
        bool partsCatalogRefs})>;
typedef $$MaintenanceRulesTableCreateCompanionBuilder
    = MaintenanceRulesCompanion Function({
  Value<int> id,
  required int motorcycleId,
  required int itemId,
  required String ruleType,
  required String actionCode,
  required String source,
  Value<String?> sourceDocument,
  Value<int?> sourcePage,
  Value<int?> intervalKm,
  Value<int?> intervalMonths,
  Value<int?> warningKm,
  Value<int?> warningDays,
  Value<int?> lastCompletedKm,
  Value<String?> lastCompletedDate,
  Value<bool> isVerified,
  Value<bool> isActive,
  Value<String?> notes,
});
typedef $$MaintenanceRulesTableUpdateCompanionBuilder
    = MaintenanceRulesCompanion Function({
  Value<int> id,
  Value<int> motorcycleId,
  Value<int> itemId,
  Value<String> ruleType,
  Value<String> actionCode,
  Value<String> source,
  Value<String?> sourceDocument,
  Value<int?> sourcePage,
  Value<int?> intervalKm,
  Value<int?> intervalMonths,
  Value<int?> warningKm,
  Value<int?> warningDays,
  Value<int?> lastCompletedKm,
  Value<String?> lastCompletedDate,
  Value<bool> isVerified,
  Value<bool> isActive,
  Value<String?> notes,
});

final class $$MaintenanceRulesTableReferences extends BaseReferences<
    _$AppDatabase, $MaintenanceRulesTable, MaintenanceRuleRow> {
  $$MaintenanceRulesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MotorcyclesTable _motorcycleIdTable(_$AppDatabase db) =>
      db.motorcycles.createAlias($_aliasNameGenerator(
          db.maintenanceRules.motorcycleId, db.motorcycles.id));

  $$MotorcyclesTableProcessedTableManager? get motorcycleId {
    if ($_item.motorcycleId == null) return null;
    final manager = $$MotorcyclesTableTableManager($_db, $_db.motorcycles)
        .filter((f) => f.id($_item.motorcycleId!));
    final item = $_typedResult.readTableOrNull(_motorcycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MaintenanceItemsTable _itemIdTable(_$AppDatabase db) =>
      db.maintenanceItems.createAlias($_aliasNameGenerator(
          db.maintenanceRules.itemId, db.maintenanceItems.id));

  $$MaintenanceItemsTableProcessedTableManager? get itemId {
    if ($_item.itemId == null) return null;
    final manager =
        $$MaintenanceItemsTableTableManager($_db, $_db.maintenanceItems)
            .filter((f) => f.id($_item.itemId!));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$MaintenanceRuleStepsTable,
      List<MaintenanceRuleStepRow>> _maintenanceRuleStepsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.maintenanceRuleSteps,
          aliasName: $_aliasNameGenerator(
              db.maintenanceRules.id, db.maintenanceRuleSteps.ruleId));

  $$MaintenanceRuleStepsTableProcessedTableManager
      get maintenanceRuleStepsRefs {
    final manager =
        $$MaintenanceRuleStepsTableTableManager($_db, $_db.maintenanceRuleSteps)
            .filter((f) => f.ruleId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_maintenanceRuleStepsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MaintenanceRemindersTable,
      List<MaintenanceReminderRow>> _maintenanceRemindersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.maintenanceReminders,
          aliasName: $_aliasNameGenerator(
              db.maintenanceRules.id, db.maintenanceReminders.ruleId));

  $$MaintenanceRemindersTableProcessedTableManager
      get maintenanceRemindersRefs {
    final manager =
        $$MaintenanceRemindersTableTableManager($_db, $_db.maintenanceReminders)
            .filter((f) => f.ruleId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_maintenanceRemindersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MaintenanceRulesTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceRulesTable> {
  $$MaintenanceRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ruleType => $composableBuilder(
      column: $table.ruleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actionCode => $composableBuilder(
      column: $table.actionCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceDocument => $composableBuilder(
      column: $table.sourceDocument,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sourcePage => $composableBuilder(
      column: $table.sourcePage, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalKm => $composableBuilder(
      column: $table.intervalKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalMonths => $composableBuilder(
      column: $table.intervalMonths,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get warningKm => $composableBuilder(
      column: $table.warningKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get warningDays => $composableBuilder(
      column: $table.warningDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastCompletedKm => $composableBuilder(
      column: $table.lastCompletedKm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastCompletedDate => $composableBuilder(
      column: $table.lastCompletedDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isVerified => $composableBuilder(
      column: $table.isVerified, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$MotorcyclesTableFilterComposer get motorcycleId {
    final $$MotorcyclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableFilterComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceItemsTableFilterComposer get itemId {
    final $$MaintenanceItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> maintenanceRuleStepsRefs(
      Expression<bool> Function($$MaintenanceRuleStepsTableFilterComposer f)
          f) {
    final $$MaintenanceRuleStepsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.maintenanceRuleSteps,
        getReferencedColumn: (t) => t.ruleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRuleStepsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceRuleSteps,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> maintenanceRemindersRefs(
      Expression<bool> Function($$MaintenanceRemindersTableFilterComposer f)
          f) {
    final $$MaintenanceRemindersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.maintenanceReminders,
        getReferencedColumn: (t) => t.ruleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRemindersTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceReminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MaintenanceRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceRulesTable> {
  $$MaintenanceRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ruleType => $composableBuilder(
      column: $table.ruleType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actionCode => $composableBuilder(
      column: $table.actionCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceDocument => $composableBuilder(
      column: $table.sourceDocument,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sourcePage => $composableBuilder(
      column: $table.sourcePage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalKm => $composableBuilder(
      column: $table.intervalKm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalMonths => $composableBuilder(
      column: $table.intervalMonths,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get warningKm => $composableBuilder(
      column: $table.warningKm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get warningDays => $composableBuilder(
      column: $table.warningDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastCompletedKm => $composableBuilder(
      column: $table.lastCompletedKm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastCompletedDate => $composableBuilder(
      column: $table.lastCompletedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isVerified => $composableBuilder(
      column: $table.isVerified, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$MotorcyclesTableOrderingComposer get motorcycleId {
    final $$MotorcyclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableOrderingComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceItemsTableOrderingComposer get itemId {
    final $$MaintenanceItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableOrderingComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaintenanceRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceRulesTable> {
  $$MaintenanceRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ruleType =>
      $composableBuilder(column: $table.ruleType, builder: (column) => column);

  GeneratedColumn<String> get actionCode => $composableBuilder(
      column: $table.actionCode, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get sourceDocument => $composableBuilder(
      column: $table.sourceDocument, builder: (column) => column);

  GeneratedColumn<int> get sourcePage => $composableBuilder(
      column: $table.sourcePage, builder: (column) => column);

  GeneratedColumn<int> get intervalKm => $composableBuilder(
      column: $table.intervalKm, builder: (column) => column);

  GeneratedColumn<int> get intervalMonths => $composableBuilder(
      column: $table.intervalMonths, builder: (column) => column);

  GeneratedColumn<int> get warningKm =>
      $composableBuilder(column: $table.warningKm, builder: (column) => column);

  GeneratedColumn<int> get warningDays => $composableBuilder(
      column: $table.warningDays, builder: (column) => column);

  GeneratedColumn<int> get lastCompletedKm => $composableBuilder(
      column: $table.lastCompletedKm, builder: (column) => column);

  GeneratedColumn<String> get lastCompletedDate => $composableBuilder(
      column: $table.lastCompletedDate, builder: (column) => column);

  GeneratedColumn<bool> get isVerified => $composableBuilder(
      column: $table.isVerified, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$MotorcyclesTableAnnotationComposer get motorcycleId {
    final $$MotorcyclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableAnnotationComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceItemsTableAnnotationComposer get itemId {
    final $$MaintenanceItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> maintenanceRuleStepsRefs<T extends Object>(
      Expression<T> Function($$MaintenanceRuleStepsTableAnnotationComposer a)
          f) {
    final $$MaintenanceRuleStepsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.maintenanceRuleSteps,
            getReferencedColumn: (t) => t.ruleId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceRuleStepsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceRuleSteps,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> maintenanceRemindersRefs<T extends Object>(
      Expression<T> Function($$MaintenanceRemindersTableAnnotationComposer a)
          f) {
    final $$MaintenanceRemindersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.maintenanceReminders,
            getReferencedColumn: (t) => t.ruleId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceRemindersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceReminders,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$MaintenanceRulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MaintenanceRulesTable,
    MaintenanceRuleRow,
    $$MaintenanceRulesTableFilterComposer,
    $$MaintenanceRulesTableOrderingComposer,
    $$MaintenanceRulesTableAnnotationComposer,
    $$MaintenanceRulesTableCreateCompanionBuilder,
    $$MaintenanceRulesTableUpdateCompanionBuilder,
    (MaintenanceRuleRow, $$MaintenanceRulesTableReferences),
    MaintenanceRuleRow,
    PrefetchHooks Function(
        {bool motorcycleId,
        bool itemId,
        bool maintenanceRuleStepsRefs,
        bool maintenanceRemindersRefs})> {
  $$MaintenanceRulesTableTableManager(
      _$AppDatabase db, $MaintenanceRulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> motorcycleId = const Value.absent(),
            Value<int> itemId = const Value.absent(),
            Value<String> ruleType = const Value.absent(),
            Value<String> actionCode = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String?> sourceDocument = const Value.absent(),
            Value<int?> sourcePage = const Value.absent(),
            Value<int?> intervalKm = const Value.absent(),
            Value<int?> intervalMonths = const Value.absent(),
            Value<int?> warningKm = const Value.absent(),
            Value<int?> warningDays = const Value.absent(),
            Value<int?> lastCompletedKm = const Value.absent(),
            Value<String?> lastCompletedDate = const Value.absent(),
            Value<bool> isVerified = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              MaintenanceRulesCompanion(
            id: id,
            motorcycleId: motorcycleId,
            itemId: itemId,
            ruleType: ruleType,
            actionCode: actionCode,
            source: source,
            sourceDocument: sourceDocument,
            sourcePage: sourcePage,
            intervalKm: intervalKm,
            intervalMonths: intervalMonths,
            warningKm: warningKm,
            warningDays: warningDays,
            lastCompletedKm: lastCompletedKm,
            lastCompletedDate: lastCompletedDate,
            isVerified: isVerified,
            isActive: isActive,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int motorcycleId,
            required int itemId,
            required String ruleType,
            required String actionCode,
            required String source,
            Value<String?> sourceDocument = const Value.absent(),
            Value<int?> sourcePage = const Value.absent(),
            Value<int?> intervalKm = const Value.absent(),
            Value<int?> intervalMonths = const Value.absent(),
            Value<int?> warningKm = const Value.absent(),
            Value<int?> warningDays = const Value.absent(),
            Value<int?> lastCompletedKm = const Value.absent(),
            Value<String?> lastCompletedDate = const Value.absent(),
            Value<bool> isVerified = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              MaintenanceRulesCompanion.insert(
            id: id,
            motorcycleId: motorcycleId,
            itemId: itemId,
            ruleType: ruleType,
            actionCode: actionCode,
            source: source,
            sourceDocument: sourceDocument,
            sourcePage: sourcePage,
            intervalKm: intervalKm,
            intervalMonths: intervalMonths,
            warningKm: warningKm,
            warningDays: warningDays,
            lastCompletedKm: lastCompletedKm,
            lastCompletedDate: lastCompletedDate,
            isVerified: isVerified,
            isActive: isActive,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MaintenanceRulesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {motorcycleId = false,
              itemId = false,
              maintenanceRuleStepsRefs = false,
              maintenanceRemindersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (maintenanceRuleStepsRefs) db.maintenanceRuleSteps,
                if (maintenanceRemindersRefs) db.maintenanceReminders
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (motorcycleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.motorcycleId,
                    referencedTable: $$MaintenanceRulesTableReferences
                        ._motorcycleIdTable(db),
                    referencedColumn: $$MaintenanceRulesTableReferences
                        ._motorcycleIdTable(db)
                        .id,
                  ) as T;
                }
                if (itemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemId,
                    referencedTable:
                        $$MaintenanceRulesTableReferences._itemIdTable(db),
                    referencedColumn:
                        $$MaintenanceRulesTableReferences._itemIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (maintenanceRuleStepsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MaintenanceRulesTableReferences
                            ._maintenanceRuleStepsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MaintenanceRulesTableReferences(db, table, p0)
                                .maintenanceRuleStepsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.ruleId == item.id),
                        typedResults: items),
                  if (maintenanceRemindersRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MaintenanceRulesTableReferences
                            ._maintenanceRemindersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MaintenanceRulesTableReferences(db, table, p0)
                                .maintenanceRemindersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.ruleId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MaintenanceRulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MaintenanceRulesTable,
    MaintenanceRuleRow,
    $$MaintenanceRulesTableFilterComposer,
    $$MaintenanceRulesTableOrderingComposer,
    $$MaintenanceRulesTableAnnotationComposer,
    $$MaintenanceRulesTableCreateCompanionBuilder,
    $$MaintenanceRulesTableUpdateCompanionBuilder,
    (MaintenanceRuleRow, $$MaintenanceRulesTableReferences),
    MaintenanceRuleRow,
    PrefetchHooks Function(
        {bool motorcycleId,
        bool itemId,
        bool maintenanceRuleStepsRefs,
        bool maintenanceRemindersRefs})>;
typedef $$MaintenanceRuleStepsTableCreateCompanionBuilder
    = MaintenanceRuleStepsCompanion Function({
  Value<int> id,
  required int ruleId,
  required int stepOrder,
  required String actionCode,
  Value<int?> atKm,
  Value<int?> atMonths,
  Value<int?> repeatEveryKm,
  Value<int?> repeatEveryMonths,
  Value<String?> notes,
});
typedef $$MaintenanceRuleStepsTableUpdateCompanionBuilder
    = MaintenanceRuleStepsCompanion Function({
  Value<int> id,
  Value<int> ruleId,
  Value<int> stepOrder,
  Value<String> actionCode,
  Value<int?> atKm,
  Value<int?> atMonths,
  Value<int?> repeatEveryKm,
  Value<int?> repeatEveryMonths,
  Value<String?> notes,
});

final class $$MaintenanceRuleStepsTableReferences extends BaseReferences<
    _$AppDatabase, $MaintenanceRuleStepsTable, MaintenanceRuleStepRow> {
  $$MaintenanceRuleStepsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MaintenanceRulesTable _ruleIdTable(_$AppDatabase db) =>
      db.maintenanceRules.createAlias($_aliasNameGenerator(
          db.maintenanceRuleSteps.ruleId, db.maintenanceRules.id));

  $$MaintenanceRulesTableProcessedTableManager? get ruleId {
    if ($_item.ruleId == null) return null;
    final manager =
        $$MaintenanceRulesTableTableManager($_db, $_db.maintenanceRules)
            .filter((f) => f.id($_item.ruleId!));
    final item = $_typedResult.readTableOrNull(_ruleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MaintenanceRuleStepsTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceRuleStepsTable> {
  $$MaintenanceRuleStepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stepOrder => $composableBuilder(
      column: $table.stepOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actionCode => $composableBuilder(
      column: $table.actionCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get atKm => $composableBuilder(
      column: $table.atKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get atMonths => $composableBuilder(
      column: $table.atMonths, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get repeatEveryKm => $composableBuilder(
      column: $table.repeatEveryKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get repeatEveryMonths => $composableBuilder(
      column: $table.repeatEveryMonths,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$MaintenanceRulesTableFilterComposer get ruleId {
    final $$MaintenanceRulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ruleId,
        referencedTable: $db.maintenanceRules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRulesTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaintenanceRuleStepsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceRuleStepsTable> {
  $$MaintenanceRuleStepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stepOrder => $composableBuilder(
      column: $table.stepOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actionCode => $composableBuilder(
      column: $table.actionCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get atKm => $composableBuilder(
      column: $table.atKm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get atMonths => $composableBuilder(
      column: $table.atMonths, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get repeatEveryKm => $composableBuilder(
      column: $table.repeatEveryKm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get repeatEveryMonths => $composableBuilder(
      column: $table.repeatEveryMonths,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$MaintenanceRulesTableOrderingComposer get ruleId {
    final $$MaintenanceRulesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ruleId,
        referencedTable: $db.maintenanceRules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRulesTableOrderingComposer(
              $db: $db,
              $table: $db.maintenanceRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaintenanceRuleStepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceRuleStepsTable> {
  $$MaintenanceRuleStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get stepOrder =>
      $composableBuilder(column: $table.stepOrder, builder: (column) => column);

  GeneratedColumn<String> get actionCode => $composableBuilder(
      column: $table.actionCode, builder: (column) => column);

  GeneratedColumn<int> get atKm =>
      $composableBuilder(column: $table.atKm, builder: (column) => column);

  GeneratedColumn<int> get atMonths =>
      $composableBuilder(column: $table.atMonths, builder: (column) => column);

  GeneratedColumn<int> get repeatEveryKm => $composableBuilder(
      column: $table.repeatEveryKm, builder: (column) => column);

  GeneratedColumn<int> get repeatEveryMonths => $composableBuilder(
      column: $table.repeatEveryMonths, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$MaintenanceRulesTableAnnotationComposer get ruleId {
    final $$MaintenanceRulesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ruleId,
        referencedTable: $db.maintenanceRules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRulesTableAnnotationComposer(
              $db: $db,
              $table: $db.maintenanceRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaintenanceRuleStepsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MaintenanceRuleStepsTable,
    MaintenanceRuleStepRow,
    $$MaintenanceRuleStepsTableFilterComposer,
    $$MaintenanceRuleStepsTableOrderingComposer,
    $$MaintenanceRuleStepsTableAnnotationComposer,
    $$MaintenanceRuleStepsTableCreateCompanionBuilder,
    $$MaintenanceRuleStepsTableUpdateCompanionBuilder,
    (MaintenanceRuleStepRow, $$MaintenanceRuleStepsTableReferences),
    MaintenanceRuleStepRow,
    PrefetchHooks Function({bool ruleId})> {
  $$MaintenanceRuleStepsTableTableManager(
      _$AppDatabase db, $MaintenanceRuleStepsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceRuleStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceRuleStepsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceRuleStepsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> ruleId = const Value.absent(),
            Value<int> stepOrder = const Value.absent(),
            Value<String> actionCode = const Value.absent(),
            Value<int?> atKm = const Value.absent(),
            Value<int?> atMonths = const Value.absent(),
            Value<int?> repeatEveryKm = const Value.absent(),
            Value<int?> repeatEveryMonths = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              MaintenanceRuleStepsCompanion(
            id: id,
            ruleId: ruleId,
            stepOrder: stepOrder,
            actionCode: actionCode,
            atKm: atKm,
            atMonths: atMonths,
            repeatEveryKm: repeatEveryKm,
            repeatEveryMonths: repeatEveryMonths,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int ruleId,
            required int stepOrder,
            required String actionCode,
            Value<int?> atKm = const Value.absent(),
            Value<int?> atMonths = const Value.absent(),
            Value<int?> repeatEveryKm = const Value.absent(),
            Value<int?> repeatEveryMonths = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              MaintenanceRuleStepsCompanion.insert(
            id: id,
            ruleId: ruleId,
            stepOrder: stepOrder,
            actionCode: actionCode,
            atKm: atKm,
            atMonths: atMonths,
            repeatEveryKm: repeatEveryKm,
            repeatEveryMonths: repeatEveryMonths,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MaintenanceRuleStepsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({ruleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (ruleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ruleId,
                    referencedTable:
                        $$MaintenanceRuleStepsTableReferences._ruleIdTable(db),
                    referencedColumn: $$MaintenanceRuleStepsTableReferences
                        ._ruleIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MaintenanceRuleStepsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $MaintenanceRuleStepsTable,
        MaintenanceRuleStepRow,
        $$MaintenanceRuleStepsTableFilterComposer,
        $$MaintenanceRuleStepsTableOrderingComposer,
        $$MaintenanceRuleStepsTableAnnotationComposer,
        $$MaintenanceRuleStepsTableCreateCompanionBuilder,
        $$MaintenanceRuleStepsTableUpdateCompanionBuilder,
        (MaintenanceRuleStepRow, $$MaintenanceRuleStepsTableReferences),
        MaintenanceRuleStepRow,
        PrefetchHooks Function({bool ruleId})>;
typedef $$MaintenanceRecordsTableCreateCompanionBuilder
    = MaintenanceRecordsCompanion Function({
  Value<int> id,
  required int motorcycleId,
  required int itemId,
  required String action,
  required String performedDate,
  required int odometerKm,
  Value<int> laborCostCentavos,
  Value<int> totalCostCentavos,
  Value<String?> serviceProvider,
  Value<String?> notes,
  Value<String?> voidedAt,
  Value<int?> supersedesRecordId,
  required String createdAt,
});
typedef $$MaintenanceRecordsTableUpdateCompanionBuilder
    = MaintenanceRecordsCompanion Function({
  Value<int> id,
  Value<int> motorcycleId,
  Value<int> itemId,
  Value<String> action,
  Value<String> performedDate,
  Value<int> odometerKm,
  Value<int> laborCostCentavos,
  Value<int> totalCostCentavos,
  Value<String?> serviceProvider,
  Value<String?> notes,
  Value<String?> voidedAt,
  Value<int?> supersedesRecordId,
  Value<String> createdAt,
});

final class $$MaintenanceRecordsTableReferences extends BaseReferences<
    _$AppDatabase, $MaintenanceRecordsTable, MaintenanceRecordRow> {
  $$MaintenanceRecordsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MotorcyclesTable _motorcycleIdTable(_$AppDatabase db) =>
      db.motorcycles.createAlias($_aliasNameGenerator(
          db.maintenanceRecords.motorcycleId, db.motorcycles.id));

  $$MotorcyclesTableProcessedTableManager? get motorcycleId {
    if ($_item.motorcycleId == null) return null;
    final manager = $$MotorcyclesTableTableManager($_db, $_db.motorcycles)
        .filter((f) => f.id($_item.motorcycleId!));
    final item = $_typedResult.readTableOrNull(_motorcycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MaintenanceItemsTable _itemIdTable(_$AppDatabase db) =>
      db.maintenanceItems.createAlias($_aliasNameGenerator(
          db.maintenanceRecords.itemId, db.maintenanceItems.id));

  $$MaintenanceItemsTableProcessedTableManager? get itemId {
    if ($_item.itemId == null) return null;
    final manager =
        $$MaintenanceItemsTableTableManager($_db, $_db.maintenanceItems)
            .filter((f) => f.id($_item.itemId!));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MaintenanceRecordsTable _supersedesRecordIdTable(_$AppDatabase db) =>
      db.maintenanceRecords.createAlias($_aliasNameGenerator(
          db.maintenanceRecords.supersedesRecordId, db.maintenanceRecords.id));

  $$MaintenanceRecordsTableProcessedTableManager? get supersedesRecordId {
    if ($_item.supersedesRecordId == null) return null;
    final manager =
        $$MaintenanceRecordsTableTableManager($_db, $_db.maintenanceRecords)
            .filter((f) => f.id($_item.supersedesRecordId!));
    final item = $_typedResult.readTableOrNull(_supersedesRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ComponentMeasurementsTable,
      List<ComponentMeasurementRow>> _componentMeasurementsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.componentMeasurements,
          aliasName: $_aliasNameGenerator(
              db.maintenanceRecords.id, db.componentMeasurements.recordId));

  $$ComponentMeasurementsTableProcessedTableManager
      get componentMeasurementsRefs {
    final manager = $$ComponentMeasurementsTableTableManager(
            $_db, $_db.componentMeasurements)
        .filter((f) => f.recordId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_componentMeasurementsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MaintenanceRecordPartsTable,
      List<MaintenanceRecordPartRow>> _maintenanceRecordPartsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.maintenanceRecordParts,
          aliasName: $_aliasNameGenerator(
              db.maintenanceRecords.id, db.maintenanceRecordParts.recordId));

  $$MaintenanceRecordPartsTableProcessedTableManager
      get maintenanceRecordPartsRefs {
    final manager = $$MaintenanceRecordPartsTableTableManager(
            $_db, $_db.maintenanceRecordParts)
        .filter((f) => f.recordId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_maintenanceRecordPartsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PartInstallationsTable, List<PartInstallationRow>>
      _partInstallationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.partInstallations,
              aliasName: $_aliasNameGenerator(
                  db.maintenanceRecords.id, db.partInstallations.recordId));

  $$PartInstallationsTableProcessedTableManager get partInstallationsRefs {
    final manager =
        $$PartInstallationsTableTableManager($_db, $_db.partInstallations)
            .filter((f) => f.recordId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_partInstallationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AttachmentsTable, List<AttachmentRow>>
      _attachmentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.attachments,
              aliasName: $_aliasNameGenerator(
                  db.maintenanceRecords.id, db.attachments.recordId));

  $$AttachmentsTableProcessedTableManager get attachmentsRefs {
    final manager = $$AttachmentsTableTableManager($_db, $_db.attachments)
        .filter((f) => f.recordId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_attachmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MaintenanceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceRecordsTable> {
  $$MaintenanceRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get performedDate => $composableBuilder(
      column: $table.performedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get odometerKm => $composableBuilder(
      column: $table.odometerKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get laborCostCentavos => $composableBuilder(
      column: $table.laborCostCentavos,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalCostCentavos => $composableBuilder(
      column: $table.totalCostCentavos,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serviceProvider => $composableBuilder(
      column: $table.serviceProvider,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get voidedAt => $composableBuilder(
      column: $table.voidedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$MotorcyclesTableFilterComposer get motorcycleId {
    final $$MotorcyclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableFilterComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceItemsTableFilterComposer get itemId {
    final $$MaintenanceItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceRecordsTableFilterComposer get supersedesRecordId {
    final $$MaintenanceRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supersedesRecordId,
        referencedTable: $db.maintenanceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRecordsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> componentMeasurementsRefs(
      Expression<bool> Function($$ComponentMeasurementsTableFilterComposer f)
          f) {
    final $$ComponentMeasurementsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.componentMeasurements,
            getReferencedColumn: (t) => t.recordId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ComponentMeasurementsTableFilterComposer(
                  $db: $db,
                  $table: $db.componentMeasurements,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> maintenanceRecordPartsRefs(
      Expression<bool> Function($$MaintenanceRecordPartsTableFilterComposer f)
          f) {
    final $$MaintenanceRecordPartsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.maintenanceRecordParts,
            getReferencedColumn: (t) => t.recordId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceRecordPartsTableFilterComposer(
                  $db: $db,
                  $table: $db.maintenanceRecordParts,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> partInstallationsRefs(
      Expression<bool> Function($$PartInstallationsTableFilterComposer f) f) {
    final $$PartInstallationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.partInstallations,
        getReferencedColumn: (t) => t.recordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartInstallationsTableFilterComposer(
              $db: $db,
              $table: $db.partInstallations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> attachmentsRefs(
      Expression<bool> Function($$AttachmentsTableFilterComposer f) f) {
    final $$AttachmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attachments,
        getReferencedColumn: (t) => t.recordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttachmentsTableFilterComposer(
              $db: $db,
              $table: $db.attachments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MaintenanceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceRecordsTable> {
  $$MaintenanceRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get performedDate => $composableBuilder(
      column: $table.performedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get odometerKm => $composableBuilder(
      column: $table.odometerKm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get laborCostCentavos => $composableBuilder(
      column: $table.laborCostCentavos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalCostCentavos => $composableBuilder(
      column: $table.totalCostCentavos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serviceProvider => $composableBuilder(
      column: $table.serviceProvider,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get voidedAt => $composableBuilder(
      column: $table.voidedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$MotorcyclesTableOrderingComposer get motorcycleId {
    final $$MotorcyclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableOrderingComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceItemsTableOrderingComposer get itemId {
    final $$MaintenanceItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableOrderingComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceRecordsTableOrderingComposer get supersedesRecordId {
    final $$MaintenanceRecordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supersedesRecordId,
        referencedTable: $db.maintenanceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRecordsTableOrderingComposer(
              $db: $db,
              $table: $db.maintenanceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaintenanceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceRecordsTable> {
  $$MaintenanceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get performedDate => $composableBuilder(
      column: $table.performedDate, builder: (column) => column);

  GeneratedColumn<int> get odometerKm => $composableBuilder(
      column: $table.odometerKm, builder: (column) => column);

  GeneratedColumn<int> get laborCostCentavos => $composableBuilder(
      column: $table.laborCostCentavos, builder: (column) => column);

  GeneratedColumn<int> get totalCostCentavos => $composableBuilder(
      column: $table.totalCostCentavos, builder: (column) => column);

  GeneratedColumn<String> get serviceProvider => $composableBuilder(
      column: $table.serviceProvider, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get voidedAt =>
      $composableBuilder(column: $table.voidedAt, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MotorcyclesTableAnnotationComposer get motorcycleId {
    final $$MotorcyclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableAnnotationComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceItemsTableAnnotationComposer get itemId {
    final $$MaintenanceItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceRecordsTableAnnotationComposer get supersedesRecordId {
    final $$MaintenanceRecordsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.supersedesRecordId,
            referencedTable: $db.maintenanceRecords,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceRecordsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceRecords,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  Expression<T> componentMeasurementsRefs<T extends Object>(
      Expression<T> Function($$ComponentMeasurementsTableAnnotationComposer a)
          f) {
    final $$ComponentMeasurementsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.componentMeasurements,
            getReferencedColumn: (t) => t.recordId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ComponentMeasurementsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.componentMeasurements,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> maintenanceRecordPartsRefs<T extends Object>(
      Expression<T> Function($$MaintenanceRecordPartsTableAnnotationComposer a)
          f) {
    final $$MaintenanceRecordPartsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.maintenanceRecordParts,
            getReferencedColumn: (t) => t.recordId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceRecordPartsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceRecordParts,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> partInstallationsRefs<T extends Object>(
      Expression<T> Function($$PartInstallationsTableAnnotationComposer a) f) {
    final $$PartInstallationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.partInstallations,
            getReferencedColumn: (t) => t.recordId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PartInstallationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.partInstallations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> attachmentsRefs<T extends Object>(
      Expression<T> Function($$AttachmentsTableAnnotationComposer a) f) {
    final $$AttachmentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attachments,
        getReferencedColumn: (t) => t.recordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttachmentsTableAnnotationComposer(
              $db: $db,
              $table: $db.attachments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MaintenanceRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MaintenanceRecordsTable,
    MaintenanceRecordRow,
    $$MaintenanceRecordsTableFilterComposer,
    $$MaintenanceRecordsTableOrderingComposer,
    $$MaintenanceRecordsTableAnnotationComposer,
    $$MaintenanceRecordsTableCreateCompanionBuilder,
    $$MaintenanceRecordsTableUpdateCompanionBuilder,
    (MaintenanceRecordRow, $$MaintenanceRecordsTableReferences),
    MaintenanceRecordRow,
    PrefetchHooks Function(
        {bool motorcycleId,
        bool itemId,
        bool supersedesRecordId,
        bool componentMeasurementsRefs,
        bool maintenanceRecordPartsRefs,
        bool partInstallationsRefs,
        bool attachmentsRefs})> {
  $$MaintenanceRecordsTableTableManager(
      _$AppDatabase db, $MaintenanceRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceRecordsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> motorcycleId = const Value.absent(),
            Value<int> itemId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String> performedDate = const Value.absent(),
            Value<int> odometerKm = const Value.absent(),
            Value<int> laborCostCentavos = const Value.absent(),
            Value<int> totalCostCentavos = const Value.absent(),
            Value<String?> serviceProvider = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> voidedAt = const Value.absent(),
            Value<int?> supersedesRecordId = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
          }) =>
              MaintenanceRecordsCompanion(
            id: id,
            motorcycleId: motorcycleId,
            itemId: itemId,
            action: action,
            performedDate: performedDate,
            odometerKm: odometerKm,
            laborCostCentavos: laborCostCentavos,
            totalCostCentavos: totalCostCentavos,
            serviceProvider: serviceProvider,
            notes: notes,
            voidedAt: voidedAt,
            supersedesRecordId: supersedesRecordId,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int motorcycleId,
            required int itemId,
            required String action,
            required String performedDate,
            required int odometerKm,
            Value<int> laborCostCentavos = const Value.absent(),
            Value<int> totalCostCentavos = const Value.absent(),
            Value<String?> serviceProvider = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> voidedAt = const Value.absent(),
            Value<int?> supersedesRecordId = const Value.absent(),
            required String createdAt,
          }) =>
              MaintenanceRecordsCompanion.insert(
            id: id,
            motorcycleId: motorcycleId,
            itemId: itemId,
            action: action,
            performedDate: performedDate,
            odometerKm: odometerKm,
            laborCostCentavos: laborCostCentavos,
            totalCostCentavos: totalCostCentavos,
            serviceProvider: serviceProvider,
            notes: notes,
            voidedAt: voidedAt,
            supersedesRecordId: supersedesRecordId,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MaintenanceRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {motorcycleId = false,
              itemId = false,
              supersedesRecordId = false,
              componentMeasurementsRefs = false,
              maintenanceRecordPartsRefs = false,
              partInstallationsRefs = false,
              attachmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (componentMeasurementsRefs) db.componentMeasurements,
                if (maintenanceRecordPartsRefs) db.maintenanceRecordParts,
                if (partInstallationsRefs) db.partInstallations,
                if (attachmentsRefs) db.attachments
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (motorcycleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.motorcycleId,
                    referencedTable: $$MaintenanceRecordsTableReferences
                        ._motorcycleIdTable(db),
                    referencedColumn: $$MaintenanceRecordsTableReferences
                        ._motorcycleIdTable(db)
                        .id,
                  ) as T;
                }
                if (itemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemId,
                    referencedTable:
                        $$MaintenanceRecordsTableReferences._itemIdTable(db),
                    referencedColumn:
                        $$MaintenanceRecordsTableReferences._itemIdTable(db).id,
                  ) as T;
                }
                if (supersedesRecordId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.supersedesRecordId,
                    referencedTable: $$MaintenanceRecordsTableReferences
                        ._supersedesRecordIdTable(db),
                    referencedColumn: $$MaintenanceRecordsTableReferences
                        ._supersedesRecordIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (componentMeasurementsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MaintenanceRecordsTableReferences
                            ._componentMeasurementsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MaintenanceRecordsTableReferences(db, table, p0)
                                .componentMeasurementsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.recordId == item.id),
                        typedResults: items),
                  if (maintenanceRecordPartsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MaintenanceRecordsTableReferences
                            ._maintenanceRecordPartsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MaintenanceRecordsTableReferences(db, table, p0)
                                .maintenanceRecordPartsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.recordId == item.id),
                        typedResults: items),
                  if (partInstallationsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MaintenanceRecordsTableReferences
                            ._partInstallationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MaintenanceRecordsTableReferences(db, table, p0)
                                .partInstallationsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.recordId == item.id),
                        typedResults: items),
                  if (attachmentsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$MaintenanceRecordsTableReferences
                            ._attachmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MaintenanceRecordsTableReferences(db, table, p0)
                                .attachmentsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.recordId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MaintenanceRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MaintenanceRecordsTable,
    MaintenanceRecordRow,
    $$MaintenanceRecordsTableFilterComposer,
    $$MaintenanceRecordsTableOrderingComposer,
    $$MaintenanceRecordsTableAnnotationComposer,
    $$MaintenanceRecordsTableCreateCompanionBuilder,
    $$MaintenanceRecordsTableUpdateCompanionBuilder,
    (MaintenanceRecordRow, $$MaintenanceRecordsTableReferences),
    MaintenanceRecordRow,
    PrefetchHooks Function(
        {bool motorcycleId,
        bool itemId,
        bool supersedesRecordId,
        bool componentMeasurementsRefs,
        bool maintenanceRecordPartsRefs,
        bool partInstallationsRefs,
        bool attachmentsRefs})>;
typedef $$OdometerLogsTableCreateCompanionBuilder = OdometerLogsCompanion
    Function({
  Value<int> id,
  required int motorcycleId,
  required int readingKm,
  required String recordedDate,
  Value<String?> notes,
  Value<String> status,
  Value<int?> supersedesLogId,
  Value<String?> correctionReason,
  required String createdAt,
});
typedef $$OdometerLogsTableUpdateCompanionBuilder = OdometerLogsCompanion
    Function({
  Value<int> id,
  Value<int> motorcycleId,
  Value<int> readingKm,
  Value<String> recordedDate,
  Value<String?> notes,
  Value<String> status,
  Value<int?> supersedesLogId,
  Value<String?> correctionReason,
  Value<String> createdAt,
});

final class $$OdometerLogsTableReferences
    extends BaseReferences<_$AppDatabase, $OdometerLogsTable, OdometerLogRow> {
  $$OdometerLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MotorcyclesTable _motorcycleIdTable(_$AppDatabase db) =>
      db.motorcycles.createAlias($_aliasNameGenerator(
          db.odometerLogs.motorcycleId, db.motorcycles.id));

  $$MotorcyclesTableProcessedTableManager? get motorcycleId {
    if ($_item.motorcycleId == null) return null;
    final manager = $$MotorcyclesTableTableManager($_db, $_db.motorcycles)
        .filter((f) => f.id($_item.motorcycleId!));
    final item = $_typedResult.readTableOrNull(_motorcycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $OdometerLogsTable _supersedesLogIdTable(_$AppDatabase db) =>
      db.odometerLogs.createAlias($_aliasNameGenerator(
          db.odometerLogs.supersedesLogId, db.odometerLogs.id));

  $$OdometerLogsTableProcessedTableManager? get supersedesLogId {
    if ($_item.supersedesLogId == null) return null;
    final manager = $$OdometerLogsTableTableManager($_db, $_db.odometerLogs)
        .filter((f) => f.id($_item.supersedesLogId!));
    final item = $_typedResult.readTableOrNull(_supersedesLogIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OdometerLogsTableFilterComposer
    extends Composer<_$AppDatabase, $OdometerLogsTable> {
  $$OdometerLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get readingKm => $composableBuilder(
      column: $table.readingKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordedDate => $composableBuilder(
      column: $table.recordedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get correctionReason => $composableBuilder(
      column: $table.correctionReason,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$MotorcyclesTableFilterComposer get motorcycleId {
    final $$MotorcyclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableFilterComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$OdometerLogsTableFilterComposer get supersedesLogId {
    final $$OdometerLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supersedesLogId,
        referencedTable: $db.odometerLogs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OdometerLogsTableFilterComposer(
              $db: $db,
              $table: $db.odometerLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OdometerLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $OdometerLogsTable> {
  $$OdometerLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get readingKm => $composableBuilder(
      column: $table.readingKm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordedDate => $composableBuilder(
      column: $table.recordedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get correctionReason => $composableBuilder(
      column: $table.correctionReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$MotorcyclesTableOrderingComposer get motorcycleId {
    final $$MotorcyclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableOrderingComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$OdometerLogsTableOrderingComposer get supersedesLogId {
    final $$OdometerLogsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supersedesLogId,
        referencedTable: $db.odometerLogs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OdometerLogsTableOrderingComposer(
              $db: $db,
              $table: $db.odometerLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OdometerLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OdometerLogsTable> {
  $$OdometerLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get readingKm =>
      $composableBuilder(column: $table.readingKm, builder: (column) => column);

  GeneratedColumn<String> get recordedDate => $composableBuilder(
      column: $table.recordedDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get correctionReason => $composableBuilder(
      column: $table.correctionReason, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MotorcyclesTableAnnotationComposer get motorcycleId {
    final $$MotorcyclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableAnnotationComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$OdometerLogsTableAnnotationComposer get supersedesLogId {
    final $$OdometerLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supersedesLogId,
        referencedTable: $db.odometerLogs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OdometerLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.odometerLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OdometerLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OdometerLogsTable,
    OdometerLogRow,
    $$OdometerLogsTableFilterComposer,
    $$OdometerLogsTableOrderingComposer,
    $$OdometerLogsTableAnnotationComposer,
    $$OdometerLogsTableCreateCompanionBuilder,
    $$OdometerLogsTableUpdateCompanionBuilder,
    (OdometerLogRow, $$OdometerLogsTableReferences),
    OdometerLogRow,
    PrefetchHooks Function({bool motorcycleId, bool supersedesLogId})> {
  $$OdometerLogsTableTableManager(_$AppDatabase db, $OdometerLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OdometerLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OdometerLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OdometerLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> motorcycleId = const Value.absent(),
            Value<int> readingKm = const Value.absent(),
            Value<String> recordedDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> supersedesLogId = const Value.absent(),
            Value<String?> correctionReason = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
          }) =>
              OdometerLogsCompanion(
            id: id,
            motorcycleId: motorcycleId,
            readingKm: readingKm,
            recordedDate: recordedDate,
            notes: notes,
            status: status,
            supersedesLogId: supersedesLogId,
            correctionReason: correctionReason,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int motorcycleId,
            required int readingKm,
            required String recordedDate,
            Value<String?> notes = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> supersedesLogId = const Value.absent(),
            Value<String?> correctionReason = const Value.absent(),
            required String createdAt,
          }) =>
              OdometerLogsCompanion.insert(
            id: id,
            motorcycleId: motorcycleId,
            readingKm: readingKm,
            recordedDate: recordedDate,
            notes: notes,
            status: status,
            supersedesLogId: supersedesLogId,
            correctionReason: correctionReason,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OdometerLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {motorcycleId = false, supersedesLogId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (motorcycleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.motorcycleId,
                    referencedTable:
                        $$OdometerLogsTableReferences._motorcycleIdTable(db),
                    referencedColumn:
                        $$OdometerLogsTableReferences._motorcycleIdTable(db).id,
                  ) as T;
                }
                if (supersedesLogId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.supersedesLogId,
                    referencedTable:
                        $$OdometerLogsTableReferences._supersedesLogIdTable(db),
                    referencedColumn: $$OdometerLogsTableReferences
                        ._supersedesLogIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$OdometerLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OdometerLogsTable,
    OdometerLogRow,
    $$OdometerLogsTableFilterComposer,
    $$OdometerLogsTableOrderingComposer,
    $$OdometerLogsTableAnnotationComposer,
    $$OdometerLogsTableCreateCompanionBuilder,
    $$OdometerLogsTableUpdateCompanionBuilder,
    (OdometerLogRow, $$OdometerLogsTableReferences),
    OdometerLogRow,
    PrefetchHooks Function({bool motorcycleId, bool supersedesLogId})>;
typedef $$ComponentMeasurementsTableCreateCompanionBuilder
    = ComponentMeasurementsCompanion Function({
  Value<int> id,
  required int motorcycleId,
  required int itemId,
  Value<int?> recordId,
  required String measuredDate,
  Value<int?> odometerKm,
  required String measurementType,
  Value<double?> value,
  required String unit,
  Value<String?> position,
  Value<String?> measurementContext,
  Value<String?> brand,
  Value<String?> partNumber,
  Value<String?> visualCondition,
  Value<bool> hasDamage,
  Value<String?> notes,
  Value<String?> voidedAt,
  required String createdAt,
});
typedef $$ComponentMeasurementsTableUpdateCompanionBuilder
    = ComponentMeasurementsCompanion Function({
  Value<int> id,
  Value<int> motorcycleId,
  Value<int> itemId,
  Value<int?> recordId,
  Value<String> measuredDate,
  Value<int?> odometerKm,
  Value<String> measurementType,
  Value<double?> value,
  Value<String> unit,
  Value<String?> position,
  Value<String?> measurementContext,
  Value<String?> brand,
  Value<String?> partNumber,
  Value<String?> visualCondition,
  Value<bool> hasDamage,
  Value<String?> notes,
  Value<String?> voidedAt,
  Value<String> createdAt,
});

final class $$ComponentMeasurementsTableReferences extends BaseReferences<
    _$AppDatabase, $ComponentMeasurementsTable, ComponentMeasurementRow> {
  $$ComponentMeasurementsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MotorcyclesTable _motorcycleIdTable(_$AppDatabase db) =>
      db.motorcycles.createAlias($_aliasNameGenerator(
          db.componentMeasurements.motorcycleId, db.motorcycles.id));

  $$MotorcyclesTableProcessedTableManager? get motorcycleId {
    if ($_item.motorcycleId == null) return null;
    final manager = $$MotorcyclesTableTableManager($_db, $_db.motorcycles)
        .filter((f) => f.id($_item.motorcycleId!));
    final item = $_typedResult.readTableOrNull(_motorcycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MaintenanceItemsTable _itemIdTable(_$AppDatabase db) =>
      db.maintenanceItems.createAlias($_aliasNameGenerator(
          db.componentMeasurements.itemId, db.maintenanceItems.id));

  $$MaintenanceItemsTableProcessedTableManager? get itemId {
    if ($_item.itemId == null) return null;
    final manager =
        $$MaintenanceItemsTableTableManager($_db, $_db.maintenanceItems)
            .filter((f) => f.id($_item.itemId!));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MaintenanceRecordsTable _recordIdTable(_$AppDatabase db) =>
      db.maintenanceRecords.createAlias($_aliasNameGenerator(
          db.componentMeasurements.recordId, db.maintenanceRecords.id));

  $$MaintenanceRecordsTableProcessedTableManager? get recordId {
    if ($_item.recordId == null) return null;
    final manager =
        $$MaintenanceRecordsTableTableManager($_db, $_db.maintenanceRecords)
            .filter((f) => f.id($_item.recordId!));
    final item = $_typedResult.readTableOrNull(_recordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$AttachmentsTable, List<AttachmentRow>>
      _attachmentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.attachments,
              aliasName: $_aliasNameGenerator(
                  db.componentMeasurements.id, db.attachments.measurementId));

  $$AttachmentsTableProcessedTableManager get attachmentsRefs {
    final manager = $$AttachmentsTableTableManager($_db, $_db.attachments)
        .filter((f) => f.measurementId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_attachmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ComponentMeasurementsTableFilterComposer
    extends Composer<_$AppDatabase, $ComponentMeasurementsTable> {
  $$ComponentMeasurementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get measuredDate => $composableBuilder(
      column: $table.measuredDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get odometerKm => $composableBuilder(
      column: $table.odometerKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get measurementType => $composableBuilder(
      column: $table.measurementType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get measurementContext => $composableBuilder(
      column: $table.measurementContext,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get partNumber => $composableBuilder(
      column: $table.partNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get visualCondition => $composableBuilder(
      column: $table.visualCondition,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasDamage => $composableBuilder(
      column: $table.hasDamage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get voidedAt => $composableBuilder(
      column: $table.voidedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$MotorcyclesTableFilterComposer get motorcycleId {
    final $$MotorcyclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableFilterComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceItemsTableFilterComposer get itemId {
    final $$MaintenanceItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceRecordsTableFilterComposer get recordId {
    final $$MaintenanceRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordId,
        referencedTable: $db.maintenanceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRecordsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> attachmentsRefs(
      Expression<bool> Function($$AttachmentsTableFilterComposer f) f) {
    final $$AttachmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attachments,
        getReferencedColumn: (t) => t.measurementId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttachmentsTableFilterComposer(
              $db: $db,
              $table: $db.attachments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ComponentMeasurementsTableOrderingComposer
    extends Composer<_$AppDatabase, $ComponentMeasurementsTable> {
  $$ComponentMeasurementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get measuredDate => $composableBuilder(
      column: $table.measuredDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get odometerKm => $composableBuilder(
      column: $table.odometerKm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get measurementType => $composableBuilder(
      column: $table.measurementType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get measurementContext => $composableBuilder(
      column: $table.measurementContext,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get partNumber => $composableBuilder(
      column: $table.partNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get visualCondition => $composableBuilder(
      column: $table.visualCondition,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasDamage => $composableBuilder(
      column: $table.hasDamage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get voidedAt => $composableBuilder(
      column: $table.voidedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$MotorcyclesTableOrderingComposer get motorcycleId {
    final $$MotorcyclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableOrderingComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceItemsTableOrderingComposer get itemId {
    final $$MaintenanceItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableOrderingComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceRecordsTableOrderingComposer get recordId {
    final $$MaintenanceRecordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordId,
        referencedTable: $db.maintenanceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRecordsTableOrderingComposer(
              $db: $db,
              $table: $db.maintenanceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ComponentMeasurementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComponentMeasurementsTable> {
  $$ComponentMeasurementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get measuredDate => $composableBuilder(
      column: $table.measuredDate, builder: (column) => column);

  GeneratedColumn<int> get odometerKm => $composableBuilder(
      column: $table.odometerKm, builder: (column) => column);

  GeneratedColumn<String> get measurementType => $composableBuilder(
      column: $table.measurementType, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get measurementContext => $composableBuilder(
      column: $table.measurementContext, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get partNumber => $composableBuilder(
      column: $table.partNumber, builder: (column) => column);

  GeneratedColumn<String> get visualCondition => $composableBuilder(
      column: $table.visualCondition, builder: (column) => column);

  GeneratedColumn<bool> get hasDamage =>
      $composableBuilder(column: $table.hasDamage, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get voidedAt =>
      $composableBuilder(column: $table.voidedAt, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MotorcyclesTableAnnotationComposer get motorcycleId {
    final $$MotorcyclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableAnnotationComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceItemsTableAnnotationComposer get itemId {
    final $$MaintenanceItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceRecordsTableAnnotationComposer get recordId {
    final $$MaintenanceRecordsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.recordId,
            referencedTable: $db.maintenanceRecords,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceRecordsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceRecords,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  Expression<T> attachmentsRefs<T extends Object>(
      Expression<T> Function($$AttachmentsTableAnnotationComposer a) f) {
    final $$AttachmentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attachments,
        getReferencedColumn: (t) => t.measurementId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttachmentsTableAnnotationComposer(
              $db: $db,
              $table: $db.attachments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ComponentMeasurementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ComponentMeasurementsTable,
    ComponentMeasurementRow,
    $$ComponentMeasurementsTableFilterComposer,
    $$ComponentMeasurementsTableOrderingComposer,
    $$ComponentMeasurementsTableAnnotationComposer,
    $$ComponentMeasurementsTableCreateCompanionBuilder,
    $$ComponentMeasurementsTableUpdateCompanionBuilder,
    (ComponentMeasurementRow, $$ComponentMeasurementsTableReferences),
    ComponentMeasurementRow,
    PrefetchHooks Function(
        {bool motorcycleId,
        bool itemId,
        bool recordId,
        bool attachmentsRefs})> {
  $$ComponentMeasurementsTableTableManager(
      _$AppDatabase db, $ComponentMeasurementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComponentMeasurementsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ComponentMeasurementsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComponentMeasurementsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> motorcycleId = const Value.absent(),
            Value<int> itemId = const Value.absent(),
            Value<int?> recordId = const Value.absent(),
            Value<String> measuredDate = const Value.absent(),
            Value<int?> odometerKm = const Value.absent(),
            Value<String> measurementType = const Value.absent(),
            Value<double?> value = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String?> position = const Value.absent(),
            Value<String?> measurementContext = const Value.absent(),
            Value<String?> brand = const Value.absent(),
            Value<String?> partNumber = const Value.absent(),
            Value<String?> visualCondition = const Value.absent(),
            Value<bool> hasDamage = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> voidedAt = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
          }) =>
              ComponentMeasurementsCompanion(
            id: id,
            motorcycleId: motorcycleId,
            itemId: itemId,
            recordId: recordId,
            measuredDate: measuredDate,
            odometerKm: odometerKm,
            measurementType: measurementType,
            value: value,
            unit: unit,
            position: position,
            measurementContext: measurementContext,
            brand: brand,
            partNumber: partNumber,
            visualCondition: visualCondition,
            hasDamage: hasDamage,
            notes: notes,
            voidedAt: voidedAt,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int motorcycleId,
            required int itemId,
            Value<int?> recordId = const Value.absent(),
            required String measuredDate,
            Value<int?> odometerKm = const Value.absent(),
            required String measurementType,
            Value<double?> value = const Value.absent(),
            required String unit,
            Value<String?> position = const Value.absent(),
            Value<String?> measurementContext = const Value.absent(),
            Value<String?> brand = const Value.absent(),
            Value<String?> partNumber = const Value.absent(),
            Value<String?> visualCondition = const Value.absent(),
            Value<bool> hasDamage = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> voidedAt = const Value.absent(),
            required String createdAt,
          }) =>
              ComponentMeasurementsCompanion.insert(
            id: id,
            motorcycleId: motorcycleId,
            itemId: itemId,
            recordId: recordId,
            measuredDate: measuredDate,
            odometerKm: odometerKm,
            measurementType: measurementType,
            value: value,
            unit: unit,
            position: position,
            measurementContext: measurementContext,
            brand: brand,
            partNumber: partNumber,
            visualCondition: visualCondition,
            hasDamage: hasDamage,
            notes: notes,
            voidedAt: voidedAt,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ComponentMeasurementsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {motorcycleId = false,
              itemId = false,
              recordId = false,
              attachmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (attachmentsRefs) db.attachments],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (motorcycleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.motorcycleId,
                    referencedTable: $$ComponentMeasurementsTableReferences
                        ._motorcycleIdTable(db),
                    referencedColumn: $$ComponentMeasurementsTableReferences
                        ._motorcycleIdTable(db)
                        .id,
                  ) as T;
                }
                if (itemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemId,
                    referencedTable:
                        $$ComponentMeasurementsTableReferences._itemIdTable(db),
                    referencedColumn: $$ComponentMeasurementsTableReferences
                        ._itemIdTable(db)
                        .id,
                  ) as T;
                }
                if (recordId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recordId,
                    referencedTable: $$ComponentMeasurementsTableReferences
                        ._recordIdTable(db),
                    referencedColumn: $$ComponentMeasurementsTableReferences
                        ._recordIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attachmentsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$ComponentMeasurementsTableReferences
                            ._attachmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ComponentMeasurementsTableReferences(
                                    db, table, p0)
                                .attachmentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.measurementId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ComponentMeasurementsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ComponentMeasurementsTable,
        ComponentMeasurementRow,
        $$ComponentMeasurementsTableFilterComposer,
        $$ComponentMeasurementsTableOrderingComposer,
        $$ComponentMeasurementsTableAnnotationComposer,
        $$ComponentMeasurementsTableCreateCompanionBuilder,
        $$ComponentMeasurementsTableUpdateCompanionBuilder,
        (ComponentMeasurementRow, $$ComponentMeasurementsTableReferences),
        ComponentMeasurementRow,
        PrefetchHooks Function(
            {bool motorcycleId,
            bool itemId,
            bool recordId,
            bool attachmentsRefs})>;
typedef $$ComponentSpecsTableCreateCompanionBuilder = ComponentSpecsCompanion
    Function({
  Value<int> id,
  required String specKey,
  required int itemId,
  Value<double?> customStandardValue,
  Value<double?> customServiceLimit,
  Value<String> unit,
  required String updatedAt,
});
typedef $$ComponentSpecsTableUpdateCompanionBuilder = ComponentSpecsCompanion
    Function({
  Value<int> id,
  Value<String> specKey,
  Value<int> itemId,
  Value<double?> customStandardValue,
  Value<double?> customServiceLimit,
  Value<String> unit,
  Value<String> updatedAt,
});

final class $$ComponentSpecsTableReferences extends BaseReferences<
    _$AppDatabase, $ComponentSpecsTable, ComponentSpecRow> {
  $$ComponentSpecsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MaintenanceItemsTable _itemIdTable(_$AppDatabase db) =>
      db.maintenanceItems.createAlias($_aliasNameGenerator(
          db.componentSpecs.itemId, db.maintenanceItems.id));

  $$MaintenanceItemsTableProcessedTableManager? get itemId {
    if ($_item.itemId == null) return null;
    final manager =
        $$MaintenanceItemsTableTableManager($_db, $_db.maintenanceItems)
            .filter((f) => f.id($_item.itemId!));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ComponentSpecsTableFilterComposer
    extends Composer<_$AppDatabase, $ComponentSpecsTable> {
  $$ComponentSpecsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get specKey => $composableBuilder(
      column: $table.specKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get customStandardValue => $composableBuilder(
      column: $table.customStandardValue,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get customServiceLimit => $composableBuilder(
      column: $table.customServiceLimit,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$MaintenanceItemsTableFilterComposer get itemId {
    final $$MaintenanceItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ComponentSpecsTableOrderingComposer
    extends Composer<_$AppDatabase, $ComponentSpecsTable> {
  $$ComponentSpecsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get specKey => $composableBuilder(
      column: $table.specKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get customStandardValue => $composableBuilder(
      column: $table.customStandardValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get customServiceLimit => $composableBuilder(
      column: $table.customServiceLimit,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$MaintenanceItemsTableOrderingComposer get itemId {
    final $$MaintenanceItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableOrderingComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ComponentSpecsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComponentSpecsTable> {
  $$ComponentSpecsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get specKey =>
      $composableBuilder(column: $table.specKey, builder: (column) => column);

  GeneratedColumn<double> get customStandardValue => $composableBuilder(
      column: $table.customStandardValue, builder: (column) => column);

  GeneratedColumn<double> get customServiceLimit => $composableBuilder(
      column: $table.customServiceLimit, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MaintenanceItemsTableAnnotationComposer get itemId {
    final $$MaintenanceItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ComponentSpecsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ComponentSpecsTable,
    ComponentSpecRow,
    $$ComponentSpecsTableFilterComposer,
    $$ComponentSpecsTableOrderingComposer,
    $$ComponentSpecsTableAnnotationComposer,
    $$ComponentSpecsTableCreateCompanionBuilder,
    $$ComponentSpecsTableUpdateCompanionBuilder,
    (ComponentSpecRow, $$ComponentSpecsTableReferences),
    ComponentSpecRow,
    PrefetchHooks Function({bool itemId})> {
  $$ComponentSpecsTableTableManager(
      _$AppDatabase db, $ComponentSpecsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComponentSpecsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComponentSpecsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComponentSpecsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> specKey = const Value.absent(),
            Value<int> itemId = const Value.absent(),
            Value<double?> customStandardValue = const Value.absent(),
            Value<double?> customServiceLimit = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
          }) =>
              ComponentSpecsCompanion(
            id: id,
            specKey: specKey,
            itemId: itemId,
            customStandardValue: customStandardValue,
            customServiceLimit: customServiceLimit,
            unit: unit,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String specKey,
            required int itemId,
            Value<double?> customStandardValue = const Value.absent(),
            Value<double?> customServiceLimit = const Value.absent(),
            Value<String> unit = const Value.absent(),
            required String updatedAt,
          }) =>
              ComponentSpecsCompanion.insert(
            id: id,
            specKey: specKey,
            itemId: itemId,
            customStandardValue: customStandardValue,
            customServiceLimit: customServiceLimit,
            unit: unit,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ComponentSpecsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (itemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemId,
                    referencedTable:
                        $$ComponentSpecsTableReferences._itemIdTable(db),
                    referencedColumn:
                        $$ComponentSpecsTableReferences._itemIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ComponentSpecsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ComponentSpecsTable,
    ComponentSpecRow,
    $$ComponentSpecsTableFilterComposer,
    $$ComponentSpecsTableOrderingComposer,
    $$ComponentSpecsTableAnnotationComposer,
    $$ComponentSpecsTableCreateCompanionBuilder,
    $$ComponentSpecsTableUpdateCompanionBuilder,
    (ComponentSpecRow, $$ComponentSpecsTableReferences),
    ComponentSpecRow,
    PrefetchHooks Function({bool itemId})>;
typedef $$PartsTableCreateCompanionBuilder = PartsCompanion Function({
  Value<int> id,
  Value<int?> itemId,
  required String name,
  Value<String?> brand,
  Value<String?> partNumber,
  Value<String?> specification,
  Value<int> purchasePriceCentavos,
  Value<String?> purchaseDate,
  Value<String?> supplier,
  Value<int> quantity,
  required String createdAt,
});
typedef $$PartsTableUpdateCompanionBuilder = PartsCompanion Function({
  Value<int> id,
  Value<int?> itemId,
  Value<String> name,
  Value<String?> brand,
  Value<String?> partNumber,
  Value<String?> specification,
  Value<int> purchasePriceCentavos,
  Value<String?> purchaseDate,
  Value<String?> supplier,
  Value<int> quantity,
  Value<String> createdAt,
});

final class $$PartsTableReferences
    extends BaseReferences<_$AppDatabase, $PartsTable, PartRow> {
  $$PartsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MaintenanceItemsTable _itemIdTable(_$AppDatabase db) =>
      db.maintenanceItems.createAlias(
          $_aliasNameGenerator(db.parts.itemId, db.maintenanceItems.id));

  $$MaintenanceItemsTableProcessedTableManager? get itemId {
    if ($_item.itemId == null) return null;
    final manager =
        $$MaintenanceItemsTableTableManager($_db, $_db.maintenanceItems)
            .filter((f) => f.id($_item.itemId!));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$MaintenanceRecordPartsTable,
      List<MaintenanceRecordPartRow>> _maintenanceRecordPartsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.maintenanceRecordParts,
          aliasName: $_aliasNameGenerator(
              db.parts.id, db.maintenanceRecordParts.partId));

  $$MaintenanceRecordPartsTableProcessedTableManager
      get maintenanceRecordPartsRefs {
    final manager = $$MaintenanceRecordPartsTableTableManager(
            $_db, $_db.maintenanceRecordParts)
        .filter((f) => f.partId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_maintenanceRecordPartsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PartInstallationsTable, List<PartInstallationRow>>
      _partInstallationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.partInstallations,
              aliasName: $_aliasNameGenerator(
                  db.parts.id, db.partInstallations.partId));

  $$PartInstallationsTableProcessedTableManager get partInstallationsRefs {
    final manager =
        $$PartInstallationsTableTableManager($_db, $_db.partInstallations)
            .filter((f) => f.partId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_partInstallationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PartsTableFilterComposer extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get partNumber => $composableBuilder(
      column: $table.partNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get specification => $composableBuilder(
      column: $table.specification, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get purchasePriceCentavos => $composableBuilder(
      column: $table.purchasePriceCentavos,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supplier => $composableBuilder(
      column: $table.supplier, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$MaintenanceItemsTableFilterComposer get itemId {
    final $$MaintenanceItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> maintenanceRecordPartsRefs(
      Expression<bool> Function($$MaintenanceRecordPartsTableFilterComposer f)
          f) {
    final $$MaintenanceRecordPartsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.maintenanceRecordParts,
            getReferencedColumn: (t) => t.partId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceRecordPartsTableFilterComposer(
                  $db: $db,
                  $table: $db.maintenanceRecordParts,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> partInstallationsRefs(
      Expression<bool> Function($$PartInstallationsTableFilterComposer f) f) {
    final $$PartInstallationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.partInstallations,
        getReferencedColumn: (t) => t.partId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartInstallationsTableFilterComposer(
              $db: $db,
              $table: $db.partInstallations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PartsTableOrderingComposer
    extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get partNumber => $composableBuilder(
      column: $table.partNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get specification => $composableBuilder(
      column: $table.specification,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get purchasePriceCentavos => $composableBuilder(
      column: $table.purchasePriceCentavos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supplier => $composableBuilder(
      column: $table.supplier, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$MaintenanceItemsTableOrderingComposer get itemId {
    final $$MaintenanceItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableOrderingComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get partNumber => $composableBuilder(
      column: $table.partNumber, builder: (column) => column);

  GeneratedColumn<String> get specification => $composableBuilder(
      column: $table.specification, builder: (column) => column);

  GeneratedColumn<int> get purchasePriceCentavos => $composableBuilder(
      column: $table.purchasePriceCentavos, builder: (column) => column);

  GeneratedColumn<String> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => column);

  GeneratedColumn<String> get supplier =>
      $composableBuilder(column: $table.supplier, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MaintenanceItemsTableAnnotationComposer get itemId {
    final $$MaintenanceItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> maintenanceRecordPartsRefs<T extends Object>(
      Expression<T> Function($$MaintenanceRecordPartsTableAnnotationComposer a)
          f) {
    final $$MaintenanceRecordPartsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.maintenanceRecordParts,
            getReferencedColumn: (t) => t.partId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceRecordPartsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceRecordParts,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> partInstallationsRefs<T extends Object>(
      Expression<T> Function($$PartInstallationsTableAnnotationComposer a) f) {
    final $$PartInstallationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.partInstallations,
            getReferencedColumn: (t) => t.partId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PartInstallationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.partInstallations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$PartsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PartsTable,
    PartRow,
    $$PartsTableFilterComposer,
    $$PartsTableOrderingComposer,
    $$PartsTableAnnotationComposer,
    $$PartsTableCreateCompanionBuilder,
    $$PartsTableUpdateCompanionBuilder,
    (PartRow, $$PartsTableReferences),
    PartRow,
    PrefetchHooks Function(
        {bool itemId,
        bool maintenanceRecordPartsRefs,
        bool partInstallationsRefs})> {
  $$PartsTableTableManager(_$AppDatabase db, $PartsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> itemId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> brand = const Value.absent(),
            Value<String?> partNumber = const Value.absent(),
            Value<String?> specification = const Value.absent(),
            Value<int> purchasePriceCentavos = const Value.absent(),
            Value<String?> purchaseDate = const Value.absent(),
            Value<String?> supplier = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
          }) =>
              PartsCompanion(
            id: id,
            itemId: itemId,
            name: name,
            brand: brand,
            partNumber: partNumber,
            specification: specification,
            purchasePriceCentavos: purchasePriceCentavos,
            purchaseDate: purchaseDate,
            supplier: supplier,
            quantity: quantity,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> itemId = const Value.absent(),
            required String name,
            Value<String?> brand = const Value.absent(),
            Value<String?> partNumber = const Value.absent(),
            Value<String?> specification = const Value.absent(),
            Value<int> purchasePriceCentavos = const Value.absent(),
            Value<String?> purchaseDate = const Value.absent(),
            Value<String?> supplier = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            required String createdAt,
          }) =>
              PartsCompanion.insert(
            id: id,
            itemId: itemId,
            name: name,
            brand: brand,
            partNumber: partNumber,
            specification: specification,
            purchasePriceCentavos: purchasePriceCentavos,
            purchaseDate: purchaseDate,
            supplier: supplier,
            quantity: quantity,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PartsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {itemId = false,
              maintenanceRecordPartsRefs = false,
              partInstallationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (maintenanceRecordPartsRefs) db.maintenanceRecordParts,
                if (partInstallationsRefs) db.partInstallations
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (itemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemId,
                    referencedTable: $$PartsTableReferences._itemIdTable(db),
                    referencedColumn:
                        $$PartsTableReferences._itemIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (maintenanceRecordPartsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$PartsTableReferences
                            ._maintenanceRecordPartsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PartsTableReferences(db, table, p0)
                                .maintenanceRecordPartsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.partId == item.id),
                        typedResults: items),
                  if (partInstallationsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$PartsTableReferences
                            ._partInstallationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PartsTableReferences(db, table, p0)
                                .partInstallationsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.partId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PartsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PartsTable,
    PartRow,
    $$PartsTableFilterComposer,
    $$PartsTableOrderingComposer,
    $$PartsTableAnnotationComposer,
    $$PartsTableCreateCompanionBuilder,
    $$PartsTableUpdateCompanionBuilder,
    (PartRow, $$PartsTableReferences),
    PartRow,
    PrefetchHooks Function(
        {bool itemId,
        bool maintenanceRecordPartsRefs,
        bool partInstallationsRefs})>;
typedef $$MaintenanceRecordPartsTableCreateCompanionBuilder
    = MaintenanceRecordPartsCompanion Function({
  Value<int> id,
  required int recordId,
  required int partId,
  Value<int> quantity,
  Value<int> unitCostCentavos,
});
typedef $$MaintenanceRecordPartsTableUpdateCompanionBuilder
    = MaintenanceRecordPartsCompanion Function({
  Value<int> id,
  Value<int> recordId,
  Value<int> partId,
  Value<int> quantity,
  Value<int> unitCostCentavos,
});

final class $$MaintenanceRecordPartsTableReferences extends BaseReferences<
    _$AppDatabase, $MaintenanceRecordPartsTable, MaintenanceRecordPartRow> {
  $$MaintenanceRecordPartsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MaintenanceRecordsTable _recordIdTable(_$AppDatabase db) =>
      db.maintenanceRecords.createAlias($_aliasNameGenerator(
          db.maintenanceRecordParts.recordId, db.maintenanceRecords.id));

  $$MaintenanceRecordsTableProcessedTableManager? get recordId {
    if ($_item.recordId == null) return null;
    final manager =
        $$MaintenanceRecordsTableTableManager($_db, $_db.maintenanceRecords)
            .filter((f) => f.id($_item.recordId!));
    final item = $_typedResult.readTableOrNull(_recordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PartsTable _partIdTable(_$AppDatabase db) => db.parts.createAlias(
      $_aliasNameGenerator(db.maintenanceRecordParts.partId, db.parts.id));

  $$PartsTableProcessedTableManager? get partId {
    if ($_item.partId == null) return null;
    final manager = $$PartsTableTableManager($_db, $_db.parts)
        .filter((f) => f.id($_item.partId!));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MaintenanceRecordPartsTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceRecordPartsTable> {
  $$MaintenanceRecordPartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitCostCentavos => $composableBuilder(
      column: $table.unitCostCentavos,
      builder: (column) => ColumnFilters(column));

  $$MaintenanceRecordsTableFilterComposer get recordId {
    final $$MaintenanceRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordId,
        referencedTable: $db.maintenanceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRecordsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableFilterComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaintenanceRecordPartsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceRecordPartsTable> {
  $$MaintenanceRecordPartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitCostCentavos => $composableBuilder(
      column: $table.unitCostCentavos,
      builder: (column) => ColumnOrderings(column));

  $$MaintenanceRecordsTableOrderingComposer get recordId {
    final $$MaintenanceRecordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordId,
        referencedTable: $db.maintenanceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRecordsTableOrderingComposer(
              $db: $db,
              $table: $db.maintenanceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableOrderingComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaintenanceRecordPartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceRecordPartsTable> {
  $$MaintenanceRecordPartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitCostCentavos => $composableBuilder(
      column: $table.unitCostCentavos, builder: (column) => column);

  $$MaintenanceRecordsTableAnnotationComposer get recordId {
    final $$MaintenanceRecordsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.recordId,
            referencedTable: $db.maintenanceRecords,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceRecordsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceRecords,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableAnnotationComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaintenanceRecordPartsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MaintenanceRecordPartsTable,
    MaintenanceRecordPartRow,
    $$MaintenanceRecordPartsTableFilterComposer,
    $$MaintenanceRecordPartsTableOrderingComposer,
    $$MaintenanceRecordPartsTableAnnotationComposer,
    $$MaintenanceRecordPartsTableCreateCompanionBuilder,
    $$MaintenanceRecordPartsTableUpdateCompanionBuilder,
    (MaintenanceRecordPartRow, $$MaintenanceRecordPartsTableReferences),
    MaintenanceRecordPartRow,
    PrefetchHooks Function({bool recordId, bool partId})> {
  $$MaintenanceRecordPartsTableTableManager(
      _$AppDatabase db, $MaintenanceRecordPartsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceRecordPartsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceRecordPartsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceRecordPartsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> recordId = const Value.absent(),
            Value<int> partId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<int> unitCostCentavos = const Value.absent(),
          }) =>
              MaintenanceRecordPartsCompanion(
            id: id,
            recordId: recordId,
            partId: partId,
            quantity: quantity,
            unitCostCentavos: unitCostCentavos,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int recordId,
            required int partId,
            Value<int> quantity = const Value.absent(),
            Value<int> unitCostCentavos = const Value.absent(),
          }) =>
              MaintenanceRecordPartsCompanion.insert(
            id: id,
            recordId: recordId,
            partId: partId,
            quantity: quantity,
            unitCostCentavos: unitCostCentavos,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MaintenanceRecordPartsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({recordId = false, partId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (recordId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recordId,
                    referencedTable: $$MaintenanceRecordPartsTableReferences
                        ._recordIdTable(db),
                    referencedColumn: $$MaintenanceRecordPartsTableReferences
                        ._recordIdTable(db)
                        .id,
                  ) as T;
                }
                if (partId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.partId,
                    referencedTable: $$MaintenanceRecordPartsTableReferences
                        ._partIdTable(db),
                    referencedColumn: $$MaintenanceRecordPartsTableReferences
                        ._partIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MaintenanceRecordPartsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $MaintenanceRecordPartsTable,
        MaintenanceRecordPartRow,
        $$MaintenanceRecordPartsTableFilterComposer,
        $$MaintenanceRecordPartsTableOrderingComposer,
        $$MaintenanceRecordPartsTableAnnotationComposer,
        $$MaintenanceRecordPartsTableCreateCompanionBuilder,
        $$MaintenanceRecordPartsTableUpdateCompanionBuilder,
        (MaintenanceRecordPartRow, $$MaintenanceRecordPartsTableReferences),
        MaintenanceRecordPartRow,
        PrefetchHooks Function({bool recordId, bool partId})>;
typedef $$PartInstallationsTableCreateCompanionBuilder
    = PartInstallationsCompanion Function({
  Value<int> id,
  required int partId,
  required int motorcycleId,
  Value<int?> recordId,
  Value<String?> position,
  required String installedDate,
  required int installedOdometerKm,
  Value<String?> removedDate,
  Value<int?> removedOdometerKm,
  Value<String?> notes,
});
typedef $$PartInstallationsTableUpdateCompanionBuilder
    = PartInstallationsCompanion Function({
  Value<int> id,
  Value<int> partId,
  Value<int> motorcycleId,
  Value<int?> recordId,
  Value<String?> position,
  Value<String> installedDate,
  Value<int> installedOdometerKm,
  Value<String?> removedDate,
  Value<int?> removedOdometerKm,
  Value<String?> notes,
});

final class $$PartInstallationsTableReferences extends BaseReferences<
    _$AppDatabase, $PartInstallationsTable, PartInstallationRow> {
  $$PartInstallationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PartsTable _partIdTable(_$AppDatabase db) => db.parts.createAlias(
      $_aliasNameGenerator(db.partInstallations.partId, db.parts.id));

  $$PartsTableProcessedTableManager? get partId {
    if ($_item.partId == null) return null;
    final manager = $$PartsTableTableManager($_db, $_db.parts)
        .filter((f) => f.id($_item.partId!));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MotorcyclesTable _motorcycleIdTable(_$AppDatabase db) =>
      db.motorcycles.createAlias($_aliasNameGenerator(
          db.partInstallations.motorcycleId, db.motorcycles.id));

  $$MotorcyclesTableProcessedTableManager? get motorcycleId {
    if ($_item.motorcycleId == null) return null;
    final manager = $$MotorcyclesTableTableManager($_db, $_db.motorcycles)
        .filter((f) => f.id($_item.motorcycleId!));
    final item = $_typedResult.readTableOrNull(_motorcycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MaintenanceRecordsTable _recordIdTable(_$AppDatabase db) =>
      db.maintenanceRecords.createAlias($_aliasNameGenerator(
          db.partInstallations.recordId, db.maintenanceRecords.id));

  $$MaintenanceRecordsTableProcessedTableManager? get recordId {
    if ($_item.recordId == null) return null;
    final manager =
        $$MaintenanceRecordsTableTableManager($_db, $_db.maintenanceRecords)
            .filter((f) => f.id($_item.recordId!));
    final item = $_typedResult.readTableOrNull(_recordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PartInstallationsTableFilterComposer
    extends Composer<_$AppDatabase, $PartInstallationsTable> {
  $$PartInstallationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get installedDate => $composableBuilder(
      column: $table.installedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get installedOdometerKm => $composableBuilder(
      column: $table.installedOdometerKm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get removedDate => $composableBuilder(
      column: $table.removedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get removedOdometerKm => $composableBuilder(
      column: $table.removedOdometerKm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableFilterComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MotorcyclesTableFilterComposer get motorcycleId {
    final $$MotorcyclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableFilterComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceRecordsTableFilterComposer get recordId {
    final $$MaintenanceRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordId,
        referencedTable: $db.maintenanceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRecordsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PartInstallationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PartInstallationsTable> {
  $$PartInstallationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get installedDate => $composableBuilder(
      column: $table.installedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get installedOdometerKm => $composableBuilder(
      column: $table.installedOdometerKm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get removedDate => $composableBuilder(
      column: $table.removedDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get removedOdometerKm => $composableBuilder(
      column: $table.removedOdometerKm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableOrderingComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MotorcyclesTableOrderingComposer get motorcycleId {
    final $$MotorcyclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableOrderingComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceRecordsTableOrderingComposer get recordId {
    final $$MaintenanceRecordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordId,
        referencedTable: $db.maintenanceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRecordsTableOrderingComposer(
              $db: $db,
              $table: $db.maintenanceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PartInstallationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartInstallationsTable> {
  $$PartInstallationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get installedDate => $composableBuilder(
      column: $table.installedDate, builder: (column) => column);

  GeneratedColumn<int> get installedOdometerKm => $composableBuilder(
      column: $table.installedOdometerKm, builder: (column) => column);

  GeneratedColumn<String> get removedDate => $composableBuilder(
      column: $table.removedDate, builder: (column) => column);

  GeneratedColumn<int> get removedOdometerKm => $composableBuilder(
      column: $table.removedOdometerKm, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableAnnotationComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MotorcyclesTableAnnotationComposer get motorcycleId {
    final $$MotorcyclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableAnnotationComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceRecordsTableAnnotationComposer get recordId {
    final $$MaintenanceRecordsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.recordId,
            referencedTable: $db.maintenanceRecords,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceRecordsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceRecords,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$PartInstallationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PartInstallationsTable,
    PartInstallationRow,
    $$PartInstallationsTableFilterComposer,
    $$PartInstallationsTableOrderingComposer,
    $$PartInstallationsTableAnnotationComposer,
    $$PartInstallationsTableCreateCompanionBuilder,
    $$PartInstallationsTableUpdateCompanionBuilder,
    (PartInstallationRow, $$PartInstallationsTableReferences),
    PartInstallationRow,
    PrefetchHooks Function({bool partId, bool motorcycleId, bool recordId})> {
  $$PartInstallationsTableTableManager(
      _$AppDatabase db, $PartInstallationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartInstallationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartInstallationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartInstallationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> partId = const Value.absent(),
            Value<int> motorcycleId = const Value.absent(),
            Value<int?> recordId = const Value.absent(),
            Value<String?> position = const Value.absent(),
            Value<String> installedDate = const Value.absent(),
            Value<int> installedOdometerKm = const Value.absent(),
            Value<String?> removedDate = const Value.absent(),
            Value<int?> removedOdometerKm = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              PartInstallationsCompanion(
            id: id,
            partId: partId,
            motorcycleId: motorcycleId,
            recordId: recordId,
            position: position,
            installedDate: installedDate,
            installedOdometerKm: installedOdometerKm,
            removedDate: removedDate,
            removedOdometerKm: removedOdometerKm,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int partId,
            required int motorcycleId,
            Value<int?> recordId = const Value.absent(),
            Value<String?> position = const Value.absent(),
            required String installedDate,
            required int installedOdometerKm,
            Value<String?> removedDate = const Value.absent(),
            Value<int?> removedOdometerKm = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              PartInstallationsCompanion.insert(
            id: id,
            partId: partId,
            motorcycleId: motorcycleId,
            recordId: recordId,
            position: position,
            installedDate: installedDate,
            installedOdometerKm: installedOdometerKm,
            removedDate: removedDate,
            removedOdometerKm: removedOdometerKm,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PartInstallationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {partId = false, motorcycleId = false, recordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (partId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.partId,
                    referencedTable:
                        $$PartInstallationsTableReferences._partIdTable(db),
                    referencedColumn:
                        $$PartInstallationsTableReferences._partIdTable(db).id,
                  ) as T;
                }
                if (motorcycleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.motorcycleId,
                    referencedTable: $$PartInstallationsTableReferences
                        ._motorcycleIdTable(db),
                    referencedColumn: $$PartInstallationsTableReferences
                        ._motorcycleIdTable(db)
                        .id,
                  ) as T;
                }
                if (recordId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recordId,
                    referencedTable:
                        $$PartInstallationsTableReferences._recordIdTable(db),
                    referencedColumn: $$PartInstallationsTableReferences
                        ._recordIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PartInstallationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PartInstallationsTable,
    PartInstallationRow,
    $$PartInstallationsTableFilterComposer,
    $$PartInstallationsTableOrderingComposer,
    $$PartInstallationsTableAnnotationComposer,
    $$PartInstallationsTableCreateCompanionBuilder,
    $$PartInstallationsTableUpdateCompanionBuilder,
    (PartInstallationRow, $$PartInstallationsTableReferences),
    PartInstallationRow,
    PrefetchHooks Function({bool partId, bool motorcycleId, bool recordId})>;
typedef $$MaintenanceRemindersTableCreateCompanionBuilder
    = MaintenanceRemindersCompanion Function({
  Value<int> id,
  required int motorcycleId,
  Value<int?> itemId,
  Value<int?> ruleId,
  required String reminderType,
  required String title,
  Value<String?> body,
  Value<String?> dueDate,
  Value<int?> dueOdometerKm,
  required String dedupeKey,
  Value<String> status,
  Value<String?> notifiedAt,
  required String createdAt,
});
typedef $$MaintenanceRemindersTableUpdateCompanionBuilder
    = MaintenanceRemindersCompanion Function({
  Value<int> id,
  Value<int> motorcycleId,
  Value<int?> itemId,
  Value<int?> ruleId,
  Value<String> reminderType,
  Value<String> title,
  Value<String?> body,
  Value<String?> dueDate,
  Value<int?> dueOdometerKm,
  Value<String> dedupeKey,
  Value<String> status,
  Value<String?> notifiedAt,
  Value<String> createdAt,
});

final class $$MaintenanceRemindersTableReferences extends BaseReferences<
    _$AppDatabase, $MaintenanceRemindersTable, MaintenanceReminderRow> {
  $$MaintenanceRemindersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MotorcyclesTable _motorcycleIdTable(_$AppDatabase db) =>
      db.motorcycles.createAlias($_aliasNameGenerator(
          db.maintenanceReminders.motorcycleId, db.motorcycles.id));

  $$MotorcyclesTableProcessedTableManager? get motorcycleId {
    if ($_item.motorcycleId == null) return null;
    final manager = $$MotorcyclesTableTableManager($_db, $_db.motorcycles)
        .filter((f) => f.id($_item.motorcycleId!));
    final item = $_typedResult.readTableOrNull(_motorcycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MaintenanceItemsTable _itemIdTable(_$AppDatabase db) =>
      db.maintenanceItems.createAlias($_aliasNameGenerator(
          db.maintenanceReminders.itemId, db.maintenanceItems.id));

  $$MaintenanceItemsTableProcessedTableManager? get itemId {
    if ($_item.itemId == null) return null;
    final manager =
        $$MaintenanceItemsTableTableManager($_db, $_db.maintenanceItems)
            .filter((f) => f.id($_item.itemId!));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MaintenanceRulesTable _ruleIdTable(_$AppDatabase db) =>
      db.maintenanceRules.createAlias($_aliasNameGenerator(
          db.maintenanceReminders.ruleId, db.maintenanceRules.id));

  $$MaintenanceRulesTableProcessedTableManager? get ruleId {
    if ($_item.ruleId == null) return null;
    final manager =
        $$MaintenanceRulesTableTableManager($_db, $_db.maintenanceRules)
            .filter((f) => f.id($_item.ruleId!));
    final item = $_typedResult.readTableOrNull(_ruleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MaintenanceRemindersTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceRemindersTable> {
  $$MaintenanceRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderType => $composableBuilder(
      column: $table.reminderType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dueOdometerKm => $composableBuilder(
      column: $table.dueOdometerKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dedupeKey => $composableBuilder(
      column: $table.dedupeKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notifiedAt => $composableBuilder(
      column: $table.notifiedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$MotorcyclesTableFilterComposer get motorcycleId {
    final $$MotorcyclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableFilterComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceItemsTableFilterComposer get itemId {
    final $$MaintenanceItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceRulesTableFilterComposer get ruleId {
    final $$MaintenanceRulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ruleId,
        referencedTable: $db.maintenanceRules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRulesTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaintenanceRemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceRemindersTable> {
  $$MaintenanceRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderType => $composableBuilder(
      column: $table.reminderType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dueOdometerKm => $composableBuilder(
      column: $table.dueOdometerKm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dedupeKey => $composableBuilder(
      column: $table.dedupeKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notifiedAt => $composableBuilder(
      column: $table.notifiedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$MotorcyclesTableOrderingComposer get motorcycleId {
    final $$MotorcyclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableOrderingComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceItemsTableOrderingComposer get itemId {
    final $$MaintenanceItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableOrderingComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceRulesTableOrderingComposer get ruleId {
    final $$MaintenanceRulesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ruleId,
        referencedTable: $db.maintenanceRules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRulesTableOrderingComposer(
              $db: $db,
              $table: $db.maintenanceRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaintenanceRemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceRemindersTable> {
  $$MaintenanceRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reminderType => $composableBuilder(
      column: $table.reminderType, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get dueOdometerKm => $composableBuilder(
      column: $table.dueOdometerKm, builder: (column) => column);

  GeneratedColumn<String> get dedupeKey =>
      $composableBuilder(column: $table.dedupeKey, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notifiedAt => $composableBuilder(
      column: $table.notifiedAt, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MotorcyclesTableAnnotationComposer get motorcycleId {
    final $$MotorcyclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableAnnotationComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceItemsTableAnnotationComposer get itemId {
    final $$MaintenanceItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceRulesTableAnnotationComposer get ruleId {
    final $$MaintenanceRulesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ruleId,
        referencedTable: $db.maintenanceRules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRulesTableAnnotationComposer(
              $db: $db,
              $table: $db.maintenanceRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaintenanceRemindersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MaintenanceRemindersTable,
    MaintenanceReminderRow,
    $$MaintenanceRemindersTableFilterComposer,
    $$MaintenanceRemindersTableOrderingComposer,
    $$MaintenanceRemindersTableAnnotationComposer,
    $$MaintenanceRemindersTableCreateCompanionBuilder,
    $$MaintenanceRemindersTableUpdateCompanionBuilder,
    (MaintenanceReminderRow, $$MaintenanceRemindersTableReferences),
    MaintenanceReminderRow,
    PrefetchHooks Function({bool motorcycleId, bool itemId, bool ruleId})> {
  $$MaintenanceRemindersTableTableManager(
      _$AppDatabase db, $MaintenanceRemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceRemindersTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceRemindersTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> motorcycleId = const Value.absent(),
            Value<int?> itemId = const Value.absent(),
            Value<int?> ruleId = const Value.absent(),
            Value<String> reminderType = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> body = const Value.absent(),
            Value<String?> dueDate = const Value.absent(),
            Value<int?> dueOdometerKm = const Value.absent(),
            Value<String> dedupeKey = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notifiedAt = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
          }) =>
              MaintenanceRemindersCompanion(
            id: id,
            motorcycleId: motorcycleId,
            itemId: itemId,
            ruleId: ruleId,
            reminderType: reminderType,
            title: title,
            body: body,
            dueDate: dueDate,
            dueOdometerKm: dueOdometerKm,
            dedupeKey: dedupeKey,
            status: status,
            notifiedAt: notifiedAt,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int motorcycleId,
            Value<int?> itemId = const Value.absent(),
            Value<int?> ruleId = const Value.absent(),
            required String reminderType,
            required String title,
            Value<String?> body = const Value.absent(),
            Value<String?> dueDate = const Value.absent(),
            Value<int?> dueOdometerKm = const Value.absent(),
            required String dedupeKey,
            Value<String> status = const Value.absent(),
            Value<String?> notifiedAt = const Value.absent(),
            required String createdAt,
          }) =>
              MaintenanceRemindersCompanion.insert(
            id: id,
            motorcycleId: motorcycleId,
            itemId: itemId,
            ruleId: ruleId,
            reminderType: reminderType,
            title: title,
            body: body,
            dueDate: dueDate,
            dueOdometerKm: dueOdometerKm,
            dedupeKey: dedupeKey,
            status: status,
            notifiedAt: notifiedAt,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MaintenanceRemindersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {motorcycleId = false, itemId = false, ruleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (motorcycleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.motorcycleId,
                    referencedTable: $$MaintenanceRemindersTableReferences
                        ._motorcycleIdTable(db),
                    referencedColumn: $$MaintenanceRemindersTableReferences
                        ._motorcycleIdTable(db)
                        .id,
                  ) as T;
                }
                if (itemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemId,
                    referencedTable:
                        $$MaintenanceRemindersTableReferences._itemIdTable(db),
                    referencedColumn: $$MaintenanceRemindersTableReferences
                        ._itemIdTable(db)
                        .id,
                  ) as T;
                }
                if (ruleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ruleId,
                    referencedTable:
                        $$MaintenanceRemindersTableReferences._ruleIdTable(db),
                    referencedColumn: $$MaintenanceRemindersTableReferences
                        ._ruleIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MaintenanceRemindersTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $MaintenanceRemindersTable,
        MaintenanceReminderRow,
        $$MaintenanceRemindersTableFilterComposer,
        $$MaintenanceRemindersTableOrderingComposer,
        $$MaintenanceRemindersTableAnnotationComposer,
        $$MaintenanceRemindersTableCreateCompanionBuilder,
        $$MaintenanceRemindersTableUpdateCompanionBuilder,
        (MaintenanceReminderRow, $$MaintenanceRemindersTableReferences),
        MaintenanceReminderRow,
        PrefetchHooks Function({bool motorcycleId, bool itemId, bool ruleId})>;
typedef $$AttachmentsTableCreateCompanionBuilder = AttachmentsCompanion
    Function({
  Value<int> id,
  Value<int?> recordId,
  Value<int?> measurementId,
  Value<int?> motorcycleId,
  required String filePath,
  Value<String?> mimeType,
  Value<String?> caption,
  required String createdAt,
});
typedef $$AttachmentsTableUpdateCompanionBuilder = AttachmentsCompanion
    Function({
  Value<int> id,
  Value<int?> recordId,
  Value<int?> measurementId,
  Value<int?> motorcycleId,
  Value<String> filePath,
  Value<String?> mimeType,
  Value<String?> caption,
  Value<String> createdAt,
});

final class $$AttachmentsTableReferences
    extends BaseReferences<_$AppDatabase, $AttachmentsTable, AttachmentRow> {
  $$AttachmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MaintenanceRecordsTable _recordIdTable(_$AppDatabase db) =>
      db.maintenanceRecords.createAlias($_aliasNameGenerator(
          db.attachments.recordId, db.maintenanceRecords.id));

  $$MaintenanceRecordsTableProcessedTableManager? get recordId {
    if ($_item.recordId == null) return null;
    final manager =
        $$MaintenanceRecordsTableTableManager($_db, $_db.maintenanceRecords)
            .filter((f) => f.id($_item.recordId!));
    final item = $_typedResult.readTableOrNull(_recordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ComponentMeasurementsTable _measurementIdTable(_$AppDatabase db) =>
      db.componentMeasurements.createAlias($_aliasNameGenerator(
          db.attachments.measurementId, db.componentMeasurements.id));

  $$ComponentMeasurementsTableProcessedTableManager? get measurementId {
    if ($_item.measurementId == null) return null;
    final manager = $$ComponentMeasurementsTableTableManager(
            $_db, $_db.componentMeasurements)
        .filter((f) => f.id($_item.measurementId!));
    final item = $_typedResult.readTableOrNull(_measurementIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MotorcyclesTable _motorcycleIdTable(_$AppDatabase db) =>
      db.motorcycles.createAlias(
          $_aliasNameGenerator(db.attachments.motorcycleId, db.motorcycles.id));

  $$MotorcyclesTableProcessedTableManager? get motorcycleId {
    if ($_item.motorcycleId == null) return null;
    final manager = $$MotorcyclesTableTableManager($_db, $_db.motorcycles)
        .filter((f) => f.id($_item.motorcycleId!));
    final item = $_typedResult.readTableOrNull(_motorcycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get caption => $composableBuilder(
      column: $table.caption, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$MaintenanceRecordsTableFilterComposer get recordId {
    final $$MaintenanceRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordId,
        referencedTable: $db.maintenanceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRecordsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ComponentMeasurementsTableFilterComposer get measurementId {
    final $$ComponentMeasurementsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.measurementId,
            referencedTable: $db.componentMeasurements,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ComponentMeasurementsTableFilterComposer(
                  $db: $db,
                  $table: $db.componentMeasurements,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$MotorcyclesTableFilterComposer get motorcycleId {
    final $$MotorcyclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableFilterComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get caption => $composableBuilder(
      column: $table.caption, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$MaintenanceRecordsTableOrderingComposer get recordId {
    final $$MaintenanceRecordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordId,
        referencedTable: $db.maintenanceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceRecordsTableOrderingComposer(
              $db: $db,
              $table: $db.maintenanceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ComponentMeasurementsTableOrderingComposer get measurementId {
    final $$ComponentMeasurementsTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.measurementId,
            referencedTable: $db.componentMeasurements,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ComponentMeasurementsTableOrderingComposer(
                  $db: $db,
                  $table: $db.componentMeasurements,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$MotorcyclesTableOrderingComposer get motorcycleId {
    final $$MotorcyclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableOrderingComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MaintenanceRecordsTableAnnotationComposer get recordId {
    final $$MaintenanceRecordsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.recordId,
            referencedTable: $db.maintenanceRecords,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceRecordsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceRecords,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$ComponentMeasurementsTableAnnotationComposer get measurementId {
    final $$ComponentMeasurementsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.measurementId,
            referencedTable: $db.componentMeasurements,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ComponentMeasurementsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.componentMeasurements,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$MotorcyclesTableAnnotationComposer get motorcycleId {
    final $$MotorcyclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableAnnotationComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttachmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AttachmentsTable,
    AttachmentRow,
    $$AttachmentsTableFilterComposer,
    $$AttachmentsTableOrderingComposer,
    $$AttachmentsTableAnnotationComposer,
    $$AttachmentsTableCreateCompanionBuilder,
    $$AttachmentsTableUpdateCompanionBuilder,
    (AttachmentRow, $$AttachmentsTableReferences),
    AttachmentRow,
    PrefetchHooks Function(
        {bool recordId, bool measurementId, bool motorcycleId})> {
  $$AttachmentsTableTableManager(_$AppDatabase db, $AttachmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> recordId = const Value.absent(),
            Value<int?> measurementId = const Value.absent(),
            Value<int?> motorcycleId = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            Value<String?> caption = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
          }) =>
              AttachmentsCompanion(
            id: id,
            recordId: recordId,
            measurementId: measurementId,
            motorcycleId: motorcycleId,
            filePath: filePath,
            mimeType: mimeType,
            caption: caption,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> recordId = const Value.absent(),
            Value<int?> measurementId = const Value.absent(),
            Value<int?> motorcycleId = const Value.absent(),
            required String filePath,
            Value<String?> mimeType = const Value.absent(),
            Value<String?> caption = const Value.absent(),
            required String createdAt,
          }) =>
              AttachmentsCompanion.insert(
            id: id,
            recordId: recordId,
            measurementId: measurementId,
            motorcycleId: motorcycleId,
            filePath: filePath,
            mimeType: mimeType,
            caption: caption,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AttachmentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {recordId = false, measurementId = false, motorcycleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (recordId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recordId,
                    referencedTable:
                        $$AttachmentsTableReferences._recordIdTable(db),
                    referencedColumn:
                        $$AttachmentsTableReferences._recordIdTable(db).id,
                  ) as T;
                }
                if (measurementId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.measurementId,
                    referencedTable:
                        $$AttachmentsTableReferences._measurementIdTable(db),
                    referencedColumn:
                        $$AttachmentsTableReferences._measurementIdTable(db).id,
                  ) as T;
                }
                if (motorcycleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.motorcycleId,
                    referencedTable:
                        $$AttachmentsTableReferences._motorcycleIdTable(db),
                    referencedColumn:
                        $$AttachmentsTableReferences._motorcycleIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AttachmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AttachmentsTable,
    AttachmentRow,
    $$AttachmentsTableFilterComposer,
    $$AttachmentsTableOrderingComposer,
    $$AttachmentsTableAnnotationComposer,
    $$AttachmentsTableCreateCompanionBuilder,
    $$AttachmentsTableUpdateCompanionBuilder,
    (AttachmentRow, $$AttachmentsTableReferences),
    AttachmentRow,
    PrefetchHooks Function(
        {bool recordId, bool measurementId, bool motorcycleId})>;
typedef $$TripsTableCreateCompanionBuilder = TripsCompanion Function({
  Value<int> id,
  required int motorcycleId,
  required String title,
  required String category,
  Value<String?> origin,
  Value<String?> destination,
  Value<int?> startOdometerKm,
  Value<int?> endOdometerKm,
  required double distanceKm,
  required DateTime startTime,
  Value<DateTime?> endTime,
  Value<int> durationSeconds,
  Value<double?> avgSpeedKmh,
  Value<double?> maxSpeedKmh,
  Value<bool> isGpsTracked,
  Value<String?> notes,
  Value<String?> photoPaths,
  required DateTime createdAt,
});
typedef $$TripsTableUpdateCompanionBuilder = TripsCompanion Function({
  Value<int> id,
  Value<int> motorcycleId,
  Value<String> title,
  Value<String> category,
  Value<String?> origin,
  Value<String?> destination,
  Value<int?> startOdometerKm,
  Value<int?> endOdometerKm,
  Value<double> distanceKm,
  Value<DateTime> startTime,
  Value<DateTime?> endTime,
  Value<int> durationSeconds,
  Value<double?> avgSpeedKmh,
  Value<double?> maxSpeedKmh,
  Value<bool> isGpsTracked,
  Value<String?> notes,
  Value<String?> photoPaths,
  Value<DateTime> createdAt,
});

final class $$TripsTableReferences
    extends BaseReferences<_$AppDatabase, $TripsTable, Trip> {
  $$TripsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MotorcyclesTable _motorcycleIdTable(_$AppDatabase db) =>
      db.motorcycles.createAlias(
          $_aliasNameGenerator(db.trips.motorcycleId, db.motorcycles.id));

  $$MotorcyclesTableProcessedTableManager? get motorcycleId {
    if ($_item.motorcycleId == null) return null;
    final manager = $$MotorcyclesTableTableManager($_db, $_db.motorcycles)
        .filter((f) => f.id($_item.motorcycleId!));
    final item = $_typedResult.readTableOrNull(_motorcycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TripWaypointsTable, List<TripWaypoint>>
      _tripWaypointsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.tripWaypoints,
              aliasName:
                  $_aliasNameGenerator(db.trips.id, db.tripWaypoints.tripId));

  $$TripWaypointsTableProcessedTableManager get tripWaypointsRefs {
    final manager = $$TripWaypointsTableTableManager($_db, $_db.tripWaypoints)
        .filter((f) => f.tripId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_tripWaypointsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TripsTableFilterComposer extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get origin => $composableBuilder(
      column: $table.origin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get destination => $composableBuilder(
      column: $table.destination, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startOdometerKm => $composableBuilder(
      column: $table.startOdometerKm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endOdometerKm => $composableBuilder(
      column: $table.endOdometerKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get distanceKm => $composableBuilder(
      column: $table.distanceKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgSpeedKmh => $composableBuilder(
      column: $table.avgSpeedKmh, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxSpeedKmh => $composableBuilder(
      column: $table.maxSpeedKmh, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isGpsTracked => $composableBuilder(
      column: $table.isGpsTracked, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPaths => $composableBuilder(
      column: $table.photoPaths, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$MotorcyclesTableFilterComposer get motorcycleId {
    final $$MotorcyclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableFilterComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> tripWaypointsRefs(
      Expression<bool> Function($$TripWaypointsTableFilterComposer f) f) {
    final $$TripWaypointsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tripWaypoints,
        getReferencedColumn: (t) => t.tripId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TripWaypointsTableFilterComposer(
              $db: $db,
              $table: $db.tripWaypoints,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TripsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get origin => $composableBuilder(
      column: $table.origin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get destination => $composableBuilder(
      column: $table.destination, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startOdometerKm => $composableBuilder(
      column: $table.startOdometerKm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endOdometerKm => $composableBuilder(
      column: $table.endOdometerKm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get distanceKm => $composableBuilder(
      column: $table.distanceKm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgSpeedKmh => $composableBuilder(
      column: $table.avgSpeedKmh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxSpeedKmh => $composableBuilder(
      column: $table.maxSpeedKmh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isGpsTracked => $composableBuilder(
      column: $table.isGpsTracked,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPaths => $composableBuilder(
      column: $table.photoPaths, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$MotorcyclesTableOrderingComposer get motorcycleId {
    final $$MotorcyclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableOrderingComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TripsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get destination => $composableBuilder(
      column: $table.destination, builder: (column) => column);

  GeneratedColumn<int> get startOdometerKm => $composableBuilder(
      column: $table.startOdometerKm, builder: (column) => column);

  GeneratedColumn<int> get endOdometerKm => $composableBuilder(
      column: $table.endOdometerKm, builder: (column) => column);

  GeneratedColumn<double> get distanceKm => $composableBuilder(
      column: $table.distanceKm, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  GeneratedColumn<double> get avgSpeedKmh => $composableBuilder(
      column: $table.avgSpeedKmh, builder: (column) => column);

  GeneratedColumn<double> get maxSpeedKmh => $composableBuilder(
      column: $table.maxSpeedKmh, builder: (column) => column);

  GeneratedColumn<bool> get isGpsTracked => $composableBuilder(
      column: $table.isGpsTracked, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get photoPaths => $composableBuilder(
      column: $table.photoPaths, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MotorcyclesTableAnnotationComposer get motorcycleId {
    final $$MotorcyclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableAnnotationComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> tripWaypointsRefs<T extends Object>(
      Expression<T> Function($$TripWaypointsTableAnnotationComposer a) f) {
    final $$TripWaypointsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tripWaypoints,
        getReferencedColumn: (t) => t.tripId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TripWaypointsTableAnnotationComposer(
              $db: $db,
              $table: $db.tripWaypoints,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TripsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TripsTable,
    Trip,
    $$TripsTableFilterComposer,
    $$TripsTableOrderingComposer,
    $$TripsTableAnnotationComposer,
    $$TripsTableCreateCompanionBuilder,
    $$TripsTableUpdateCompanionBuilder,
    (Trip, $$TripsTableReferences),
    Trip,
    PrefetchHooks Function({bool motorcycleId, bool tripWaypointsRefs})> {
  $$TripsTableTableManager(_$AppDatabase db, $TripsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> motorcycleId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> origin = const Value.absent(),
            Value<String?> destination = const Value.absent(),
            Value<int?> startOdometerKm = const Value.absent(),
            Value<int?> endOdometerKm = const Value.absent(),
            Value<double> distanceKm = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime?> endTime = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
            Value<double?> avgSpeedKmh = const Value.absent(),
            Value<double?> maxSpeedKmh = const Value.absent(),
            Value<bool> isGpsTracked = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> photoPaths = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TripsCompanion(
            id: id,
            motorcycleId: motorcycleId,
            title: title,
            category: category,
            origin: origin,
            destination: destination,
            startOdometerKm: startOdometerKm,
            endOdometerKm: endOdometerKm,
            distanceKm: distanceKm,
            startTime: startTime,
            endTime: endTime,
            durationSeconds: durationSeconds,
            avgSpeedKmh: avgSpeedKmh,
            maxSpeedKmh: maxSpeedKmh,
            isGpsTracked: isGpsTracked,
            notes: notes,
            photoPaths: photoPaths,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int motorcycleId,
            required String title,
            required String category,
            Value<String?> origin = const Value.absent(),
            Value<String?> destination = const Value.absent(),
            Value<int?> startOdometerKm = const Value.absent(),
            Value<int?> endOdometerKm = const Value.absent(),
            required double distanceKm,
            required DateTime startTime,
            Value<DateTime?> endTime = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
            Value<double?> avgSpeedKmh = const Value.absent(),
            Value<double?> maxSpeedKmh = const Value.absent(),
            Value<bool> isGpsTracked = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> photoPaths = const Value.absent(),
            required DateTime createdAt,
          }) =>
              TripsCompanion.insert(
            id: id,
            motorcycleId: motorcycleId,
            title: title,
            category: category,
            origin: origin,
            destination: destination,
            startOdometerKm: startOdometerKm,
            endOdometerKm: endOdometerKm,
            distanceKm: distanceKm,
            startTime: startTime,
            endTime: endTime,
            durationSeconds: durationSeconds,
            avgSpeedKmh: avgSpeedKmh,
            maxSpeedKmh: maxSpeedKmh,
            isGpsTracked: isGpsTracked,
            notes: notes,
            photoPaths: photoPaths,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TripsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {motorcycleId = false, tripWaypointsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (tripWaypointsRefs) db.tripWaypoints
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (motorcycleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.motorcycleId,
                    referencedTable:
                        $$TripsTableReferences._motorcycleIdTable(db),
                    referencedColumn:
                        $$TripsTableReferences._motorcycleIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tripWaypointsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$TripsTableReferences._tripWaypointsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TripsTableReferences(db, table, p0)
                                .tripWaypointsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tripId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TripsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TripsTable,
    Trip,
    $$TripsTableFilterComposer,
    $$TripsTableOrderingComposer,
    $$TripsTableAnnotationComposer,
    $$TripsTableCreateCompanionBuilder,
    $$TripsTableUpdateCompanionBuilder,
    (Trip, $$TripsTableReferences),
    Trip,
    PrefetchHooks Function({bool motorcycleId, bool tripWaypointsRefs})>;
typedef $$TripWaypointsTableCreateCompanionBuilder = TripWaypointsCompanion
    Function({
  Value<int> id,
  required int tripId,
  required double latitude,
  required double longitude,
  Value<double?> altitude,
  Value<double?> speedKmh,
  Value<double?> heading,
  Value<double?> accuracyMeters,
  required DateTime recordedAt,
  required int sequence,
});
typedef $$TripWaypointsTableUpdateCompanionBuilder = TripWaypointsCompanion
    Function({
  Value<int> id,
  Value<int> tripId,
  Value<double> latitude,
  Value<double> longitude,
  Value<double?> altitude,
  Value<double?> speedKmh,
  Value<double?> heading,
  Value<double?> accuracyMeters,
  Value<DateTime> recordedAt,
  Value<int> sequence,
});

final class $$TripWaypointsTableReferences
    extends BaseReferences<_$AppDatabase, $TripWaypointsTable, TripWaypoint> {
  $$TripWaypointsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) => db.trips
      .createAlias($_aliasNameGenerator(db.tripWaypoints.tripId, db.trips.id));

  $$TripsTableProcessedTableManager? get tripId {
    if ($_item.tripId == null) return null;
    final manager = $$TripsTableTableManager($_db, $_db.trips)
        .filter((f) => f.id($_item.tripId!));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TripWaypointsTableFilterComposer
    extends Composer<_$AppDatabase, $TripWaypointsTable> {
  $$TripWaypointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get altitude => $composableBuilder(
      column: $table.altitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get speedKmh => $composableBuilder(
      column: $table.speedKmh, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get heading => $composableBuilder(
      column: $table.heading, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get accuracyMeters => $composableBuilder(
      column: $table.accuracyMeters,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sequence => $composableBuilder(
      column: $table.sequence, builder: (column) => ColumnFilters(column));

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tripId,
        referencedTable: $db.trips,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TripsTableFilterComposer(
              $db: $db,
              $table: $db.trips,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TripWaypointsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripWaypointsTable> {
  $$TripWaypointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get altitude => $composableBuilder(
      column: $table.altitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get speedKmh => $composableBuilder(
      column: $table.speedKmh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get heading => $composableBuilder(
      column: $table.heading, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get accuracyMeters => $composableBuilder(
      column: $table.accuracyMeters,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sequence => $composableBuilder(
      column: $table.sequence, builder: (column) => ColumnOrderings(column));

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tripId,
        referencedTable: $db.trips,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TripsTableOrderingComposer(
              $db: $db,
              $table: $db.trips,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TripWaypointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripWaypointsTable> {
  $$TripWaypointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get altitude =>
      $composableBuilder(column: $table.altitude, builder: (column) => column);

  GeneratedColumn<double> get speedKmh =>
      $composableBuilder(column: $table.speedKmh, builder: (column) => column);

  GeneratedColumn<double> get heading =>
      $composableBuilder(column: $table.heading, builder: (column) => column);

  GeneratedColumn<double> get accuracyMeters => $composableBuilder(
      column: $table.accuracyMeters, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  GeneratedColumn<int> get sequence =>
      $composableBuilder(column: $table.sequence, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tripId,
        referencedTable: $db.trips,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TripsTableAnnotationComposer(
              $db: $db,
              $table: $db.trips,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TripWaypointsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TripWaypointsTable,
    TripWaypoint,
    $$TripWaypointsTableFilterComposer,
    $$TripWaypointsTableOrderingComposer,
    $$TripWaypointsTableAnnotationComposer,
    $$TripWaypointsTableCreateCompanionBuilder,
    $$TripWaypointsTableUpdateCompanionBuilder,
    (TripWaypoint, $$TripWaypointsTableReferences),
    TripWaypoint,
    PrefetchHooks Function({bool tripId})> {
  $$TripWaypointsTableTableManager(_$AppDatabase db, $TripWaypointsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripWaypointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripWaypointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripWaypointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> tripId = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<double?> altitude = const Value.absent(),
            Value<double?> speedKmh = const Value.absent(),
            Value<double?> heading = const Value.absent(),
            Value<double?> accuracyMeters = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
            Value<int> sequence = const Value.absent(),
          }) =>
              TripWaypointsCompanion(
            id: id,
            tripId: tripId,
            latitude: latitude,
            longitude: longitude,
            altitude: altitude,
            speedKmh: speedKmh,
            heading: heading,
            accuracyMeters: accuracyMeters,
            recordedAt: recordedAt,
            sequence: sequence,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int tripId,
            required double latitude,
            required double longitude,
            Value<double?> altitude = const Value.absent(),
            Value<double?> speedKmh = const Value.absent(),
            Value<double?> heading = const Value.absent(),
            Value<double?> accuracyMeters = const Value.absent(),
            required DateTime recordedAt,
            required int sequence,
          }) =>
              TripWaypointsCompanion.insert(
            id: id,
            tripId: tripId,
            latitude: latitude,
            longitude: longitude,
            altitude: altitude,
            speedKmh: speedKmh,
            heading: heading,
            accuracyMeters: accuracyMeters,
            recordedAt: recordedAt,
            sequence: sequence,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TripWaypointsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({tripId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (tripId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tripId,
                    referencedTable:
                        $$TripWaypointsTableReferences._tripIdTable(db),
                    referencedColumn:
                        $$TripWaypointsTableReferences._tripIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TripWaypointsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TripWaypointsTable,
    TripWaypoint,
    $$TripWaypointsTableFilterComposer,
    $$TripWaypointsTableOrderingComposer,
    $$TripWaypointsTableAnnotationComposer,
    $$TripWaypointsTableCreateCompanionBuilder,
    $$TripWaypointsTableUpdateCompanionBuilder,
    (TripWaypoint, $$TripWaypointsTableReferences),
    TripWaypoint,
    PrefetchHooks Function({bool tripId})>;
typedef $$SavedLocationsTableCreateCompanionBuilder = SavedLocationsCompanion
    Function({
  Value<int> id,
  required String name,
  required String category,
  required double latitude,
  required double longitude,
  Value<String?> address,
  required DateTime createdAt,
});
typedef $$SavedLocationsTableUpdateCompanionBuilder = SavedLocationsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> category,
  Value<double> latitude,
  Value<double> longitude,
  Value<String?> address,
  Value<DateTime> createdAt,
});

class $$SavedLocationsTableFilterComposer
    extends Composer<_$AppDatabase, $SavedLocationsTable> {
  $$SavedLocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SavedLocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedLocationsTable> {
  $$SavedLocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SavedLocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedLocationsTable> {
  $$SavedLocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SavedLocationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SavedLocationsTable,
    SavedLocation,
    $$SavedLocationsTableFilterComposer,
    $$SavedLocationsTableOrderingComposer,
    $$SavedLocationsTableAnnotationComposer,
    $$SavedLocationsTableCreateCompanionBuilder,
    $$SavedLocationsTableUpdateCompanionBuilder,
    (
      SavedLocation,
      BaseReferences<_$AppDatabase, $SavedLocationsTable, SavedLocation>
    ),
    SavedLocation,
    PrefetchHooks Function()> {
  $$SavedLocationsTableTableManager(
      _$AppDatabase db, $SavedLocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedLocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedLocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedLocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SavedLocationsCompanion(
            id: id,
            name: name,
            category: category,
            latitude: latitude,
            longitude: longitude,
            address: address,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String category,
            required double latitude,
            required double longitude,
            Value<String?> address = const Value.absent(),
            required DateTime createdAt,
          }) =>
              SavedLocationsCompanion.insert(
            id: id,
            name: name,
            category: category,
            latitude: latitude,
            longitude: longitude,
            address: address,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SavedLocationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SavedLocationsTable,
    SavedLocation,
    $$SavedLocationsTableFilterComposer,
    $$SavedLocationsTableOrderingComposer,
    $$SavedLocationsTableAnnotationComposer,
    $$SavedLocationsTableCreateCompanionBuilder,
    $$SavedLocationsTableUpdateCompanionBuilder,
    (
      SavedLocation,
      BaseReferences<_$AppDatabase, $SavedLocationsTable, SavedLocation>
    ),
    SavedLocation,
    PrefetchHooks Function()>;
typedef $$SavedRoutesTableCreateCompanionBuilder = SavedRoutesCompanion
    Function({
  Value<int> id,
  required int motorcycleId,
  required String name,
  Value<String?> originName,
  Value<String?> destinationName,
  required double originLat,
  required double originLng,
  required double destLat,
  required double destLng,
  Value<String?> waypointsJson,
  Value<double> distanceKm,
  Value<int?> durationMinutes,
  Value<String?> notes,
  required DateTime createdAt,
});
typedef $$SavedRoutesTableUpdateCompanionBuilder = SavedRoutesCompanion
    Function({
  Value<int> id,
  Value<int> motorcycleId,
  Value<String> name,
  Value<String?> originName,
  Value<String?> destinationName,
  Value<double> originLat,
  Value<double> originLng,
  Value<double> destLat,
  Value<double> destLng,
  Value<String?> waypointsJson,
  Value<double> distanceKm,
  Value<int?> durationMinutes,
  Value<String?> notes,
  Value<DateTime> createdAt,
});

final class $$SavedRoutesTableReferences
    extends BaseReferences<_$AppDatabase, $SavedRoutesTable, SavedRoute> {
  $$SavedRoutesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MotorcyclesTable _motorcycleIdTable(_$AppDatabase db) =>
      db.motorcycles.createAlias(
          $_aliasNameGenerator(db.savedRoutes.motorcycleId, db.motorcycles.id));

  $$MotorcyclesTableProcessedTableManager? get motorcycleId {
    if ($_item.motorcycleId == null) return null;
    final manager = $$MotorcyclesTableTableManager($_db, $_db.motorcycles)
        .filter((f) => f.id($_item.motorcycleId!));
    final item = $_typedResult.readTableOrNull(_motorcycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SavedRoutesTableFilterComposer
    extends Composer<_$AppDatabase, $SavedRoutesTable> {
  $$SavedRoutesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originName => $composableBuilder(
      column: $table.originName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get destinationName => $composableBuilder(
      column: $table.destinationName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get originLat => $composableBuilder(
      column: $table.originLat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get originLng => $composableBuilder(
      column: $table.originLng, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get destLat => $composableBuilder(
      column: $table.destLat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get destLng => $composableBuilder(
      column: $table.destLng, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get waypointsJson => $composableBuilder(
      column: $table.waypointsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get distanceKm => $composableBuilder(
      column: $table.distanceKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$MotorcyclesTableFilterComposer get motorcycleId {
    final $$MotorcyclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableFilterComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SavedRoutesTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedRoutesTable> {
  $$SavedRoutesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originName => $composableBuilder(
      column: $table.originName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get destinationName => $composableBuilder(
      column: $table.destinationName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get originLat => $composableBuilder(
      column: $table.originLat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get originLng => $composableBuilder(
      column: $table.originLng, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get destLat => $composableBuilder(
      column: $table.destLat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get destLng => $composableBuilder(
      column: $table.destLng, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get waypointsJson => $composableBuilder(
      column: $table.waypointsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get distanceKm => $composableBuilder(
      column: $table.distanceKm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$MotorcyclesTableOrderingComposer get motorcycleId {
    final $$MotorcyclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableOrderingComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SavedRoutesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedRoutesTable> {
  $$SavedRoutesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get originName => $composableBuilder(
      column: $table.originName, builder: (column) => column);

  GeneratedColumn<String> get destinationName => $composableBuilder(
      column: $table.destinationName, builder: (column) => column);

  GeneratedColumn<double> get originLat =>
      $composableBuilder(column: $table.originLat, builder: (column) => column);

  GeneratedColumn<double> get originLng =>
      $composableBuilder(column: $table.originLng, builder: (column) => column);

  GeneratedColumn<double> get destLat =>
      $composableBuilder(column: $table.destLat, builder: (column) => column);

  GeneratedColumn<double> get destLng =>
      $composableBuilder(column: $table.destLng, builder: (column) => column);

  GeneratedColumn<String> get waypointsJson => $composableBuilder(
      column: $table.waypointsJson, builder: (column) => column);

  GeneratedColumn<double> get distanceKm => $composableBuilder(
      column: $table.distanceKm, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MotorcyclesTableAnnotationComposer get motorcycleId {
    final $$MotorcyclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableAnnotationComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SavedRoutesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SavedRoutesTable,
    SavedRoute,
    $$SavedRoutesTableFilterComposer,
    $$SavedRoutesTableOrderingComposer,
    $$SavedRoutesTableAnnotationComposer,
    $$SavedRoutesTableCreateCompanionBuilder,
    $$SavedRoutesTableUpdateCompanionBuilder,
    (SavedRoute, $$SavedRoutesTableReferences),
    SavedRoute,
    PrefetchHooks Function({bool motorcycleId})> {
  $$SavedRoutesTableTableManager(_$AppDatabase db, $SavedRoutesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedRoutesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedRoutesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedRoutesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> motorcycleId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> originName = const Value.absent(),
            Value<String?> destinationName = const Value.absent(),
            Value<double> originLat = const Value.absent(),
            Value<double> originLng = const Value.absent(),
            Value<double> destLat = const Value.absent(),
            Value<double> destLng = const Value.absent(),
            Value<String?> waypointsJson = const Value.absent(),
            Value<double> distanceKm = const Value.absent(),
            Value<int?> durationMinutes = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SavedRoutesCompanion(
            id: id,
            motorcycleId: motorcycleId,
            name: name,
            originName: originName,
            destinationName: destinationName,
            originLat: originLat,
            originLng: originLng,
            destLat: destLat,
            destLng: destLng,
            waypointsJson: waypointsJson,
            distanceKm: distanceKm,
            durationMinutes: durationMinutes,
            notes: notes,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int motorcycleId,
            required String name,
            Value<String?> originName = const Value.absent(),
            Value<String?> destinationName = const Value.absent(),
            required double originLat,
            required double originLng,
            required double destLat,
            required double destLng,
            Value<String?> waypointsJson = const Value.absent(),
            Value<double> distanceKm = const Value.absent(),
            Value<int?> durationMinutes = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
          }) =>
              SavedRoutesCompanion.insert(
            id: id,
            motorcycleId: motorcycleId,
            name: name,
            originName: originName,
            destinationName: destinationName,
            originLat: originLat,
            originLng: originLng,
            destLat: destLat,
            destLng: destLng,
            waypointsJson: waypointsJson,
            distanceKm: distanceKm,
            durationMinutes: durationMinutes,
            notes: notes,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SavedRoutesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({motorcycleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (motorcycleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.motorcycleId,
                    referencedTable:
                        $$SavedRoutesTableReferences._motorcycleIdTable(db),
                    referencedColumn:
                        $$SavedRoutesTableReferences._motorcycleIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SavedRoutesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SavedRoutesTable,
    SavedRoute,
    $$SavedRoutesTableFilterComposer,
    $$SavedRoutesTableOrderingComposer,
    $$SavedRoutesTableAnnotationComposer,
    $$SavedRoutesTableCreateCompanionBuilder,
    $$SavedRoutesTableUpdateCompanionBuilder,
    (SavedRoute, $$SavedRoutesTableReferences),
    SavedRoute,
    PrefetchHooks Function({bool motorcycleId})>;
typedef $$CvtConfigurationsTableCreateCompanionBuilder
    = CvtConfigurationsCompanion Function({
  Value<int> id,
  required int motorcycleId,
  required String name,
  Value<String?> pulleyBrandModel,
  Value<double?> flyballWeightGrams,
  Value<String?> flyballArrangement,
  Value<int?> centerSpringRpm,
  Value<int?> clutchSpringRpm,
  Value<String?> beltBrandPartNumber,
  Value<double?> pulleyWasherThicknessMm,
  Value<String?> clutchBellSpec,
  Value<String?> exhaustSpec,
  Value<String?> otherMods,
  required DateTime installedDate,
  Value<int?> installedOdometerKm,
  Value<bool> isActive,
  Value<bool> isArchived,
  Value<String?> notes,
  Value<String?> photoPaths,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$CvtConfigurationsTableUpdateCompanionBuilder
    = CvtConfigurationsCompanion Function({
  Value<int> id,
  Value<int> motorcycleId,
  Value<String> name,
  Value<String?> pulleyBrandModel,
  Value<double?> flyballWeightGrams,
  Value<String?> flyballArrangement,
  Value<int?> centerSpringRpm,
  Value<int?> clutchSpringRpm,
  Value<String?> beltBrandPartNumber,
  Value<double?> pulleyWasherThicknessMm,
  Value<String?> clutchBellSpec,
  Value<String?> exhaustSpec,
  Value<String?> otherMods,
  Value<DateTime> installedDate,
  Value<int?> installedOdometerKm,
  Value<bool> isActive,
  Value<bool> isArchived,
  Value<String?> notes,
  Value<String?> photoPaths,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$CvtConfigurationsTableReferences extends BaseReferences<
    _$AppDatabase, $CvtConfigurationsTable, CvtConfiguration> {
  $$CvtConfigurationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MotorcyclesTable _motorcycleIdTable(_$AppDatabase db) =>
      db.motorcycles.createAlias($_aliasNameGenerator(
          db.cvtConfigurations.motorcycleId, db.motorcycles.id));

  $$MotorcyclesTableProcessedTableManager? get motorcycleId {
    if ($_item.motorcycleId == null) return null;
    final manager = $$MotorcyclesTableTableManager($_db, $_db.motorcycles)
        .filter((f) => f.id($_item.motorcycleId!));
    final item = $_typedResult.readTableOrNull(_motorcycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$CvtPerformanceLogsTable, List<CvtPerformanceLog>>
      _cvtPerformanceLogsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.cvtPerformanceLogs,
              aliasName: $_aliasNameGenerator(db.cvtConfigurations.id,
                  db.cvtPerformanceLogs.configurationId));

  $$CvtPerformanceLogsTableProcessedTableManager get cvtPerformanceLogsRefs {
    final manager =
        $$CvtPerformanceLogsTableTableManager($_db, $_db.cvtPerformanceLogs)
            .filter((f) => f.configurationId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_cvtPerformanceLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CvtConfigurationsTableFilterComposer
    extends Composer<_$AppDatabase, $CvtConfigurationsTable> {
  $$CvtConfigurationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pulleyBrandModel => $composableBuilder(
      column: $table.pulleyBrandModel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get flyballWeightGrams => $composableBuilder(
      column: $table.flyballWeightGrams,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get flyballArrangement => $composableBuilder(
      column: $table.flyballArrangement,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get centerSpringRpm => $composableBuilder(
      column: $table.centerSpringRpm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get clutchSpringRpm => $composableBuilder(
      column: $table.clutchSpringRpm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get beltBrandPartNumber => $composableBuilder(
      column: $table.beltBrandPartNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pulleyWasherThicknessMm => $composableBuilder(
      column: $table.pulleyWasherThicknessMm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clutchBellSpec => $composableBuilder(
      column: $table.clutchBellSpec,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exhaustSpec => $composableBuilder(
      column: $table.exhaustSpec, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get otherMods => $composableBuilder(
      column: $table.otherMods, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get installedDate => $composableBuilder(
      column: $table.installedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get installedOdometerKm => $composableBuilder(
      column: $table.installedOdometerKm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPaths => $composableBuilder(
      column: $table.photoPaths, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$MotorcyclesTableFilterComposer get motorcycleId {
    final $$MotorcyclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableFilterComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> cvtPerformanceLogsRefs(
      Expression<bool> Function($$CvtPerformanceLogsTableFilterComposer f) f) {
    final $$CvtPerformanceLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.cvtPerformanceLogs,
        getReferencedColumn: (t) => t.configurationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CvtPerformanceLogsTableFilterComposer(
              $db: $db,
              $table: $db.cvtPerformanceLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CvtConfigurationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CvtConfigurationsTable> {
  $$CvtConfigurationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pulleyBrandModel => $composableBuilder(
      column: $table.pulleyBrandModel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get flyballWeightGrams => $composableBuilder(
      column: $table.flyballWeightGrams,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get flyballArrangement => $composableBuilder(
      column: $table.flyballArrangement,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get centerSpringRpm => $composableBuilder(
      column: $table.centerSpringRpm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get clutchSpringRpm => $composableBuilder(
      column: $table.clutchSpringRpm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get beltBrandPartNumber => $composableBuilder(
      column: $table.beltBrandPartNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pulleyWasherThicknessMm => $composableBuilder(
      column: $table.pulleyWasherThicknessMm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clutchBellSpec => $composableBuilder(
      column: $table.clutchBellSpec,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exhaustSpec => $composableBuilder(
      column: $table.exhaustSpec, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get otherMods => $composableBuilder(
      column: $table.otherMods, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get installedDate => $composableBuilder(
      column: $table.installedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get installedOdometerKm => $composableBuilder(
      column: $table.installedOdometerKm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPaths => $composableBuilder(
      column: $table.photoPaths, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$MotorcyclesTableOrderingComposer get motorcycleId {
    final $$MotorcyclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableOrderingComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CvtConfigurationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CvtConfigurationsTable> {
  $$CvtConfigurationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get pulleyBrandModel => $composableBuilder(
      column: $table.pulleyBrandModel, builder: (column) => column);

  GeneratedColumn<double> get flyballWeightGrams => $composableBuilder(
      column: $table.flyballWeightGrams, builder: (column) => column);

  GeneratedColumn<String> get flyballArrangement => $composableBuilder(
      column: $table.flyballArrangement, builder: (column) => column);

  GeneratedColumn<int> get centerSpringRpm => $composableBuilder(
      column: $table.centerSpringRpm, builder: (column) => column);

  GeneratedColumn<int> get clutchSpringRpm => $composableBuilder(
      column: $table.clutchSpringRpm, builder: (column) => column);

  GeneratedColumn<String> get beltBrandPartNumber => $composableBuilder(
      column: $table.beltBrandPartNumber, builder: (column) => column);

  GeneratedColumn<double> get pulleyWasherThicknessMm => $composableBuilder(
      column: $table.pulleyWasherThicknessMm, builder: (column) => column);

  GeneratedColumn<String> get clutchBellSpec => $composableBuilder(
      column: $table.clutchBellSpec, builder: (column) => column);

  GeneratedColumn<String> get exhaustSpec => $composableBuilder(
      column: $table.exhaustSpec, builder: (column) => column);

  GeneratedColumn<String> get otherMods =>
      $composableBuilder(column: $table.otherMods, builder: (column) => column);

  GeneratedColumn<DateTime> get installedDate => $composableBuilder(
      column: $table.installedDate, builder: (column) => column);

  GeneratedColumn<int> get installedOdometerKm => $composableBuilder(
      column: $table.installedOdometerKm, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get photoPaths => $composableBuilder(
      column: $table.photoPaths, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MotorcyclesTableAnnotationComposer get motorcycleId {
    final $$MotorcyclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableAnnotationComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> cvtPerformanceLogsRefs<T extends Object>(
      Expression<T> Function($$CvtPerformanceLogsTableAnnotationComposer a) f) {
    final $$CvtPerformanceLogsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.cvtPerformanceLogs,
            getReferencedColumn: (t) => t.configurationId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CvtPerformanceLogsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.cvtPerformanceLogs,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$CvtConfigurationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CvtConfigurationsTable,
    CvtConfiguration,
    $$CvtConfigurationsTableFilterComposer,
    $$CvtConfigurationsTableOrderingComposer,
    $$CvtConfigurationsTableAnnotationComposer,
    $$CvtConfigurationsTableCreateCompanionBuilder,
    $$CvtConfigurationsTableUpdateCompanionBuilder,
    (CvtConfiguration, $$CvtConfigurationsTableReferences),
    CvtConfiguration,
    PrefetchHooks Function({bool motorcycleId, bool cvtPerformanceLogsRefs})> {
  $$CvtConfigurationsTableTableManager(
      _$AppDatabase db, $CvtConfigurationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CvtConfigurationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CvtConfigurationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CvtConfigurationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> motorcycleId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> pulleyBrandModel = const Value.absent(),
            Value<double?> flyballWeightGrams = const Value.absent(),
            Value<String?> flyballArrangement = const Value.absent(),
            Value<int?> centerSpringRpm = const Value.absent(),
            Value<int?> clutchSpringRpm = const Value.absent(),
            Value<String?> beltBrandPartNumber = const Value.absent(),
            Value<double?> pulleyWasherThicknessMm = const Value.absent(),
            Value<String?> clutchBellSpec = const Value.absent(),
            Value<String?> exhaustSpec = const Value.absent(),
            Value<String?> otherMods = const Value.absent(),
            Value<DateTime> installedDate = const Value.absent(),
            Value<int?> installedOdometerKm = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> photoPaths = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CvtConfigurationsCompanion(
            id: id,
            motorcycleId: motorcycleId,
            name: name,
            pulleyBrandModel: pulleyBrandModel,
            flyballWeightGrams: flyballWeightGrams,
            flyballArrangement: flyballArrangement,
            centerSpringRpm: centerSpringRpm,
            clutchSpringRpm: clutchSpringRpm,
            beltBrandPartNumber: beltBrandPartNumber,
            pulleyWasherThicknessMm: pulleyWasherThicknessMm,
            clutchBellSpec: clutchBellSpec,
            exhaustSpec: exhaustSpec,
            otherMods: otherMods,
            installedDate: installedDate,
            installedOdometerKm: installedOdometerKm,
            isActive: isActive,
            isArchived: isArchived,
            notes: notes,
            photoPaths: photoPaths,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int motorcycleId,
            required String name,
            Value<String?> pulleyBrandModel = const Value.absent(),
            Value<double?> flyballWeightGrams = const Value.absent(),
            Value<String?> flyballArrangement = const Value.absent(),
            Value<int?> centerSpringRpm = const Value.absent(),
            Value<int?> clutchSpringRpm = const Value.absent(),
            Value<String?> beltBrandPartNumber = const Value.absent(),
            Value<double?> pulleyWasherThicknessMm = const Value.absent(),
            Value<String?> clutchBellSpec = const Value.absent(),
            Value<String?> exhaustSpec = const Value.absent(),
            Value<String?> otherMods = const Value.absent(),
            required DateTime installedDate,
            Value<int?> installedOdometerKm = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> photoPaths = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              CvtConfigurationsCompanion.insert(
            id: id,
            motorcycleId: motorcycleId,
            name: name,
            pulleyBrandModel: pulleyBrandModel,
            flyballWeightGrams: flyballWeightGrams,
            flyballArrangement: flyballArrangement,
            centerSpringRpm: centerSpringRpm,
            clutchSpringRpm: clutchSpringRpm,
            beltBrandPartNumber: beltBrandPartNumber,
            pulleyWasherThicknessMm: pulleyWasherThicknessMm,
            clutchBellSpec: clutchBellSpec,
            exhaustSpec: exhaustSpec,
            otherMods: otherMods,
            installedDate: installedDate,
            installedOdometerKm: installedOdometerKm,
            isActive: isActive,
            isArchived: isArchived,
            notes: notes,
            photoPaths: photoPaths,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CvtConfigurationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {motorcycleId = false, cvtPerformanceLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (cvtPerformanceLogsRefs) db.cvtPerformanceLogs
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (motorcycleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.motorcycleId,
                    referencedTable: $$CvtConfigurationsTableReferences
                        ._motorcycleIdTable(db),
                    referencedColumn: $$CvtConfigurationsTableReferences
                        ._motorcycleIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cvtPerformanceLogsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$CvtConfigurationsTableReferences
                            ._cvtPerformanceLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CvtConfigurationsTableReferences(db, table, p0)
                                .cvtPerformanceLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.configurationId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CvtConfigurationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CvtConfigurationsTable,
    CvtConfiguration,
    $$CvtConfigurationsTableFilterComposer,
    $$CvtConfigurationsTableOrderingComposer,
    $$CvtConfigurationsTableAnnotationComposer,
    $$CvtConfigurationsTableCreateCompanionBuilder,
    $$CvtConfigurationsTableUpdateCompanionBuilder,
    (CvtConfiguration, $$CvtConfigurationsTableReferences),
    CvtConfiguration,
    PrefetchHooks Function({bool motorcycleId, bool cvtPerformanceLogsRefs})>;
typedef $$CvtPerformanceLogsTableCreateCompanionBuilder
    = CvtPerformanceLogsCompanion Function({
  Value<int> id,
  required int configurationId,
  required DateTime logDate,
  Value<int?> odometerKm,
  Value<int?> accelerationRating,
  Value<double?> topSpeedKmh,
  Value<int?> rpmObserved,
  Value<double?> fuelConsumptionKpl,
  Value<int?> vibrationRating,
  Value<int?> comfortRating,
  Value<String?> overallAssessment,
  Value<String?> notes,
  Value<bool> isMeasured,
  required DateTime createdAt,
});
typedef $$CvtPerformanceLogsTableUpdateCompanionBuilder
    = CvtPerformanceLogsCompanion Function({
  Value<int> id,
  Value<int> configurationId,
  Value<DateTime> logDate,
  Value<int?> odometerKm,
  Value<int?> accelerationRating,
  Value<double?> topSpeedKmh,
  Value<int?> rpmObserved,
  Value<double?> fuelConsumptionKpl,
  Value<int?> vibrationRating,
  Value<int?> comfortRating,
  Value<String?> overallAssessment,
  Value<String?> notes,
  Value<bool> isMeasured,
  Value<DateTime> createdAt,
});

final class $$CvtPerformanceLogsTableReferences extends BaseReferences<
    _$AppDatabase, $CvtPerformanceLogsTable, CvtPerformanceLog> {
  $$CvtPerformanceLogsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CvtConfigurationsTable _configurationIdTable(_$AppDatabase db) =>
      db.cvtConfigurations.createAlias($_aliasNameGenerator(
          db.cvtPerformanceLogs.configurationId, db.cvtConfigurations.id));

  $$CvtConfigurationsTableProcessedTableManager? get configurationId {
    if ($_item.configurationId == null) return null;
    final manager =
        $$CvtConfigurationsTableTableManager($_db, $_db.cvtConfigurations)
            .filter((f) => f.id($_item.configurationId!));
    final item = $_typedResult.readTableOrNull(_configurationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CvtPerformanceLogsTableFilterComposer
    extends Composer<_$AppDatabase, $CvtPerformanceLogsTable> {
  $$CvtPerformanceLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get logDate => $composableBuilder(
      column: $table.logDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get odometerKm => $composableBuilder(
      column: $table.odometerKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accelerationRating => $composableBuilder(
      column: $table.accelerationRating,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get topSpeedKmh => $composableBuilder(
      column: $table.topSpeedKmh, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rpmObserved => $composableBuilder(
      column: $table.rpmObserved, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fuelConsumptionKpl => $composableBuilder(
      column: $table.fuelConsumptionKpl,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get vibrationRating => $composableBuilder(
      column: $table.vibrationRating,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get comfortRating => $composableBuilder(
      column: $table.comfortRating, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overallAssessment => $composableBuilder(
      column: $table.overallAssessment,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isMeasured => $composableBuilder(
      column: $table.isMeasured, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CvtConfigurationsTableFilterComposer get configurationId {
    final $$CvtConfigurationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.configurationId,
        referencedTable: $db.cvtConfigurations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CvtConfigurationsTableFilterComposer(
              $db: $db,
              $table: $db.cvtConfigurations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CvtPerformanceLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $CvtPerformanceLogsTable> {
  $$CvtPerformanceLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get logDate => $composableBuilder(
      column: $table.logDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get odometerKm => $composableBuilder(
      column: $table.odometerKm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accelerationRating => $composableBuilder(
      column: $table.accelerationRating,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get topSpeedKmh => $composableBuilder(
      column: $table.topSpeedKmh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rpmObserved => $composableBuilder(
      column: $table.rpmObserved, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fuelConsumptionKpl => $composableBuilder(
      column: $table.fuelConsumptionKpl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get vibrationRating => $composableBuilder(
      column: $table.vibrationRating,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get comfortRating => $composableBuilder(
      column: $table.comfortRating,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overallAssessment => $composableBuilder(
      column: $table.overallAssessment,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isMeasured => $composableBuilder(
      column: $table.isMeasured, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CvtConfigurationsTableOrderingComposer get configurationId {
    final $$CvtConfigurationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.configurationId,
        referencedTable: $db.cvtConfigurations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CvtConfigurationsTableOrderingComposer(
              $db: $db,
              $table: $db.cvtConfigurations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CvtPerformanceLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CvtPerformanceLogsTable> {
  $$CvtPerformanceLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<int> get odometerKm => $composableBuilder(
      column: $table.odometerKm, builder: (column) => column);

  GeneratedColumn<int> get accelerationRating => $composableBuilder(
      column: $table.accelerationRating, builder: (column) => column);

  GeneratedColumn<double> get topSpeedKmh => $composableBuilder(
      column: $table.topSpeedKmh, builder: (column) => column);

  GeneratedColumn<int> get rpmObserved => $composableBuilder(
      column: $table.rpmObserved, builder: (column) => column);

  GeneratedColumn<double> get fuelConsumptionKpl => $composableBuilder(
      column: $table.fuelConsumptionKpl, builder: (column) => column);

  GeneratedColumn<int> get vibrationRating => $composableBuilder(
      column: $table.vibrationRating, builder: (column) => column);

  GeneratedColumn<int> get comfortRating => $composableBuilder(
      column: $table.comfortRating, builder: (column) => column);

  GeneratedColumn<String> get overallAssessment => $composableBuilder(
      column: $table.overallAssessment, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isMeasured => $composableBuilder(
      column: $table.isMeasured, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CvtConfigurationsTableAnnotationComposer get configurationId {
    final $$CvtConfigurationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.configurationId,
            referencedTable: $db.cvtConfigurations,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CvtConfigurationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.cvtConfigurations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$CvtPerformanceLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CvtPerformanceLogsTable,
    CvtPerformanceLog,
    $$CvtPerformanceLogsTableFilterComposer,
    $$CvtPerformanceLogsTableOrderingComposer,
    $$CvtPerformanceLogsTableAnnotationComposer,
    $$CvtPerformanceLogsTableCreateCompanionBuilder,
    $$CvtPerformanceLogsTableUpdateCompanionBuilder,
    (CvtPerformanceLog, $$CvtPerformanceLogsTableReferences),
    CvtPerformanceLog,
    PrefetchHooks Function({bool configurationId})> {
  $$CvtPerformanceLogsTableTableManager(
      _$AppDatabase db, $CvtPerformanceLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CvtPerformanceLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CvtPerformanceLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CvtPerformanceLogsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> configurationId = const Value.absent(),
            Value<DateTime> logDate = const Value.absent(),
            Value<int?> odometerKm = const Value.absent(),
            Value<int?> accelerationRating = const Value.absent(),
            Value<double?> topSpeedKmh = const Value.absent(),
            Value<int?> rpmObserved = const Value.absent(),
            Value<double?> fuelConsumptionKpl = const Value.absent(),
            Value<int?> vibrationRating = const Value.absent(),
            Value<int?> comfortRating = const Value.absent(),
            Value<String?> overallAssessment = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isMeasured = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CvtPerformanceLogsCompanion(
            id: id,
            configurationId: configurationId,
            logDate: logDate,
            odometerKm: odometerKm,
            accelerationRating: accelerationRating,
            topSpeedKmh: topSpeedKmh,
            rpmObserved: rpmObserved,
            fuelConsumptionKpl: fuelConsumptionKpl,
            vibrationRating: vibrationRating,
            comfortRating: comfortRating,
            overallAssessment: overallAssessment,
            notes: notes,
            isMeasured: isMeasured,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int configurationId,
            required DateTime logDate,
            Value<int?> odometerKm = const Value.absent(),
            Value<int?> accelerationRating = const Value.absent(),
            Value<double?> topSpeedKmh = const Value.absent(),
            Value<int?> rpmObserved = const Value.absent(),
            Value<double?> fuelConsumptionKpl = const Value.absent(),
            Value<int?> vibrationRating = const Value.absent(),
            Value<int?> comfortRating = const Value.absent(),
            Value<String?> overallAssessment = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isMeasured = const Value.absent(),
            required DateTime createdAt,
          }) =>
              CvtPerformanceLogsCompanion.insert(
            id: id,
            configurationId: configurationId,
            logDate: logDate,
            odometerKm: odometerKm,
            accelerationRating: accelerationRating,
            topSpeedKmh: topSpeedKmh,
            rpmObserved: rpmObserved,
            fuelConsumptionKpl: fuelConsumptionKpl,
            vibrationRating: vibrationRating,
            comfortRating: comfortRating,
            overallAssessment: overallAssessment,
            notes: notes,
            isMeasured: isMeasured,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CvtPerformanceLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({configurationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (configurationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.configurationId,
                    referencedTable: $$CvtPerformanceLogsTableReferences
                        ._configurationIdTable(db),
                    referencedColumn: $$CvtPerformanceLogsTableReferences
                        ._configurationIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CvtPerformanceLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CvtPerformanceLogsTable,
    CvtPerformanceLog,
    $$CvtPerformanceLogsTableFilterComposer,
    $$CvtPerformanceLogsTableOrderingComposer,
    $$CvtPerformanceLogsTableAnnotationComposer,
    $$CvtPerformanceLogsTableCreateCompanionBuilder,
    $$CvtPerformanceLogsTableUpdateCompanionBuilder,
    (CvtPerformanceLog, $$CvtPerformanceLogsTableReferences),
    CvtPerformanceLog,
    PrefetchHooks Function({bool configurationId})>;
typedef $$PartsCatalogTableCreateCompanionBuilder = PartsCatalogCompanion
    Function({
  Value<int> id,
  required String partNumber,
  required String officialName,
  Value<String?> description,
  required String category,
  required String assemblyName,
  Value<String?> diagramNumber,
  Value<int?> referenceNumber,
  Value<int> standardQuantity,
  Value<String?> supersededPartNumber,
  Value<String?> remarks,
  Value<int?> maintenanceItemId,
  Value<String?> imageAssetPath,
  required String createdAt,
});
typedef $$PartsCatalogTableUpdateCompanionBuilder = PartsCatalogCompanion
    Function({
  Value<int> id,
  Value<String> partNumber,
  Value<String> officialName,
  Value<String?> description,
  Value<String> category,
  Value<String> assemblyName,
  Value<String?> diagramNumber,
  Value<int?> referenceNumber,
  Value<int> standardQuantity,
  Value<String?> supersededPartNumber,
  Value<String?> remarks,
  Value<int?> maintenanceItemId,
  Value<String?> imageAssetPath,
  Value<String> createdAt,
});

final class $$PartsCatalogTableReferences
    extends BaseReferences<_$AppDatabase, $PartsCatalogTable, PartsCatalogRow> {
  $$PartsCatalogTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MaintenanceItemsTable _maintenanceItemIdTable(_$AppDatabase db) =>
      db.maintenanceItems.createAlias($_aliasNameGenerator(
          db.partsCatalog.maintenanceItemId, db.maintenanceItems.id));

  $$MaintenanceItemsTableProcessedTableManager? get maintenanceItemId {
    if ($_item.maintenanceItemId == null) return null;
    final manager =
        $$MaintenanceItemsTableTableManager($_db, $_db.maintenanceItems)
            .filter((f) => f.id($_item.maintenanceItemId!));
    final item = $_typedResult.readTableOrNull(_maintenanceItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PartsCatalogCompatibilityTable,
      List<PartsCatalogCompatibilityRow>> _partsCatalogCompatibilityRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.partsCatalogCompatibility,
          aliasName: $_aliasNameGenerator(
              db.partsCatalog.id, db.partsCatalogCompatibility.partsCatalogId));

  $$PartsCatalogCompatibilityTableProcessedTableManager
      get partsCatalogCompatibilityRefs {
    final manager = $$PartsCatalogCompatibilityTableTableManager(
            $_db, $_db.partsCatalogCompatibility)
        .filter((f) => f.partsCatalogId.id($_item.id));

    final cache = $_typedResult
        .readTableOrNull(_partsCatalogCompatibilityRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PartsCatalogTableFilterComposer
    extends Composer<_$AppDatabase, $PartsCatalogTable> {
  $$PartsCatalogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get partNumber => $composableBuilder(
      column: $table.partNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get officialName => $composableBuilder(
      column: $table.officialName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assemblyName => $composableBuilder(
      column: $table.assemblyName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get diagramNumber => $composableBuilder(
      column: $table.diagramNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get standardQuantity => $composableBuilder(
      column: $table.standardQuantity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supersededPartNumber => $composableBuilder(
      column: $table.supersededPartNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remarks => $composableBuilder(
      column: $table.remarks, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageAssetPath => $composableBuilder(
      column: $table.imageAssetPath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$MaintenanceItemsTableFilterComposer get maintenanceItemId {
    final $$MaintenanceItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.maintenanceItemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> partsCatalogCompatibilityRefs(
      Expression<bool> Function(
              $$PartsCatalogCompatibilityTableFilterComposer f)
          f) {
    final $$PartsCatalogCompatibilityTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.partsCatalogCompatibility,
            getReferencedColumn: (t) => t.partsCatalogId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PartsCatalogCompatibilityTableFilterComposer(
                  $db: $db,
                  $table: $db.partsCatalogCompatibility,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$PartsCatalogTableOrderingComposer
    extends Composer<_$AppDatabase, $PartsCatalogTable> {
  $$PartsCatalogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get partNumber => $composableBuilder(
      column: $table.partNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get officialName => $composableBuilder(
      column: $table.officialName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assemblyName => $composableBuilder(
      column: $table.assemblyName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get diagramNumber => $composableBuilder(
      column: $table.diagramNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get standardQuantity => $composableBuilder(
      column: $table.standardQuantity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supersededPartNumber => $composableBuilder(
      column: $table.supersededPartNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remarks => $composableBuilder(
      column: $table.remarks, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageAssetPath => $composableBuilder(
      column: $table.imageAssetPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$MaintenanceItemsTableOrderingComposer get maintenanceItemId {
    final $$MaintenanceItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.maintenanceItemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableOrderingComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PartsCatalogTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartsCatalogTable> {
  $$PartsCatalogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get partNumber => $composableBuilder(
      column: $table.partNumber, builder: (column) => column);

  GeneratedColumn<String> get officialName => $composableBuilder(
      column: $table.officialName, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get assemblyName => $composableBuilder(
      column: $table.assemblyName, builder: (column) => column);

  GeneratedColumn<String> get diagramNumber => $composableBuilder(
      column: $table.diagramNumber, builder: (column) => column);

  GeneratedColumn<int> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber, builder: (column) => column);

  GeneratedColumn<int> get standardQuantity => $composableBuilder(
      column: $table.standardQuantity, builder: (column) => column);

  GeneratedColumn<String> get supersededPartNumber => $composableBuilder(
      column: $table.supersededPartNumber, builder: (column) => column);

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<String> get imageAssetPath => $composableBuilder(
      column: $table.imageAssetPath, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MaintenanceItemsTableAnnotationComposer get maintenanceItemId {
    final $$MaintenanceItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.maintenanceItemId,
        referencedTable: $db.maintenanceItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.maintenanceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> partsCatalogCompatibilityRefs<T extends Object>(
      Expression<T> Function(
              $$PartsCatalogCompatibilityTableAnnotationComposer a)
          f) {
    final $$PartsCatalogCompatibilityTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.partsCatalogCompatibility,
            getReferencedColumn: (t) => t.partsCatalogId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PartsCatalogCompatibilityTableAnnotationComposer(
                  $db: $db,
                  $table: $db.partsCatalogCompatibility,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$PartsCatalogTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PartsCatalogTable,
    PartsCatalogRow,
    $$PartsCatalogTableFilterComposer,
    $$PartsCatalogTableOrderingComposer,
    $$PartsCatalogTableAnnotationComposer,
    $$PartsCatalogTableCreateCompanionBuilder,
    $$PartsCatalogTableUpdateCompanionBuilder,
    (PartsCatalogRow, $$PartsCatalogTableReferences),
    PartsCatalogRow,
    PrefetchHooks Function(
        {bool maintenanceItemId, bool partsCatalogCompatibilityRefs})> {
  $$PartsCatalogTableTableManager(_$AppDatabase db, $PartsCatalogTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartsCatalogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartsCatalogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartsCatalogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> partNumber = const Value.absent(),
            Value<String> officialName = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> assemblyName = const Value.absent(),
            Value<String?> diagramNumber = const Value.absent(),
            Value<int?> referenceNumber = const Value.absent(),
            Value<int> standardQuantity = const Value.absent(),
            Value<String?> supersededPartNumber = const Value.absent(),
            Value<String?> remarks = const Value.absent(),
            Value<int?> maintenanceItemId = const Value.absent(),
            Value<String?> imageAssetPath = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
          }) =>
              PartsCatalogCompanion(
            id: id,
            partNumber: partNumber,
            officialName: officialName,
            description: description,
            category: category,
            assemblyName: assemblyName,
            diagramNumber: diagramNumber,
            referenceNumber: referenceNumber,
            standardQuantity: standardQuantity,
            supersededPartNumber: supersededPartNumber,
            remarks: remarks,
            maintenanceItemId: maintenanceItemId,
            imageAssetPath: imageAssetPath,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String partNumber,
            required String officialName,
            Value<String?> description = const Value.absent(),
            required String category,
            required String assemblyName,
            Value<String?> diagramNumber = const Value.absent(),
            Value<int?> referenceNumber = const Value.absent(),
            Value<int> standardQuantity = const Value.absent(),
            Value<String?> supersededPartNumber = const Value.absent(),
            Value<String?> remarks = const Value.absent(),
            Value<int?> maintenanceItemId = const Value.absent(),
            Value<String?> imageAssetPath = const Value.absent(),
            required String createdAt,
          }) =>
              PartsCatalogCompanion.insert(
            id: id,
            partNumber: partNumber,
            officialName: officialName,
            description: description,
            category: category,
            assemblyName: assemblyName,
            diagramNumber: diagramNumber,
            referenceNumber: referenceNumber,
            standardQuantity: standardQuantity,
            supersededPartNumber: supersededPartNumber,
            remarks: remarks,
            maintenanceItemId: maintenanceItemId,
            imageAssetPath: imageAssetPath,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PartsCatalogTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {maintenanceItemId = false,
              partsCatalogCompatibilityRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (partsCatalogCompatibilityRefs) db.partsCatalogCompatibility
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (maintenanceItemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.maintenanceItemId,
                    referencedTable: $$PartsCatalogTableReferences
                        ._maintenanceItemIdTable(db),
                    referencedColumn: $$PartsCatalogTableReferences
                        ._maintenanceItemIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (partsCatalogCompatibilityRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$PartsCatalogTableReferences
                            ._partsCatalogCompatibilityRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PartsCatalogTableReferences(db, table, p0)
                                .partsCatalogCompatibilityRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.partsCatalogId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PartsCatalogTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PartsCatalogTable,
    PartsCatalogRow,
    $$PartsCatalogTableFilterComposer,
    $$PartsCatalogTableOrderingComposer,
    $$PartsCatalogTableAnnotationComposer,
    $$PartsCatalogTableCreateCompanionBuilder,
    $$PartsCatalogTableUpdateCompanionBuilder,
    (PartsCatalogRow, $$PartsCatalogTableReferences),
    PartsCatalogRow,
    PrefetchHooks Function(
        {bool maintenanceItemId, bool partsCatalogCompatibilityRefs})>;
typedef $$PartsCatalogImagesTableCreateCompanionBuilder
    = PartsCatalogImagesCompanion Function({
  Value<int> id,
  required String diagramCode,
  required String title,
  Value<String?> description,
  Value<String?> imageAssetPath,
  required String assemblyName,
});
typedef $$PartsCatalogImagesTableUpdateCompanionBuilder
    = PartsCatalogImagesCompanion Function({
  Value<int> id,
  Value<String> diagramCode,
  Value<String> title,
  Value<String?> description,
  Value<String?> imageAssetPath,
  Value<String> assemblyName,
});

class $$PartsCatalogImagesTableFilterComposer
    extends Composer<_$AppDatabase, $PartsCatalogImagesTable> {
  $$PartsCatalogImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get diagramCode => $composableBuilder(
      column: $table.diagramCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageAssetPath => $composableBuilder(
      column: $table.imageAssetPath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assemblyName => $composableBuilder(
      column: $table.assemblyName, builder: (column) => ColumnFilters(column));
}

class $$PartsCatalogImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $PartsCatalogImagesTable> {
  $$PartsCatalogImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get diagramCode => $composableBuilder(
      column: $table.diagramCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageAssetPath => $composableBuilder(
      column: $table.imageAssetPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assemblyName => $composableBuilder(
      column: $table.assemblyName,
      builder: (column) => ColumnOrderings(column));
}

class $$PartsCatalogImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartsCatalogImagesTable> {
  $$PartsCatalogImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get diagramCode => $composableBuilder(
      column: $table.diagramCode, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get imageAssetPath => $composableBuilder(
      column: $table.imageAssetPath, builder: (column) => column);

  GeneratedColumn<String> get assemblyName => $composableBuilder(
      column: $table.assemblyName, builder: (column) => column);
}

class $$PartsCatalogImagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PartsCatalogImagesTable,
    PartsCatalogImageRow,
    $$PartsCatalogImagesTableFilterComposer,
    $$PartsCatalogImagesTableOrderingComposer,
    $$PartsCatalogImagesTableAnnotationComposer,
    $$PartsCatalogImagesTableCreateCompanionBuilder,
    $$PartsCatalogImagesTableUpdateCompanionBuilder,
    (
      PartsCatalogImageRow,
      BaseReferences<_$AppDatabase, $PartsCatalogImagesTable,
          PartsCatalogImageRow>
    ),
    PartsCatalogImageRow,
    PrefetchHooks Function()> {
  $$PartsCatalogImagesTableTableManager(
      _$AppDatabase db, $PartsCatalogImagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartsCatalogImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartsCatalogImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartsCatalogImagesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> diagramCode = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> imageAssetPath = const Value.absent(),
            Value<String> assemblyName = const Value.absent(),
          }) =>
              PartsCatalogImagesCompanion(
            id: id,
            diagramCode: diagramCode,
            title: title,
            description: description,
            imageAssetPath: imageAssetPath,
            assemblyName: assemblyName,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String diagramCode,
            required String title,
            Value<String?> description = const Value.absent(),
            Value<String?> imageAssetPath = const Value.absent(),
            required String assemblyName,
          }) =>
              PartsCatalogImagesCompanion.insert(
            id: id,
            diagramCode: diagramCode,
            title: title,
            description: description,
            imageAssetPath: imageAssetPath,
            assemblyName: assemblyName,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PartsCatalogImagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PartsCatalogImagesTable,
    PartsCatalogImageRow,
    $$PartsCatalogImagesTableFilterComposer,
    $$PartsCatalogImagesTableOrderingComposer,
    $$PartsCatalogImagesTableAnnotationComposer,
    $$PartsCatalogImagesTableCreateCompanionBuilder,
    $$PartsCatalogImagesTableUpdateCompanionBuilder,
    (
      PartsCatalogImageRow,
      BaseReferences<_$AppDatabase, $PartsCatalogImagesTable,
          PartsCatalogImageRow>
    ),
    PartsCatalogImageRow,
    PrefetchHooks Function()>;
typedef $$PartsCatalogCompatibilityTableCreateCompanionBuilder
    = PartsCatalogCompatibilityCompanion Function({
  Value<int> id,
  required int partsCatalogId,
  required String modelName,
  required String modelCode,
  required int startYear,
  Value<int?> endYear,
  required String regionalVariant,
  Value<String?> notes,
});
typedef $$PartsCatalogCompatibilityTableUpdateCompanionBuilder
    = PartsCatalogCompatibilityCompanion Function({
  Value<int> id,
  Value<int> partsCatalogId,
  Value<String> modelName,
  Value<String> modelCode,
  Value<int> startYear,
  Value<int?> endYear,
  Value<String> regionalVariant,
  Value<String?> notes,
});

final class $$PartsCatalogCompatibilityTableReferences extends BaseReferences<
    _$AppDatabase,
    $PartsCatalogCompatibilityTable,
    PartsCatalogCompatibilityRow> {
  $$PartsCatalogCompatibilityTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PartsCatalogTable _partsCatalogIdTable(_$AppDatabase db) =>
      db.partsCatalog.createAlias($_aliasNameGenerator(
          db.partsCatalogCompatibility.partsCatalogId, db.partsCatalog.id));

  $$PartsCatalogTableProcessedTableManager? get partsCatalogId {
    if ($_item.partsCatalogId == null) return null;
    final manager = $$PartsCatalogTableTableManager($_db, $_db.partsCatalog)
        .filter((f) => f.id($_item.partsCatalogId!));
    final item = $_typedResult.readTableOrNull(_partsCatalogIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PartsCatalogCompatibilityTableFilterComposer
    extends Composer<_$AppDatabase, $PartsCatalogCompatibilityTable> {
  $$PartsCatalogCompatibilityTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modelName => $composableBuilder(
      column: $table.modelName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modelCode => $composableBuilder(
      column: $table.modelCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startYear => $composableBuilder(
      column: $table.startYear, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endYear => $composableBuilder(
      column: $table.endYear, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get regionalVariant => $composableBuilder(
      column: $table.regionalVariant,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$PartsCatalogTableFilterComposer get partsCatalogId {
    final $$PartsCatalogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partsCatalogId,
        referencedTable: $db.partsCatalog,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsCatalogTableFilterComposer(
              $db: $db,
              $table: $db.partsCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PartsCatalogCompatibilityTableOrderingComposer
    extends Composer<_$AppDatabase, $PartsCatalogCompatibilityTable> {
  $$PartsCatalogCompatibilityTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modelName => $composableBuilder(
      column: $table.modelName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modelCode => $composableBuilder(
      column: $table.modelCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startYear => $composableBuilder(
      column: $table.startYear, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endYear => $composableBuilder(
      column: $table.endYear, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get regionalVariant => $composableBuilder(
      column: $table.regionalVariant,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$PartsCatalogTableOrderingComposer get partsCatalogId {
    final $$PartsCatalogTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partsCatalogId,
        referencedTable: $db.partsCatalog,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsCatalogTableOrderingComposer(
              $db: $db,
              $table: $db.partsCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PartsCatalogCompatibilityTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartsCatalogCompatibilityTable> {
  $$PartsCatalogCompatibilityTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get modelName =>
      $composableBuilder(column: $table.modelName, builder: (column) => column);

  GeneratedColumn<String> get modelCode =>
      $composableBuilder(column: $table.modelCode, builder: (column) => column);

  GeneratedColumn<int> get startYear =>
      $composableBuilder(column: $table.startYear, builder: (column) => column);

  GeneratedColumn<int> get endYear =>
      $composableBuilder(column: $table.endYear, builder: (column) => column);

  GeneratedColumn<String> get regionalVariant => $composableBuilder(
      column: $table.regionalVariant, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$PartsCatalogTableAnnotationComposer get partsCatalogId {
    final $$PartsCatalogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partsCatalogId,
        referencedTable: $db.partsCatalog,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsCatalogTableAnnotationComposer(
              $db: $db,
              $table: $db.partsCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PartsCatalogCompatibilityTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PartsCatalogCompatibilityTable,
    PartsCatalogCompatibilityRow,
    $$PartsCatalogCompatibilityTableFilterComposer,
    $$PartsCatalogCompatibilityTableOrderingComposer,
    $$PartsCatalogCompatibilityTableAnnotationComposer,
    $$PartsCatalogCompatibilityTableCreateCompanionBuilder,
    $$PartsCatalogCompatibilityTableUpdateCompanionBuilder,
    (PartsCatalogCompatibilityRow, $$PartsCatalogCompatibilityTableReferences),
    PartsCatalogCompatibilityRow,
    PrefetchHooks Function({bool partsCatalogId})> {
  $$PartsCatalogCompatibilityTableTableManager(
      _$AppDatabase db, $PartsCatalogCompatibilityTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartsCatalogCompatibilityTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$PartsCatalogCompatibilityTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartsCatalogCompatibilityTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> partsCatalogId = const Value.absent(),
            Value<String> modelName = const Value.absent(),
            Value<String> modelCode = const Value.absent(),
            Value<int> startYear = const Value.absent(),
            Value<int?> endYear = const Value.absent(),
            Value<String> regionalVariant = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              PartsCatalogCompatibilityCompanion(
            id: id,
            partsCatalogId: partsCatalogId,
            modelName: modelName,
            modelCode: modelCode,
            startYear: startYear,
            endYear: endYear,
            regionalVariant: regionalVariant,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int partsCatalogId,
            required String modelName,
            required String modelCode,
            required int startYear,
            Value<int?> endYear = const Value.absent(),
            required String regionalVariant,
            Value<String?> notes = const Value.absent(),
          }) =>
              PartsCatalogCompatibilityCompanion.insert(
            id: id,
            partsCatalogId: partsCatalogId,
            modelName: modelName,
            modelCode: modelCode,
            startYear: startYear,
            endYear: endYear,
            regionalVariant: regionalVariant,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PartsCatalogCompatibilityTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({partsCatalogId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (partsCatalogId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.partsCatalogId,
                    referencedTable: $$PartsCatalogCompatibilityTableReferences
                        ._partsCatalogIdTable(db),
                    referencedColumn: $$PartsCatalogCompatibilityTableReferences
                        ._partsCatalogIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PartsCatalogCompatibilityTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $PartsCatalogCompatibilityTable,
        PartsCatalogCompatibilityRow,
        $$PartsCatalogCompatibilityTableFilterComposer,
        $$PartsCatalogCompatibilityTableOrderingComposer,
        $$PartsCatalogCompatibilityTableAnnotationComposer,
        $$PartsCatalogCompatibilityTableCreateCompanionBuilder,
        $$PartsCatalogCompatibilityTableUpdateCompanionBuilder,
        (
          PartsCatalogCompatibilityRow,
          $$PartsCatalogCompatibilityTableReferences
        ),
        PartsCatalogCompatibilityRow,
        PrefetchHooks Function({bool partsCatalogId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MotorcyclesTableTableManager get motorcycles =>
      $$MotorcyclesTableTableManager(_db, _db.motorcycles);
  $$MaintenanceCategoriesTableTableManager get maintenanceCategories =>
      $$MaintenanceCategoriesTableTableManager(_db, _db.maintenanceCategories);
  $$MaintenanceItemsTableTableManager get maintenanceItems =>
      $$MaintenanceItemsTableTableManager(_db, _db.maintenanceItems);
  $$MaintenanceRulesTableTableManager get maintenanceRules =>
      $$MaintenanceRulesTableTableManager(_db, _db.maintenanceRules);
  $$MaintenanceRuleStepsTableTableManager get maintenanceRuleSteps =>
      $$MaintenanceRuleStepsTableTableManager(_db, _db.maintenanceRuleSteps);
  $$MaintenanceRecordsTableTableManager get maintenanceRecords =>
      $$MaintenanceRecordsTableTableManager(_db, _db.maintenanceRecords);
  $$OdometerLogsTableTableManager get odometerLogs =>
      $$OdometerLogsTableTableManager(_db, _db.odometerLogs);
  $$ComponentMeasurementsTableTableManager get componentMeasurements =>
      $$ComponentMeasurementsTableTableManager(_db, _db.componentMeasurements);
  $$ComponentSpecsTableTableManager get componentSpecs =>
      $$ComponentSpecsTableTableManager(_db, _db.componentSpecs);
  $$PartsTableTableManager get parts =>
      $$PartsTableTableManager(_db, _db.parts);
  $$MaintenanceRecordPartsTableTableManager get maintenanceRecordParts =>
      $$MaintenanceRecordPartsTableTableManager(
          _db, _db.maintenanceRecordParts);
  $$PartInstallationsTableTableManager get partInstallations =>
      $$PartInstallationsTableTableManager(_db, _db.partInstallations);
  $$MaintenanceRemindersTableTableManager get maintenanceReminders =>
      $$MaintenanceRemindersTableTableManager(_db, _db.maintenanceReminders);
  $$AttachmentsTableTableManager get attachments =>
      $$AttachmentsTableTableManager(_db, _db.attachments);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db, _db.trips);
  $$TripWaypointsTableTableManager get tripWaypoints =>
      $$TripWaypointsTableTableManager(_db, _db.tripWaypoints);
  $$SavedLocationsTableTableManager get savedLocations =>
      $$SavedLocationsTableTableManager(_db, _db.savedLocations);
  $$SavedRoutesTableTableManager get savedRoutes =>
      $$SavedRoutesTableTableManager(_db, _db.savedRoutes);
  $$CvtConfigurationsTableTableManager get cvtConfigurations =>
      $$CvtConfigurationsTableTableManager(_db, _db.cvtConfigurations);
  $$CvtPerformanceLogsTableTableManager get cvtPerformanceLogs =>
      $$CvtPerformanceLogsTableTableManager(_db, _db.cvtPerformanceLogs);
  $$PartsCatalogTableTableManager get partsCatalog =>
      $$PartsCatalogTableTableManager(_db, _db.partsCatalog);
  $$PartsCatalogImagesTableTableManager get partsCatalogImages =>
      $$PartsCatalogImagesTableTableManager(_db, _db.partsCatalogImages);
  $$PartsCatalogCompatibilityTableTableManager get partsCatalogCompatibility =>
      $$PartsCatalogCompatibilityTableTableManager(
          _db, _db.partsCatalogCompatibility);
}
