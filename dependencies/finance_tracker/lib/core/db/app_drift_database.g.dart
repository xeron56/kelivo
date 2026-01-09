// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_drift_database.dart';

// ignore_for_file: type=lint
class $DriftAccTypesTable extends DriftAccTypes
    with TableInfo<$DriftAccTypesTable, DriftAccType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftAccTypesTable(this.attachedDatabase, [this._alias]);
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
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<PrimaryType, int> primary =
      GeneratedColumn<int>('primary', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<PrimaryType>($DriftAccTypesTable.$converterprimary);
  static const VerificationMeta _addedDateMeta =
      const VerificationMeta('addedDate');
  @override
  late final GeneratedColumn<DateTime> addedDate = GeneratedColumn<DateTime>(
      'added_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updateDateMeta =
      const VerificationMeta('updateDate');
  @override
  late final GeneratedColumn<DateTime> updateDate = GeneratedColumn<DateTime>(
      'update_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _isEditableMeta =
      const VerificationMeta('isEditable');
  @override
  late final GeneratedColumn<bool> isEditable = GeneratedColumn<bool>(
      'is_editable', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_editable" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, primary, addedDate, updateDate, isEditable];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_acc_types';
  @override
  VerificationContext validateIntegrity(Insertable<DriftAccType> instance,
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
    if (data.containsKey('added_date')) {
      context.handle(_addedDateMeta,
          addedDate.isAcceptableOrUnknown(data['added_date']!, _addedDateMeta));
    }
    if (data.containsKey('update_date')) {
      context.handle(
          _updateDateMeta,
          updateDate.isAcceptableOrUnknown(
              data['update_date']!, _updateDateMeta));
    }
    if (data.containsKey('is_editable')) {
      context.handle(
          _isEditableMeta,
          isEditable.isAcceptableOrUnknown(
              data['is_editable']!, _isEditableMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftAccType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftAccType(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      primary: $DriftAccTypesTable.$converterprimary.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}primary'])!),
      addedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_date'])!,
      updateDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_date'])!,
      isEditable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_editable'])!,
    );
  }

  @override
  $DriftAccTypesTable createAlias(String alias) {
    return $DriftAccTypesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PrimaryType, int, int> $converterprimary =
      const EnumIndexConverter<PrimaryType>(PrimaryType.values);
}

class DriftAccType extends DataClass implements Insertable<DriftAccType> {
  final int id;
  final String name;
  final PrimaryType primary;
  final DateTime addedDate;
  final DateTime updateDate;
  final bool isEditable;
  const DriftAccType(
      {required this.id,
      required this.name,
      required this.primary,
      required this.addedDate,
      required this.updateDate,
      required this.isEditable});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['primary'] =
          Variable<int>($DriftAccTypesTable.$converterprimary.toSql(primary));
    }
    map['added_date'] = Variable<DateTime>(addedDate);
    map['update_date'] = Variable<DateTime>(updateDate);
    map['is_editable'] = Variable<bool>(isEditable);
    return map;
  }

  DriftAccTypesCompanion toCompanion(bool nullToAbsent) {
    return DriftAccTypesCompanion(
      id: Value(id),
      name: Value(name),
      primary: Value(primary),
      addedDate: Value(addedDate),
      updateDate: Value(updateDate),
      isEditable: Value(isEditable),
    );
  }

  factory DriftAccType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftAccType(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      primary: $DriftAccTypesTable.$converterprimary
          .fromJson(serializer.fromJson<int>(json['primary'])),
      addedDate: serializer.fromJson<DateTime>(json['addedDate']),
      updateDate: serializer.fromJson<DateTime>(json['updateDate']),
      isEditable: serializer.fromJson<bool>(json['isEditable']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'primary': serializer
          .toJson<int>($DriftAccTypesTable.$converterprimary.toJson(primary)),
      'addedDate': serializer.toJson<DateTime>(addedDate),
      'updateDate': serializer.toJson<DateTime>(updateDate),
      'isEditable': serializer.toJson<bool>(isEditable),
    };
  }

  DriftAccType copyWith(
          {int? id,
          String? name,
          PrimaryType? primary,
          DateTime? addedDate,
          DateTime? updateDate,
          bool? isEditable}) =>
      DriftAccType(
        id: id ?? this.id,
        name: name ?? this.name,
        primary: primary ?? this.primary,
        addedDate: addedDate ?? this.addedDate,
        updateDate: updateDate ?? this.updateDate,
        isEditable: isEditable ?? this.isEditable,
      );
  DriftAccType copyWithCompanion(DriftAccTypesCompanion data) {
    return DriftAccType(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      primary: data.primary.present ? data.primary.value : this.primary,
      addedDate: data.addedDate.present ? data.addedDate.value : this.addedDate,
      updateDate:
          data.updateDate.present ? data.updateDate.value : this.updateDate,
      isEditable:
          data.isEditable.present ? data.isEditable.value : this.isEditable,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftAccType(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('primary: $primary, ')
          ..write('addedDate: $addedDate, ')
          ..write('updateDate: $updateDate, ')
          ..write('isEditable: $isEditable')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, primary, addedDate, updateDate, isEditable);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftAccType &&
          other.id == this.id &&
          other.name == this.name &&
          other.primary == this.primary &&
          other.addedDate == this.addedDate &&
          other.updateDate == this.updateDate &&
          other.isEditable == this.isEditable);
}

class DriftAccTypesCompanion extends UpdateCompanion<DriftAccType> {
  final Value<int> id;
  final Value<String> name;
  final Value<PrimaryType> primary;
  final Value<DateTime> addedDate;
  final Value<DateTime> updateDate;
  final Value<bool> isEditable;
  const DriftAccTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.primary = const Value.absent(),
    this.addedDate = const Value.absent(),
    this.updateDate = const Value.absent(),
    this.isEditable = const Value.absent(),
  });
  DriftAccTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required PrimaryType primary,
    this.addedDate = const Value.absent(),
    this.updateDate = const Value.absent(),
    this.isEditable = const Value.absent(),
  })  : name = Value(name),
        primary = Value(primary);
  static Insertable<DriftAccType> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? primary,
    Expression<DateTime>? addedDate,
    Expression<DateTime>? updateDate,
    Expression<bool>? isEditable,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (primary != null) 'primary': primary,
      if (addedDate != null) 'added_date': addedDate,
      if (updateDate != null) 'update_date': updateDate,
      if (isEditable != null) 'is_editable': isEditable,
    });
  }

  DriftAccTypesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<PrimaryType>? primary,
      Value<DateTime>? addedDate,
      Value<DateTime>? updateDate,
      Value<bool>? isEditable}) {
    return DriftAccTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      primary: primary ?? this.primary,
      addedDate: addedDate ?? this.addedDate,
      updateDate: updateDate ?? this.updateDate,
      isEditable: isEditable ?? this.isEditable,
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
    if (primary.present) {
      map['primary'] = Variable<int>(
          $DriftAccTypesTable.$converterprimary.toSql(primary.value));
    }
    if (addedDate.present) {
      map['added_date'] = Variable<DateTime>(addedDate.value);
    }
    if (updateDate.present) {
      map['update_date'] = Variable<DateTime>(updateDate.value);
    }
    if (isEditable.present) {
      map['is_editable'] = Variable<bool>(isEditable.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftAccTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('primary: $primary, ')
          ..write('addedDate: $addedDate, ')
          ..write('updateDate: $updateDate, ')
          ..write('isEditable: $isEditable')
          ..write(')'))
        .toString();
  }
}

class $DriftProfilesTable extends DriftProfiles
    with TableInfo<$DriftProfilesTable, DriftProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftProfilesTable(this.attachedDatabase, [this._alias]);
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
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
      'alias', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 512),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _zipMeta = const VerificationMeta('zip');
  @override
  late final GeneratedColumn<String> zip = GeneratedColumn<String>(
      'zip', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 4, maxTextLength: 9),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 15),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _tinMeta = const VerificationMeta('tin');
  @override
  late final GeneratedColumn<String> tin = GeneratedColumn<String>(
      'tin', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 24),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _isSelectedMeta =
      const VerificationMeta('isSelected');
  @override
  late final GeneratedColumn<bool> isSelected = GeneratedColumn<bool>(
      'is_selected', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_selected" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  late final GeneratedColumnWithTypeConverter<Currency, int> currency =
      GeneratedColumn<int>('currency', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<Currency>($DriftProfilesTable.$convertercurrency);
  static const VerificationMeta _globalIDMeta =
      const VerificationMeta('globalID');
  @override
  late final GeneratedColumn<String> globalID = GeneratedColumn<String>(
      'global_i_d', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _isLocalMeta =
      const VerificationMeta('isLocal');
  @override
  late final GeneratedColumn<bool> isLocal = GeneratedColumn<bool>(
      'is_local', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_local" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _addedDateMeta =
      const VerificationMeta('addedDate');
  @override
  late final GeneratedColumn<DateTime> addedDate = GeneratedColumn<DateTime>(
      'added_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updateDateMeta =
      const VerificationMeta('updateDate');
  @override
  late final GeneratedColumn<DateTime> updateDate = GeneratedColumn<DateTime>(
      'update_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        alias,
        address,
        zip,
        email,
        phone,
        tin,
        isSelected,
        currency,
        globalID,
        isLocal,
        addedDate,
        updateDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<DriftProfile> instance,
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
    if (data.containsKey('alias')) {
      context.handle(
          _aliasMeta, alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('zip')) {
      context.handle(
          _zipMeta, zip.isAcceptableOrUnknown(data['zip']!, _zipMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('tin')) {
      context.handle(
          _tinMeta, tin.isAcceptableOrUnknown(data['tin']!, _tinMeta));
    }
    if (data.containsKey('is_selected')) {
      context.handle(
          _isSelectedMeta,
          isSelected.isAcceptableOrUnknown(
              data['is_selected']!, _isSelectedMeta));
    }
    if (data.containsKey('global_i_d')) {
      context.handle(_globalIDMeta,
          globalID.isAcceptableOrUnknown(data['global_i_d']!, _globalIDMeta));
    }
    if (data.containsKey('is_local')) {
      context.handle(_isLocalMeta,
          isLocal.isAcceptableOrUnknown(data['is_local']!, _isLocalMeta));
    }
    if (data.containsKey('added_date')) {
      context.handle(_addedDateMeta,
          addedDate.isAcceptableOrUnknown(data['added_date']!, _addedDateMeta));
    }
    if (data.containsKey('update_date')) {
      context.handle(
          _updateDateMeta,
          updateDate.isAcceptableOrUnknown(
              data['update_date']!, _updateDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      alias: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alias']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      zip: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}zip']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      tin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tin']),
      isSelected: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_selected'])!,
      currency: $DriftProfilesTable.$convertercurrency.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}currency'])!),
      globalID: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}global_i_d']),
      isLocal: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_local'])!,
      addedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_date'])!,
      updateDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_date'])!,
    );
  }

  @override
  $DriftProfilesTable createAlias(String alias) {
    return $DriftProfilesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Currency, int, int> $convertercurrency =
      const EnumIndexConverter<Currency>(Currency.values);
}

class DriftProfile extends DataClass implements Insertable<DriftProfile> {
  final int id;
  final String name;
  final String? alias;
  final String? address;
  final String? zip;
  final String? email;
  final String? phone;
  final String? tin;
  final bool isSelected;
  final Currency currency;
  final String? globalID;
  final bool isLocal;
  final DateTime addedDate;
  final DateTime updateDate;
  const DriftProfile(
      {required this.id,
      required this.name,
      this.alias,
      this.address,
      this.zip,
      this.email,
      this.phone,
      this.tin,
      required this.isSelected,
      required this.currency,
      this.globalID,
      required this.isLocal,
      required this.addedDate,
      required this.updateDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || alias != null) {
      map['alias'] = Variable<String>(alias);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || zip != null) {
      map['zip'] = Variable<String>(zip);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || tin != null) {
      map['tin'] = Variable<String>(tin);
    }
    map['is_selected'] = Variable<bool>(isSelected);
    {
      map['currency'] =
          Variable<int>($DriftProfilesTable.$convertercurrency.toSql(currency));
    }
    if (!nullToAbsent || globalID != null) {
      map['global_i_d'] = Variable<String>(globalID);
    }
    map['is_local'] = Variable<bool>(isLocal);
    map['added_date'] = Variable<DateTime>(addedDate);
    map['update_date'] = Variable<DateTime>(updateDate);
    return map;
  }

  DriftProfilesCompanion toCompanion(bool nullToAbsent) {
    return DriftProfilesCompanion(
      id: Value(id),
      name: Value(name),
      alias:
          alias == null && nullToAbsent ? const Value.absent() : Value(alias),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      zip: zip == null && nullToAbsent ? const Value.absent() : Value(zip),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      tin: tin == null && nullToAbsent ? const Value.absent() : Value(tin),
      isSelected: Value(isSelected),
      currency: Value(currency),
      globalID: globalID == null && nullToAbsent
          ? const Value.absent()
          : Value(globalID),
      isLocal: Value(isLocal),
      addedDate: Value(addedDate),
      updateDate: Value(updateDate),
    );
  }

  factory DriftProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftProfile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      alias: serializer.fromJson<String?>(json['alias']),
      address: serializer.fromJson<String?>(json['address']),
      zip: serializer.fromJson<String?>(json['zip']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      tin: serializer.fromJson<String?>(json['tin']),
      isSelected: serializer.fromJson<bool>(json['isSelected']),
      currency: $DriftProfilesTable.$convertercurrency
          .fromJson(serializer.fromJson<int>(json['currency'])),
      globalID: serializer.fromJson<String?>(json['globalID']),
      isLocal: serializer.fromJson<bool>(json['isLocal']),
      addedDate: serializer.fromJson<DateTime>(json['addedDate']),
      updateDate: serializer.fromJson<DateTime>(json['updateDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'alias': serializer.toJson<String?>(alias),
      'address': serializer.toJson<String?>(address),
      'zip': serializer.toJson<String?>(zip),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'tin': serializer.toJson<String?>(tin),
      'isSelected': serializer.toJson<bool>(isSelected),
      'currency': serializer
          .toJson<int>($DriftProfilesTable.$convertercurrency.toJson(currency)),
      'globalID': serializer.toJson<String?>(globalID),
      'isLocal': serializer.toJson<bool>(isLocal),
      'addedDate': serializer.toJson<DateTime>(addedDate),
      'updateDate': serializer.toJson<DateTime>(updateDate),
    };
  }

  DriftProfile copyWith(
          {int? id,
          String? name,
          Value<String?> alias = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> zip = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> tin = const Value.absent(),
          bool? isSelected,
          Currency? currency,
          Value<String?> globalID = const Value.absent(),
          bool? isLocal,
          DateTime? addedDate,
          DateTime? updateDate}) =>
      DriftProfile(
        id: id ?? this.id,
        name: name ?? this.name,
        alias: alias.present ? alias.value : this.alias,
        address: address.present ? address.value : this.address,
        zip: zip.present ? zip.value : this.zip,
        email: email.present ? email.value : this.email,
        phone: phone.present ? phone.value : this.phone,
        tin: tin.present ? tin.value : this.tin,
        isSelected: isSelected ?? this.isSelected,
        currency: currency ?? this.currency,
        globalID: globalID.present ? globalID.value : this.globalID,
        isLocal: isLocal ?? this.isLocal,
        addedDate: addedDate ?? this.addedDate,
        updateDate: updateDate ?? this.updateDate,
      );
  DriftProfile copyWithCompanion(DriftProfilesCompanion data) {
    return DriftProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      alias: data.alias.present ? data.alias.value : this.alias,
      address: data.address.present ? data.address.value : this.address,
      zip: data.zip.present ? data.zip.value : this.zip,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      tin: data.tin.present ? data.tin.value : this.tin,
      isSelected:
          data.isSelected.present ? data.isSelected.value : this.isSelected,
      currency: data.currency.present ? data.currency.value : this.currency,
      globalID: data.globalID.present ? data.globalID.value : this.globalID,
      isLocal: data.isLocal.present ? data.isLocal.value : this.isLocal,
      addedDate: data.addedDate.present ? data.addedDate.value : this.addedDate,
      updateDate:
          data.updateDate.present ? data.updateDate.value : this.updateDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('alias: $alias, ')
          ..write('address: $address, ')
          ..write('zip: $zip, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('tin: $tin, ')
          ..write('isSelected: $isSelected, ')
          ..write('currency: $currency, ')
          ..write('globalID: $globalID, ')
          ..write('isLocal: $isLocal, ')
          ..write('addedDate: $addedDate, ')
          ..write('updateDate: $updateDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, alias, address, zip, email, phone,
      tin, isSelected, currency, globalID, isLocal, addedDate, updateDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.alias == this.alias &&
          other.address == this.address &&
          other.zip == this.zip &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.tin == this.tin &&
          other.isSelected == this.isSelected &&
          other.currency == this.currency &&
          other.globalID == this.globalID &&
          other.isLocal == this.isLocal &&
          other.addedDate == this.addedDate &&
          other.updateDate == this.updateDate);
}

class DriftProfilesCompanion extends UpdateCompanion<DriftProfile> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> alias;
  final Value<String?> address;
  final Value<String?> zip;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> tin;
  final Value<bool> isSelected;
  final Value<Currency> currency;
  final Value<String?> globalID;
  final Value<bool> isLocal;
  final Value<DateTime> addedDate;
  final Value<DateTime> updateDate;
  const DriftProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.alias = const Value.absent(),
    this.address = const Value.absent(),
    this.zip = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.tin = const Value.absent(),
    this.isSelected = const Value.absent(),
    this.currency = const Value.absent(),
    this.globalID = const Value.absent(),
    this.isLocal = const Value.absent(),
    this.addedDate = const Value.absent(),
    this.updateDate = const Value.absent(),
  });
  DriftProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.alias = const Value.absent(),
    this.address = const Value.absent(),
    this.zip = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.tin = const Value.absent(),
    this.isSelected = const Value.absent(),
    required Currency currency,
    this.globalID = const Value.absent(),
    this.isLocal = const Value.absent(),
    this.addedDate = const Value.absent(),
    this.updateDate = const Value.absent(),
  })  : name = Value(name),
        currency = Value(currency);
  static Insertable<DriftProfile> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? alias,
    Expression<String>? address,
    Expression<String>? zip,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? tin,
    Expression<bool>? isSelected,
    Expression<int>? currency,
    Expression<String>? globalID,
    Expression<bool>? isLocal,
    Expression<DateTime>? addedDate,
    Expression<DateTime>? updateDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (alias != null) 'alias': alias,
      if (address != null) 'address': address,
      if (zip != null) 'zip': zip,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (tin != null) 'tin': tin,
      if (isSelected != null) 'is_selected': isSelected,
      if (currency != null) 'currency': currency,
      if (globalID != null) 'global_i_d': globalID,
      if (isLocal != null) 'is_local': isLocal,
      if (addedDate != null) 'added_date': addedDate,
      if (updateDate != null) 'update_date': updateDate,
    });
  }

  DriftProfilesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? alias,
      Value<String?>? address,
      Value<String?>? zip,
      Value<String?>? email,
      Value<String?>? phone,
      Value<String?>? tin,
      Value<bool>? isSelected,
      Value<Currency>? currency,
      Value<String?>? globalID,
      Value<bool>? isLocal,
      Value<DateTime>? addedDate,
      Value<DateTime>? updateDate}) {
    return DriftProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      alias: alias ?? this.alias,
      address: address ?? this.address,
      zip: zip ?? this.zip,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      tin: tin ?? this.tin,
      isSelected: isSelected ?? this.isSelected,
      currency: currency ?? this.currency,
      globalID: globalID ?? this.globalID,
      isLocal: isLocal ?? this.isLocal,
      addedDate: addedDate ?? this.addedDate,
      updateDate: updateDate ?? this.updateDate,
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
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (zip.present) {
      map['zip'] = Variable<String>(zip.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (tin.present) {
      map['tin'] = Variable<String>(tin.value);
    }
    if (isSelected.present) {
      map['is_selected'] = Variable<bool>(isSelected.value);
    }
    if (currency.present) {
      map['currency'] = Variable<int>(
          $DriftProfilesTable.$convertercurrency.toSql(currency.value));
    }
    if (globalID.present) {
      map['global_i_d'] = Variable<String>(globalID.value);
    }
    if (isLocal.present) {
      map['is_local'] = Variable<bool>(isLocal.value);
    }
    if (addedDate.present) {
      map['added_date'] = Variable<DateTime>(addedDate.value);
    }
    if (updateDate.present) {
      map['update_date'] = Variable<DateTime>(updateDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('alias: $alias, ')
          ..write('address: $address, ')
          ..write('zip: $zip, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('tin: $tin, ')
          ..write('isSelected: $isSelected, ')
          ..write('currency: $currency, ')
          ..write('globalID: $globalID, ')
          ..write('isLocal: $isLocal, ')
          ..write('addedDate: $addedDate, ')
          ..write('updateDate: $updateDate')
          ..write(')'))
        .toString();
  }
}

class $DriftAccountsTable extends DriftAccounts
    with TableInfo<$DriftAccountsTable, DriftAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftAccountsTable(this.attachedDatabase, [this._alias]);
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
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _openBalMeta =
      const VerificationMeta('openBal');
  @override
  late final GeneratedColumn<int> openBal = GeneratedColumn<int>(
      'open_bal', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _openDateMeta =
      const VerificationMeta('openDate');
  @override
  late final GeneratedColumn<DateTime> openDate = GeneratedColumn<DateTime>(
      'open_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _accTypeMeta =
      const VerificationMeta('accType');
  @override
  late final GeneratedColumn<int> accType = GeneratedColumn<int>(
      'acc_type', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_acc_types (id) ON DELETE CASCADE'));
  static const VerificationMeta _addedDateMeta =
      const VerificationMeta('addedDate');
  @override
  late final GeneratedColumn<DateTime> addedDate = GeneratedColumn<DateTime>(
      'added_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updateDateMeta =
      const VerificationMeta('updateDate');
  @override
  late final GeneratedColumn<DateTime> updateDate = GeneratedColumn<DateTime>(
      'update_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _isEditableMeta =
      const VerificationMeta('isEditable');
  @override
  late final GeneratedColumn<bool> isEditable = GeneratedColumn<bool>(
      'is_editable', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_editable" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _profileMeta =
      const VerificationMeta('profile');
  @override
  late final GeneratedColumn<int> profile = GeneratedColumn<int>(
      'profile', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_profiles (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        openBal,
        openDate,
        accType,
        addedDate,
        updateDate,
        isEditable,
        profile
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_accounts';
  @override
  VerificationContext validateIntegrity(Insertable<DriftAccount> instance,
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
    if (data.containsKey('open_bal')) {
      context.handle(_openBalMeta,
          openBal.isAcceptableOrUnknown(data['open_bal']!, _openBalMeta));
    }
    if (data.containsKey('open_date')) {
      context.handle(_openDateMeta,
          openDate.isAcceptableOrUnknown(data['open_date']!, _openDateMeta));
    }
    if (data.containsKey('acc_type')) {
      context.handle(_accTypeMeta,
          accType.isAcceptableOrUnknown(data['acc_type']!, _accTypeMeta));
    } else if (isInserting) {
      context.missing(_accTypeMeta);
    }
    if (data.containsKey('added_date')) {
      context.handle(_addedDateMeta,
          addedDate.isAcceptableOrUnknown(data['added_date']!, _addedDateMeta));
    }
    if (data.containsKey('update_date')) {
      context.handle(
          _updateDateMeta,
          updateDate.isAcceptableOrUnknown(
              data['update_date']!, _updateDateMeta));
    }
    if (data.containsKey('is_editable')) {
      context.handle(
          _isEditableMeta,
          isEditable.isAcceptableOrUnknown(
              data['is_editable']!, _isEditableMeta));
    }
    if (data.containsKey('profile')) {
      context.handle(_profileMeta,
          profile.isAcceptableOrUnknown(data['profile']!, _profileMeta));
    } else if (isInserting) {
      context.missing(_profileMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftAccount(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      openBal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}open_bal'])!,
      openDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}open_date'])!,
      accType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}acc_type'])!,
      addedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_date'])!,
      updateDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_date'])!,
      isEditable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_editable'])!,
      profile: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}profile'])!,
    );
  }

  @override
  $DriftAccountsTable createAlias(String alias) {
    return $DriftAccountsTable(attachedDatabase, alias);
  }
}

class DriftAccount extends DataClass implements Insertable<DriftAccount> {
  final int id;
  final String name;
  final int openBal;
  final DateTime openDate;
  final int accType;
  final DateTime addedDate;
  final DateTime updateDate;
  final bool isEditable;
  final int profile;
  const DriftAccount(
      {required this.id,
      required this.name,
      required this.openBal,
      required this.openDate,
      required this.accType,
      required this.addedDate,
      required this.updateDate,
      required this.isEditable,
      required this.profile});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['open_bal'] = Variable<int>(openBal);
    map['open_date'] = Variable<DateTime>(openDate);
    map['acc_type'] = Variable<int>(accType);
    map['added_date'] = Variable<DateTime>(addedDate);
    map['update_date'] = Variable<DateTime>(updateDate);
    map['is_editable'] = Variable<bool>(isEditable);
    map['profile'] = Variable<int>(profile);
    return map;
  }

  DriftAccountsCompanion toCompanion(bool nullToAbsent) {
    return DriftAccountsCompanion(
      id: Value(id),
      name: Value(name),
      openBal: Value(openBal),
      openDate: Value(openDate),
      accType: Value(accType),
      addedDate: Value(addedDate),
      updateDate: Value(updateDate),
      isEditable: Value(isEditable),
      profile: Value(profile),
    );
  }

  factory DriftAccount.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftAccount(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      openBal: serializer.fromJson<int>(json['openBal']),
      openDate: serializer.fromJson<DateTime>(json['openDate']),
      accType: serializer.fromJson<int>(json['accType']),
      addedDate: serializer.fromJson<DateTime>(json['addedDate']),
      updateDate: serializer.fromJson<DateTime>(json['updateDate']),
      isEditable: serializer.fromJson<bool>(json['isEditable']),
      profile: serializer.fromJson<int>(json['profile']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'openBal': serializer.toJson<int>(openBal),
      'openDate': serializer.toJson<DateTime>(openDate),
      'accType': serializer.toJson<int>(accType),
      'addedDate': serializer.toJson<DateTime>(addedDate),
      'updateDate': serializer.toJson<DateTime>(updateDate),
      'isEditable': serializer.toJson<bool>(isEditable),
      'profile': serializer.toJson<int>(profile),
    };
  }

  DriftAccount copyWith(
          {int? id,
          String? name,
          int? openBal,
          DateTime? openDate,
          int? accType,
          DateTime? addedDate,
          DateTime? updateDate,
          bool? isEditable,
          int? profile}) =>
      DriftAccount(
        id: id ?? this.id,
        name: name ?? this.name,
        openBal: openBal ?? this.openBal,
        openDate: openDate ?? this.openDate,
        accType: accType ?? this.accType,
        addedDate: addedDate ?? this.addedDate,
        updateDate: updateDate ?? this.updateDate,
        isEditable: isEditable ?? this.isEditable,
        profile: profile ?? this.profile,
      );
  DriftAccount copyWithCompanion(DriftAccountsCompanion data) {
    return DriftAccount(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      openBal: data.openBal.present ? data.openBal.value : this.openBal,
      openDate: data.openDate.present ? data.openDate.value : this.openDate,
      accType: data.accType.present ? data.accType.value : this.accType,
      addedDate: data.addedDate.present ? data.addedDate.value : this.addedDate,
      updateDate:
          data.updateDate.present ? data.updateDate.value : this.updateDate,
      isEditable:
          data.isEditable.present ? data.isEditable.value : this.isEditable,
      profile: data.profile.present ? data.profile.value : this.profile,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftAccount(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('openBal: $openBal, ')
          ..write('openDate: $openDate, ')
          ..write('accType: $accType, ')
          ..write('addedDate: $addedDate, ')
          ..write('updateDate: $updateDate, ')
          ..write('isEditable: $isEditable, ')
          ..write('profile: $profile')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, openBal, openDate, accType,
      addedDate, updateDate, isEditable, profile);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftAccount &&
          other.id == this.id &&
          other.name == this.name &&
          other.openBal == this.openBal &&
          other.openDate == this.openDate &&
          other.accType == this.accType &&
          other.addedDate == this.addedDate &&
          other.updateDate == this.updateDate &&
          other.isEditable == this.isEditable &&
          other.profile == this.profile);
}

class DriftAccountsCompanion extends UpdateCompanion<DriftAccount> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> openBal;
  final Value<DateTime> openDate;
  final Value<int> accType;
  final Value<DateTime> addedDate;
  final Value<DateTime> updateDate;
  final Value<bool> isEditable;
  final Value<int> profile;
  const DriftAccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.openBal = const Value.absent(),
    this.openDate = const Value.absent(),
    this.accType = const Value.absent(),
    this.addedDate = const Value.absent(),
    this.updateDate = const Value.absent(),
    this.isEditable = const Value.absent(),
    this.profile = const Value.absent(),
  });
  DriftAccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.openBal = const Value.absent(),
    this.openDate = const Value.absent(),
    required int accType,
    this.addedDate = const Value.absent(),
    this.updateDate = const Value.absent(),
    this.isEditable = const Value.absent(),
    required int profile,
  })  : name = Value(name),
        accType = Value(accType),
        profile = Value(profile);
  static Insertable<DriftAccount> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? openBal,
    Expression<DateTime>? openDate,
    Expression<int>? accType,
    Expression<DateTime>? addedDate,
    Expression<DateTime>? updateDate,
    Expression<bool>? isEditable,
    Expression<int>? profile,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (openBal != null) 'open_bal': openBal,
      if (openDate != null) 'open_date': openDate,
      if (accType != null) 'acc_type': accType,
      if (addedDate != null) 'added_date': addedDate,
      if (updateDate != null) 'update_date': updateDate,
      if (isEditable != null) 'is_editable': isEditable,
      if (profile != null) 'profile': profile,
    });
  }

  DriftAccountsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? openBal,
      Value<DateTime>? openDate,
      Value<int>? accType,
      Value<DateTime>? addedDate,
      Value<DateTime>? updateDate,
      Value<bool>? isEditable,
      Value<int>? profile}) {
    return DriftAccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      openBal: openBal ?? this.openBal,
      openDate: openDate ?? this.openDate,
      accType: accType ?? this.accType,
      addedDate: addedDate ?? this.addedDate,
      updateDate: updateDate ?? this.updateDate,
      isEditable: isEditable ?? this.isEditable,
      profile: profile ?? this.profile,
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
    if (openBal.present) {
      map['open_bal'] = Variable<int>(openBal.value);
    }
    if (openDate.present) {
      map['open_date'] = Variable<DateTime>(openDate.value);
    }
    if (accType.present) {
      map['acc_type'] = Variable<int>(accType.value);
    }
    if (addedDate.present) {
      map['added_date'] = Variable<DateTime>(addedDate.value);
    }
    if (updateDate.present) {
      map['update_date'] = Variable<DateTime>(updateDate.value);
    }
    if (isEditable.present) {
      map['is_editable'] = Variable<bool>(isEditable.value);
    }
    if (profile.present) {
      map['profile'] = Variable<int>(profile.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftAccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('openBal: $openBal, ')
          ..write('openDate: $openDate, ')
          ..write('accType: $accType, ')
          ..write('addedDate: $addedDate, ')
          ..write('updateDate: $updateDate, ')
          ..write('isEditable: $isEditable, ')
          ..write('profile: $profile')
          ..write(')'))
        .toString();
  }
}

class $DriftBudgetsTable extends DriftBudgets
    with TableInfo<$DriftBudgetsTable, DriftBudget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftBudgetsTable(this.attachedDatabase, [this._alias]);
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
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 128),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<BudgetInterval, int> interval =
      GeneratedColumn<int>('interval', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<BudgetInterval>($DriftBudgetsTable.$converterinterval);
  static const VerificationMeta _detailsMeta =
      const VerificationMeta('details');
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 128),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _startDayMeta =
      const VerificationMeta('startDay');
  @override
  late final GeneratedColumn<int> startDay = GeneratedColumn<int>(
      'start_day', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _profileMeta =
      const VerificationMeta('profile');
  @override
  late final GeneratedColumn<int> profile = GeneratedColumn<int>(
      'profile', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_profiles (id) ON DELETE CASCADE'));
  static const VerificationMeta _addedDateMeta =
      const VerificationMeta('addedDate');
  @override
  late final GeneratedColumn<DateTime> addedDate = GeneratedColumn<DateTime>(
      'added_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updateDateMeta =
      const VerificationMeta('updateDate');
  @override
  late final GeneratedColumn<DateTime> updateDate = GeneratedColumn<DateTime>(
      'update_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        interval,
        details,
        startDay,
        startDate,
        profile,
        addedDate,
        updateDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_budgets';
  @override
  VerificationContext validateIntegrity(Insertable<DriftBudget> instance,
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
    if (data.containsKey('details')) {
      context.handle(_detailsMeta,
          details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    } else if (isInserting) {
      context.missing(_detailsMeta);
    }
    if (data.containsKey('start_day')) {
      context.handle(_startDayMeta,
          startDay.isAcceptableOrUnknown(data['start_day']!, _startDayMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('profile')) {
      context.handle(_profileMeta,
          profile.isAcceptableOrUnknown(data['profile']!, _profileMeta));
    } else if (isInserting) {
      context.missing(_profileMeta);
    }
    if (data.containsKey('added_date')) {
      context.handle(_addedDateMeta,
          addedDate.isAcceptableOrUnknown(data['added_date']!, _addedDateMeta));
    }
    if (data.containsKey('update_date')) {
      context.handle(
          _updateDateMeta,
          updateDate.isAcceptableOrUnknown(
              data['update_date']!, _updateDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftBudget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftBudget(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      interval: $DriftBudgetsTable.$converterinterval.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval'])!),
      details: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details'])!,
      startDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_day'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      profile: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}profile'])!,
      addedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_date'])!,
      updateDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_date'])!,
    );
  }

  @override
  $DriftBudgetsTable createAlias(String alias) {
    return $DriftBudgetsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BudgetInterval, int, int> $converterinterval =
      const EnumIndexConverter<BudgetInterval>(BudgetInterval.values);
}

class DriftBudget extends DataClass implements Insertable<DriftBudget> {
  final int id;
  final String name;
  final BudgetInterval interval;
  final String details;
  final int startDay;
  final DateTime startDate;
  final int profile;
  final DateTime addedDate;
  final DateTime updateDate;
  const DriftBudget(
      {required this.id,
      required this.name,
      required this.interval,
      required this.details,
      required this.startDay,
      required this.startDate,
      required this.profile,
      required this.addedDate,
      required this.updateDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['interval'] =
          Variable<int>($DriftBudgetsTable.$converterinterval.toSql(interval));
    }
    map['details'] = Variable<String>(details);
    map['start_day'] = Variable<int>(startDay);
    map['start_date'] = Variable<DateTime>(startDate);
    map['profile'] = Variable<int>(profile);
    map['added_date'] = Variable<DateTime>(addedDate);
    map['update_date'] = Variable<DateTime>(updateDate);
    return map;
  }

  DriftBudgetsCompanion toCompanion(bool nullToAbsent) {
    return DriftBudgetsCompanion(
      id: Value(id),
      name: Value(name),
      interval: Value(interval),
      details: Value(details),
      startDay: Value(startDay),
      startDate: Value(startDate),
      profile: Value(profile),
      addedDate: Value(addedDate),
      updateDate: Value(updateDate),
    );
  }

  factory DriftBudget.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftBudget(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      interval: $DriftBudgetsTable.$converterinterval
          .fromJson(serializer.fromJson<int>(json['interval'])),
      details: serializer.fromJson<String>(json['details']),
      startDay: serializer.fromJson<int>(json['startDay']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      profile: serializer.fromJson<int>(json['profile']),
      addedDate: serializer.fromJson<DateTime>(json['addedDate']),
      updateDate: serializer.fromJson<DateTime>(json['updateDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'interval': serializer
          .toJson<int>($DriftBudgetsTable.$converterinterval.toJson(interval)),
      'details': serializer.toJson<String>(details),
      'startDay': serializer.toJson<int>(startDay),
      'startDate': serializer.toJson<DateTime>(startDate),
      'profile': serializer.toJson<int>(profile),
      'addedDate': serializer.toJson<DateTime>(addedDate),
      'updateDate': serializer.toJson<DateTime>(updateDate),
    };
  }

  DriftBudget copyWith(
          {int? id,
          String? name,
          BudgetInterval? interval,
          String? details,
          int? startDay,
          DateTime? startDate,
          int? profile,
          DateTime? addedDate,
          DateTime? updateDate}) =>
      DriftBudget(
        id: id ?? this.id,
        name: name ?? this.name,
        interval: interval ?? this.interval,
        details: details ?? this.details,
        startDay: startDay ?? this.startDay,
        startDate: startDate ?? this.startDate,
        profile: profile ?? this.profile,
        addedDate: addedDate ?? this.addedDate,
        updateDate: updateDate ?? this.updateDate,
      );
  DriftBudget copyWithCompanion(DriftBudgetsCompanion data) {
    return DriftBudget(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      interval: data.interval.present ? data.interval.value : this.interval,
      details: data.details.present ? data.details.value : this.details,
      startDay: data.startDay.present ? data.startDay.value : this.startDay,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      profile: data.profile.present ? data.profile.value : this.profile,
      addedDate: data.addedDate.present ? data.addedDate.value : this.addedDate,
      updateDate:
          data.updateDate.present ? data.updateDate.value : this.updateDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftBudget(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('interval: $interval, ')
          ..write('details: $details, ')
          ..write('startDay: $startDay, ')
          ..write('startDate: $startDate, ')
          ..write('profile: $profile, ')
          ..write('addedDate: $addedDate, ')
          ..write('updateDate: $updateDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, interval, details, startDay,
      startDate, profile, addedDate, updateDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftBudget &&
          other.id == this.id &&
          other.name == this.name &&
          other.interval == this.interval &&
          other.details == this.details &&
          other.startDay == this.startDay &&
          other.startDate == this.startDate &&
          other.profile == this.profile &&
          other.addedDate == this.addedDate &&
          other.updateDate == this.updateDate);
}

class DriftBudgetsCompanion extends UpdateCompanion<DriftBudget> {
  final Value<int> id;
  final Value<String> name;
  final Value<BudgetInterval> interval;
  final Value<String> details;
  final Value<int> startDay;
  final Value<DateTime> startDate;
  final Value<int> profile;
  final Value<DateTime> addedDate;
  final Value<DateTime> updateDate;
  const DriftBudgetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.interval = const Value.absent(),
    this.details = const Value.absent(),
    this.startDay = const Value.absent(),
    this.startDate = const Value.absent(),
    this.profile = const Value.absent(),
    this.addedDate = const Value.absent(),
    this.updateDate = const Value.absent(),
  });
  DriftBudgetsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required BudgetInterval interval,
    required String details,
    this.startDay = const Value.absent(),
    this.startDate = const Value.absent(),
    required int profile,
    this.addedDate = const Value.absent(),
    this.updateDate = const Value.absent(),
  })  : name = Value(name),
        interval = Value(interval),
        details = Value(details),
        profile = Value(profile);
  static Insertable<DriftBudget> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? interval,
    Expression<String>? details,
    Expression<int>? startDay,
    Expression<DateTime>? startDate,
    Expression<int>? profile,
    Expression<DateTime>? addedDate,
    Expression<DateTime>? updateDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (interval != null) 'interval': interval,
      if (details != null) 'details': details,
      if (startDay != null) 'start_day': startDay,
      if (startDate != null) 'start_date': startDate,
      if (profile != null) 'profile': profile,
      if (addedDate != null) 'added_date': addedDate,
      if (updateDate != null) 'update_date': updateDate,
    });
  }

  DriftBudgetsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<BudgetInterval>? interval,
      Value<String>? details,
      Value<int>? startDay,
      Value<DateTime>? startDate,
      Value<int>? profile,
      Value<DateTime>? addedDate,
      Value<DateTime>? updateDate}) {
    return DriftBudgetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      interval: interval ?? this.interval,
      details: details ?? this.details,
      startDay: startDay ?? this.startDay,
      startDate: startDate ?? this.startDate,
      profile: profile ?? this.profile,
      addedDate: addedDate ?? this.addedDate,
      updateDate: updateDate ?? this.updateDate,
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
    if (interval.present) {
      map['interval'] = Variable<int>(
          $DriftBudgetsTable.$converterinterval.toSql(interval.value));
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (startDay.present) {
      map['start_day'] = Variable<int>(startDay.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (profile.present) {
      map['profile'] = Variable<int>(profile.value);
    }
    if (addedDate.present) {
      map['added_date'] = Variable<DateTime>(addedDate.value);
    }
    if (updateDate.present) {
      map['update_date'] = Variable<DateTime>(updateDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftBudgetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('interval: $interval, ')
          ..write('details: $details, ')
          ..write('startDay: $startDay, ')
          ..write('startDate: $startDate, ')
          ..write('profile: $profile, ')
          ..write('addedDate: $addedDate, ')
          ..write('updateDate: $updateDate')
          ..write(')'))
        .toString();
  }
}

class $DriftProjectsTable extends DriftProjects
    with TableInfo<$DriftProjectsTable, DriftProject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftProjectsTable(this.attachedDatabase, [this._alias]);
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
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 128),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _profileMeta =
      const VerificationMeta('profile');
  @override
  late final GeneratedColumn<int> profile = GeneratedColumn<int>(
      'profile', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_profiles (id) ON DELETE CASCADE'));
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<ProjectStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<ProjectStatus>($DriftProjectsTable.$converterstatus);
  static const VerificationMeta _budgetMeta = const VerificationMeta('budget');
  @override
  late final GeneratedColumn<int> budget = GeneratedColumn<int>(
      'budget', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_budgets (id) ON DELETE SET NULL'));
  static const VerificationMeta _addedDateMeta =
      const VerificationMeta('addedDate');
  @override
  late final GeneratedColumn<DateTime> addedDate = GeneratedColumn<DateTime>(
      'added_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updateDateMeta =
      const VerificationMeta('updateDate');
  @override
  late final GeneratedColumn<DateTime> updateDate = GeneratedColumn<DateTime>(
      'update_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        startDate,
        profile,
        endDate,
        status,
        budget,
        addedDate,
        updateDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_projects';
  @override
  VerificationContext validateIntegrity(Insertable<DriftProject> instance,
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
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('profile')) {
      context.handle(_profileMeta,
          profile.isAcceptableOrUnknown(data['profile']!, _profileMeta));
    } else if (isInserting) {
      context.missing(_profileMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('budget')) {
      context.handle(_budgetMeta,
          budget.isAcceptableOrUnknown(data['budget']!, _budgetMeta));
    }
    if (data.containsKey('added_date')) {
      context.handle(_addedDateMeta,
          addedDate.isAcceptableOrUnknown(data['added_date']!, _addedDateMeta));
    }
    if (data.containsKey('update_date')) {
      context.handle(
          _updateDateMeta,
          updateDate.isAcceptableOrUnknown(
              data['update_date']!, _updateDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftProject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftProject(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      profile: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}profile'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      status: $DriftProjectsTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      budget: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}budget']),
      addedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_date'])!,
      updateDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_date'])!,
    );
  }

  @override
  $DriftProjectsTable createAlias(String alias) {
    return $DriftProjectsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ProjectStatus, int, int> $converterstatus =
      const EnumIndexConverter<ProjectStatus>(ProjectStatus.values);
}

class DriftProject extends DataClass implements Insertable<DriftProject> {
  final int id;
  final String name;
  final String? description;
  final DateTime? startDate;
  final int profile;
  final DateTime? endDate;
  final ProjectStatus status;
  final int? budget;
  final DateTime addedDate;
  final DateTime updateDate;
  const DriftProject(
      {required this.id,
      required this.name,
      this.description,
      this.startDate,
      required this.profile,
      this.endDate,
      required this.status,
      this.budget,
      required this.addedDate,
      required this.updateDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    map['profile'] = Variable<int>(profile);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    {
      map['status'] =
          Variable<int>($DriftProjectsTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || budget != null) {
      map['budget'] = Variable<int>(budget);
    }
    map['added_date'] = Variable<DateTime>(addedDate);
    map['update_date'] = Variable<DateTime>(updateDate);
    return map;
  }

  DriftProjectsCompanion toCompanion(bool nullToAbsent) {
    return DriftProjectsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      profile: Value(profile),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      status: Value(status),
      budget:
          budget == null && nullToAbsent ? const Value.absent() : Value(budget),
      addedDate: Value(addedDate),
      updateDate: Value(updateDate),
    );
  }

  factory DriftProject.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftProject(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      profile: serializer.fromJson<int>(json['profile']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      status: $DriftProjectsTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      budget: serializer.fromJson<int?>(json['budget']),
      addedDate: serializer.fromJson<DateTime>(json['addedDate']),
      updateDate: serializer.fromJson<DateTime>(json['updateDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'profile': serializer.toJson<int>(profile),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'status': serializer
          .toJson<int>($DriftProjectsTable.$converterstatus.toJson(status)),
      'budget': serializer.toJson<int?>(budget),
      'addedDate': serializer.toJson<DateTime>(addedDate),
      'updateDate': serializer.toJson<DateTime>(updateDate),
    };
  }

  DriftProject copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<DateTime?> startDate = const Value.absent(),
          int? profile,
          Value<DateTime?> endDate = const Value.absent(),
          ProjectStatus? status,
          Value<int?> budget = const Value.absent(),
          DateTime? addedDate,
          DateTime? updateDate}) =>
      DriftProject(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        startDate: startDate.present ? startDate.value : this.startDate,
        profile: profile ?? this.profile,
        endDate: endDate.present ? endDate.value : this.endDate,
        status: status ?? this.status,
        budget: budget.present ? budget.value : this.budget,
        addedDate: addedDate ?? this.addedDate,
        updateDate: updateDate ?? this.updateDate,
      );
  DriftProject copyWithCompanion(DriftProjectsCompanion data) {
    return DriftProject(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      profile: data.profile.present ? data.profile.value : this.profile,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      status: data.status.present ? data.status.value : this.status,
      budget: data.budget.present ? data.budget.value : this.budget,
      addedDate: data.addedDate.present ? data.addedDate.value : this.addedDate,
      updateDate:
          data.updateDate.present ? data.updateDate.value : this.updateDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftProject(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('startDate: $startDate, ')
          ..write('profile: $profile, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('budget: $budget, ')
          ..write('addedDate: $addedDate, ')
          ..write('updateDate: $updateDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, startDate, profile,
      endDate, status, budget, addedDate, updateDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftProject &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.startDate == this.startDate &&
          other.profile == this.profile &&
          other.endDate == this.endDate &&
          other.status == this.status &&
          other.budget == this.budget &&
          other.addedDate == this.addedDate &&
          other.updateDate == this.updateDate);
}

class DriftProjectsCompanion extends UpdateCompanion<DriftProject> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<DateTime?> startDate;
  final Value<int> profile;
  final Value<DateTime?> endDate;
  final Value<ProjectStatus> status;
  final Value<int?> budget;
  final Value<DateTime> addedDate;
  final Value<DateTime> updateDate;
  const DriftProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.startDate = const Value.absent(),
    this.profile = const Value.absent(),
    this.endDate = const Value.absent(),
    this.status = const Value.absent(),
    this.budget = const Value.absent(),
    this.addedDate = const Value.absent(),
    this.updateDate = const Value.absent(),
  });
  DriftProjectsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.startDate = const Value.absent(),
    required int profile,
    this.endDate = const Value.absent(),
    required ProjectStatus status,
    this.budget = const Value.absent(),
    this.addedDate = const Value.absent(),
    this.updateDate = const Value.absent(),
  })  : name = Value(name),
        profile = Value(profile),
        status = Value(status);
  static Insertable<DriftProject> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? startDate,
    Expression<int>? profile,
    Expression<DateTime>? endDate,
    Expression<int>? status,
    Expression<int>? budget,
    Expression<DateTime>? addedDate,
    Expression<DateTime>? updateDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (startDate != null) 'start_date': startDate,
      if (profile != null) 'profile': profile,
      if (endDate != null) 'end_date': endDate,
      if (status != null) 'status': status,
      if (budget != null) 'budget': budget,
      if (addedDate != null) 'added_date': addedDate,
      if (updateDate != null) 'update_date': updateDate,
    });
  }

  DriftProjectsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<DateTime?>? startDate,
      Value<int>? profile,
      Value<DateTime?>? endDate,
      Value<ProjectStatus>? status,
      Value<int?>? budget,
      Value<DateTime>? addedDate,
      Value<DateTime>? updateDate}) {
    return DriftProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      profile: profile ?? this.profile,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      budget: budget ?? this.budget,
      addedDate: addedDate ?? this.addedDate,
      updateDate: updateDate ?? this.updateDate,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (profile.present) {
      map['profile'] = Variable<int>(profile.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
          $DriftProjectsTable.$converterstatus.toSql(status.value));
    }
    if (budget.present) {
      map['budget'] = Variable<int>(budget.value);
    }
    if (addedDate.present) {
      map['added_date'] = Variable<DateTime>(addedDate.value);
    }
    if (updateDate.present) {
      map['update_date'] = Variable<DateTime>(updateDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('startDate: $startDate, ')
          ..write('profile: $profile, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('budget: $budget, ')
          ..write('addedDate: $addedDate, ')
          ..write('updateDate: $updateDate')
          ..write(')'))
        .toString();
  }
}

class $DriftTransactionsTable extends DriftTransactions
    with TableInfo<$DriftTransactionsTable, DriftTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _vchDateMeta =
      const VerificationMeta('vchDate');
  @override
  late final GeneratedColumn<DateTime> vchDate = GeneratedColumn<DateTime>(
      'vch_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _narrMeta = const VerificationMeta('narr');
  @override
  late final GeneratedColumn<String> narr = GeneratedColumn<String>(
      'narr', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 128),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _refNoMeta = const VerificationMeta('refNo');
  @override
  late final GeneratedColumn<String> refNo = GeneratedColumn<String>(
      'ref_no', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<VoucherType, int> vchType =
      GeneratedColumn<int>('vch_type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<VoucherType>(
              $DriftTransactionsTable.$convertervchType);
  static const VerificationMeta _drMeta = const VerificationMeta('dr');
  @override
  late final GeneratedColumn<int> dr = GeneratedColumn<int>(
      'dr', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_accounts (id) ON DELETE CASCADE'));
  static const VerificationMeta _crMeta = const VerificationMeta('cr');
  @override
  late final GeneratedColumn<int> cr = GeneratedColumn<int>(
      'cr', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_accounts (id) ON DELETE CASCADE'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _profileMeta =
      const VerificationMeta('profile');
  @override
  late final GeneratedColumn<int> profile = GeneratedColumn<int>(
      'profile', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_profiles (id) ON DELETE CASCADE'));
  static const VerificationMeta _projectMeta =
      const VerificationMeta('project');
  @override
  late final GeneratedColumn<int> project = GeneratedColumn<int>(
      'project', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_projects (id) ON DELETE SET NULL'));
  static const VerificationMeta _addedDateMeta =
      const VerificationMeta('addedDate');
  @override
  late final GeneratedColumn<DateTime> addedDate = GeneratedColumn<DateTime>(
      'added_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updateDateMeta =
      const VerificationMeta('updateDate');
  @override
  late final GeneratedColumn<DateTime> updateDate = GeneratedColumn<DateTime>(
      'update_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        vchDate,
        narr,
        refNo,
        vchType,
        dr,
        cr,
        amount,
        profile,
        project,
        addedDate,
        updateDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_transactions';
  @override
  VerificationContext validateIntegrity(Insertable<DriftTransaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vch_date')) {
      context.handle(_vchDateMeta,
          vchDate.isAcceptableOrUnknown(data['vch_date']!, _vchDateMeta));
    } else if (isInserting) {
      context.missing(_vchDateMeta);
    }
    if (data.containsKey('narr')) {
      context.handle(
          _narrMeta, narr.isAcceptableOrUnknown(data['narr']!, _narrMeta));
    } else if (isInserting) {
      context.missing(_narrMeta);
    }
    if (data.containsKey('ref_no')) {
      context.handle(
          _refNoMeta, refNo.isAcceptableOrUnknown(data['ref_no']!, _refNoMeta));
    } else if (isInserting) {
      context.missing(_refNoMeta);
    }
    if (data.containsKey('dr')) {
      context.handle(_drMeta, dr.isAcceptableOrUnknown(data['dr']!, _drMeta));
    } else if (isInserting) {
      context.missing(_drMeta);
    }
    if (data.containsKey('cr')) {
      context.handle(_crMeta, cr.isAcceptableOrUnknown(data['cr']!, _crMeta));
    } else if (isInserting) {
      context.missing(_crMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('profile')) {
      context.handle(_profileMeta,
          profile.isAcceptableOrUnknown(data['profile']!, _profileMeta));
    } else if (isInserting) {
      context.missing(_profileMeta);
    }
    if (data.containsKey('project')) {
      context.handle(_projectMeta,
          project.isAcceptableOrUnknown(data['project']!, _projectMeta));
    }
    if (data.containsKey('added_date')) {
      context.handle(_addedDateMeta,
          addedDate.isAcceptableOrUnknown(data['added_date']!, _addedDateMeta));
    }
    if (data.containsKey('update_date')) {
      context.handle(
          _updateDateMeta,
          updateDate.isAcceptableOrUnknown(
              data['update_date']!, _updateDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftTransaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      vchDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}vch_date'])!,
      narr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}narr'])!,
      refNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ref_no'])!,
      vchType: $DriftTransactionsTable.$convertervchType.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}vch_type'])!),
      dr: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dr'])!,
      cr: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cr'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      profile: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}profile'])!,
      project: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}project']),
      addedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_date'])!,
      updateDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_date'])!,
    );
  }

  @override
  $DriftTransactionsTable createAlias(String alias) {
    return $DriftTransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<VoucherType, int, int> $convertervchType =
      const EnumIndexConverter<VoucherType>(VoucherType.values);
}

class DriftTransaction extends DataClass
    implements Insertable<DriftTransaction> {
  final int id;
  final DateTime vchDate;
  final String narr;
  final String refNo;
  final VoucherType vchType;
  final int dr;
  final int cr;
  final int amount;
  final int profile;
  final int? project;
  final DateTime addedDate;
  final DateTime updateDate;
  const DriftTransaction(
      {required this.id,
      required this.vchDate,
      required this.narr,
      required this.refNo,
      required this.vchType,
      required this.dr,
      required this.cr,
      required this.amount,
      required this.profile,
      this.project,
      required this.addedDate,
      required this.updateDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vch_date'] = Variable<DateTime>(vchDate);
    map['narr'] = Variable<String>(narr);
    map['ref_no'] = Variable<String>(refNo);
    {
      map['vch_type'] = Variable<int>(
          $DriftTransactionsTable.$convertervchType.toSql(vchType));
    }
    map['dr'] = Variable<int>(dr);
    map['cr'] = Variable<int>(cr);
    map['amount'] = Variable<int>(amount);
    map['profile'] = Variable<int>(profile);
    if (!nullToAbsent || project != null) {
      map['project'] = Variable<int>(project);
    }
    map['added_date'] = Variable<DateTime>(addedDate);
    map['update_date'] = Variable<DateTime>(updateDate);
    return map;
  }

  DriftTransactionsCompanion toCompanion(bool nullToAbsent) {
    return DriftTransactionsCompanion(
      id: Value(id),
      vchDate: Value(vchDate),
      narr: Value(narr),
      refNo: Value(refNo),
      vchType: Value(vchType),
      dr: Value(dr),
      cr: Value(cr),
      amount: Value(amount),
      profile: Value(profile),
      project: project == null && nullToAbsent
          ? const Value.absent()
          : Value(project),
      addedDate: Value(addedDate),
      updateDate: Value(updateDate),
    );
  }

  factory DriftTransaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftTransaction(
      id: serializer.fromJson<int>(json['id']),
      vchDate: serializer.fromJson<DateTime>(json['vchDate']),
      narr: serializer.fromJson<String>(json['narr']),
      refNo: serializer.fromJson<String>(json['refNo']),
      vchType: $DriftTransactionsTable.$convertervchType
          .fromJson(serializer.fromJson<int>(json['vchType'])),
      dr: serializer.fromJson<int>(json['dr']),
      cr: serializer.fromJson<int>(json['cr']),
      amount: serializer.fromJson<int>(json['amount']),
      profile: serializer.fromJson<int>(json['profile']),
      project: serializer.fromJson<int?>(json['project']),
      addedDate: serializer.fromJson<DateTime>(json['addedDate']),
      updateDate: serializer.fromJson<DateTime>(json['updateDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vchDate': serializer.toJson<DateTime>(vchDate),
      'narr': serializer.toJson<String>(narr),
      'refNo': serializer.toJson<String>(refNo),
      'vchType': serializer.toJson<int>(
          $DriftTransactionsTable.$convertervchType.toJson(vchType)),
      'dr': serializer.toJson<int>(dr),
      'cr': serializer.toJson<int>(cr),
      'amount': serializer.toJson<int>(amount),
      'profile': serializer.toJson<int>(profile),
      'project': serializer.toJson<int?>(project),
      'addedDate': serializer.toJson<DateTime>(addedDate),
      'updateDate': serializer.toJson<DateTime>(updateDate),
    };
  }

  DriftTransaction copyWith(
          {int? id,
          DateTime? vchDate,
          String? narr,
          String? refNo,
          VoucherType? vchType,
          int? dr,
          int? cr,
          int? amount,
          int? profile,
          Value<int?> project = const Value.absent(),
          DateTime? addedDate,
          DateTime? updateDate}) =>
      DriftTransaction(
        id: id ?? this.id,
        vchDate: vchDate ?? this.vchDate,
        narr: narr ?? this.narr,
        refNo: refNo ?? this.refNo,
        vchType: vchType ?? this.vchType,
        dr: dr ?? this.dr,
        cr: cr ?? this.cr,
        amount: amount ?? this.amount,
        profile: profile ?? this.profile,
        project: project.present ? project.value : this.project,
        addedDate: addedDate ?? this.addedDate,
        updateDate: updateDate ?? this.updateDate,
      );
  DriftTransaction copyWithCompanion(DriftTransactionsCompanion data) {
    return DriftTransaction(
      id: data.id.present ? data.id.value : this.id,
      vchDate: data.vchDate.present ? data.vchDate.value : this.vchDate,
      narr: data.narr.present ? data.narr.value : this.narr,
      refNo: data.refNo.present ? data.refNo.value : this.refNo,
      vchType: data.vchType.present ? data.vchType.value : this.vchType,
      dr: data.dr.present ? data.dr.value : this.dr,
      cr: data.cr.present ? data.cr.value : this.cr,
      amount: data.amount.present ? data.amount.value : this.amount,
      profile: data.profile.present ? data.profile.value : this.profile,
      project: data.project.present ? data.project.value : this.project,
      addedDate: data.addedDate.present ? data.addedDate.value : this.addedDate,
      updateDate:
          data.updateDate.present ? data.updateDate.value : this.updateDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftTransaction(')
          ..write('id: $id, ')
          ..write('vchDate: $vchDate, ')
          ..write('narr: $narr, ')
          ..write('refNo: $refNo, ')
          ..write('vchType: $vchType, ')
          ..write('dr: $dr, ')
          ..write('cr: $cr, ')
          ..write('amount: $amount, ')
          ..write('profile: $profile, ')
          ..write('project: $project, ')
          ..write('addedDate: $addedDate, ')
          ..write('updateDate: $updateDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, vchDate, narr, refNo, vchType, dr, cr,
      amount, profile, project, addedDate, updateDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftTransaction &&
          other.id == this.id &&
          other.vchDate == this.vchDate &&
          other.narr == this.narr &&
          other.refNo == this.refNo &&
          other.vchType == this.vchType &&
          other.dr == this.dr &&
          other.cr == this.cr &&
          other.amount == this.amount &&
          other.profile == this.profile &&
          other.project == this.project &&
          other.addedDate == this.addedDate &&
          other.updateDate == this.updateDate);
}

class DriftTransactionsCompanion extends UpdateCompanion<DriftTransaction> {
  final Value<int> id;
  final Value<DateTime> vchDate;
  final Value<String> narr;
  final Value<String> refNo;
  final Value<VoucherType> vchType;
  final Value<int> dr;
  final Value<int> cr;
  final Value<int> amount;
  final Value<int> profile;
  final Value<int?> project;
  final Value<DateTime> addedDate;
  final Value<DateTime> updateDate;
  const DriftTransactionsCompanion({
    this.id = const Value.absent(),
    this.vchDate = const Value.absent(),
    this.narr = const Value.absent(),
    this.refNo = const Value.absent(),
    this.vchType = const Value.absent(),
    this.dr = const Value.absent(),
    this.cr = const Value.absent(),
    this.amount = const Value.absent(),
    this.profile = const Value.absent(),
    this.project = const Value.absent(),
    this.addedDate = const Value.absent(),
    this.updateDate = const Value.absent(),
  });
  DriftTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime vchDate,
    required String narr,
    required String refNo,
    required VoucherType vchType,
    required int dr,
    required int cr,
    this.amount = const Value.absent(),
    required int profile,
    this.project = const Value.absent(),
    this.addedDate = const Value.absent(),
    this.updateDate = const Value.absent(),
  })  : vchDate = Value(vchDate),
        narr = Value(narr),
        refNo = Value(refNo),
        vchType = Value(vchType),
        dr = Value(dr),
        cr = Value(cr),
        profile = Value(profile);
  static Insertable<DriftTransaction> custom({
    Expression<int>? id,
    Expression<DateTime>? vchDate,
    Expression<String>? narr,
    Expression<String>? refNo,
    Expression<int>? vchType,
    Expression<int>? dr,
    Expression<int>? cr,
    Expression<int>? amount,
    Expression<int>? profile,
    Expression<int>? project,
    Expression<DateTime>? addedDate,
    Expression<DateTime>? updateDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vchDate != null) 'vch_date': vchDate,
      if (narr != null) 'narr': narr,
      if (refNo != null) 'ref_no': refNo,
      if (vchType != null) 'vch_type': vchType,
      if (dr != null) 'dr': dr,
      if (cr != null) 'cr': cr,
      if (amount != null) 'amount': amount,
      if (profile != null) 'profile': profile,
      if (project != null) 'project': project,
      if (addedDate != null) 'added_date': addedDate,
      if (updateDate != null) 'update_date': updateDate,
    });
  }

  DriftTransactionsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? vchDate,
      Value<String>? narr,
      Value<String>? refNo,
      Value<VoucherType>? vchType,
      Value<int>? dr,
      Value<int>? cr,
      Value<int>? amount,
      Value<int>? profile,
      Value<int?>? project,
      Value<DateTime>? addedDate,
      Value<DateTime>? updateDate}) {
    return DriftTransactionsCompanion(
      id: id ?? this.id,
      vchDate: vchDate ?? this.vchDate,
      narr: narr ?? this.narr,
      refNo: refNo ?? this.refNo,
      vchType: vchType ?? this.vchType,
      dr: dr ?? this.dr,
      cr: cr ?? this.cr,
      amount: amount ?? this.amount,
      profile: profile ?? this.profile,
      project: project ?? this.project,
      addedDate: addedDate ?? this.addedDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vchDate.present) {
      map['vch_date'] = Variable<DateTime>(vchDate.value);
    }
    if (narr.present) {
      map['narr'] = Variable<String>(narr.value);
    }
    if (refNo.present) {
      map['ref_no'] = Variable<String>(refNo.value);
    }
    if (vchType.present) {
      map['vch_type'] = Variable<int>(
          $DriftTransactionsTable.$convertervchType.toSql(vchType.value));
    }
    if (dr.present) {
      map['dr'] = Variable<int>(dr.value);
    }
    if (cr.present) {
      map['cr'] = Variable<int>(cr.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (profile.present) {
      map['profile'] = Variable<int>(profile.value);
    }
    if (project.present) {
      map['project'] = Variable<int>(project.value);
    }
    if (addedDate.present) {
      map['added_date'] = Variable<DateTime>(addedDate.value);
    }
    if (updateDate.present) {
      map['update_date'] = Variable<DateTime>(updateDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('vchDate: $vchDate, ')
          ..write('narr: $narr, ')
          ..write('refNo: $refNo, ')
          ..write('vchType: $vchType, ')
          ..write('dr: $dr, ')
          ..write('cr: $cr, ')
          ..write('amount: $amount, ')
          ..write('profile: $profile, ')
          ..write('project: $project, ')
          ..write('addedDate: $addedDate, ')
          ..write('updateDate: $updateDate')
          ..write(')'))
        .toString();
  }
}

class $DriftUsersTable extends DriftUsers
    with TableInfo<$DriftUsersTable, DriftUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftUsersTable(this.attachedDatabase, [this._alias]);
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
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _deviceIDMeta =
      const VerificationMeta('deviceID');
  @override
  late final GeneratedColumn<String> deviceID = GeneratedColumn<String>(
      'device_i_d', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, deviceID, photoPath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_users';
  @override
  VerificationContext validateIntegrity(Insertable<DriftUser> instance,
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
    if (data.containsKey('device_i_d')) {
      context.handle(_deviceIDMeta,
          deviceID.isAcceptableOrUnknown(data['device_i_d']!, _deviceIDMeta));
    } else if (isInserting) {
      context.missing(_deviceIDMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    } else if (isInserting) {
      context.missing(_photoPathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftUser(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      deviceID: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_i_d'])!,
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path'])!,
    );
  }

  @override
  $DriftUsersTable createAlias(String alias) {
    return $DriftUsersTable(attachedDatabase, alias);
  }
}

class DriftUser extends DataClass implements Insertable<DriftUser> {
  final int id;
  final String name;
  final String deviceID;
  final String photoPath;
  const DriftUser(
      {required this.id,
      required this.name,
      required this.deviceID,
      required this.photoPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['device_i_d'] = Variable<String>(deviceID);
    map['photo_path'] = Variable<String>(photoPath);
    return map;
  }

  DriftUsersCompanion toCompanion(bool nullToAbsent) {
    return DriftUsersCompanion(
      id: Value(id),
      name: Value(name),
      deviceID: Value(deviceID),
      photoPath: Value(photoPath),
    );
  }

  factory DriftUser.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftUser(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      deviceID: serializer.fromJson<String>(json['deviceID']),
      photoPath: serializer.fromJson<String>(json['photoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'deviceID': serializer.toJson<String>(deviceID),
      'photoPath': serializer.toJson<String>(photoPath),
    };
  }

  DriftUser copyWith(
          {int? id, String? name, String? deviceID, String? photoPath}) =>
      DriftUser(
        id: id ?? this.id,
        name: name ?? this.name,
        deviceID: deviceID ?? this.deviceID,
        photoPath: photoPath ?? this.photoPath,
      );
  DriftUser copyWithCompanion(DriftUsersCompanion data) {
    return DriftUser(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      deviceID: data.deviceID.present ? data.deviceID.value : this.deviceID,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftUser(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('deviceID: $deviceID, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, deviceID, photoPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftUser &&
          other.id == this.id &&
          other.name == this.name &&
          other.deviceID == this.deviceID &&
          other.photoPath == this.photoPath);
}

class DriftUsersCompanion extends UpdateCompanion<DriftUser> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> deviceID;
  final Value<String> photoPath;
  const DriftUsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.deviceID = const Value.absent(),
    this.photoPath = const Value.absent(),
  });
  DriftUsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String deviceID,
    required String photoPath,
  })  : name = Value(name),
        deviceID = Value(deviceID),
        photoPath = Value(photoPath);
  static Insertable<DriftUser> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? deviceID,
    Expression<String>? photoPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (deviceID != null) 'device_i_d': deviceID,
      if (photoPath != null) 'photo_path': photoPath,
    });
  }

  DriftUsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? deviceID,
      Value<String>? photoPath}) {
    return DriftUsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      deviceID: deviceID ?? this.deviceID,
      photoPath: photoPath ?? this.photoPath,
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
    if (deviceID.present) {
      map['device_i_d'] = Variable<String>(deviceID.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftUsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('deviceID: $deviceID, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }
}

class $DriftBanksTable extends DriftBanks
    with TableInfo<$DriftBanksTable, DriftBank> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftBanksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _accountMeta =
      const VerificationMeta('account');
  @override
  late final GeneratedColumn<int> account = GeneratedColumn<int>(
      'account', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_accounts (id) ON DELETE CASCADE'));
  static const VerificationMeta _holderNameMeta =
      const VerificationMeta('holderName');
  @override
  late final GeneratedColumn<String> holderName = GeneratedColumn<String>(
      'holder_name', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _institutionMeta =
      const VerificationMeta('institution');
  @override
  late final GeneratedColumn<String> institution = GeneratedColumn<String>(
      'institution', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _branchMeta = const VerificationMeta('branch');
  @override
  late final GeneratedColumn<String> branch = GeneratedColumn<String>(
      'branch', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _branchCodeMeta =
      const VerificationMeta('branchCode');
  @override
  late final GeneratedColumn<String> branchCode = GeneratedColumn<String>(
      'branch_code', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _accountNoMeta =
      const VerificationMeta('accountNo');
  @override
  late final GeneratedColumn<String> accountNo = GeneratedColumn<String>(
      'account_no', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, account, holderName, institution, branch, branchCode, accountNo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_banks';
  @override
  VerificationContext validateIntegrity(Insertable<DriftBank> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account')) {
      context.handle(_accountMeta,
          account.isAcceptableOrUnknown(data['account']!, _accountMeta));
    } else if (isInserting) {
      context.missing(_accountMeta);
    }
    if (data.containsKey('holder_name')) {
      context.handle(
          _holderNameMeta,
          holderName.isAcceptableOrUnknown(
              data['holder_name']!, _holderNameMeta));
    }
    if (data.containsKey('institution')) {
      context.handle(
          _institutionMeta,
          institution.isAcceptableOrUnknown(
              data['institution']!, _institutionMeta));
    }
    if (data.containsKey('branch')) {
      context.handle(_branchMeta,
          branch.isAcceptableOrUnknown(data['branch']!, _branchMeta));
    }
    if (data.containsKey('branch_code')) {
      context.handle(
          _branchCodeMeta,
          branchCode.isAcceptableOrUnknown(
              data['branch_code']!, _branchCodeMeta));
    }
    if (data.containsKey('account_no')) {
      context.handle(_accountNoMeta,
          accountNo.isAcceptableOrUnknown(data['account_no']!, _accountNoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftBank map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftBank(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      account: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account'])!,
      holderName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}holder_name']),
      institution: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}institution']),
      branch: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}branch']),
      branchCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}branch_code']),
      accountNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_no']),
    );
  }

  @override
  $DriftBanksTable createAlias(String alias) {
    return $DriftBanksTable(attachedDatabase, alias);
  }
}

class DriftBank extends DataClass implements Insertable<DriftBank> {
  final int id;
  final int account;
  final String? holderName;
  final String? institution;
  final String? branch;
  final String? branchCode;
  final String? accountNo;
  const DriftBank(
      {required this.id,
      required this.account,
      this.holderName,
      this.institution,
      this.branch,
      this.branchCode,
      this.accountNo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account'] = Variable<int>(account);
    if (!nullToAbsent || holderName != null) {
      map['holder_name'] = Variable<String>(holderName);
    }
    if (!nullToAbsent || institution != null) {
      map['institution'] = Variable<String>(institution);
    }
    if (!nullToAbsent || branch != null) {
      map['branch'] = Variable<String>(branch);
    }
    if (!nullToAbsent || branchCode != null) {
      map['branch_code'] = Variable<String>(branchCode);
    }
    if (!nullToAbsent || accountNo != null) {
      map['account_no'] = Variable<String>(accountNo);
    }
    return map;
  }

  DriftBanksCompanion toCompanion(bool nullToAbsent) {
    return DriftBanksCompanion(
      id: Value(id),
      account: Value(account),
      holderName: holderName == null && nullToAbsent
          ? const Value.absent()
          : Value(holderName),
      institution: institution == null && nullToAbsent
          ? const Value.absent()
          : Value(institution),
      branch:
          branch == null && nullToAbsent ? const Value.absent() : Value(branch),
      branchCode: branchCode == null && nullToAbsent
          ? const Value.absent()
          : Value(branchCode),
      accountNo: accountNo == null && nullToAbsent
          ? const Value.absent()
          : Value(accountNo),
    );
  }

  factory DriftBank.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftBank(
      id: serializer.fromJson<int>(json['id']),
      account: serializer.fromJson<int>(json['account']),
      holderName: serializer.fromJson<String?>(json['holderName']),
      institution: serializer.fromJson<String?>(json['institution']),
      branch: serializer.fromJson<String?>(json['branch']),
      branchCode: serializer.fromJson<String?>(json['branchCode']),
      accountNo: serializer.fromJson<String?>(json['accountNo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'account': serializer.toJson<int>(account),
      'holderName': serializer.toJson<String?>(holderName),
      'institution': serializer.toJson<String?>(institution),
      'branch': serializer.toJson<String?>(branch),
      'branchCode': serializer.toJson<String?>(branchCode),
      'accountNo': serializer.toJson<String?>(accountNo),
    };
  }

  DriftBank copyWith(
          {int? id,
          int? account,
          Value<String?> holderName = const Value.absent(),
          Value<String?> institution = const Value.absent(),
          Value<String?> branch = const Value.absent(),
          Value<String?> branchCode = const Value.absent(),
          Value<String?> accountNo = const Value.absent()}) =>
      DriftBank(
        id: id ?? this.id,
        account: account ?? this.account,
        holderName: holderName.present ? holderName.value : this.holderName,
        institution: institution.present ? institution.value : this.institution,
        branch: branch.present ? branch.value : this.branch,
        branchCode: branchCode.present ? branchCode.value : this.branchCode,
        accountNo: accountNo.present ? accountNo.value : this.accountNo,
      );
  DriftBank copyWithCompanion(DriftBanksCompanion data) {
    return DriftBank(
      id: data.id.present ? data.id.value : this.id,
      account: data.account.present ? data.account.value : this.account,
      holderName:
          data.holderName.present ? data.holderName.value : this.holderName,
      institution:
          data.institution.present ? data.institution.value : this.institution,
      branch: data.branch.present ? data.branch.value : this.branch,
      branchCode:
          data.branchCode.present ? data.branchCode.value : this.branchCode,
      accountNo: data.accountNo.present ? data.accountNo.value : this.accountNo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftBank(')
          ..write('id: $id, ')
          ..write('account: $account, ')
          ..write('holderName: $holderName, ')
          ..write('institution: $institution, ')
          ..write('branch: $branch, ')
          ..write('branchCode: $branchCode, ')
          ..write('accountNo: $accountNo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, account, holderName, institution, branch, branchCode, accountNo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftBank &&
          other.id == this.id &&
          other.account == this.account &&
          other.holderName == this.holderName &&
          other.institution == this.institution &&
          other.branch == this.branch &&
          other.branchCode == this.branchCode &&
          other.accountNo == this.accountNo);
}

class DriftBanksCompanion extends UpdateCompanion<DriftBank> {
  final Value<int> id;
  final Value<int> account;
  final Value<String?> holderName;
  final Value<String?> institution;
  final Value<String?> branch;
  final Value<String?> branchCode;
  final Value<String?> accountNo;
  const DriftBanksCompanion({
    this.id = const Value.absent(),
    this.account = const Value.absent(),
    this.holderName = const Value.absent(),
    this.institution = const Value.absent(),
    this.branch = const Value.absent(),
    this.branchCode = const Value.absent(),
    this.accountNo = const Value.absent(),
  });
  DriftBanksCompanion.insert({
    this.id = const Value.absent(),
    required int account,
    this.holderName = const Value.absent(),
    this.institution = const Value.absent(),
    this.branch = const Value.absent(),
    this.branchCode = const Value.absent(),
    this.accountNo = const Value.absent(),
  }) : account = Value(account);
  static Insertable<DriftBank> custom({
    Expression<int>? id,
    Expression<int>? account,
    Expression<String>? holderName,
    Expression<String>? institution,
    Expression<String>? branch,
    Expression<String>? branchCode,
    Expression<String>? accountNo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (account != null) 'account': account,
      if (holderName != null) 'holder_name': holderName,
      if (institution != null) 'institution': institution,
      if (branch != null) 'branch': branch,
      if (branchCode != null) 'branch_code': branchCode,
      if (accountNo != null) 'account_no': accountNo,
    });
  }

  DriftBanksCompanion copyWith(
      {Value<int>? id,
      Value<int>? account,
      Value<String?>? holderName,
      Value<String?>? institution,
      Value<String?>? branch,
      Value<String?>? branchCode,
      Value<String?>? accountNo}) {
    return DriftBanksCompanion(
      id: id ?? this.id,
      account: account ?? this.account,
      holderName: holderName ?? this.holderName,
      institution: institution ?? this.institution,
      branch: branch ?? this.branch,
      branchCode: branchCode ?? this.branchCode,
      accountNo: accountNo ?? this.accountNo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (account.present) {
      map['account'] = Variable<int>(account.value);
    }
    if (holderName.present) {
      map['holder_name'] = Variable<String>(holderName.value);
    }
    if (institution.present) {
      map['institution'] = Variable<String>(institution.value);
    }
    if (branch.present) {
      map['branch'] = Variable<String>(branch.value);
    }
    if (branchCode.present) {
      map['branch_code'] = Variable<String>(branchCode.value);
    }
    if (accountNo.present) {
      map['account_no'] = Variable<String>(accountNo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftBanksCompanion(')
          ..write('id: $id, ')
          ..write('account: $account, ')
          ..write('holderName: $holderName, ')
          ..write('institution: $institution, ')
          ..write('branch: $branch, ')
          ..write('branchCode: $branchCode, ')
          ..write('accountNo: $accountNo')
          ..write(')'))
        .toString();
  }
}

class $DriftWalletsTable extends DriftWallets
    with TableInfo<$DriftWalletsTable, DriftWallet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftWalletsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _accountMeta =
      const VerificationMeta('account');
  @override
  late final GeneratedColumn<int> account = GeneratedColumn<int>(
      'account', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_accounts (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [id, account];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_wallets';
  @override
  VerificationContext validateIntegrity(Insertable<DriftWallet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account')) {
      context.handle(_accountMeta,
          account.isAcceptableOrUnknown(data['account']!, _accountMeta));
    } else if (isInserting) {
      context.missing(_accountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftWallet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftWallet(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      account: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account'])!,
    );
  }

  @override
  $DriftWalletsTable createAlias(String alias) {
    return $DriftWalletsTable(attachedDatabase, alias);
  }
}

class DriftWallet extends DataClass implements Insertable<DriftWallet> {
  final int id;
  final int account;
  const DriftWallet({required this.id, required this.account});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account'] = Variable<int>(account);
    return map;
  }

  DriftWalletsCompanion toCompanion(bool nullToAbsent) {
    return DriftWalletsCompanion(
      id: Value(id),
      account: Value(account),
    );
  }

  factory DriftWallet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftWallet(
      id: serializer.fromJson<int>(json['id']),
      account: serializer.fromJson<int>(json['account']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'account': serializer.toJson<int>(account),
    };
  }

  DriftWallet copyWith({int? id, int? account}) => DriftWallet(
        id: id ?? this.id,
        account: account ?? this.account,
      );
  DriftWallet copyWithCompanion(DriftWalletsCompanion data) {
    return DriftWallet(
      id: data.id.present ? data.id.value : this.id,
      account: data.account.present ? data.account.value : this.account,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftWallet(')
          ..write('id: $id, ')
          ..write('account: $account')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, account);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftWallet &&
          other.id == this.id &&
          other.account == this.account);
}

class DriftWalletsCompanion extends UpdateCompanion<DriftWallet> {
  final Value<int> id;
  final Value<int> account;
  const DriftWalletsCompanion({
    this.id = const Value.absent(),
    this.account = const Value.absent(),
  });
  DriftWalletsCompanion.insert({
    this.id = const Value.absent(),
    required int account,
  }) : account = Value(account);
  static Insertable<DriftWallet> custom({
    Expression<int>? id,
    Expression<int>? account,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (account != null) 'account': account,
    });
  }

  DriftWalletsCompanion copyWith({Value<int>? id, Value<int>? account}) {
    return DriftWalletsCompanion(
      id: id ?? this.id,
      account: account ?? this.account,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (account.present) {
      map['account'] = Variable<int>(account.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftWalletsCompanion(')
          ..write('id: $id, ')
          ..write('account: $account')
          ..write(')'))
        .toString();
  }
}

class $DriftLoansTable extends DriftLoans
    with TableInfo<$DriftLoansTable, DriftLoan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftLoansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _accountMeta =
      const VerificationMeta('account');
  @override
  late final GeneratedColumn<int> account = GeneratedColumn<int>(
      'account', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_accounts (id) ON DELETE CASCADE'));
  static const VerificationMeta _institutionMeta =
      const VerificationMeta('institution');
  @override
  late final GeneratedColumn<String> institution = GeneratedColumn<String>(
      'institution', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _interestRateMeta =
      const VerificationMeta('interestRate');
  @override
  late final GeneratedColumn<double> interestRate = GeneratedColumn<double>(
      'interest_rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _agreementNoMeta =
      const VerificationMeta('agreementNo');
  @override
  late final GeneratedColumn<String> agreementNo = GeneratedColumn<String>(
      'agreement_no', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _accountNoMeta =
      const VerificationMeta('accountNo');
  @override
  late final GeneratedColumn<String> accountNo = GeneratedColumn<String>(
      'account_no', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        account,
        institution,
        interestRate,
        startDate,
        endDate,
        agreementNo,
        accountNo
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_loans';
  @override
  VerificationContext validateIntegrity(Insertable<DriftLoan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account')) {
      context.handle(_accountMeta,
          account.isAcceptableOrUnknown(data['account']!, _accountMeta));
    } else if (isInserting) {
      context.missing(_accountMeta);
    }
    if (data.containsKey('institution')) {
      context.handle(
          _institutionMeta,
          institution.isAcceptableOrUnknown(
              data['institution']!, _institutionMeta));
    }
    if (data.containsKey('interest_rate')) {
      context.handle(
          _interestRateMeta,
          interestRate.isAcceptableOrUnknown(
              data['interest_rate']!, _interestRateMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('agreement_no')) {
      context.handle(
          _agreementNoMeta,
          agreementNo.isAcceptableOrUnknown(
              data['agreement_no']!, _agreementNoMeta));
    }
    if (data.containsKey('account_no')) {
      context.handle(_accountNoMeta,
          accountNo.isAcceptableOrUnknown(data['account_no']!, _accountNoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftLoan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftLoan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      account: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account'])!,
      institution: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}institution']),
      interestRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}interest_rate']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      agreementNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}agreement_no']),
      accountNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_no']),
    );
  }

  @override
  $DriftLoansTable createAlias(String alias) {
    return $DriftLoansTable(attachedDatabase, alias);
  }
}

class DriftLoan extends DataClass implements Insertable<DriftLoan> {
  final int id;
  final int account;
  final String? institution;
  final double? interestRate;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? agreementNo;
  final String? accountNo;
  const DriftLoan(
      {required this.id,
      required this.account,
      this.institution,
      this.interestRate,
      this.startDate,
      this.endDate,
      this.agreementNo,
      this.accountNo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account'] = Variable<int>(account);
    if (!nullToAbsent || institution != null) {
      map['institution'] = Variable<String>(institution);
    }
    if (!nullToAbsent || interestRate != null) {
      map['interest_rate'] = Variable<double>(interestRate);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || agreementNo != null) {
      map['agreement_no'] = Variable<String>(agreementNo);
    }
    if (!nullToAbsent || accountNo != null) {
      map['account_no'] = Variable<String>(accountNo);
    }
    return map;
  }

  DriftLoansCompanion toCompanion(bool nullToAbsent) {
    return DriftLoansCompanion(
      id: Value(id),
      account: Value(account),
      institution: institution == null && nullToAbsent
          ? const Value.absent()
          : Value(institution),
      interestRate: interestRate == null && nullToAbsent
          ? const Value.absent()
          : Value(interestRate),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      agreementNo: agreementNo == null && nullToAbsent
          ? const Value.absent()
          : Value(agreementNo),
      accountNo: accountNo == null && nullToAbsent
          ? const Value.absent()
          : Value(accountNo),
    );
  }

  factory DriftLoan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftLoan(
      id: serializer.fromJson<int>(json['id']),
      account: serializer.fromJson<int>(json['account']),
      institution: serializer.fromJson<String?>(json['institution']),
      interestRate: serializer.fromJson<double?>(json['interestRate']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      agreementNo: serializer.fromJson<String?>(json['agreementNo']),
      accountNo: serializer.fromJson<String?>(json['accountNo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'account': serializer.toJson<int>(account),
      'institution': serializer.toJson<String?>(institution),
      'interestRate': serializer.toJson<double?>(interestRate),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'agreementNo': serializer.toJson<String?>(agreementNo),
      'accountNo': serializer.toJson<String?>(accountNo),
    };
  }

  DriftLoan copyWith(
          {int? id,
          int? account,
          Value<String?> institution = const Value.absent(),
          Value<double?> interestRate = const Value.absent(),
          Value<DateTime?> startDate = const Value.absent(),
          Value<DateTime?> endDate = const Value.absent(),
          Value<String?> agreementNo = const Value.absent(),
          Value<String?> accountNo = const Value.absent()}) =>
      DriftLoan(
        id: id ?? this.id,
        account: account ?? this.account,
        institution: institution.present ? institution.value : this.institution,
        interestRate:
            interestRate.present ? interestRate.value : this.interestRate,
        startDate: startDate.present ? startDate.value : this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        agreementNo: agreementNo.present ? agreementNo.value : this.agreementNo,
        accountNo: accountNo.present ? accountNo.value : this.accountNo,
      );
  DriftLoan copyWithCompanion(DriftLoansCompanion data) {
    return DriftLoan(
      id: data.id.present ? data.id.value : this.id,
      account: data.account.present ? data.account.value : this.account,
      institution:
          data.institution.present ? data.institution.value : this.institution,
      interestRate: data.interestRate.present
          ? data.interestRate.value
          : this.interestRate,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      agreementNo:
          data.agreementNo.present ? data.agreementNo.value : this.agreementNo,
      accountNo: data.accountNo.present ? data.accountNo.value : this.accountNo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftLoan(')
          ..write('id: $id, ')
          ..write('account: $account, ')
          ..write('institution: $institution, ')
          ..write('interestRate: $interestRate, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('agreementNo: $agreementNo, ')
          ..write('accountNo: $accountNo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, account, institution, interestRate,
      startDate, endDate, agreementNo, accountNo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftLoan &&
          other.id == this.id &&
          other.account == this.account &&
          other.institution == this.institution &&
          other.interestRate == this.interestRate &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.agreementNo == this.agreementNo &&
          other.accountNo == this.accountNo);
}

class DriftLoansCompanion extends UpdateCompanion<DriftLoan> {
  final Value<int> id;
  final Value<int> account;
  final Value<String?> institution;
  final Value<double?> interestRate;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<String?> agreementNo;
  final Value<String?> accountNo;
  const DriftLoansCompanion({
    this.id = const Value.absent(),
    this.account = const Value.absent(),
    this.institution = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.agreementNo = const Value.absent(),
    this.accountNo = const Value.absent(),
  });
  DriftLoansCompanion.insert({
    this.id = const Value.absent(),
    required int account,
    this.institution = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.agreementNo = const Value.absent(),
    this.accountNo = const Value.absent(),
  }) : account = Value(account);
  static Insertable<DriftLoan> custom({
    Expression<int>? id,
    Expression<int>? account,
    Expression<String>? institution,
    Expression<double>? interestRate,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? agreementNo,
    Expression<String>? accountNo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (account != null) 'account': account,
      if (institution != null) 'institution': institution,
      if (interestRate != null) 'interest_rate': interestRate,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (agreementNo != null) 'agreement_no': agreementNo,
      if (accountNo != null) 'account_no': accountNo,
    });
  }

  DriftLoansCompanion copyWith(
      {Value<int>? id,
      Value<int>? account,
      Value<String?>? institution,
      Value<double?>? interestRate,
      Value<DateTime?>? startDate,
      Value<DateTime?>? endDate,
      Value<String?>? agreementNo,
      Value<String?>? accountNo}) {
    return DriftLoansCompanion(
      id: id ?? this.id,
      account: account ?? this.account,
      institution: institution ?? this.institution,
      interestRate: interestRate ?? this.interestRate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      agreementNo: agreementNo ?? this.agreementNo,
      accountNo: accountNo ?? this.accountNo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (account.present) {
      map['account'] = Variable<int>(account.value);
    }
    if (institution.present) {
      map['institution'] = Variable<String>(institution.value);
    }
    if (interestRate.present) {
      map['interest_rate'] = Variable<double>(interestRate.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (agreementNo.present) {
      map['agreement_no'] = Variable<String>(agreementNo.value);
    }
    if (accountNo.present) {
      map['account_no'] = Variable<String>(accountNo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftLoansCompanion(')
          ..write('id: $id, ')
          ..write('account: $account, ')
          ..write('institution: $institution, ')
          ..write('interestRate: $interestRate, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('agreementNo: $agreementNo, ')
          ..write('accountNo: $accountNo')
          ..write(')'))
        .toString();
  }
}

class $DriftCCardsTable extends DriftCCards
    with TableInfo<$DriftCCardsTable, DriftCCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftCCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _accountMeta =
      const VerificationMeta('account');
  @override
  late final GeneratedColumn<int> account = GeneratedColumn<int>(
      'account', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_accounts (id) ON DELETE CASCADE'));
  static const VerificationMeta _institutionMeta =
      const VerificationMeta('institution');
  @override
  late final GeneratedColumn<String> institution = GeneratedColumn<String>(
      'institution', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _statementDateMeta =
      const VerificationMeta('statementDate');
  @override
  late final GeneratedColumn<int> statementDate = GeneratedColumn<int>(
      'statement_date', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _cardNoMeta = const VerificationMeta('cardNo');
  @override
  late final GeneratedColumn<String> cardNo = GeneratedColumn<String>(
      'card_no', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _cardNetworkMeta =
      const VerificationMeta('cardNetwork');
  @override
  late final GeneratedColumn<String> cardNetwork = GeneratedColumn<String>(
      'card_network', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, account, institution, statementDate, cardNo, cardNetwork];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_c_cards';
  @override
  VerificationContext validateIntegrity(Insertable<DriftCCard> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account')) {
      context.handle(_accountMeta,
          account.isAcceptableOrUnknown(data['account']!, _accountMeta));
    } else if (isInserting) {
      context.missing(_accountMeta);
    }
    if (data.containsKey('institution')) {
      context.handle(
          _institutionMeta,
          institution.isAcceptableOrUnknown(
              data['institution']!, _institutionMeta));
    }
    if (data.containsKey('statement_date')) {
      context.handle(
          _statementDateMeta,
          statementDate.isAcceptableOrUnknown(
              data['statement_date']!, _statementDateMeta));
    }
    if (data.containsKey('card_no')) {
      context.handle(_cardNoMeta,
          cardNo.isAcceptableOrUnknown(data['card_no']!, _cardNoMeta));
    }
    if (data.containsKey('card_network')) {
      context.handle(
          _cardNetworkMeta,
          cardNetwork.isAcceptableOrUnknown(
              data['card_network']!, _cardNetworkMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftCCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftCCard(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      account: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account'])!,
      institution: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}institution']),
      statementDate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}statement_date']),
      cardNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_no']),
      cardNetwork: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_network']),
    );
  }

  @override
  $DriftCCardsTable createAlias(String alias) {
    return $DriftCCardsTable(attachedDatabase, alias);
  }
}

class DriftCCard extends DataClass implements Insertable<DriftCCard> {
  final int id;
  final int account;
  final String? institution;
  final int? statementDate;
  final String? cardNo;
  final String? cardNetwork;
  const DriftCCard(
      {required this.id,
      required this.account,
      this.institution,
      this.statementDate,
      this.cardNo,
      this.cardNetwork});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account'] = Variable<int>(account);
    if (!nullToAbsent || institution != null) {
      map['institution'] = Variable<String>(institution);
    }
    if (!nullToAbsent || statementDate != null) {
      map['statement_date'] = Variable<int>(statementDate);
    }
    if (!nullToAbsent || cardNo != null) {
      map['card_no'] = Variable<String>(cardNo);
    }
    if (!nullToAbsent || cardNetwork != null) {
      map['card_network'] = Variable<String>(cardNetwork);
    }
    return map;
  }

  DriftCCardsCompanion toCompanion(bool nullToAbsent) {
    return DriftCCardsCompanion(
      id: Value(id),
      account: Value(account),
      institution: institution == null && nullToAbsent
          ? const Value.absent()
          : Value(institution),
      statementDate: statementDate == null && nullToAbsent
          ? const Value.absent()
          : Value(statementDate),
      cardNo:
          cardNo == null && nullToAbsent ? const Value.absent() : Value(cardNo),
      cardNetwork: cardNetwork == null && nullToAbsent
          ? const Value.absent()
          : Value(cardNetwork),
    );
  }

  factory DriftCCard.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftCCard(
      id: serializer.fromJson<int>(json['id']),
      account: serializer.fromJson<int>(json['account']),
      institution: serializer.fromJson<String?>(json['institution']),
      statementDate: serializer.fromJson<int?>(json['statementDate']),
      cardNo: serializer.fromJson<String?>(json['cardNo']),
      cardNetwork: serializer.fromJson<String?>(json['cardNetwork']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'account': serializer.toJson<int>(account),
      'institution': serializer.toJson<String?>(institution),
      'statementDate': serializer.toJson<int?>(statementDate),
      'cardNo': serializer.toJson<String?>(cardNo),
      'cardNetwork': serializer.toJson<String?>(cardNetwork),
    };
  }

  DriftCCard copyWith(
          {int? id,
          int? account,
          Value<String?> institution = const Value.absent(),
          Value<int?> statementDate = const Value.absent(),
          Value<String?> cardNo = const Value.absent(),
          Value<String?> cardNetwork = const Value.absent()}) =>
      DriftCCard(
        id: id ?? this.id,
        account: account ?? this.account,
        institution: institution.present ? institution.value : this.institution,
        statementDate:
            statementDate.present ? statementDate.value : this.statementDate,
        cardNo: cardNo.present ? cardNo.value : this.cardNo,
        cardNetwork: cardNetwork.present ? cardNetwork.value : this.cardNetwork,
      );
  DriftCCard copyWithCompanion(DriftCCardsCompanion data) {
    return DriftCCard(
      id: data.id.present ? data.id.value : this.id,
      account: data.account.present ? data.account.value : this.account,
      institution:
          data.institution.present ? data.institution.value : this.institution,
      statementDate: data.statementDate.present
          ? data.statementDate.value
          : this.statementDate,
      cardNo: data.cardNo.present ? data.cardNo.value : this.cardNo,
      cardNetwork:
          data.cardNetwork.present ? data.cardNetwork.value : this.cardNetwork,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftCCard(')
          ..write('id: $id, ')
          ..write('account: $account, ')
          ..write('institution: $institution, ')
          ..write('statementDate: $statementDate, ')
          ..write('cardNo: $cardNo, ')
          ..write('cardNetwork: $cardNetwork')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, account, institution, statementDate, cardNo, cardNetwork);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftCCard &&
          other.id == this.id &&
          other.account == this.account &&
          other.institution == this.institution &&
          other.statementDate == this.statementDate &&
          other.cardNo == this.cardNo &&
          other.cardNetwork == this.cardNetwork);
}

class DriftCCardsCompanion extends UpdateCompanion<DriftCCard> {
  final Value<int> id;
  final Value<int> account;
  final Value<String?> institution;
  final Value<int?> statementDate;
  final Value<String?> cardNo;
  final Value<String?> cardNetwork;
  const DriftCCardsCompanion({
    this.id = const Value.absent(),
    this.account = const Value.absent(),
    this.institution = const Value.absent(),
    this.statementDate = const Value.absent(),
    this.cardNo = const Value.absent(),
    this.cardNetwork = const Value.absent(),
  });
  DriftCCardsCompanion.insert({
    this.id = const Value.absent(),
    required int account,
    this.institution = const Value.absent(),
    this.statementDate = const Value.absent(),
    this.cardNo = const Value.absent(),
    this.cardNetwork = const Value.absent(),
  }) : account = Value(account);
  static Insertable<DriftCCard> custom({
    Expression<int>? id,
    Expression<int>? account,
    Expression<String>? institution,
    Expression<int>? statementDate,
    Expression<String>? cardNo,
    Expression<String>? cardNetwork,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (account != null) 'account': account,
      if (institution != null) 'institution': institution,
      if (statementDate != null) 'statement_date': statementDate,
      if (cardNo != null) 'card_no': cardNo,
      if (cardNetwork != null) 'card_network': cardNetwork,
    });
  }

  DriftCCardsCompanion copyWith(
      {Value<int>? id,
      Value<int>? account,
      Value<String?>? institution,
      Value<int?>? statementDate,
      Value<String?>? cardNo,
      Value<String?>? cardNetwork}) {
    return DriftCCardsCompanion(
      id: id ?? this.id,
      account: account ?? this.account,
      institution: institution ?? this.institution,
      statementDate: statementDate ?? this.statementDate,
      cardNo: cardNo ?? this.cardNo,
      cardNetwork: cardNetwork ?? this.cardNetwork,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (account.present) {
      map['account'] = Variable<int>(account.value);
    }
    if (institution.present) {
      map['institution'] = Variable<String>(institution.value);
    }
    if (statementDate.present) {
      map['statement_date'] = Variable<int>(statementDate.value);
    }
    if (cardNo.present) {
      map['card_no'] = Variable<String>(cardNo.value);
    }
    if (cardNetwork.present) {
      map['card_network'] = Variable<String>(cardNetwork.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftCCardsCompanion(')
          ..write('id: $id, ')
          ..write('account: $account, ')
          ..write('institution: $institution, ')
          ..write('statementDate: $statementDate, ')
          ..write('cardNo: $cardNo, ')
          ..write('cardNetwork: $cardNetwork')
          ..write(')'))
        .toString();
  }
}

class $DriftBalancesTable extends DriftBalances
    with TableInfo<$DriftBalancesTable, DriftBalance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftBalancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _accountMeta =
      const VerificationMeta('account');
  @override
  late final GeneratedColumn<int> account = GeneratedColumn<int>(
      'account', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_accounts (id) ON DELETE CASCADE'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, account, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_balances';
  @override
  VerificationContext validateIntegrity(Insertable<DriftBalance> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account')) {
      context.handle(_accountMeta,
          account.isAcceptableOrUnknown(data['account']!, _accountMeta));
    } else if (isInserting) {
      context.missing(_accountMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftBalance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftBalance(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      account: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
    );
  }

  @override
  $DriftBalancesTable createAlias(String alias) {
    return $DriftBalancesTable(attachedDatabase, alias);
  }
}

class DriftBalance extends DataClass implements Insertable<DriftBalance> {
  final int id;
  final int account;
  final int amount;
  const DriftBalance(
      {required this.id, required this.account, required this.amount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account'] = Variable<int>(account);
    map['amount'] = Variable<int>(amount);
    return map;
  }

  DriftBalancesCompanion toCompanion(bool nullToAbsent) {
    return DriftBalancesCompanion(
      id: Value(id),
      account: Value(account),
      amount: Value(amount),
    );
  }

  factory DriftBalance.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftBalance(
      id: serializer.fromJson<int>(json['id']),
      account: serializer.fromJson<int>(json['account']),
      amount: serializer.fromJson<int>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'account': serializer.toJson<int>(account),
      'amount': serializer.toJson<int>(amount),
    };
  }

  DriftBalance copyWith({int? id, int? account, int? amount}) => DriftBalance(
        id: id ?? this.id,
        account: account ?? this.account,
        amount: amount ?? this.amount,
      );
  DriftBalance copyWithCompanion(DriftBalancesCompanion data) {
    return DriftBalance(
      id: data.id.present ? data.id.value : this.id,
      account: data.account.present ? data.account.value : this.account,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftBalance(')
          ..write('id: $id, ')
          ..write('account: $account, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, account, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftBalance &&
          other.id == this.id &&
          other.account == this.account &&
          other.amount == this.amount);
}

class DriftBalancesCompanion extends UpdateCompanion<DriftBalance> {
  final Value<int> id;
  final Value<int> account;
  final Value<int> amount;
  const DriftBalancesCompanion({
    this.id = const Value.absent(),
    this.account = const Value.absent(),
    this.amount = const Value.absent(),
  });
  DriftBalancesCompanion.insert({
    this.id = const Value.absent(),
    required int account,
    this.amount = const Value.absent(),
  }) : account = Value(account);
  static Insertable<DriftBalance> custom({
    Expression<int>? id,
    Expression<int>? account,
    Expression<int>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (account != null) 'account': account,
      if (amount != null) 'amount': amount,
    });
  }

  DriftBalancesCompanion copyWith(
      {Value<int>? id, Value<int>? account, Value<int>? amount}) {
    return DriftBalancesCompanion(
      id: id ?? this.id,
      account: account ?? this.account,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (account.present) {
      map['account'] = Variable<int>(account.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftBalancesCompanion(')
          ..write('id: $id, ')
          ..write('account: $account, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

class $DriftBudgetAccountsTable extends DriftBudgetAccounts
    with TableInfo<$DriftBudgetAccountsTable, DriftBudgetAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftBudgetAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _accountMeta =
      const VerificationMeta('account');
  @override
  late final GeneratedColumn<int> account = GeneratedColumn<int>(
      'account', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_accounts (id) ON DELETE CASCADE'));
  static const VerificationMeta _budgetMeta = const VerificationMeta('budget');
  @override
  late final GeneratedColumn<int> budget = GeneratedColumn<int>(
      'budget', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_budgets (id) ON DELETE CASCADE'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, account, budget, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_budget_accounts';
  @override
  VerificationContext validateIntegrity(Insertable<DriftBudgetAccount> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account')) {
      context.handle(_accountMeta,
          account.isAcceptableOrUnknown(data['account']!, _accountMeta));
    } else if (isInserting) {
      context.missing(_accountMeta);
    }
    if (data.containsKey('budget')) {
      context.handle(_budgetMeta,
          budget.isAcceptableOrUnknown(data['budget']!, _budgetMeta));
    } else if (isInserting) {
      context.missing(_budgetMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftBudgetAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftBudgetAccount(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      account: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account'])!,
      budget: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}budget'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
    );
  }

  @override
  $DriftBudgetAccountsTable createAlias(String alias) {
    return $DriftBudgetAccountsTable(attachedDatabase, alias);
  }
}

class DriftBudgetAccount extends DataClass
    implements Insertable<DriftBudgetAccount> {
  final int id;
  final int account;
  final int budget;
  final int amount;
  const DriftBudgetAccount(
      {required this.id,
      required this.account,
      required this.budget,
      required this.amount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account'] = Variable<int>(account);
    map['budget'] = Variable<int>(budget);
    map['amount'] = Variable<int>(amount);
    return map;
  }

  DriftBudgetAccountsCompanion toCompanion(bool nullToAbsent) {
    return DriftBudgetAccountsCompanion(
      id: Value(id),
      account: Value(account),
      budget: Value(budget),
      amount: Value(amount),
    );
  }

  factory DriftBudgetAccount.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftBudgetAccount(
      id: serializer.fromJson<int>(json['id']),
      account: serializer.fromJson<int>(json['account']),
      budget: serializer.fromJson<int>(json['budget']),
      amount: serializer.fromJson<int>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'account': serializer.toJson<int>(account),
      'budget': serializer.toJson<int>(budget),
      'amount': serializer.toJson<int>(amount),
    };
  }

  DriftBudgetAccount copyWith(
          {int? id, int? account, int? budget, int? amount}) =>
      DriftBudgetAccount(
        id: id ?? this.id,
        account: account ?? this.account,
        budget: budget ?? this.budget,
        amount: amount ?? this.amount,
      );
  DriftBudgetAccount copyWithCompanion(DriftBudgetAccountsCompanion data) {
    return DriftBudgetAccount(
      id: data.id.present ? data.id.value : this.id,
      account: data.account.present ? data.account.value : this.account,
      budget: data.budget.present ? data.budget.value : this.budget,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftBudgetAccount(')
          ..write('id: $id, ')
          ..write('account: $account, ')
          ..write('budget: $budget, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, account, budget, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftBudgetAccount &&
          other.id == this.id &&
          other.account == this.account &&
          other.budget == this.budget &&
          other.amount == this.amount);
}

class DriftBudgetAccountsCompanion extends UpdateCompanion<DriftBudgetAccount> {
  final Value<int> id;
  final Value<int> account;
  final Value<int> budget;
  final Value<int> amount;
  const DriftBudgetAccountsCompanion({
    this.id = const Value.absent(),
    this.account = const Value.absent(),
    this.budget = const Value.absent(),
    this.amount = const Value.absent(),
  });
  DriftBudgetAccountsCompanion.insert({
    this.id = const Value.absent(),
    required int account,
    required int budget,
    this.amount = const Value.absent(),
  })  : account = Value(account),
        budget = Value(budget);
  static Insertable<DriftBudgetAccount> custom({
    Expression<int>? id,
    Expression<int>? account,
    Expression<int>? budget,
    Expression<int>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (account != null) 'account': account,
      if (budget != null) 'budget': budget,
      if (amount != null) 'amount': amount,
    });
  }

  DriftBudgetAccountsCompanion copyWith(
      {Value<int>? id,
      Value<int>? account,
      Value<int>? budget,
      Value<int>? amount}) {
    return DriftBudgetAccountsCompanion(
      id: id ?? this.id,
      account: account ?? this.account,
      budget: budget ?? this.budget,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (account.present) {
      map['account'] = Variable<int>(account.value);
    }
    if (budget.present) {
      map['budget'] = Variable<int>(budget.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftBudgetAccountsCompanion(')
          ..write('id: $id, ')
          ..write('account: $account, ')
          ..write('budget: $budget, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

class $DriftBudgetFundsTable extends DriftBudgetFunds
    with TableInfo<$DriftBudgetFundsTable, DriftBudgetFund> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftBudgetFundsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _accountMeta =
      const VerificationMeta('account');
  @override
  late final GeneratedColumn<int> account = GeneratedColumn<int>(
      'account', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_accounts (id) ON DELETE CASCADE'));
  static const VerificationMeta _budgetMeta = const VerificationMeta('budget');
  @override
  late final GeneratedColumn<int> budget = GeneratedColumn<int>(
      'budget', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_budgets (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [id, account, budget];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_budget_funds';
  @override
  VerificationContext validateIntegrity(Insertable<DriftBudgetFund> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account')) {
      context.handle(_accountMeta,
          account.isAcceptableOrUnknown(data['account']!, _accountMeta));
    } else if (isInserting) {
      context.missing(_accountMeta);
    }
    if (data.containsKey('budget')) {
      context.handle(_budgetMeta,
          budget.isAcceptableOrUnknown(data['budget']!, _budgetMeta));
    } else if (isInserting) {
      context.missing(_budgetMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftBudgetFund map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftBudgetFund(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      account: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account'])!,
      budget: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}budget'])!,
    );
  }

  @override
  $DriftBudgetFundsTable createAlias(String alias) {
    return $DriftBudgetFundsTable(attachedDatabase, alias);
  }
}

class DriftBudgetFund extends DataClass implements Insertable<DriftBudgetFund> {
  final int id;
  final int account;
  final int budget;
  const DriftBudgetFund(
      {required this.id, required this.account, required this.budget});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account'] = Variable<int>(account);
    map['budget'] = Variable<int>(budget);
    return map;
  }

  DriftBudgetFundsCompanion toCompanion(bool nullToAbsent) {
    return DriftBudgetFundsCompanion(
      id: Value(id),
      account: Value(account),
      budget: Value(budget),
    );
  }

  factory DriftBudgetFund.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftBudgetFund(
      id: serializer.fromJson<int>(json['id']),
      account: serializer.fromJson<int>(json['account']),
      budget: serializer.fromJson<int>(json['budget']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'account': serializer.toJson<int>(account),
      'budget': serializer.toJson<int>(budget),
    };
  }

  DriftBudgetFund copyWith({int? id, int? account, int? budget}) =>
      DriftBudgetFund(
        id: id ?? this.id,
        account: account ?? this.account,
        budget: budget ?? this.budget,
      );
  DriftBudgetFund copyWithCompanion(DriftBudgetFundsCompanion data) {
    return DriftBudgetFund(
      id: data.id.present ? data.id.value : this.id,
      account: data.account.present ? data.account.value : this.account,
      budget: data.budget.present ? data.budget.value : this.budget,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftBudgetFund(')
          ..write('id: $id, ')
          ..write('account: $account, ')
          ..write('budget: $budget')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, account, budget);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftBudgetFund &&
          other.id == this.id &&
          other.account == this.account &&
          other.budget == this.budget);
}

class DriftBudgetFundsCompanion extends UpdateCompanion<DriftBudgetFund> {
  final Value<int> id;
  final Value<int> account;
  final Value<int> budget;
  const DriftBudgetFundsCompanion({
    this.id = const Value.absent(),
    this.account = const Value.absent(),
    this.budget = const Value.absent(),
  });
  DriftBudgetFundsCompanion.insert({
    this.id = const Value.absent(),
    required int account,
    required int budget,
  })  : account = Value(account),
        budget = Value(budget);
  static Insertable<DriftBudgetFund> custom({
    Expression<int>? id,
    Expression<int>? account,
    Expression<int>? budget,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (account != null) 'account': account,
      if (budget != null) 'budget': budget,
    });
  }

  DriftBudgetFundsCompanion copyWith(
      {Value<int>? id, Value<int>? account, Value<int>? budget}) {
    return DriftBudgetFundsCompanion(
      id: id ?? this.id,
      account: account ?? this.account,
      budget: budget ?? this.budget,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (account.present) {
      map['account'] = Variable<int>(account.value);
    }
    if (budget.present) {
      map['budget'] = Variable<int>(budget.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftBudgetFundsCompanion(')
          ..write('id: $id, ')
          ..write('account: $account, ')
          ..write('budget: $budget')
          ..write(')'))
        .toString();
  }
}

class $DriftReceivablesTable extends DriftReceivables
    with TableInfo<$DriftReceivablesTable, DriftReceivable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftReceivablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_accounts (id) ON DELETE CASCADE'));
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<int> totalAmount = GeneratedColumn<int>(
      'total_amount', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _paidDateMeta =
      const VerificationMeta('paidDate');
  @override
  late final GeneratedColumn<DateTime> paidDate = GeneratedColumn<DateTime>(
      'paid_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, accountId, totalAmount, paidDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_receivables';
  @override
  VerificationContext validateIntegrity(Insertable<DriftReceivable> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    }
    if (data.containsKey('paid_date')) {
      context.handle(_paidDateMeta,
          paidDate.isAcceptableOrUnknown(data['paid_date']!, _paidDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftReceivable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftReceivable(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_amount']),
      paidDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}paid_date']),
    );
  }

  @override
  $DriftReceivablesTable createAlias(String alias) {
    return $DriftReceivablesTable(attachedDatabase, alias);
  }
}

class DriftReceivable extends DataClass implements Insertable<DriftReceivable> {
  final int id;
  final int accountId;
  final int? totalAmount;
  final DateTime? paidDate;
  const DriftReceivable(
      {required this.id,
      required this.accountId,
      this.totalAmount,
      this.paidDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || totalAmount != null) {
      map['total_amount'] = Variable<int>(totalAmount);
    }
    if (!nullToAbsent || paidDate != null) {
      map['paid_date'] = Variable<DateTime>(paidDate);
    }
    return map;
  }

  DriftReceivablesCompanion toCompanion(bool nullToAbsent) {
    return DriftReceivablesCompanion(
      id: Value(id),
      accountId: Value(accountId),
      totalAmount: totalAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(totalAmount),
      paidDate: paidDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paidDate),
    );
  }

  factory DriftReceivable.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftReceivable(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      totalAmount: serializer.fromJson<int?>(json['totalAmount']),
      paidDate: serializer.fromJson<DateTime?>(json['paidDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'totalAmount': serializer.toJson<int?>(totalAmount),
      'paidDate': serializer.toJson<DateTime?>(paidDate),
    };
  }

  DriftReceivable copyWith(
          {int? id,
          int? accountId,
          Value<int?> totalAmount = const Value.absent(),
          Value<DateTime?> paidDate = const Value.absent()}) =>
      DriftReceivable(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        totalAmount: totalAmount.present ? totalAmount.value : this.totalAmount,
        paidDate: paidDate.present ? paidDate.value : this.paidDate,
      );
  DriftReceivable copyWithCompanion(DriftReceivablesCompanion data) {
    return DriftReceivable(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      paidDate: data.paidDate.present ? data.paidDate.value : this.paidDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftReceivable(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paidDate: $paidDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, totalAmount, paidDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftReceivable &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.totalAmount == this.totalAmount &&
          other.paidDate == this.paidDate);
}

class DriftReceivablesCompanion extends UpdateCompanion<DriftReceivable> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<int?> totalAmount;
  final Value<DateTime?> paidDate;
  const DriftReceivablesCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.paidDate = const Value.absent(),
  });
  DriftReceivablesCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    this.totalAmount = const Value.absent(),
    this.paidDate = const Value.absent(),
  }) : accountId = Value(accountId);
  static Insertable<DriftReceivable> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<int>? totalAmount,
    Expression<DateTime>? paidDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (paidDate != null) 'paid_date': paidDate,
    });
  }

  DriftReceivablesCompanion copyWith(
      {Value<int>? id,
      Value<int>? accountId,
      Value<int?>? totalAmount,
      Value<DateTime?>? paidDate}) {
    return DriftReceivablesCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      totalAmount: totalAmount ?? this.totalAmount,
      paidDate: paidDate ?? this.paidDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<int>(totalAmount.value);
    }
    if (paidDate.present) {
      map['paid_date'] = Variable<DateTime>(paidDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftReceivablesCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paidDate: $paidDate')
          ..write(')'))
        .toString();
  }
}

class $DriftPeopleTable extends DriftPeople
    with TableInfo<$DriftPeopleTable, DriftPeopleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftPeopleTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_accounts (id) ON DELETE CASCADE'));
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _zipMeta = const VerificationMeta('zip');
  @override
  late final GeneratedColumn<String> zip = GeneratedColumn<String>(
      'zip', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tinMeta = const VerificationMeta('tin');
  @override
  late final GeneratedColumn<String> tin = GeneratedColumn<String>(
      'tin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, accountId, address, zip, email, phone, tin];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_people';
  @override
  VerificationContext validateIntegrity(Insertable<DriftPeopleData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('zip')) {
      context.handle(
          _zipMeta, zip.isAcceptableOrUnknown(data['zip']!, _zipMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('tin')) {
      context.handle(
          _tinMeta, tin.isAcceptableOrUnknown(data['tin']!, _tinMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftPeopleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftPeopleData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      zip: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}zip']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      tin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tin']),
    );
  }

  @override
  $DriftPeopleTable createAlias(String alias) {
    return $DriftPeopleTable(attachedDatabase, alias);
  }
}

class DriftPeopleData extends DataClass implements Insertable<DriftPeopleData> {
  final int id;
  final int accountId;
  final String? address;
  final String? zip;
  final String? email;
  final String? phone;
  final String? tin;
  const DriftPeopleData(
      {required this.id,
      required this.accountId,
      this.address,
      this.zip,
      this.email,
      this.phone,
      this.tin});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || zip != null) {
      map['zip'] = Variable<String>(zip);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || tin != null) {
      map['tin'] = Variable<String>(tin);
    }
    return map;
  }

  DriftPeopleCompanion toCompanion(bool nullToAbsent) {
    return DriftPeopleCompanion(
      id: Value(id),
      accountId: Value(accountId),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      zip: zip == null && nullToAbsent ? const Value.absent() : Value(zip),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      tin: tin == null && nullToAbsent ? const Value.absent() : Value(tin),
    );
  }

  factory DriftPeopleData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftPeopleData(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      address: serializer.fromJson<String?>(json['address']),
      zip: serializer.fromJson<String?>(json['zip']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      tin: serializer.fromJson<String?>(json['tin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'address': serializer.toJson<String?>(address),
      'zip': serializer.toJson<String?>(zip),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'tin': serializer.toJson<String?>(tin),
    };
  }

  DriftPeopleData copyWith(
          {int? id,
          int? accountId,
          Value<String?> address = const Value.absent(),
          Value<String?> zip = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> tin = const Value.absent()}) =>
      DriftPeopleData(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        address: address.present ? address.value : this.address,
        zip: zip.present ? zip.value : this.zip,
        email: email.present ? email.value : this.email,
        phone: phone.present ? phone.value : this.phone,
        tin: tin.present ? tin.value : this.tin,
      );
  DriftPeopleData copyWithCompanion(DriftPeopleCompanion data) {
    return DriftPeopleData(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      address: data.address.present ? data.address.value : this.address,
      zip: data.zip.present ? data.zip.value : this.zip,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      tin: data.tin.present ? data.tin.value : this.tin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftPeopleData(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('address: $address, ')
          ..write('zip: $zip, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('tin: $tin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, accountId, address, zip, email, phone, tin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftPeopleData &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.address == this.address &&
          other.zip == this.zip &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.tin == this.tin);
}

class DriftPeopleCompanion extends UpdateCompanion<DriftPeopleData> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<String?> address;
  final Value<String?> zip;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> tin;
  const DriftPeopleCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.address = const Value.absent(),
    this.zip = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.tin = const Value.absent(),
  });
  DriftPeopleCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    this.address = const Value.absent(),
    this.zip = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.tin = const Value.absent(),
  }) : accountId = Value(accountId);
  static Insertable<DriftPeopleData> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<String>? address,
    Expression<String>? zip,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? tin,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (address != null) 'address': address,
      if (zip != null) 'zip': zip,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (tin != null) 'tin': tin,
    });
  }

  DriftPeopleCompanion copyWith(
      {Value<int>? id,
      Value<int>? accountId,
      Value<String?>? address,
      Value<String?>? zip,
      Value<String?>? email,
      Value<String?>? phone,
      Value<String?>? tin}) {
    return DriftPeopleCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      address: address ?? this.address,
      zip: zip ?? this.zip,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      tin: tin ?? this.tin,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (zip.present) {
      map['zip'] = Variable<String>(zip.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (tin.present) {
      map['tin'] = Variable<String>(tin.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftPeopleCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('address: $address, ')
          ..write('zip: $zip, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('tin: $tin')
          ..write(')'))
        .toString();
  }
}

class $DriftPaymentRemindersTable extends DriftPaymentReminders
    with TableInfo<$DriftPaymentRemindersTable, DriftPaymentReminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftPaymentRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _accountMeta =
      const VerificationMeta('account');
  @override
  late final GeneratedColumn<int> account = GeneratedColumn<int>(
      'account', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_accounts (id) ON DELETE CASCADE'));
  static const VerificationMeta _fundMeta = const VerificationMeta('fund');
  @override
  late final GeneratedColumn<int> fund = GeneratedColumn<int>(
      'fund', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_accounts (id) ON DELETE SET NULL'));
  static const VerificationMeta _profileMeta =
      const VerificationMeta('profile');
  @override
  late final GeneratedColumn<int> profile = GeneratedColumn<int>(
      'profile', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES drift_profiles (id) ON DELETE CASCADE'));
  static const VerificationMeta _detailsMeta =
      const VerificationMeta('details');
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<BudgetInterval?, int> interval =
      GeneratedColumn<int>('interval', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<BudgetInterval?>(
              $DriftPaymentRemindersTable.$converterintervaln);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
      'day', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _paymentDateMeta =
      const VerificationMeta('paymentDate');
  @override
  late final GeneratedColumn<DateTime> paymentDate = GeneratedColumn<DateTime>(
      'payment_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _addedDateMeta =
      const VerificationMeta('addedDate');
  @override
  late final GeneratedColumn<DateTime> addedDate = GeneratedColumn<DateTime>(
      'added_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updateDateMeta =
      const VerificationMeta('updateDate');
  @override
  late final GeneratedColumn<DateTime> updateDate = GeneratedColumn<DateTime>(
      'update_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  late final GeneratedColumnWithTypeConverter<PaymentStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<PaymentStatus>(
              $DriftPaymentRemindersTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        account,
        fund,
        profile,
        details,
        interval,
        day,
        amount,
        paymentDate,
        addedDate,
        updateDate,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_payment_reminders';
  @override
  VerificationContext validateIntegrity(
      Insertable<DriftPaymentReminder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account')) {
      context.handle(_accountMeta,
          account.isAcceptableOrUnknown(data['account']!, _accountMeta));
    }
    if (data.containsKey('fund')) {
      context.handle(
          _fundMeta, fund.isAcceptableOrUnknown(data['fund']!, _fundMeta));
    }
    if (data.containsKey('profile')) {
      context.handle(_profileMeta,
          profile.isAcceptableOrUnknown(data['profile']!, _profileMeta));
    } else if (isInserting) {
      context.missing(_profileMeta);
    }
    if (data.containsKey('details')) {
      context.handle(_detailsMeta,
          details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    } else if (isInserting) {
      context.missing(_detailsMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
          _dayMeta, day.isAcceptableOrUnknown(data['day']!, _dayMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('payment_date')) {
      context.handle(
          _paymentDateMeta,
          paymentDate.isAcceptableOrUnknown(
              data['payment_date']!, _paymentDateMeta));
    }
    if (data.containsKey('added_date')) {
      context.handle(_addedDateMeta,
          addedDate.isAcceptableOrUnknown(data['added_date']!, _addedDateMeta));
    }
    if (data.containsKey('update_date')) {
      context.handle(
          _updateDateMeta,
          updateDate.isAcceptableOrUnknown(
              data['update_date']!, _updateDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftPaymentReminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftPaymentReminder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      account: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account']),
      fund: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fund']),
      profile: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}profile'])!,
      details: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details'])!,
      interval: $DriftPaymentRemindersTable.$converterintervaln.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}interval'])),
      day: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      paymentDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}payment_date']),
      addedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_date'])!,
      updateDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_date'])!,
      status: $DriftPaymentRemindersTable.$converterstatus.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
    );
  }

  @override
  $DriftPaymentRemindersTable createAlias(String alias) {
    return $DriftPaymentRemindersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BudgetInterval, int, int> $converterinterval =
      const EnumIndexConverter<BudgetInterval>(BudgetInterval.values);
  static JsonTypeConverter2<BudgetInterval?, int?, int?> $converterintervaln =
      JsonTypeConverter2.asNullable($converterinterval);
  static JsonTypeConverter2<PaymentStatus, int, int> $converterstatus =
      const EnumIndexConverter<PaymentStatus>(PaymentStatus.values);
}

class DriftPaymentReminder extends DataClass
    implements Insertable<DriftPaymentReminder> {
  final int id;
  final int? account;
  final int? fund;
  final int profile;
  final String details;
  final BudgetInterval? interval;
  final int day;
  final int amount;
  final DateTime? paymentDate;
  final DateTime addedDate;
  final DateTime updateDate;
  final PaymentStatus status;
  const DriftPaymentReminder(
      {required this.id,
      this.account,
      this.fund,
      required this.profile,
      required this.details,
      this.interval,
      required this.day,
      required this.amount,
      this.paymentDate,
      required this.addedDate,
      required this.updateDate,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || account != null) {
      map['account'] = Variable<int>(account);
    }
    if (!nullToAbsent || fund != null) {
      map['fund'] = Variable<int>(fund);
    }
    map['profile'] = Variable<int>(profile);
    map['details'] = Variable<String>(details);
    if (!nullToAbsent || interval != null) {
      map['interval'] = Variable<int>(
          $DriftPaymentRemindersTable.$converterintervaln.toSql(interval));
    }
    map['day'] = Variable<int>(day);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || paymentDate != null) {
      map['payment_date'] = Variable<DateTime>(paymentDate);
    }
    map['added_date'] = Variable<DateTime>(addedDate);
    map['update_date'] = Variable<DateTime>(updateDate);
    {
      map['status'] = Variable<int>(
          $DriftPaymentRemindersTable.$converterstatus.toSql(status));
    }
    return map;
  }

  DriftPaymentRemindersCompanion toCompanion(bool nullToAbsent) {
    return DriftPaymentRemindersCompanion(
      id: Value(id),
      account: account == null && nullToAbsent
          ? const Value.absent()
          : Value(account),
      fund: fund == null && nullToAbsent ? const Value.absent() : Value(fund),
      profile: Value(profile),
      details: Value(details),
      interval: interval == null && nullToAbsent
          ? const Value.absent()
          : Value(interval),
      day: Value(day),
      amount: Value(amount),
      paymentDate: paymentDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentDate),
      addedDate: Value(addedDate),
      updateDate: Value(updateDate),
      status: Value(status),
    );
  }

  factory DriftPaymentReminder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftPaymentReminder(
      id: serializer.fromJson<int>(json['id']),
      account: serializer.fromJson<int?>(json['account']),
      fund: serializer.fromJson<int?>(json['fund']),
      profile: serializer.fromJson<int>(json['profile']),
      details: serializer.fromJson<String>(json['details']),
      interval: $DriftPaymentRemindersTable.$converterintervaln
          .fromJson(serializer.fromJson<int?>(json['interval'])),
      day: serializer.fromJson<int>(json['day']),
      amount: serializer.fromJson<int>(json['amount']),
      paymentDate: serializer.fromJson<DateTime?>(json['paymentDate']),
      addedDate: serializer.fromJson<DateTime>(json['addedDate']),
      updateDate: serializer.fromJson<DateTime>(json['updateDate']),
      status: $DriftPaymentRemindersTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'account': serializer.toJson<int?>(account),
      'fund': serializer.toJson<int?>(fund),
      'profile': serializer.toJson<int>(profile),
      'details': serializer.toJson<String>(details),
      'interval': serializer.toJson<int?>(
          $DriftPaymentRemindersTable.$converterintervaln.toJson(interval)),
      'day': serializer.toJson<int>(day),
      'amount': serializer.toJson<int>(amount),
      'paymentDate': serializer.toJson<DateTime?>(paymentDate),
      'addedDate': serializer.toJson<DateTime>(addedDate),
      'updateDate': serializer.toJson<DateTime>(updateDate),
      'status': serializer.toJson<int>(
          $DriftPaymentRemindersTable.$converterstatus.toJson(status)),
    };
  }

  DriftPaymentReminder copyWith(
          {int? id,
          Value<int?> account = const Value.absent(),
          Value<int?> fund = const Value.absent(),
          int? profile,
          String? details,
          Value<BudgetInterval?> interval = const Value.absent(),
          int? day,
          int? amount,
          Value<DateTime?> paymentDate = const Value.absent(),
          DateTime? addedDate,
          DateTime? updateDate,
          PaymentStatus? status}) =>
      DriftPaymentReminder(
        id: id ?? this.id,
        account: account.present ? account.value : this.account,
        fund: fund.present ? fund.value : this.fund,
        profile: profile ?? this.profile,
        details: details ?? this.details,
        interval: interval.present ? interval.value : this.interval,
        day: day ?? this.day,
        amount: amount ?? this.amount,
        paymentDate: paymentDate.present ? paymentDate.value : this.paymentDate,
        addedDate: addedDate ?? this.addedDate,
        updateDate: updateDate ?? this.updateDate,
        status: status ?? this.status,
      );
  DriftPaymentReminder copyWithCompanion(DriftPaymentRemindersCompanion data) {
    return DriftPaymentReminder(
      id: data.id.present ? data.id.value : this.id,
      account: data.account.present ? data.account.value : this.account,
      fund: data.fund.present ? data.fund.value : this.fund,
      profile: data.profile.present ? data.profile.value : this.profile,
      details: data.details.present ? data.details.value : this.details,
      interval: data.interval.present ? data.interval.value : this.interval,
      day: data.day.present ? data.day.value : this.day,
      amount: data.amount.present ? data.amount.value : this.amount,
      paymentDate:
          data.paymentDate.present ? data.paymentDate.value : this.paymentDate,
      addedDate: data.addedDate.present ? data.addedDate.value : this.addedDate,
      updateDate:
          data.updateDate.present ? data.updateDate.value : this.updateDate,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftPaymentReminder(')
          ..write('id: $id, ')
          ..write('account: $account, ')
          ..write('fund: $fund, ')
          ..write('profile: $profile, ')
          ..write('details: $details, ')
          ..write('interval: $interval, ')
          ..write('day: $day, ')
          ..write('amount: $amount, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('addedDate: $addedDate, ')
          ..write('updateDate: $updateDate, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, account, fund, profile, details, interval,
      day, amount, paymentDate, addedDate, updateDate, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftPaymentReminder &&
          other.id == this.id &&
          other.account == this.account &&
          other.fund == this.fund &&
          other.profile == this.profile &&
          other.details == this.details &&
          other.interval == this.interval &&
          other.day == this.day &&
          other.amount == this.amount &&
          other.paymentDate == this.paymentDate &&
          other.addedDate == this.addedDate &&
          other.updateDate == this.updateDate &&
          other.status == this.status);
}

class DriftPaymentRemindersCompanion
    extends UpdateCompanion<DriftPaymentReminder> {
  final Value<int> id;
  final Value<int?> account;
  final Value<int?> fund;
  final Value<int> profile;
  final Value<String> details;
  final Value<BudgetInterval?> interval;
  final Value<int> day;
  final Value<int> amount;
  final Value<DateTime?> paymentDate;
  final Value<DateTime> addedDate;
  final Value<DateTime> updateDate;
  final Value<PaymentStatus> status;
  const DriftPaymentRemindersCompanion({
    this.id = const Value.absent(),
    this.account = const Value.absent(),
    this.fund = const Value.absent(),
    this.profile = const Value.absent(),
    this.details = const Value.absent(),
    this.interval = const Value.absent(),
    this.day = const Value.absent(),
    this.amount = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.addedDate = const Value.absent(),
    this.updateDate = const Value.absent(),
    this.status = const Value.absent(),
  });
  DriftPaymentRemindersCompanion.insert({
    this.id = const Value.absent(),
    this.account = const Value.absent(),
    this.fund = const Value.absent(),
    required int profile,
    required String details,
    this.interval = const Value.absent(),
    this.day = const Value.absent(),
    this.amount = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.addedDate = const Value.absent(),
    this.updateDate = const Value.absent(),
    required PaymentStatus status,
  })  : profile = Value(profile),
        details = Value(details),
        status = Value(status);
  static Insertable<DriftPaymentReminder> custom({
    Expression<int>? id,
    Expression<int>? account,
    Expression<int>? fund,
    Expression<int>? profile,
    Expression<String>? details,
    Expression<int>? interval,
    Expression<int>? day,
    Expression<int>? amount,
    Expression<DateTime>? paymentDate,
    Expression<DateTime>? addedDate,
    Expression<DateTime>? updateDate,
    Expression<int>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (account != null) 'account': account,
      if (fund != null) 'fund': fund,
      if (profile != null) 'profile': profile,
      if (details != null) 'details': details,
      if (interval != null) 'interval': interval,
      if (day != null) 'day': day,
      if (amount != null) 'amount': amount,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (addedDate != null) 'added_date': addedDate,
      if (updateDate != null) 'update_date': updateDate,
      if (status != null) 'status': status,
    });
  }

  DriftPaymentRemindersCompanion copyWith(
      {Value<int>? id,
      Value<int?>? account,
      Value<int?>? fund,
      Value<int>? profile,
      Value<String>? details,
      Value<BudgetInterval?>? interval,
      Value<int>? day,
      Value<int>? amount,
      Value<DateTime?>? paymentDate,
      Value<DateTime>? addedDate,
      Value<DateTime>? updateDate,
      Value<PaymentStatus>? status}) {
    return DriftPaymentRemindersCompanion(
      id: id ?? this.id,
      account: account ?? this.account,
      fund: fund ?? this.fund,
      profile: profile ?? this.profile,
      details: details ?? this.details,
      interval: interval ?? this.interval,
      day: day ?? this.day,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      addedDate: addedDate ?? this.addedDate,
      updateDate: updateDate ?? this.updateDate,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (account.present) {
      map['account'] = Variable<int>(account.value);
    }
    if (fund.present) {
      map['fund'] = Variable<int>(fund.value);
    }
    if (profile.present) {
      map['profile'] = Variable<int>(profile.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (interval.present) {
      map['interval'] = Variable<int>($DriftPaymentRemindersTable
          .$converterintervaln
          .toSql(interval.value));
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<DateTime>(paymentDate.value);
    }
    if (addedDate.present) {
      map['added_date'] = Variable<DateTime>(addedDate.value);
    }
    if (updateDate.present) {
      map['update_date'] = Variable<DateTime>(updateDate.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
          $DriftPaymentRemindersTable.$converterstatus.toSql(status.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftPaymentRemindersCompanion(')
          ..write('id: $id, ')
          ..write('account: $account, ')
          ..write('fund: $fund, ')
          ..write('profile: $profile, ')
          ..write('details: $details, ')
          ..write('interval: $interval, ')
          ..write('day: $day, ')
          ..write('amount: $amount, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('addedDate: $addedDate, ')
          ..write('updateDate: $updateDate, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $DriftFilePathsTable extends DriftFilePaths
    with TableInfo<$DriftFilePathsTable, DriftFilePath> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftFilePathsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumnWithTypeConverter<DBTableType, int> tableType =
      GeneratedColumn<int>('table_type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<DBTableType>($DriftFilePathsTable.$convertertableType);
  static const VerificationMeta _parentTableMeta =
      const VerificationMeta('parentTable');
  @override
  late final GeneratedColumn<int> parentTable = GeneratedColumn<int>(
      'parent_table', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 512),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, tableType, parentTable, path];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_file_paths';
  @override
  VerificationContext validateIntegrity(Insertable<DriftFilePath> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('parent_table')) {
      context.handle(
          _parentTableMeta,
          parentTable.isAcceptableOrUnknown(
              data['parent_table']!, _parentTableMeta));
    } else if (isInserting) {
      context.missing(_parentTableMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftFilePath map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftFilePath(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tableType: $DriftFilePathsTable.$convertertableType.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}table_type'])!),
      parentTable: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_table'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
    );
  }

  @override
  $DriftFilePathsTable createAlias(String alias) {
    return $DriftFilePathsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DBTableType, int, int> $convertertableType =
      const EnumIndexConverter<DBTableType>(DBTableType.values);
}

class DriftFilePath extends DataClass implements Insertable<DriftFilePath> {
  final int id;
  final DBTableType tableType;
  final int parentTable;
  final String path;
  const DriftFilePath(
      {required this.id,
      required this.tableType,
      required this.parentTable,
      required this.path});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['table_type'] = Variable<int>(
          $DriftFilePathsTable.$convertertableType.toSql(tableType));
    }
    map['parent_table'] = Variable<int>(parentTable);
    map['path'] = Variable<String>(path);
    return map;
  }

  DriftFilePathsCompanion toCompanion(bool nullToAbsent) {
    return DriftFilePathsCompanion(
      id: Value(id),
      tableType: Value(tableType),
      parentTable: Value(parentTable),
      path: Value(path),
    );
  }

  factory DriftFilePath.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftFilePath(
      id: serializer.fromJson<int>(json['id']),
      tableType: $DriftFilePathsTable.$convertertableType
          .fromJson(serializer.fromJson<int>(json['tableType'])),
      parentTable: serializer.fromJson<int>(json['parentTable']),
      path: serializer.fromJson<String>(json['path']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tableType': serializer.toJson<int>(
          $DriftFilePathsTable.$convertertableType.toJson(tableType)),
      'parentTable': serializer.toJson<int>(parentTable),
      'path': serializer.toJson<String>(path),
    };
  }

  DriftFilePath copyWith(
          {int? id, DBTableType? tableType, int? parentTable, String? path}) =>
      DriftFilePath(
        id: id ?? this.id,
        tableType: tableType ?? this.tableType,
        parentTable: parentTable ?? this.parentTable,
        path: path ?? this.path,
      );
  DriftFilePath copyWithCompanion(DriftFilePathsCompanion data) {
    return DriftFilePath(
      id: data.id.present ? data.id.value : this.id,
      tableType: data.tableType.present ? data.tableType.value : this.tableType,
      parentTable:
          data.parentTable.present ? data.parentTable.value : this.parentTable,
      path: data.path.present ? data.path.value : this.path,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftFilePath(')
          ..write('id: $id, ')
          ..write('tableType: $tableType, ')
          ..write('parentTable: $parentTable, ')
          ..write('path: $path')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tableType, parentTable, path);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftFilePath &&
          other.id == this.id &&
          other.tableType == this.tableType &&
          other.parentTable == this.parentTable &&
          other.path == this.path);
}

class DriftFilePathsCompanion extends UpdateCompanion<DriftFilePath> {
  final Value<int> id;
  final Value<DBTableType> tableType;
  final Value<int> parentTable;
  final Value<String> path;
  const DriftFilePathsCompanion({
    this.id = const Value.absent(),
    this.tableType = const Value.absent(),
    this.parentTable = const Value.absent(),
    this.path = const Value.absent(),
  });
  DriftFilePathsCompanion.insert({
    this.id = const Value.absent(),
    required DBTableType tableType,
    required int parentTable,
    required String path,
  })  : tableType = Value(tableType),
        parentTable = Value(parentTable),
        path = Value(path);
  static Insertable<DriftFilePath> custom({
    Expression<int>? id,
    Expression<int>? tableType,
    Expression<int>? parentTable,
    Expression<String>? path,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tableType != null) 'table_type': tableType,
      if (parentTable != null) 'parent_table': parentTable,
      if (path != null) 'path': path,
    });
  }

  DriftFilePathsCompanion copyWith(
      {Value<int>? id,
      Value<DBTableType>? tableType,
      Value<int>? parentTable,
      Value<String>? path}) {
    return DriftFilePathsCompanion(
      id: id ?? this.id,
      tableType: tableType ?? this.tableType,
      parentTable: parentTable ?? this.parentTable,
      path: path ?? this.path,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tableType.present) {
      map['table_type'] = Variable<int>(
          $DriftFilePathsTable.$convertertableType.toSql(tableType.value));
    }
    if (parentTable.present) {
      map['parent_table'] = Variable<int>(parentTable.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftFilePathsCompanion(')
          ..write('id: $id, ')
          ..write('tableType: $tableType, ')
          ..write('parentTable: $parentTable, ')
          ..write('path: $path')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDriftDatabase extends GeneratedDatabase {
  _$AppDriftDatabase(QueryExecutor e) : super(e);
  $AppDriftDatabaseManager get managers => $AppDriftDatabaseManager(this);
  late final $DriftAccTypesTable driftAccTypes = $DriftAccTypesTable(this);
  late final $DriftProfilesTable driftProfiles = $DriftProfilesTable(this);
  late final $DriftAccountsTable driftAccounts = $DriftAccountsTable(this);
  late final $DriftBudgetsTable driftBudgets = $DriftBudgetsTable(this);
  late final $DriftProjectsTable driftProjects = $DriftProjectsTable(this);
  late final $DriftTransactionsTable driftTransactions =
      $DriftTransactionsTable(this);
  late final $DriftUsersTable driftUsers = $DriftUsersTable(this);
  late final $DriftBanksTable driftBanks = $DriftBanksTable(this);
  late final $DriftWalletsTable driftWallets = $DriftWalletsTable(this);
  late final $DriftLoansTable driftLoans = $DriftLoansTable(this);
  late final $DriftCCardsTable driftCCards = $DriftCCardsTable(this);
  late final $DriftBalancesTable driftBalances = $DriftBalancesTable(this);
  late final $DriftBudgetAccountsTable driftBudgetAccounts =
      $DriftBudgetAccountsTable(this);
  late final $DriftBudgetFundsTable driftBudgetFunds =
      $DriftBudgetFundsTable(this);
  late final $DriftReceivablesTable driftReceivables =
      $DriftReceivablesTable(this);
  late final $DriftPeopleTable driftPeople = $DriftPeopleTable(this);
  late final $DriftPaymentRemindersTable driftPaymentReminders =
      $DriftPaymentRemindersTable(this);
  late final $DriftFilePathsTable driftFilePaths = $DriftFilePathsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        driftAccTypes,
        driftProfiles,
        driftAccounts,
        driftBudgets,
        driftProjects,
        driftTransactions,
        driftUsers,
        driftBanks,
        driftWallets,
        driftLoans,
        driftCCards,
        driftBalances,
        driftBudgetAccounts,
        driftBudgetFunds,
        driftReceivables,
        driftPeople,
        driftPaymentReminders,
        driftFilePaths
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_acc_types',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_accounts', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_profiles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_accounts', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_profiles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_budgets', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_profiles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_projects', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_budgets',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_projects', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_transactions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_transactions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_profiles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_transactions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_projects',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_transactions', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_banks', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_wallets', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_loans', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_c_cards', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_balances', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_budget_accounts', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_budgets',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_budget_accounts', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_budget_funds', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_budgets',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_budget_funds', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_receivables', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_people', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_payment_reminders', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_payment_reminders', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('drift_profiles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('drift_payment_reminders', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$DriftAccTypesTableCreateCompanionBuilder = DriftAccTypesCompanion
    Function({
  Value<int> id,
  required String name,
  required PrimaryType primary,
  Value<DateTime> addedDate,
  Value<DateTime> updateDate,
  Value<bool> isEditable,
});
typedef $$DriftAccTypesTableUpdateCompanionBuilder = DriftAccTypesCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<PrimaryType> primary,
  Value<DateTime> addedDate,
  Value<DateTime> updateDate,
  Value<bool> isEditable,
});

final class $$DriftAccTypesTableReferences extends BaseReferences<
    _$AppDriftDatabase, $DriftAccTypesTable, DriftAccType> {
  $$DriftAccTypesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DriftAccountsTable, List<DriftAccount>>
      _driftAccountsRefsTable(_$AppDriftDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftAccounts,
              aliasName: $_aliasNameGenerator(
                  db.driftAccTypes.id, db.driftAccounts.accType));

  $$DriftAccountsTableProcessedTableManager get driftAccountsRefs {
    final manager = $$DriftAccountsTableTableManager($_db, $_db.driftAccounts)
        .filter((f) => f.accType.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_driftAccountsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DriftAccTypesTableFilterComposer
    extends Composer<_$AppDriftDatabase, $DriftAccTypesTable> {
  $$DriftAccTypesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<PrimaryType, PrimaryType, int> get primary =>
      $composableBuilder(
          column: $table.primary,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get addedDate => $composableBuilder(
      column: $table.addedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEditable => $composableBuilder(
      column: $table.isEditable, builder: (column) => ColumnFilters(column));

  Expression<bool> driftAccountsRefs(
      Expression<bool> Function($$DriftAccountsTableFilterComposer f) f) {
    final $$DriftAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.accType,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableFilterComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DriftAccTypesTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $DriftAccTypesTable> {
  $$DriftAccTypesTableOrderingComposer({
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

  ColumnOrderings<int> get primary => $composableBuilder(
      column: $table.primary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedDate => $composableBuilder(
      column: $table.addedDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEditable => $composableBuilder(
      column: $table.isEditable, builder: (column) => ColumnOrderings(column));
}

class $$DriftAccTypesTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $DriftAccTypesTable> {
  $$DriftAccTypesTableAnnotationComposer({
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

  GeneratedColumnWithTypeConverter<PrimaryType, int> get primary =>
      $composableBuilder(column: $table.primary, builder: (column) => column);

  GeneratedColumn<DateTime> get addedDate =>
      $composableBuilder(column: $table.addedDate, builder: (column) => column);

  GeneratedColumn<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => column);

  GeneratedColumn<bool> get isEditable => $composableBuilder(
      column: $table.isEditable, builder: (column) => column);

  Expression<T> driftAccountsRefs<T extends Object>(
      Expression<T> Function($$DriftAccountsTableAnnotationComposer a) f) {
    final $$DriftAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.accType,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DriftAccTypesTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $DriftAccTypesTable,
    DriftAccType,
    $$DriftAccTypesTableFilterComposer,
    $$DriftAccTypesTableOrderingComposer,
    $$DriftAccTypesTableAnnotationComposer,
    $$DriftAccTypesTableCreateCompanionBuilder,
    $$DriftAccTypesTableUpdateCompanionBuilder,
    (DriftAccType, $$DriftAccTypesTableReferences),
    DriftAccType,
    PrefetchHooks Function({bool driftAccountsRefs})> {
  $$DriftAccTypesTableTableManager(
      _$AppDriftDatabase db, $DriftAccTypesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftAccTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftAccTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftAccTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<PrimaryType> primary = const Value.absent(),
            Value<DateTime> addedDate = const Value.absent(),
            Value<DateTime> updateDate = const Value.absent(),
            Value<bool> isEditable = const Value.absent(),
          }) =>
              DriftAccTypesCompanion(
            id: id,
            name: name,
            primary: primary,
            addedDate: addedDate,
            updateDate: updateDate,
            isEditable: isEditable,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required PrimaryType primary,
            Value<DateTime> addedDate = const Value.absent(),
            Value<DateTime> updateDate = const Value.absent(),
            Value<bool> isEditable = const Value.absent(),
          }) =>
              DriftAccTypesCompanion.insert(
            id: id,
            name: name,
            primary: primary,
            addedDate: addedDate,
            updateDate: updateDate,
            isEditable: isEditable,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DriftAccTypesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({driftAccountsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (driftAccountsRefs) db.driftAccounts
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (driftAccountsRefs)
                    await $_getPrefetchedData<DriftAccType, $DriftAccTypesTable,
                            DriftAccount>(
                        currentTable: table,
                        referencedTable: $$DriftAccTypesTableReferences
                            ._driftAccountsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftAccTypesTableReferences(db, table, p0)
                                .driftAccountsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.accType == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DriftAccTypesTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $DriftAccTypesTable,
    DriftAccType,
    $$DriftAccTypesTableFilterComposer,
    $$DriftAccTypesTableOrderingComposer,
    $$DriftAccTypesTableAnnotationComposer,
    $$DriftAccTypesTableCreateCompanionBuilder,
    $$DriftAccTypesTableUpdateCompanionBuilder,
    (DriftAccType, $$DriftAccTypesTableReferences),
    DriftAccType,
    PrefetchHooks Function({bool driftAccountsRefs})>;
typedef $$DriftProfilesTableCreateCompanionBuilder = DriftProfilesCompanion
    Function({
  Value<int> id,
  required String name,
  Value<String?> alias,
  Value<String?> address,
  Value<String?> zip,
  Value<String?> email,
  Value<String?> phone,
  Value<String?> tin,
  Value<bool> isSelected,
  required Currency currency,
  Value<String?> globalID,
  Value<bool> isLocal,
  Value<DateTime> addedDate,
  Value<DateTime> updateDate,
});
typedef $$DriftProfilesTableUpdateCompanionBuilder = DriftProfilesCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String?> alias,
  Value<String?> address,
  Value<String?> zip,
  Value<String?> email,
  Value<String?> phone,
  Value<String?> tin,
  Value<bool> isSelected,
  Value<Currency> currency,
  Value<String?> globalID,
  Value<bool> isLocal,
  Value<DateTime> addedDate,
  Value<DateTime> updateDate,
});

final class $$DriftProfilesTableReferences extends BaseReferences<
    _$AppDriftDatabase, $DriftProfilesTable, DriftProfile> {
  $$DriftProfilesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DriftAccountsTable, List<DriftAccount>>
      _driftAccountsRefsTable(_$AppDriftDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftAccounts,
              aliasName: $_aliasNameGenerator(
                  db.driftProfiles.id, db.driftAccounts.profile));

  $$DriftAccountsTableProcessedTableManager get driftAccountsRefs {
    final manager = $$DriftAccountsTableTableManager($_db, $_db.driftAccounts)
        .filter((f) => f.profile.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_driftAccountsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DriftBudgetsTable, List<DriftBudget>>
      _driftBudgetsRefsTable(_$AppDriftDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftBudgets,
              aliasName: $_aliasNameGenerator(
                  db.driftProfiles.id, db.driftBudgets.profile));

  $$DriftBudgetsTableProcessedTableManager get driftBudgetsRefs {
    final manager = $$DriftBudgetsTableTableManager($_db, $_db.driftBudgets)
        .filter((f) => f.profile.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_driftBudgetsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DriftProjectsTable, List<DriftProject>>
      _driftProjectsRefsTable(_$AppDriftDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftProjects,
              aliasName: $_aliasNameGenerator(
                  db.driftProfiles.id, db.driftProjects.profile));

  $$DriftProjectsTableProcessedTableManager get driftProjectsRefs {
    final manager = $$DriftProjectsTableTableManager($_db, $_db.driftProjects)
        .filter((f) => f.profile.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_driftProjectsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DriftTransactionsTable, List<DriftTransaction>>
      _driftTransactionsRefsTable(_$AppDriftDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftTransactions,
              aliasName: $_aliasNameGenerator(
                  db.driftProfiles.id, db.driftTransactions.profile));

  $$DriftTransactionsTableProcessedTableManager get driftTransactionsRefs {
    final manager =
        $$DriftTransactionsTableTableManager($_db, $_db.driftTransactions)
            .filter((f) => f.profile.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_driftTransactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DriftPaymentRemindersTable,
      List<DriftPaymentReminder>> _driftPaymentRemindersRefsTable(
          _$AppDriftDatabase db) =>
      MultiTypedResultKey.fromTable(db.driftPaymentReminders,
          aliasName: $_aliasNameGenerator(
              db.driftProfiles.id, db.driftPaymentReminders.profile));

  $$DriftPaymentRemindersTableProcessedTableManager
      get driftPaymentRemindersRefs {
    final manager = $$DriftPaymentRemindersTableTableManager(
            $_db, $_db.driftPaymentReminders)
        .filter((f) => f.profile.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_driftPaymentRemindersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DriftProfilesTableFilterComposer
    extends Composer<_$AppDriftDatabase, $DriftProfilesTable> {
  $$DriftProfilesTableFilterComposer({
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

  ColumnFilters<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get zip => $composableBuilder(
      column: $table.zip, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tin => $composableBuilder(
      column: $table.tin, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSelected => $composableBuilder(
      column: $table.isSelected, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Currency, Currency, int> get currency =>
      $composableBuilder(
          column: $table.currency,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get globalID => $composableBuilder(
      column: $table.globalID, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isLocal => $composableBuilder(
      column: $table.isLocal, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedDate => $composableBuilder(
      column: $table.addedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => ColumnFilters(column));

  Expression<bool> driftAccountsRefs(
      Expression<bool> Function($$DriftAccountsTableFilterComposer f) f) {
    final $$DriftAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.profile,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableFilterComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> driftBudgetsRefs(
      Expression<bool> Function($$DriftBudgetsTableFilterComposer f) f) {
    final $$DriftBudgetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftBudgets,
        getReferencedColumn: (t) => t.profile,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBudgetsTableFilterComposer(
              $db: $db,
              $table: $db.driftBudgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> driftProjectsRefs(
      Expression<bool> Function($$DriftProjectsTableFilterComposer f) f) {
    final $$DriftProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftProjects,
        getReferencedColumn: (t) => t.profile,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProjectsTableFilterComposer(
              $db: $db,
              $table: $db.driftProjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> driftTransactionsRefs(
      Expression<bool> Function($$DriftTransactionsTableFilterComposer f) f) {
    final $$DriftTransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftTransactions,
        getReferencedColumn: (t) => t.profile,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftTransactionsTableFilterComposer(
              $db: $db,
              $table: $db.driftTransactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> driftPaymentRemindersRefs(
      Expression<bool> Function($$DriftPaymentRemindersTableFilterComposer f)
          f) {
    final $$DriftPaymentRemindersTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.driftPaymentReminders,
            getReferencedColumn: (t) => t.profile,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DriftPaymentRemindersTableFilterComposer(
                  $db: $db,
                  $table: $db.driftPaymentReminders,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$DriftProfilesTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $DriftProfilesTable> {
  $$DriftProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get zip => $composableBuilder(
      column: $table.zip, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tin => $composableBuilder(
      column: $table.tin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSelected => $composableBuilder(
      column: $table.isSelected, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get globalID => $composableBuilder(
      column: $table.globalID, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isLocal => $composableBuilder(
      column: $table.isLocal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedDate => $composableBuilder(
      column: $table.addedDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => ColumnOrderings(column));
}

class $$DriftProfilesTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $DriftProfilesTable> {
  $$DriftProfilesTableAnnotationComposer({
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

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get zip =>
      $composableBuilder(column: $table.zip, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get tin =>
      $composableBuilder(column: $table.tin, builder: (column) => column);

  GeneratedColumn<bool> get isSelected => $composableBuilder(
      column: $table.isSelected, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Currency, int> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get globalID =>
      $composableBuilder(column: $table.globalID, builder: (column) => column);

  GeneratedColumn<bool> get isLocal =>
      $composableBuilder(column: $table.isLocal, builder: (column) => column);

  GeneratedColumn<DateTime> get addedDate =>
      $composableBuilder(column: $table.addedDate, builder: (column) => column);

  GeneratedColumn<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => column);

  Expression<T> driftAccountsRefs<T extends Object>(
      Expression<T> Function($$DriftAccountsTableAnnotationComposer a) f) {
    final $$DriftAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.profile,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> driftBudgetsRefs<T extends Object>(
      Expression<T> Function($$DriftBudgetsTableAnnotationComposer a) f) {
    final $$DriftBudgetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftBudgets,
        getReferencedColumn: (t) => t.profile,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBudgetsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftBudgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> driftProjectsRefs<T extends Object>(
      Expression<T> Function($$DriftProjectsTableAnnotationComposer a) f) {
    final $$DriftProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftProjects,
        getReferencedColumn: (t) => t.profile,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftProjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> driftTransactionsRefs<T extends Object>(
      Expression<T> Function($$DriftTransactionsTableAnnotationComposer a) f) {
    final $$DriftTransactionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.driftTransactions,
            getReferencedColumn: (t) => t.profile,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DriftTransactionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.driftTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> driftPaymentRemindersRefs<T extends Object>(
      Expression<T> Function($$DriftPaymentRemindersTableAnnotationComposer a)
          f) {
    final $$DriftPaymentRemindersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.driftPaymentReminders,
            getReferencedColumn: (t) => t.profile,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DriftPaymentRemindersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.driftPaymentReminders,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$DriftProfilesTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $DriftProfilesTable,
    DriftProfile,
    $$DriftProfilesTableFilterComposer,
    $$DriftProfilesTableOrderingComposer,
    $$DriftProfilesTableAnnotationComposer,
    $$DriftProfilesTableCreateCompanionBuilder,
    $$DriftProfilesTableUpdateCompanionBuilder,
    (DriftProfile, $$DriftProfilesTableReferences),
    DriftProfile,
    PrefetchHooks Function(
        {bool driftAccountsRefs,
        bool driftBudgetsRefs,
        bool driftProjectsRefs,
        bool driftTransactionsRefs,
        bool driftPaymentRemindersRefs})> {
  $$DriftProfilesTableTableManager(
      _$AppDriftDatabase db, $DriftProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> alias = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> zip = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> tin = const Value.absent(),
            Value<bool> isSelected = const Value.absent(),
            Value<Currency> currency = const Value.absent(),
            Value<String?> globalID = const Value.absent(),
            Value<bool> isLocal = const Value.absent(),
            Value<DateTime> addedDate = const Value.absent(),
            Value<DateTime> updateDate = const Value.absent(),
          }) =>
              DriftProfilesCompanion(
            id: id,
            name: name,
            alias: alias,
            address: address,
            zip: zip,
            email: email,
            phone: phone,
            tin: tin,
            isSelected: isSelected,
            currency: currency,
            globalID: globalID,
            isLocal: isLocal,
            addedDate: addedDate,
            updateDate: updateDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> alias = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> zip = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> tin = const Value.absent(),
            Value<bool> isSelected = const Value.absent(),
            required Currency currency,
            Value<String?> globalID = const Value.absent(),
            Value<bool> isLocal = const Value.absent(),
            Value<DateTime> addedDate = const Value.absent(),
            Value<DateTime> updateDate = const Value.absent(),
          }) =>
              DriftProfilesCompanion.insert(
            id: id,
            name: name,
            alias: alias,
            address: address,
            zip: zip,
            email: email,
            phone: phone,
            tin: tin,
            isSelected: isSelected,
            currency: currency,
            globalID: globalID,
            isLocal: isLocal,
            addedDate: addedDate,
            updateDate: updateDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DriftProfilesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {driftAccountsRefs = false,
              driftBudgetsRefs = false,
              driftProjectsRefs = false,
              driftTransactionsRefs = false,
              driftPaymentRemindersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (driftAccountsRefs) db.driftAccounts,
                if (driftBudgetsRefs) db.driftBudgets,
                if (driftProjectsRefs) db.driftProjects,
                if (driftTransactionsRefs) db.driftTransactions,
                if (driftPaymentRemindersRefs) db.driftPaymentReminders
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (driftAccountsRefs)
                    await $_getPrefetchedData<DriftProfile, $DriftProfilesTable,
                            DriftAccount>(
                        currentTable: table,
                        referencedTable: $$DriftProfilesTableReferences
                            ._driftAccountsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftProfilesTableReferences(db, table, p0)
                                .driftAccountsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.profile == item.id),
                        typedResults: items),
                  if (driftBudgetsRefs)
                    await $_getPrefetchedData<DriftProfile, $DriftProfilesTable,
                            DriftBudget>(
                        currentTable: table,
                        referencedTable: $$DriftProfilesTableReferences
                            ._driftBudgetsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftProfilesTableReferences(db, table, p0)
                                .driftBudgetsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.profile == item.id),
                        typedResults: items),
                  if (driftProjectsRefs)
                    await $_getPrefetchedData<DriftProfile, $DriftProfilesTable,
                            DriftProject>(
                        currentTable: table,
                        referencedTable: $$DriftProfilesTableReferences
                            ._driftProjectsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftProfilesTableReferences(db, table, p0)
                                .driftProjectsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.profile == item.id),
                        typedResults: items),
                  if (driftTransactionsRefs)
                    await $_getPrefetchedData<DriftProfile, $DriftProfilesTable,
                            DriftTransaction>(
                        currentTable: table,
                        referencedTable: $$DriftProfilesTableReferences
                            ._driftTransactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftProfilesTableReferences(db, table, p0)
                                .driftTransactionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.profile == item.id),
                        typedResults: items),
                  if (driftPaymentRemindersRefs)
                    await $_getPrefetchedData<DriftProfile, $DriftProfilesTable,
                            DriftPaymentReminder>(
                        currentTable: table,
                        referencedTable: $$DriftProfilesTableReferences
                            ._driftPaymentRemindersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftProfilesTableReferences(db, table, p0)
                                .driftPaymentRemindersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.profile == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DriftProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $DriftProfilesTable,
    DriftProfile,
    $$DriftProfilesTableFilterComposer,
    $$DriftProfilesTableOrderingComposer,
    $$DriftProfilesTableAnnotationComposer,
    $$DriftProfilesTableCreateCompanionBuilder,
    $$DriftProfilesTableUpdateCompanionBuilder,
    (DriftProfile, $$DriftProfilesTableReferences),
    DriftProfile,
    PrefetchHooks Function(
        {bool driftAccountsRefs,
        bool driftBudgetsRefs,
        bool driftProjectsRefs,
        bool driftTransactionsRefs,
        bool driftPaymentRemindersRefs})>;
typedef $$DriftAccountsTableCreateCompanionBuilder = DriftAccountsCompanion
    Function({
  Value<int> id,
  required String name,
  Value<int> openBal,
  Value<DateTime> openDate,
  required int accType,
  Value<DateTime> addedDate,
  Value<DateTime> updateDate,
  Value<bool> isEditable,
  required int profile,
});
typedef $$DriftAccountsTableUpdateCompanionBuilder = DriftAccountsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int> openBal,
  Value<DateTime> openDate,
  Value<int> accType,
  Value<DateTime> addedDate,
  Value<DateTime> updateDate,
  Value<bool> isEditable,
  Value<int> profile,
});

final class $$DriftAccountsTableReferences extends BaseReferences<
    _$AppDriftDatabase, $DriftAccountsTable, DriftAccount> {
  $$DriftAccountsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DriftAccTypesTable _accTypeTable(_$AppDriftDatabase db) =>
      db.driftAccTypes.createAlias(
          $_aliasNameGenerator(db.driftAccounts.accType, db.driftAccTypes.id));

  $$DriftAccTypesTableProcessedTableManager get accType {
    final $_column = $_itemColumn<int>('acc_type')!;

    final manager = $$DriftAccTypesTableTableManager($_db, $_db.driftAccTypes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accTypeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DriftProfilesTable _profileTable(_$AppDriftDatabase db) =>
      db.driftProfiles.createAlias(
          $_aliasNameGenerator(db.driftAccounts.profile, db.driftProfiles.id));

  $$DriftProfilesTableProcessedTableManager get profile {
    final $_column = $_itemColumn<int>('profile')!;

    final manager = $$DriftProfilesTableTableManager($_db, $_db.driftProfiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$DriftTransactionsTable, List<DriftTransaction>>
      _drAccountTable(_$AppDriftDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftTransactions,
              aliasName: $_aliasNameGenerator(
                  db.driftAccounts.id, db.driftTransactions.dr));

  $$DriftTransactionsTableProcessedTableManager get drAccount {
    final manager =
        $$DriftTransactionsTableTableManager($_db, $_db.driftTransactions)
            .filter((f) => f.dr.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_drAccountTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DriftTransactionsTable, List<DriftTransaction>>
      _crAccountTable(_$AppDriftDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftTransactions,
              aliasName: $_aliasNameGenerator(
                  db.driftAccounts.id, db.driftTransactions.cr));

  $$DriftTransactionsTableProcessedTableManager get crAccount {
    final manager =
        $$DriftTransactionsTableTableManager($_db, $_db.driftTransactions)
            .filter((f) => f.cr.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_crAccountTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DriftBanksTable, List<DriftBank>>
      _driftBanksRefsTable(_$AppDriftDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftBanks,
              aliasName: $_aliasNameGenerator(
                  db.driftAccounts.id, db.driftBanks.account));

  $$DriftBanksTableProcessedTableManager get driftBanksRefs {
    final manager = $$DriftBanksTableTableManager($_db, $_db.driftBanks)
        .filter((f) => f.account.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_driftBanksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DriftWalletsTable, List<DriftWallet>>
      _driftWalletsRefsTable(_$AppDriftDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftWallets,
              aliasName: $_aliasNameGenerator(
                  db.driftAccounts.id, db.driftWallets.account));

  $$DriftWalletsTableProcessedTableManager get driftWalletsRefs {
    final manager = $$DriftWalletsTableTableManager($_db, $_db.driftWallets)
        .filter((f) => f.account.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_driftWalletsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DriftLoansTable, List<DriftLoan>>
      _driftLoansRefsTable(_$AppDriftDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftLoans,
              aliasName: $_aliasNameGenerator(
                  db.driftAccounts.id, db.driftLoans.account));

  $$DriftLoansTableProcessedTableManager get driftLoansRefs {
    final manager = $$DriftLoansTableTableManager($_db, $_db.driftLoans)
        .filter((f) => f.account.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_driftLoansRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DriftCCardsTable, List<DriftCCard>>
      _driftCCardsRefsTable(_$AppDriftDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftCCards,
              aliasName: $_aliasNameGenerator(
                  db.driftAccounts.id, db.driftCCards.account));

  $$DriftCCardsTableProcessedTableManager get driftCCardsRefs {
    final manager = $$DriftCCardsTableTableManager($_db, $_db.driftCCards)
        .filter((f) => f.account.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_driftCCardsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DriftBalancesTable, List<DriftBalance>>
      _driftBalancesRefsTable(_$AppDriftDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftBalances,
              aliasName: $_aliasNameGenerator(
                  db.driftAccounts.id, db.driftBalances.account));

  $$DriftBalancesTableProcessedTableManager get driftBalancesRefs {
    final manager = $$DriftBalancesTableTableManager($_db, $_db.driftBalances)
        .filter((f) => f.account.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_driftBalancesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DriftBudgetAccountsTable,
      List<DriftBudgetAccount>> _driftBudgetAccountsRefsTable(
          _$AppDriftDatabase db) =>
      MultiTypedResultKey.fromTable(db.driftBudgetAccounts,
          aliasName: $_aliasNameGenerator(
              db.driftAccounts.id, db.driftBudgetAccounts.account));

  $$DriftBudgetAccountsTableProcessedTableManager get driftBudgetAccountsRefs {
    final manager =
        $$DriftBudgetAccountsTableTableManager($_db, $_db.driftBudgetAccounts)
            .filter((f) => f.account.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_driftBudgetAccountsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DriftBudgetFundsTable, List<DriftBudgetFund>>
      _driftBudgetFundsRefsTable(_$AppDriftDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftBudgetFunds,
              aliasName: $_aliasNameGenerator(
                  db.driftAccounts.id, db.driftBudgetFunds.account));

  $$DriftBudgetFundsTableProcessedTableManager get driftBudgetFundsRefs {
    final manager =
        $$DriftBudgetFundsTableTableManager($_db, $_db.driftBudgetFunds)
            .filter((f) => f.account.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_driftBudgetFundsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DriftReceivablesTable, List<DriftReceivable>>
      _driftReceivablesRefsTable(_$AppDriftDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftReceivables,
              aliasName: $_aliasNameGenerator(
                  db.driftAccounts.id, db.driftReceivables.accountId));

  $$DriftReceivablesTableProcessedTableManager get driftReceivablesRefs {
    final manager =
        $$DriftReceivablesTableTableManager($_db, $_db.driftReceivables)
            .filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_driftReceivablesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DriftPeopleTable, List<DriftPeopleData>>
      _driftPeopleRefsTable(_$AppDriftDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftPeople,
              aliasName: $_aliasNameGenerator(
                  db.driftAccounts.id, db.driftPeople.accountId));

  $$DriftPeopleTableProcessedTableManager get driftPeopleRefs {
    final manager = $$DriftPeopleTableTableManager($_db, $_db.driftPeople)
        .filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_driftPeopleRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DriftPaymentRemindersTable,
      List<DriftPaymentReminder>> _accountTable(
          _$AppDriftDatabase db) =>
      MultiTypedResultKey.fromTable(db.driftPaymentReminders,
          aliasName: $_aliasNameGenerator(
              db.driftAccounts.id, db.driftPaymentReminders.account));

  $$DriftPaymentRemindersTableProcessedTableManager get account {
    final manager = $$DriftPaymentRemindersTableTableManager(
            $_db, $_db.driftPaymentReminders)
        .filter((f) => f.account.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_accountTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DriftPaymentRemindersTable,
      List<DriftPaymentReminder>> _fundTable(
          _$AppDriftDatabase db) =>
      MultiTypedResultKey.fromTable(db.driftPaymentReminders,
          aliasName: $_aliasNameGenerator(
              db.driftAccounts.id, db.driftPaymentReminders.fund));

  $$DriftPaymentRemindersTableProcessedTableManager get fund {
    final manager = $$DriftPaymentRemindersTableTableManager(
            $_db, $_db.driftPaymentReminders)
        .filter((f) => f.fund.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fundTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DriftAccountsTableFilterComposer
    extends Composer<_$AppDriftDatabase, $DriftAccountsTable> {
  $$DriftAccountsTableFilterComposer({
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

  ColumnFilters<int> get openBal => $composableBuilder(
      column: $table.openBal, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get openDate => $composableBuilder(
      column: $table.openDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedDate => $composableBuilder(
      column: $table.addedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEditable => $composableBuilder(
      column: $table.isEditable, builder: (column) => ColumnFilters(column));

  $$DriftAccTypesTableFilterComposer get accType {
    final $$DriftAccTypesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accType,
        referencedTable: $db.driftAccTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccTypesTableFilterComposer(
              $db: $db,
              $table: $db.driftAccTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftProfilesTableFilterComposer get profile {
    final $$DriftProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profile,
        referencedTable: $db.driftProfiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProfilesTableFilterComposer(
              $db: $db,
              $table: $db.driftProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> drAccount(
      Expression<bool> Function($$DriftTransactionsTableFilterComposer f) f) {
    final $$DriftTransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftTransactions,
        getReferencedColumn: (t) => t.dr,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftTransactionsTableFilterComposer(
              $db: $db,
              $table: $db.driftTransactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> crAccount(
      Expression<bool> Function($$DriftTransactionsTableFilterComposer f) f) {
    final $$DriftTransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftTransactions,
        getReferencedColumn: (t) => t.cr,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftTransactionsTableFilterComposer(
              $db: $db,
              $table: $db.driftTransactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> driftBanksRefs(
      Expression<bool> Function($$DriftBanksTableFilterComposer f) f) {
    final $$DriftBanksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftBanks,
        getReferencedColumn: (t) => t.account,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBanksTableFilterComposer(
              $db: $db,
              $table: $db.driftBanks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> driftWalletsRefs(
      Expression<bool> Function($$DriftWalletsTableFilterComposer f) f) {
    final $$DriftWalletsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftWallets,
        getReferencedColumn: (t) => t.account,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftWalletsTableFilterComposer(
              $db: $db,
              $table: $db.driftWallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> driftLoansRefs(
      Expression<bool> Function($$DriftLoansTableFilterComposer f) f) {
    final $$DriftLoansTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftLoans,
        getReferencedColumn: (t) => t.account,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftLoansTableFilterComposer(
              $db: $db,
              $table: $db.driftLoans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> driftCCardsRefs(
      Expression<bool> Function($$DriftCCardsTableFilterComposer f) f) {
    final $$DriftCCardsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftCCards,
        getReferencedColumn: (t) => t.account,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftCCardsTableFilterComposer(
              $db: $db,
              $table: $db.driftCCards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> driftBalancesRefs(
      Expression<bool> Function($$DriftBalancesTableFilterComposer f) f) {
    final $$DriftBalancesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftBalances,
        getReferencedColumn: (t) => t.account,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBalancesTableFilterComposer(
              $db: $db,
              $table: $db.driftBalances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> driftBudgetAccountsRefs(
      Expression<bool> Function($$DriftBudgetAccountsTableFilterComposer f) f) {
    final $$DriftBudgetAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftBudgetAccounts,
        getReferencedColumn: (t) => t.account,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBudgetAccountsTableFilterComposer(
              $db: $db,
              $table: $db.driftBudgetAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> driftBudgetFundsRefs(
      Expression<bool> Function($$DriftBudgetFundsTableFilterComposer f) f) {
    final $$DriftBudgetFundsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftBudgetFunds,
        getReferencedColumn: (t) => t.account,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBudgetFundsTableFilterComposer(
              $db: $db,
              $table: $db.driftBudgetFunds,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> driftReceivablesRefs(
      Expression<bool> Function($$DriftReceivablesTableFilterComposer f) f) {
    final $$DriftReceivablesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftReceivables,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftReceivablesTableFilterComposer(
              $db: $db,
              $table: $db.driftReceivables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> driftPeopleRefs(
      Expression<bool> Function($$DriftPeopleTableFilterComposer f) f) {
    final $$DriftPeopleTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftPeople,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftPeopleTableFilterComposer(
              $db: $db,
              $table: $db.driftPeople,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> account(
      Expression<bool> Function($$DriftPaymentRemindersTableFilterComposer f)
          f) {
    final $$DriftPaymentRemindersTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.driftPaymentReminders,
            getReferencedColumn: (t) => t.account,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DriftPaymentRemindersTableFilterComposer(
                  $db: $db,
                  $table: $db.driftPaymentReminders,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> fund(
      Expression<bool> Function($$DriftPaymentRemindersTableFilterComposer f)
          f) {
    final $$DriftPaymentRemindersTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.driftPaymentReminders,
            getReferencedColumn: (t) => t.fund,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DriftPaymentRemindersTableFilterComposer(
                  $db: $db,
                  $table: $db.driftPaymentReminders,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$DriftAccountsTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $DriftAccountsTable> {
  $$DriftAccountsTableOrderingComposer({
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

  ColumnOrderings<int> get openBal => $composableBuilder(
      column: $table.openBal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get openDate => $composableBuilder(
      column: $table.openDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedDate => $composableBuilder(
      column: $table.addedDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEditable => $composableBuilder(
      column: $table.isEditable, builder: (column) => ColumnOrderings(column));

  $$DriftAccTypesTableOrderingComposer get accType {
    final $$DriftAccTypesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accType,
        referencedTable: $db.driftAccTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccTypesTableOrderingComposer(
              $db: $db,
              $table: $db.driftAccTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftProfilesTableOrderingComposer get profile {
    final $$DriftProfilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profile,
        referencedTable: $db.driftProfiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProfilesTableOrderingComposer(
              $db: $db,
              $table: $db.driftProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftAccountsTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $DriftAccountsTable> {
  $$DriftAccountsTableAnnotationComposer({
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

  GeneratedColumn<int> get openBal =>
      $composableBuilder(column: $table.openBal, builder: (column) => column);

  GeneratedColumn<DateTime> get openDate =>
      $composableBuilder(column: $table.openDate, builder: (column) => column);

  GeneratedColumn<DateTime> get addedDate =>
      $composableBuilder(column: $table.addedDate, builder: (column) => column);

  GeneratedColumn<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => column);

  GeneratedColumn<bool> get isEditable => $composableBuilder(
      column: $table.isEditable, builder: (column) => column);

  $$DriftAccTypesTableAnnotationComposer get accType {
    final $$DriftAccTypesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accType,
        referencedTable: $db.driftAccTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccTypesTableAnnotationComposer(
              $db: $db,
              $table: $db.driftAccTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftProfilesTableAnnotationComposer get profile {
    final $$DriftProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profile,
        referencedTable: $db.driftProfiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.driftProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> drAccount<T extends Object>(
      Expression<T> Function($$DriftTransactionsTableAnnotationComposer a) f) {
    final $$DriftTransactionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.driftTransactions,
            getReferencedColumn: (t) => t.dr,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DriftTransactionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.driftTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> crAccount<T extends Object>(
      Expression<T> Function($$DriftTransactionsTableAnnotationComposer a) f) {
    final $$DriftTransactionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.driftTransactions,
            getReferencedColumn: (t) => t.cr,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DriftTransactionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.driftTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> driftBanksRefs<T extends Object>(
      Expression<T> Function($$DriftBanksTableAnnotationComposer a) f) {
    final $$DriftBanksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftBanks,
        getReferencedColumn: (t) => t.account,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBanksTableAnnotationComposer(
              $db: $db,
              $table: $db.driftBanks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> driftWalletsRefs<T extends Object>(
      Expression<T> Function($$DriftWalletsTableAnnotationComposer a) f) {
    final $$DriftWalletsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftWallets,
        getReferencedColumn: (t) => t.account,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftWalletsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftWallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> driftLoansRefs<T extends Object>(
      Expression<T> Function($$DriftLoansTableAnnotationComposer a) f) {
    final $$DriftLoansTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftLoans,
        getReferencedColumn: (t) => t.account,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftLoansTableAnnotationComposer(
              $db: $db,
              $table: $db.driftLoans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> driftCCardsRefs<T extends Object>(
      Expression<T> Function($$DriftCCardsTableAnnotationComposer a) f) {
    final $$DriftCCardsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftCCards,
        getReferencedColumn: (t) => t.account,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftCCardsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftCCards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> driftBalancesRefs<T extends Object>(
      Expression<T> Function($$DriftBalancesTableAnnotationComposer a) f) {
    final $$DriftBalancesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftBalances,
        getReferencedColumn: (t) => t.account,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBalancesTableAnnotationComposer(
              $db: $db,
              $table: $db.driftBalances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> driftBudgetAccountsRefs<T extends Object>(
      Expression<T> Function($$DriftBudgetAccountsTableAnnotationComposer a)
          f) {
    final $$DriftBudgetAccountsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.driftBudgetAccounts,
            getReferencedColumn: (t) => t.account,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DriftBudgetAccountsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.driftBudgetAccounts,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> driftBudgetFundsRefs<T extends Object>(
      Expression<T> Function($$DriftBudgetFundsTableAnnotationComposer a) f) {
    final $$DriftBudgetFundsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftBudgetFunds,
        getReferencedColumn: (t) => t.account,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBudgetFundsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftBudgetFunds,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> driftReceivablesRefs<T extends Object>(
      Expression<T> Function($$DriftReceivablesTableAnnotationComposer a) f) {
    final $$DriftReceivablesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftReceivables,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftReceivablesTableAnnotationComposer(
              $db: $db,
              $table: $db.driftReceivables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> driftPeopleRefs<T extends Object>(
      Expression<T> Function($$DriftPeopleTableAnnotationComposer a) f) {
    final $$DriftPeopleTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftPeople,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftPeopleTableAnnotationComposer(
              $db: $db,
              $table: $db.driftPeople,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> account<T extends Object>(
      Expression<T> Function($$DriftPaymentRemindersTableAnnotationComposer a)
          f) {
    final $$DriftPaymentRemindersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.driftPaymentReminders,
            getReferencedColumn: (t) => t.account,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DriftPaymentRemindersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.driftPaymentReminders,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> fund<T extends Object>(
      Expression<T> Function($$DriftPaymentRemindersTableAnnotationComposer a)
          f) {
    final $$DriftPaymentRemindersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.driftPaymentReminders,
            getReferencedColumn: (t) => t.fund,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DriftPaymentRemindersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.driftPaymentReminders,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$DriftAccountsTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $DriftAccountsTable,
    DriftAccount,
    $$DriftAccountsTableFilterComposer,
    $$DriftAccountsTableOrderingComposer,
    $$DriftAccountsTableAnnotationComposer,
    $$DriftAccountsTableCreateCompanionBuilder,
    $$DriftAccountsTableUpdateCompanionBuilder,
    (DriftAccount, $$DriftAccountsTableReferences),
    DriftAccount,
    PrefetchHooks Function(
        {bool accType,
        bool profile,
        bool drAccount,
        bool crAccount,
        bool driftBanksRefs,
        bool driftWalletsRefs,
        bool driftLoansRefs,
        bool driftCCardsRefs,
        bool driftBalancesRefs,
        bool driftBudgetAccountsRefs,
        bool driftBudgetFundsRefs,
        bool driftReceivablesRefs,
        bool driftPeopleRefs,
        bool account,
        bool fund})> {
  $$DriftAccountsTableTableManager(
      _$AppDriftDatabase db, $DriftAccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> openBal = const Value.absent(),
            Value<DateTime> openDate = const Value.absent(),
            Value<int> accType = const Value.absent(),
            Value<DateTime> addedDate = const Value.absent(),
            Value<DateTime> updateDate = const Value.absent(),
            Value<bool> isEditable = const Value.absent(),
            Value<int> profile = const Value.absent(),
          }) =>
              DriftAccountsCompanion(
            id: id,
            name: name,
            openBal: openBal,
            openDate: openDate,
            accType: accType,
            addedDate: addedDate,
            updateDate: updateDate,
            isEditable: isEditable,
            profile: profile,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int> openBal = const Value.absent(),
            Value<DateTime> openDate = const Value.absent(),
            required int accType,
            Value<DateTime> addedDate = const Value.absent(),
            Value<DateTime> updateDate = const Value.absent(),
            Value<bool> isEditable = const Value.absent(),
            required int profile,
          }) =>
              DriftAccountsCompanion.insert(
            id: id,
            name: name,
            openBal: openBal,
            openDate: openDate,
            accType: accType,
            addedDate: addedDate,
            updateDate: updateDate,
            isEditable: isEditable,
            profile: profile,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DriftAccountsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {accType = false,
              profile = false,
              drAccount = false,
              crAccount = false,
              driftBanksRefs = false,
              driftWalletsRefs = false,
              driftLoansRefs = false,
              driftCCardsRefs = false,
              driftBalancesRefs = false,
              driftBudgetAccountsRefs = false,
              driftBudgetFundsRefs = false,
              driftReceivablesRefs = false,
              driftPeopleRefs = false,
              account = false,
              fund = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (drAccount) db.driftTransactions,
                if (crAccount) db.driftTransactions,
                if (driftBanksRefs) db.driftBanks,
                if (driftWalletsRefs) db.driftWallets,
                if (driftLoansRefs) db.driftLoans,
                if (driftCCardsRefs) db.driftCCards,
                if (driftBalancesRefs) db.driftBalances,
                if (driftBudgetAccountsRefs) db.driftBudgetAccounts,
                if (driftBudgetFundsRefs) db.driftBudgetFunds,
                if (driftReceivablesRefs) db.driftReceivables,
                if (driftPeopleRefs) db.driftPeople,
                if (account) db.driftPaymentReminders,
                if (fund) db.driftPaymentReminders
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
                if (accType) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.accType,
                    referencedTable:
                        $$DriftAccountsTableReferences._accTypeTable(db),
                    referencedColumn:
                        $$DriftAccountsTableReferences._accTypeTable(db).id,
                  ) as T;
                }
                if (profile) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.profile,
                    referencedTable:
                        $$DriftAccountsTableReferences._profileTable(db),
                    referencedColumn:
                        $$DriftAccountsTableReferences._profileTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (drAccount)
                    await $_getPrefetchedData<DriftAccount, $DriftAccountsTable,
                            DriftTransaction>(
                        currentTable: table,
                        referencedTable:
                            $$DriftAccountsTableReferences._drAccountTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftAccountsTableReferences(db, table, p0)
                                .drAccount,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) =>
                                referencedItems.where((e) => e.dr == item.id),
                        typedResults: items),
                  if (crAccount)
                    await $_getPrefetchedData<DriftAccount, $DriftAccountsTable,
                            DriftTransaction>(
                        currentTable: table,
                        referencedTable:
                            $$DriftAccountsTableReferences._crAccountTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftAccountsTableReferences(db, table, p0)
                                .crAccount,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) =>
                                referencedItems.where((e) => e.cr == item.id),
                        typedResults: items),
                  if (driftBanksRefs)
                    await $_getPrefetchedData<DriftAccount, $DriftAccountsTable,
                            DriftBank>(
                        currentTable: table,
                        referencedTable: $$DriftAccountsTableReferences
                            ._driftBanksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftAccountsTableReferences(db, table, p0)
                                .driftBanksRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.account == item.id),
                        typedResults: items),
                  if (driftWalletsRefs)
                    await $_getPrefetchedData<DriftAccount, $DriftAccountsTable,
                            DriftWallet>(
                        currentTable: table,
                        referencedTable: $$DriftAccountsTableReferences
                            ._driftWalletsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftAccountsTableReferences(db, table, p0)
                                .driftWalletsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.account == item.id),
                        typedResults: items),
                  if (driftLoansRefs)
                    await $_getPrefetchedData<DriftAccount, $DriftAccountsTable,
                            DriftLoan>(
                        currentTable: table,
                        referencedTable: $$DriftAccountsTableReferences
                            ._driftLoansRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftAccountsTableReferences(db, table, p0)
                                .driftLoansRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.account == item.id),
                        typedResults: items),
                  if (driftCCardsRefs)
                    await $_getPrefetchedData<DriftAccount, $DriftAccountsTable,
                            DriftCCard>(
                        currentTable: table,
                        referencedTable: $$DriftAccountsTableReferences
                            ._driftCCardsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftAccountsTableReferences(db, table, p0)
                                .driftCCardsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.account == item.id),
                        typedResults: items),
                  if (driftBalancesRefs)
                    await $_getPrefetchedData<DriftAccount, $DriftAccountsTable,
                            DriftBalance>(
                        currentTable: table,
                        referencedTable: $$DriftAccountsTableReferences
                            ._driftBalancesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftAccountsTableReferences(db, table, p0)
                                .driftBalancesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.account == item.id),
                        typedResults: items),
                  if (driftBudgetAccountsRefs)
                    await $_getPrefetchedData<DriftAccount, $DriftAccountsTable,
                            DriftBudgetAccount>(
                        currentTable: table,
                        referencedTable: $$DriftAccountsTableReferences
                            ._driftBudgetAccountsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftAccountsTableReferences(db, table, p0)
                                .driftBudgetAccountsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.account == item.id),
                        typedResults: items),
                  if (driftBudgetFundsRefs)
                    await $_getPrefetchedData<DriftAccount, $DriftAccountsTable,
                            DriftBudgetFund>(
                        currentTable: table,
                        referencedTable: $$DriftAccountsTableReferences
                            ._driftBudgetFundsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftAccountsTableReferences(db, table, p0)
                                .driftBudgetFundsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.account == item.id),
                        typedResults: items),
                  if (driftReceivablesRefs)
                    await $_getPrefetchedData<DriftAccount, $DriftAccountsTable,
                            DriftReceivable>(
                        currentTable: table,
                        referencedTable: $$DriftAccountsTableReferences
                            ._driftReceivablesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftAccountsTableReferences(db, table, p0)
                                .driftReceivablesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.accountId == item.id),
                        typedResults: items),
                  if (driftPeopleRefs)
                    await $_getPrefetchedData<DriftAccount, $DriftAccountsTable,
                            DriftPeopleData>(
                        currentTable: table,
                        referencedTable: $$DriftAccountsTableReferences
                            ._driftPeopleRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftAccountsTableReferences(db, table, p0)
                                .driftPeopleRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.accountId == item.id),
                        typedResults: items),
                  if (account)
                    await $_getPrefetchedData<DriftAccount, $DriftAccountsTable,
                            DriftPaymentReminder>(
                        currentTable: table,
                        referencedTable:
                            $$DriftAccountsTableReferences._accountTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftAccountsTableReferences(db, table, p0)
                                .account,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.account == item.id),
                        typedResults: items),
                  if (fund)
                    await $_getPrefetchedData<DriftAccount, $DriftAccountsTable,
                            DriftPaymentReminder>(
                        currentTable: table,
                        referencedTable:
                            $$DriftAccountsTableReferences._fundTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftAccountsTableReferences(db, table, p0).fund,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) =>
                                referencedItems.where((e) => e.fund == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DriftAccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $DriftAccountsTable,
    DriftAccount,
    $$DriftAccountsTableFilterComposer,
    $$DriftAccountsTableOrderingComposer,
    $$DriftAccountsTableAnnotationComposer,
    $$DriftAccountsTableCreateCompanionBuilder,
    $$DriftAccountsTableUpdateCompanionBuilder,
    (DriftAccount, $$DriftAccountsTableReferences),
    DriftAccount,
    PrefetchHooks Function(
        {bool accType,
        bool profile,
        bool drAccount,
        bool crAccount,
        bool driftBanksRefs,
        bool driftWalletsRefs,
        bool driftLoansRefs,
        bool driftCCardsRefs,
        bool driftBalancesRefs,
        bool driftBudgetAccountsRefs,
        bool driftBudgetFundsRefs,
        bool driftReceivablesRefs,
        bool driftPeopleRefs,
        bool account,
        bool fund})>;
typedef $$DriftBudgetsTableCreateCompanionBuilder = DriftBudgetsCompanion
    Function({
  Value<int> id,
  required String name,
  required BudgetInterval interval,
  required String details,
  Value<int> startDay,
  Value<DateTime> startDate,
  required int profile,
  Value<DateTime> addedDate,
  Value<DateTime> updateDate,
});
typedef $$DriftBudgetsTableUpdateCompanionBuilder = DriftBudgetsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<BudgetInterval> interval,
  Value<String> details,
  Value<int> startDay,
  Value<DateTime> startDate,
  Value<int> profile,
  Value<DateTime> addedDate,
  Value<DateTime> updateDate,
});

final class $$DriftBudgetsTableReferences extends BaseReferences<
    _$AppDriftDatabase, $DriftBudgetsTable, DriftBudget> {
  $$DriftBudgetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DriftProfilesTable _profileTable(_$AppDriftDatabase db) =>
      db.driftProfiles.createAlias(
          $_aliasNameGenerator(db.driftBudgets.profile, db.driftProfiles.id));

  $$DriftProfilesTableProcessedTableManager get profile {
    final $_column = $_itemColumn<int>('profile')!;

    final manager = $$DriftProfilesTableTableManager($_db, $_db.driftProfiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$DriftProjectsTable, List<DriftProject>>
      _driftProjectsRefsTable(_$AppDriftDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftProjects,
              aliasName: $_aliasNameGenerator(
                  db.driftBudgets.id, db.driftProjects.budget));

  $$DriftProjectsTableProcessedTableManager get driftProjectsRefs {
    final manager = $$DriftProjectsTableTableManager($_db, $_db.driftProjects)
        .filter((f) => f.budget.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_driftProjectsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DriftBudgetAccountsTable,
      List<DriftBudgetAccount>> _driftBudgetAccountsRefsTable(
          _$AppDriftDatabase db) =>
      MultiTypedResultKey.fromTable(db.driftBudgetAccounts,
          aliasName: $_aliasNameGenerator(
              db.driftBudgets.id, db.driftBudgetAccounts.budget));

  $$DriftBudgetAccountsTableProcessedTableManager get driftBudgetAccountsRefs {
    final manager =
        $$DriftBudgetAccountsTableTableManager($_db, $_db.driftBudgetAccounts)
            .filter((f) => f.budget.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_driftBudgetAccountsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DriftBudgetFundsTable, List<DriftBudgetFund>>
      _driftBudgetFundsRefsTable(_$AppDriftDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftBudgetFunds,
              aliasName: $_aliasNameGenerator(
                  db.driftBudgets.id, db.driftBudgetFunds.budget));

  $$DriftBudgetFundsTableProcessedTableManager get driftBudgetFundsRefs {
    final manager =
        $$DriftBudgetFundsTableTableManager($_db, $_db.driftBudgetFunds)
            .filter((f) => f.budget.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_driftBudgetFundsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DriftBudgetsTableFilterComposer
    extends Composer<_$AppDriftDatabase, $DriftBudgetsTable> {
  $$DriftBudgetsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<BudgetInterval, BudgetInterval, int>
      get interval => $composableBuilder(
          column: $table.interval,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startDay => $composableBuilder(
      column: $table.startDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedDate => $composableBuilder(
      column: $table.addedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => ColumnFilters(column));

  $$DriftProfilesTableFilterComposer get profile {
    final $$DriftProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profile,
        referencedTable: $db.driftProfiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProfilesTableFilterComposer(
              $db: $db,
              $table: $db.driftProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> driftProjectsRefs(
      Expression<bool> Function($$DriftProjectsTableFilterComposer f) f) {
    final $$DriftProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftProjects,
        getReferencedColumn: (t) => t.budget,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProjectsTableFilterComposer(
              $db: $db,
              $table: $db.driftProjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> driftBudgetAccountsRefs(
      Expression<bool> Function($$DriftBudgetAccountsTableFilterComposer f) f) {
    final $$DriftBudgetAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftBudgetAccounts,
        getReferencedColumn: (t) => t.budget,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBudgetAccountsTableFilterComposer(
              $db: $db,
              $table: $db.driftBudgetAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> driftBudgetFundsRefs(
      Expression<bool> Function($$DriftBudgetFundsTableFilterComposer f) f) {
    final $$DriftBudgetFundsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftBudgetFunds,
        getReferencedColumn: (t) => t.budget,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBudgetFundsTableFilterComposer(
              $db: $db,
              $table: $db.driftBudgetFunds,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DriftBudgetsTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $DriftBudgetsTable> {
  $$DriftBudgetsTableOrderingComposer({
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

  ColumnOrderings<int> get interval => $composableBuilder(
      column: $table.interval, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startDay => $composableBuilder(
      column: $table.startDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedDate => $composableBuilder(
      column: $table.addedDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => ColumnOrderings(column));

  $$DriftProfilesTableOrderingComposer get profile {
    final $$DriftProfilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profile,
        referencedTable: $db.driftProfiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProfilesTableOrderingComposer(
              $db: $db,
              $table: $db.driftProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftBudgetsTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $DriftBudgetsTable> {
  $$DriftBudgetsTableAnnotationComposer({
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

  GeneratedColumnWithTypeConverter<BudgetInterval, int> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<int> get startDay =>
      $composableBuilder(column: $table.startDay, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get addedDate =>
      $composableBuilder(column: $table.addedDate, builder: (column) => column);

  GeneratedColumn<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => column);

  $$DriftProfilesTableAnnotationComposer get profile {
    final $$DriftProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profile,
        referencedTable: $db.driftProfiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.driftProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> driftProjectsRefs<T extends Object>(
      Expression<T> Function($$DriftProjectsTableAnnotationComposer a) f) {
    final $$DriftProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftProjects,
        getReferencedColumn: (t) => t.budget,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftProjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> driftBudgetAccountsRefs<T extends Object>(
      Expression<T> Function($$DriftBudgetAccountsTableAnnotationComposer a)
          f) {
    final $$DriftBudgetAccountsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.driftBudgetAccounts,
            getReferencedColumn: (t) => t.budget,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DriftBudgetAccountsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.driftBudgetAccounts,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> driftBudgetFundsRefs<T extends Object>(
      Expression<T> Function($$DriftBudgetFundsTableAnnotationComposer a) f) {
    final $$DriftBudgetFundsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftBudgetFunds,
        getReferencedColumn: (t) => t.budget,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBudgetFundsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftBudgetFunds,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DriftBudgetsTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $DriftBudgetsTable,
    DriftBudget,
    $$DriftBudgetsTableFilterComposer,
    $$DriftBudgetsTableOrderingComposer,
    $$DriftBudgetsTableAnnotationComposer,
    $$DriftBudgetsTableCreateCompanionBuilder,
    $$DriftBudgetsTableUpdateCompanionBuilder,
    (DriftBudget, $$DriftBudgetsTableReferences),
    DriftBudget,
    PrefetchHooks Function(
        {bool profile,
        bool driftProjectsRefs,
        bool driftBudgetAccountsRefs,
        bool driftBudgetFundsRefs})> {
  $$DriftBudgetsTableTableManager(
      _$AppDriftDatabase db, $DriftBudgetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftBudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftBudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftBudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<BudgetInterval> interval = const Value.absent(),
            Value<String> details = const Value.absent(),
            Value<int> startDay = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<int> profile = const Value.absent(),
            Value<DateTime> addedDate = const Value.absent(),
            Value<DateTime> updateDate = const Value.absent(),
          }) =>
              DriftBudgetsCompanion(
            id: id,
            name: name,
            interval: interval,
            details: details,
            startDay: startDay,
            startDate: startDate,
            profile: profile,
            addedDate: addedDate,
            updateDate: updateDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required BudgetInterval interval,
            required String details,
            Value<int> startDay = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            required int profile,
            Value<DateTime> addedDate = const Value.absent(),
            Value<DateTime> updateDate = const Value.absent(),
          }) =>
              DriftBudgetsCompanion.insert(
            id: id,
            name: name,
            interval: interval,
            details: details,
            startDay: startDay,
            startDate: startDate,
            profile: profile,
            addedDate: addedDate,
            updateDate: updateDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DriftBudgetsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {profile = false,
              driftProjectsRefs = false,
              driftBudgetAccountsRefs = false,
              driftBudgetFundsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (driftProjectsRefs) db.driftProjects,
                if (driftBudgetAccountsRefs) db.driftBudgetAccounts,
                if (driftBudgetFundsRefs) db.driftBudgetFunds
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
                if (profile) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.profile,
                    referencedTable:
                        $$DriftBudgetsTableReferences._profileTable(db),
                    referencedColumn:
                        $$DriftBudgetsTableReferences._profileTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (driftProjectsRefs)
                    await $_getPrefetchedData<DriftBudget, $DriftBudgetsTable,
                            DriftProject>(
                        currentTable: table,
                        referencedTable: $$DriftBudgetsTableReferences
                            ._driftProjectsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftBudgetsTableReferences(db, table, p0)
                                .driftProjectsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.budget == item.id),
                        typedResults: items),
                  if (driftBudgetAccountsRefs)
                    await $_getPrefetchedData<DriftBudget, $DriftBudgetsTable,
                            DriftBudgetAccount>(
                        currentTable: table,
                        referencedTable: $$DriftBudgetsTableReferences
                            ._driftBudgetAccountsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftBudgetsTableReferences(db, table, p0)
                                .driftBudgetAccountsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.budget == item.id),
                        typedResults: items),
                  if (driftBudgetFundsRefs)
                    await $_getPrefetchedData<DriftBudget, $DriftBudgetsTable,
                            DriftBudgetFund>(
                        currentTable: table,
                        referencedTable: $$DriftBudgetsTableReferences
                            ._driftBudgetFundsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftBudgetsTableReferences(db, table, p0)
                                .driftBudgetFundsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.budget == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DriftBudgetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $DriftBudgetsTable,
    DriftBudget,
    $$DriftBudgetsTableFilterComposer,
    $$DriftBudgetsTableOrderingComposer,
    $$DriftBudgetsTableAnnotationComposer,
    $$DriftBudgetsTableCreateCompanionBuilder,
    $$DriftBudgetsTableUpdateCompanionBuilder,
    (DriftBudget, $$DriftBudgetsTableReferences),
    DriftBudget,
    PrefetchHooks Function(
        {bool profile,
        bool driftProjectsRefs,
        bool driftBudgetAccountsRefs,
        bool driftBudgetFundsRefs})>;
typedef $$DriftProjectsTableCreateCompanionBuilder = DriftProjectsCompanion
    Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  Value<DateTime?> startDate,
  required int profile,
  Value<DateTime?> endDate,
  required ProjectStatus status,
  Value<int?> budget,
  Value<DateTime> addedDate,
  Value<DateTime> updateDate,
});
typedef $$DriftProjectsTableUpdateCompanionBuilder = DriftProjectsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<DateTime?> startDate,
  Value<int> profile,
  Value<DateTime?> endDate,
  Value<ProjectStatus> status,
  Value<int?> budget,
  Value<DateTime> addedDate,
  Value<DateTime> updateDate,
});

final class $$DriftProjectsTableReferences extends BaseReferences<
    _$AppDriftDatabase, $DriftProjectsTable, DriftProject> {
  $$DriftProjectsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DriftProfilesTable _profileTable(_$AppDriftDatabase db) =>
      db.driftProfiles.createAlias(
          $_aliasNameGenerator(db.driftProjects.profile, db.driftProfiles.id));

  $$DriftProfilesTableProcessedTableManager get profile {
    final $_column = $_itemColumn<int>('profile')!;

    final manager = $$DriftProfilesTableTableManager($_db, $_db.driftProfiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DriftBudgetsTable _budgetTable(_$AppDriftDatabase db) =>
      db.driftBudgets.createAlias(
          $_aliasNameGenerator(db.driftProjects.budget, db.driftBudgets.id));

  $$DriftBudgetsTableProcessedTableManager? get budget {
    final $_column = $_itemColumn<int>('budget');
    if ($_column == null) return null;
    final manager = $$DriftBudgetsTableTableManager($_db, $_db.driftBudgets)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_budgetTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$DriftTransactionsTable, List<DriftTransaction>>
      _driftTransactionsRefsTable(_$AppDriftDatabase db) =>
          MultiTypedResultKey.fromTable(db.driftTransactions,
              aliasName: $_aliasNameGenerator(
                  db.driftProjects.id, db.driftTransactions.project));

  $$DriftTransactionsTableProcessedTableManager get driftTransactionsRefs {
    final manager =
        $$DriftTransactionsTableTableManager($_db, $_db.driftTransactions)
            .filter((f) => f.project.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_driftTransactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DriftProjectsTableFilterComposer
    extends Composer<_$AppDriftDatabase, $DriftProjectsTable> {
  $$DriftProjectsTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<ProjectStatus, ProjectStatus, int>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get addedDate => $composableBuilder(
      column: $table.addedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => ColumnFilters(column));

  $$DriftProfilesTableFilterComposer get profile {
    final $$DriftProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profile,
        referencedTable: $db.driftProfiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProfilesTableFilterComposer(
              $db: $db,
              $table: $db.driftProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftBudgetsTableFilterComposer get budget {
    final $$DriftBudgetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budget,
        referencedTable: $db.driftBudgets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBudgetsTableFilterComposer(
              $db: $db,
              $table: $db.driftBudgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> driftTransactionsRefs(
      Expression<bool> Function($$DriftTransactionsTableFilterComposer f) f) {
    final $$DriftTransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.driftTransactions,
        getReferencedColumn: (t) => t.project,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftTransactionsTableFilterComposer(
              $db: $db,
              $table: $db.driftTransactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DriftProjectsTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $DriftProjectsTable> {
  $$DriftProjectsTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedDate => $composableBuilder(
      column: $table.addedDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => ColumnOrderings(column));

  $$DriftProfilesTableOrderingComposer get profile {
    final $$DriftProfilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profile,
        referencedTable: $db.driftProfiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProfilesTableOrderingComposer(
              $db: $db,
              $table: $db.driftProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftBudgetsTableOrderingComposer get budget {
    final $$DriftBudgetsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budget,
        referencedTable: $db.driftBudgets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBudgetsTableOrderingComposer(
              $db: $db,
              $table: $db.driftBudgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftProjectsTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $DriftProjectsTable> {
  $$DriftProjectsTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ProjectStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get addedDate =>
      $composableBuilder(column: $table.addedDate, builder: (column) => column);

  GeneratedColumn<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => column);

  $$DriftProfilesTableAnnotationComposer get profile {
    final $$DriftProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profile,
        referencedTable: $db.driftProfiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.driftProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftBudgetsTableAnnotationComposer get budget {
    final $$DriftBudgetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budget,
        referencedTable: $db.driftBudgets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBudgetsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftBudgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> driftTransactionsRefs<T extends Object>(
      Expression<T> Function($$DriftTransactionsTableAnnotationComposer a) f) {
    final $$DriftTransactionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.driftTransactions,
            getReferencedColumn: (t) => t.project,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DriftTransactionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.driftTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$DriftProjectsTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $DriftProjectsTable,
    DriftProject,
    $$DriftProjectsTableFilterComposer,
    $$DriftProjectsTableOrderingComposer,
    $$DriftProjectsTableAnnotationComposer,
    $$DriftProjectsTableCreateCompanionBuilder,
    $$DriftProjectsTableUpdateCompanionBuilder,
    (DriftProject, $$DriftProjectsTableReferences),
    DriftProject,
    PrefetchHooks Function(
        {bool profile, bool budget, bool driftTransactionsRefs})> {
  $$DriftProjectsTableTableManager(
      _$AppDriftDatabase db, $DriftProjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<int> profile = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<ProjectStatus> status = const Value.absent(),
            Value<int?> budget = const Value.absent(),
            Value<DateTime> addedDate = const Value.absent(),
            Value<DateTime> updateDate = const Value.absent(),
          }) =>
              DriftProjectsCompanion(
            id: id,
            name: name,
            description: description,
            startDate: startDate,
            profile: profile,
            endDate: endDate,
            status: status,
            budget: budget,
            addedDate: addedDate,
            updateDate: updateDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            required int profile,
            Value<DateTime?> endDate = const Value.absent(),
            required ProjectStatus status,
            Value<int?> budget = const Value.absent(),
            Value<DateTime> addedDate = const Value.absent(),
            Value<DateTime> updateDate = const Value.absent(),
          }) =>
              DriftProjectsCompanion.insert(
            id: id,
            name: name,
            description: description,
            startDate: startDate,
            profile: profile,
            endDate: endDate,
            status: status,
            budget: budget,
            addedDate: addedDate,
            updateDate: updateDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DriftProjectsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {profile = false,
              budget = false,
              driftTransactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (driftTransactionsRefs) db.driftTransactions
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
                if (profile) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.profile,
                    referencedTable:
                        $$DriftProjectsTableReferences._profileTable(db),
                    referencedColumn:
                        $$DriftProjectsTableReferences._profileTable(db).id,
                  ) as T;
                }
                if (budget) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.budget,
                    referencedTable:
                        $$DriftProjectsTableReferences._budgetTable(db),
                    referencedColumn:
                        $$DriftProjectsTableReferences._budgetTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (driftTransactionsRefs)
                    await $_getPrefetchedData<DriftProject, $DriftProjectsTable,
                            DriftTransaction>(
                        currentTable: table,
                        referencedTable: $$DriftProjectsTableReferences
                            ._driftTransactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriftProjectsTableReferences(db, table, p0)
                                .driftTransactionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.project == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DriftProjectsTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $DriftProjectsTable,
    DriftProject,
    $$DriftProjectsTableFilterComposer,
    $$DriftProjectsTableOrderingComposer,
    $$DriftProjectsTableAnnotationComposer,
    $$DriftProjectsTableCreateCompanionBuilder,
    $$DriftProjectsTableUpdateCompanionBuilder,
    (DriftProject, $$DriftProjectsTableReferences),
    DriftProject,
    PrefetchHooks Function(
        {bool profile, bool budget, bool driftTransactionsRefs})>;
typedef $$DriftTransactionsTableCreateCompanionBuilder
    = DriftTransactionsCompanion Function({
  Value<int> id,
  required DateTime vchDate,
  required String narr,
  required String refNo,
  required VoucherType vchType,
  required int dr,
  required int cr,
  Value<int> amount,
  required int profile,
  Value<int?> project,
  Value<DateTime> addedDate,
  Value<DateTime> updateDate,
});
typedef $$DriftTransactionsTableUpdateCompanionBuilder
    = DriftTransactionsCompanion Function({
  Value<int> id,
  Value<DateTime> vchDate,
  Value<String> narr,
  Value<String> refNo,
  Value<VoucherType> vchType,
  Value<int> dr,
  Value<int> cr,
  Value<int> amount,
  Value<int> profile,
  Value<int?> project,
  Value<DateTime> addedDate,
  Value<DateTime> updateDate,
});

final class $$DriftTransactionsTableReferences extends BaseReferences<
    _$AppDriftDatabase, $DriftTransactionsTable, DriftTransaction> {
  $$DriftTransactionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DriftAccountsTable _drTable(_$AppDriftDatabase db) =>
      db.driftAccounts.createAlias(
          $_aliasNameGenerator(db.driftTransactions.dr, db.driftAccounts.id));

  $$DriftAccountsTableProcessedTableManager get dr {
    final $_column = $_itemColumn<int>('dr')!;

    final manager = $$DriftAccountsTableTableManager($_db, $_db.driftAccounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_drTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DriftAccountsTable _crTable(_$AppDriftDatabase db) =>
      db.driftAccounts.createAlias(
          $_aliasNameGenerator(db.driftTransactions.cr, db.driftAccounts.id));

  $$DriftAccountsTableProcessedTableManager get cr {
    final $_column = $_itemColumn<int>('cr')!;

    final manager = $$DriftAccountsTableTableManager($_db, $_db.driftAccounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_crTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DriftProfilesTable _profileTable(_$AppDriftDatabase db) =>
      db.driftProfiles.createAlias($_aliasNameGenerator(
          db.driftTransactions.profile, db.driftProfiles.id));

  $$DriftProfilesTableProcessedTableManager get profile {
    final $_column = $_itemColumn<int>('profile')!;

    final manager = $$DriftProfilesTableTableManager($_db, $_db.driftProfiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DriftProjectsTable _projectTable(_$AppDriftDatabase db) =>
      db.driftProjects.createAlias($_aliasNameGenerator(
          db.driftTransactions.project, db.driftProjects.id));

  $$DriftProjectsTableProcessedTableManager? get project {
    final $_column = $_itemColumn<int>('project');
    if ($_column == null) return null;
    final manager = $$DriftProjectsTableTableManager($_db, $_db.driftProjects)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DriftTransactionsTableFilterComposer
    extends Composer<_$AppDriftDatabase, $DriftTransactionsTable> {
  $$DriftTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get vchDate => $composableBuilder(
      column: $table.vchDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get narr => $composableBuilder(
      column: $table.narr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get refNo => $composableBuilder(
      column: $table.refNo, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<VoucherType, VoucherType, int> get vchType =>
      $composableBuilder(
          column: $table.vchType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedDate => $composableBuilder(
      column: $table.addedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => ColumnFilters(column));

  $$DriftAccountsTableFilterComposer get dr {
    final $$DriftAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dr,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableFilterComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftAccountsTableFilterComposer get cr {
    final $$DriftAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cr,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableFilterComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftProfilesTableFilterComposer get profile {
    final $$DriftProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profile,
        referencedTable: $db.driftProfiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProfilesTableFilterComposer(
              $db: $db,
              $table: $db.driftProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftProjectsTableFilterComposer get project {
    final $$DriftProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.project,
        referencedTable: $db.driftProjects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProjectsTableFilterComposer(
              $db: $db,
              $table: $db.driftProjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftTransactionsTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $DriftTransactionsTable> {
  $$DriftTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get vchDate => $composableBuilder(
      column: $table.vchDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get narr => $composableBuilder(
      column: $table.narr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get refNo => $composableBuilder(
      column: $table.refNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get vchType => $composableBuilder(
      column: $table.vchType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedDate => $composableBuilder(
      column: $table.addedDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => ColumnOrderings(column));

  $$DriftAccountsTableOrderingComposer get dr {
    final $$DriftAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dr,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftAccountsTableOrderingComposer get cr {
    final $$DriftAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cr,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftProfilesTableOrderingComposer get profile {
    final $$DriftProfilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profile,
        referencedTable: $db.driftProfiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProfilesTableOrderingComposer(
              $db: $db,
              $table: $db.driftProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftProjectsTableOrderingComposer get project {
    final $$DriftProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.project,
        referencedTable: $db.driftProjects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.driftProjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftTransactionsTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $DriftTransactionsTable> {
  $$DriftTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get vchDate =>
      $composableBuilder(column: $table.vchDate, builder: (column) => column);

  GeneratedColumn<String> get narr =>
      $composableBuilder(column: $table.narr, builder: (column) => column);

  GeneratedColumn<String> get refNo =>
      $composableBuilder(column: $table.refNo, builder: (column) => column);

  GeneratedColumnWithTypeConverter<VoucherType, int> get vchType =>
      $composableBuilder(column: $table.vchType, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get addedDate =>
      $composableBuilder(column: $table.addedDate, builder: (column) => column);

  GeneratedColumn<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => column);

  $$DriftAccountsTableAnnotationComposer get dr {
    final $$DriftAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dr,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftAccountsTableAnnotationComposer get cr {
    final $$DriftAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cr,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftProfilesTableAnnotationComposer get profile {
    final $$DriftProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profile,
        referencedTable: $db.driftProfiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.driftProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftProjectsTableAnnotationComposer get project {
    final $$DriftProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.project,
        referencedTable: $db.driftProjects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftProjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftTransactionsTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $DriftTransactionsTable,
    DriftTransaction,
    $$DriftTransactionsTableFilterComposer,
    $$DriftTransactionsTableOrderingComposer,
    $$DriftTransactionsTableAnnotationComposer,
    $$DriftTransactionsTableCreateCompanionBuilder,
    $$DriftTransactionsTableUpdateCompanionBuilder,
    (DriftTransaction, $$DriftTransactionsTableReferences),
    DriftTransaction,
    PrefetchHooks Function({bool dr, bool cr, bool profile, bool project})> {
  $$DriftTransactionsTableTableManager(
      _$AppDriftDatabase db, $DriftTransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftTransactionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> vchDate = const Value.absent(),
            Value<String> narr = const Value.absent(),
            Value<String> refNo = const Value.absent(),
            Value<VoucherType> vchType = const Value.absent(),
            Value<int> dr = const Value.absent(),
            Value<int> cr = const Value.absent(),
            Value<int> amount = const Value.absent(),
            Value<int> profile = const Value.absent(),
            Value<int?> project = const Value.absent(),
            Value<DateTime> addedDate = const Value.absent(),
            Value<DateTime> updateDate = const Value.absent(),
          }) =>
              DriftTransactionsCompanion(
            id: id,
            vchDate: vchDate,
            narr: narr,
            refNo: refNo,
            vchType: vchType,
            dr: dr,
            cr: cr,
            amount: amount,
            profile: profile,
            project: project,
            addedDate: addedDate,
            updateDate: updateDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime vchDate,
            required String narr,
            required String refNo,
            required VoucherType vchType,
            required int dr,
            required int cr,
            Value<int> amount = const Value.absent(),
            required int profile,
            Value<int?> project = const Value.absent(),
            Value<DateTime> addedDate = const Value.absent(),
            Value<DateTime> updateDate = const Value.absent(),
          }) =>
              DriftTransactionsCompanion.insert(
            id: id,
            vchDate: vchDate,
            narr: narr,
            refNo: refNo,
            vchType: vchType,
            dr: dr,
            cr: cr,
            amount: amount,
            profile: profile,
            project: project,
            addedDate: addedDate,
            updateDate: updateDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DriftTransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {dr = false, cr = false, profile = false, project = false}) {
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
                if (dr) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dr,
                    referencedTable:
                        $$DriftTransactionsTableReferences._drTable(db),
                    referencedColumn:
                        $$DriftTransactionsTableReferences._drTable(db).id,
                  ) as T;
                }
                if (cr) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cr,
                    referencedTable:
                        $$DriftTransactionsTableReferences._crTable(db),
                    referencedColumn:
                        $$DriftTransactionsTableReferences._crTable(db).id,
                  ) as T;
                }
                if (profile) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.profile,
                    referencedTable:
                        $$DriftTransactionsTableReferences._profileTable(db),
                    referencedColumn:
                        $$DriftTransactionsTableReferences._profileTable(db).id,
                  ) as T;
                }
                if (project) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.project,
                    referencedTable:
                        $$DriftTransactionsTableReferences._projectTable(db),
                    referencedColumn:
                        $$DriftTransactionsTableReferences._projectTable(db).id,
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

typedef $$DriftTransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $DriftTransactionsTable,
    DriftTransaction,
    $$DriftTransactionsTableFilterComposer,
    $$DriftTransactionsTableOrderingComposer,
    $$DriftTransactionsTableAnnotationComposer,
    $$DriftTransactionsTableCreateCompanionBuilder,
    $$DriftTransactionsTableUpdateCompanionBuilder,
    (DriftTransaction, $$DriftTransactionsTableReferences),
    DriftTransaction,
    PrefetchHooks Function({bool dr, bool cr, bool profile, bool project})>;
typedef $$DriftUsersTableCreateCompanionBuilder = DriftUsersCompanion Function({
  Value<int> id,
  required String name,
  required String deviceID,
  required String photoPath,
});
typedef $$DriftUsersTableUpdateCompanionBuilder = DriftUsersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> deviceID,
  Value<String> photoPath,
});

class $$DriftUsersTableFilterComposer
    extends Composer<_$AppDriftDatabase, $DriftUsersTable> {
  $$DriftUsersTableFilterComposer({
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

  ColumnFilters<String> get deviceID => $composableBuilder(
      column: $table.deviceID, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));
}

class $$DriftUsersTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $DriftUsersTable> {
  $$DriftUsersTableOrderingComposer({
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

  ColumnOrderings<String> get deviceID => $composableBuilder(
      column: $table.deviceID, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));
}

class $$DriftUsersTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $DriftUsersTable> {
  $$DriftUsersTableAnnotationComposer({
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

  GeneratedColumn<String> get deviceID =>
      $composableBuilder(column: $table.deviceID, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);
}

class $$DriftUsersTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $DriftUsersTable,
    DriftUser,
    $$DriftUsersTableFilterComposer,
    $$DriftUsersTableOrderingComposer,
    $$DriftUsersTableAnnotationComposer,
    $$DriftUsersTableCreateCompanionBuilder,
    $$DriftUsersTableUpdateCompanionBuilder,
    (
      DriftUser,
      BaseReferences<_$AppDriftDatabase, $DriftUsersTable, DriftUser>
    ),
    DriftUser,
    PrefetchHooks Function()> {
  $$DriftUsersTableTableManager(_$AppDriftDatabase db, $DriftUsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> deviceID = const Value.absent(),
            Value<String> photoPath = const Value.absent(),
          }) =>
              DriftUsersCompanion(
            id: id,
            name: name,
            deviceID: deviceID,
            photoPath: photoPath,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String deviceID,
            required String photoPath,
          }) =>
              DriftUsersCompanion.insert(
            id: id,
            name: name,
            deviceID: deviceID,
            photoPath: photoPath,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DriftUsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $DriftUsersTable,
    DriftUser,
    $$DriftUsersTableFilterComposer,
    $$DriftUsersTableOrderingComposer,
    $$DriftUsersTableAnnotationComposer,
    $$DriftUsersTableCreateCompanionBuilder,
    $$DriftUsersTableUpdateCompanionBuilder,
    (
      DriftUser,
      BaseReferences<_$AppDriftDatabase, $DriftUsersTable, DriftUser>
    ),
    DriftUser,
    PrefetchHooks Function()>;
typedef $$DriftBanksTableCreateCompanionBuilder = DriftBanksCompanion Function({
  Value<int> id,
  required int account,
  Value<String?> holderName,
  Value<String?> institution,
  Value<String?> branch,
  Value<String?> branchCode,
  Value<String?> accountNo,
});
typedef $$DriftBanksTableUpdateCompanionBuilder = DriftBanksCompanion Function({
  Value<int> id,
  Value<int> account,
  Value<String?> holderName,
  Value<String?> institution,
  Value<String?> branch,
  Value<String?> branchCode,
  Value<String?> accountNo,
});

final class $$DriftBanksTableReferences
    extends BaseReferences<_$AppDriftDatabase, $DriftBanksTable, DriftBank> {
  $$DriftBanksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DriftAccountsTable _accountTable(_$AppDriftDatabase db) =>
      db.driftAccounts.createAlias(
          $_aliasNameGenerator(db.driftBanks.account, db.driftAccounts.id));

  $$DriftAccountsTableProcessedTableManager get account {
    final $_column = $_itemColumn<int>('account')!;

    final manager = $$DriftAccountsTableTableManager($_db, $_db.driftAccounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DriftBanksTableFilterComposer
    extends Composer<_$AppDriftDatabase, $DriftBanksTable> {
  $$DriftBanksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get holderName => $composableBuilder(
      column: $table.holderName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get institution => $composableBuilder(
      column: $table.institution, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get branch => $composableBuilder(
      column: $table.branch, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get branchCode => $composableBuilder(
      column: $table.branchCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountNo => $composableBuilder(
      column: $table.accountNo, builder: (column) => ColumnFilters(column));

  $$DriftAccountsTableFilterComposer get account {
    final $$DriftAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableFilterComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftBanksTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $DriftBanksTable> {
  $$DriftBanksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get holderName => $composableBuilder(
      column: $table.holderName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get institution => $composableBuilder(
      column: $table.institution, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get branch => $composableBuilder(
      column: $table.branch, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get branchCode => $composableBuilder(
      column: $table.branchCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountNo => $composableBuilder(
      column: $table.accountNo, builder: (column) => ColumnOrderings(column));

  $$DriftAccountsTableOrderingComposer get account {
    final $$DriftAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftBanksTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $DriftBanksTable> {
  $$DriftBanksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get holderName => $composableBuilder(
      column: $table.holderName, builder: (column) => column);

  GeneratedColumn<String> get institution => $composableBuilder(
      column: $table.institution, builder: (column) => column);

  GeneratedColumn<String> get branch =>
      $composableBuilder(column: $table.branch, builder: (column) => column);

  GeneratedColumn<String> get branchCode => $composableBuilder(
      column: $table.branchCode, builder: (column) => column);

  GeneratedColumn<String> get accountNo =>
      $composableBuilder(column: $table.accountNo, builder: (column) => column);

  $$DriftAccountsTableAnnotationComposer get account {
    final $$DriftAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftBanksTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $DriftBanksTable,
    DriftBank,
    $$DriftBanksTableFilterComposer,
    $$DriftBanksTableOrderingComposer,
    $$DriftBanksTableAnnotationComposer,
    $$DriftBanksTableCreateCompanionBuilder,
    $$DriftBanksTableUpdateCompanionBuilder,
    (DriftBank, $$DriftBanksTableReferences),
    DriftBank,
    PrefetchHooks Function({bool account})> {
  $$DriftBanksTableTableManager(_$AppDriftDatabase db, $DriftBanksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftBanksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftBanksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftBanksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> account = const Value.absent(),
            Value<String?> holderName = const Value.absent(),
            Value<String?> institution = const Value.absent(),
            Value<String?> branch = const Value.absent(),
            Value<String?> branchCode = const Value.absent(),
            Value<String?> accountNo = const Value.absent(),
          }) =>
              DriftBanksCompanion(
            id: id,
            account: account,
            holderName: holderName,
            institution: institution,
            branch: branch,
            branchCode: branchCode,
            accountNo: accountNo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int account,
            Value<String?> holderName = const Value.absent(),
            Value<String?> institution = const Value.absent(),
            Value<String?> branch = const Value.absent(),
            Value<String?> branchCode = const Value.absent(),
            Value<String?> accountNo = const Value.absent(),
          }) =>
              DriftBanksCompanion.insert(
            id: id,
            account: account,
            holderName: holderName,
            institution: institution,
            branch: branch,
            branchCode: branchCode,
            accountNo: accountNo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DriftBanksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({account = false}) {
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
                if (account) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.account,
                    referencedTable:
                        $$DriftBanksTableReferences._accountTable(db),
                    referencedColumn:
                        $$DriftBanksTableReferences._accountTable(db).id,
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

typedef $$DriftBanksTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $DriftBanksTable,
    DriftBank,
    $$DriftBanksTableFilterComposer,
    $$DriftBanksTableOrderingComposer,
    $$DriftBanksTableAnnotationComposer,
    $$DriftBanksTableCreateCompanionBuilder,
    $$DriftBanksTableUpdateCompanionBuilder,
    (DriftBank, $$DriftBanksTableReferences),
    DriftBank,
    PrefetchHooks Function({bool account})>;
typedef $$DriftWalletsTableCreateCompanionBuilder = DriftWalletsCompanion
    Function({
  Value<int> id,
  required int account,
});
typedef $$DriftWalletsTableUpdateCompanionBuilder = DriftWalletsCompanion
    Function({
  Value<int> id,
  Value<int> account,
});

final class $$DriftWalletsTableReferences extends BaseReferences<
    _$AppDriftDatabase, $DriftWalletsTable, DriftWallet> {
  $$DriftWalletsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DriftAccountsTable _accountTable(_$AppDriftDatabase db) =>
      db.driftAccounts.createAlias(
          $_aliasNameGenerator(db.driftWallets.account, db.driftAccounts.id));

  $$DriftAccountsTableProcessedTableManager get account {
    final $_column = $_itemColumn<int>('account')!;

    final manager = $$DriftAccountsTableTableManager($_db, $_db.driftAccounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DriftWalletsTableFilterComposer
    extends Composer<_$AppDriftDatabase, $DriftWalletsTable> {
  $$DriftWalletsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  $$DriftAccountsTableFilterComposer get account {
    final $$DriftAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableFilterComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftWalletsTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $DriftWalletsTable> {
  $$DriftWalletsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  $$DriftAccountsTableOrderingComposer get account {
    final $$DriftAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftWalletsTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $DriftWalletsTable> {
  $$DriftWalletsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$DriftAccountsTableAnnotationComposer get account {
    final $$DriftAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftWalletsTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $DriftWalletsTable,
    DriftWallet,
    $$DriftWalletsTableFilterComposer,
    $$DriftWalletsTableOrderingComposer,
    $$DriftWalletsTableAnnotationComposer,
    $$DriftWalletsTableCreateCompanionBuilder,
    $$DriftWalletsTableUpdateCompanionBuilder,
    (DriftWallet, $$DriftWalletsTableReferences),
    DriftWallet,
    PrefetchHooks Function({bool account})> {
  $$DriftWalletsTableTableManager(
      _$AppDriftDatabase db, $DriftWalletsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftWalletsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftWalletsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftWalletsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> account = const Value.absent(),
          }) =>
              DriftWalletsCompanion(
            id: id,
            account: account,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int account,
          }) =>
              DriftWalletsCompanion.insert(
            id: id,
            account: account,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DriftWalletsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({account = false}) {
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
                if (account) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.account,
                    referencedTable:
                        $$DriftWalletsTableReferences._accountTable(db),
                    referencedColumn:
                        $$DriftWalletsTableReferences._accountTable(db).id,
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

typedef $$DriftWalletsTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $DriftWalletsTable,
    DriftWallet,
    $$DriftWalletsTableFilterComposer,
    $$DriftWalletsTableOrderingComposer,
    $$DriftWalletsTableAnnotationComposer,
    $$DriftWalletsTableCreateCompanionBuilder,
    $$DriftWalletsTableUpdateCompanionBuilder,
    (DriftWallet, $$DriftWalletsTableReferences),
    DriftWallet,
    PrefetchHooks Function({bool account})>;
typedef $$DriftLoansTableCreateCompanionBuilder = DriftLoansCompanion Function({
  Value<int> id,
  required int account,
  Value<String?> institution,
  Value<double?> interestRate,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<String?> agreementNo,
  Value<String?> accountNo,
});
typedef $$DriftLoansTableUpdateCompanionBuilder = DriftLoansCompanion Function({
  Value<int> id,
  Value<int> account,
  Value<String?> institution,
  Value<double?> interestRate,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<String?> agreementNo,
  Value<String?> accountNo,
});

final class $$DriftLoansTableReferences
    extends BaseReferences<_$AppDriftDatabase, $DriftLoansTable, DriftLoan> {
  $$DriftLoansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DriftAccountsTable _accountTable(_$AppDriftDatabase db) =>
      db.driftAccounts.createAlias(
          $_aliasNameGenerator(db.driftLoans.account, db.driftAccounts.id));

  $$DriftAccountsTableProcessedTableManager get account {
    final $_column = $_itemColumn<int>('account')!;

    final manager = $$DriftAccountsTableTableManager($_db, $_db.driftAccounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DriftLoansTableFilterComposer
    extends Composer<_$AppDriftDatabase, $DriftLoansTable> {
  $$DriftLoansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get institution => $composableBuilder(
      column: $table.institution, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get interestRate => $composableBuilder(
      column: $table.interestRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get agreementNo => $composableBuilder(
      column: $table.agreementNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountNo => $composableBuilder(
      column: $table.accountNo, builder: (column) => ColumnFilters(column));

  $$DriftAccountsTableFilterComposer get account {
    final $$DriftAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableFilterComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftLoansTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $DriftLoansTable> {
  $$DriftLoansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get institution => $composableBuilder(
      column: $table.institution, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get interestRate => $composableBuilder(
      column: $table.interestRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get agreementNo => $composableBuilder(
      column: $table.agreementNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountNo => $composableBuilder(
      column: $table.accountNo, builder: (column) => ColumnOrderings(column));

  $$DriftAccountsTableOrderingComposer get account {
    final $$DriftAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftLoansTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $DriftLoansTable> {
  $$DriftLoansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get institution => $composableBuilder(
      column: $table.institution, builder: (column) => column);

  GeneratedColumn<double> get interestRate => $composableBuilder(
      column: $table.interestRate, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get agreementNo => $composableBuilder(
      column: $table.agreementNo, builder: (column) => column);

  GeneratedColumn<String> get accountNo =>
      $composableBuilder(column: $table.accountNo, builder: (column) => column);

  $$DriftAccountsTableAnnotationComposer get account {
    final $$DriftAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftLoansTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $DriftLoansTable,
    DriftLoan,
    $$DriftLoansTableFilterComposer,
    $$DriftLoansTableOrderingComposer,
    $$DriftLoansTableAnnotationComposer,
    $$DriftLoansTableCreateCompanionBuilder,
    $$DriftLoansTableUpdateCompanionBuilder,
    (DriftLoan, $$DriftLoansTableReferences),
    DriftLoan,
    PrefetchHooks Function({bool account})> {
  $$DriftLoansTableTableManager(_$AppDriftDatabase db, $DriftLoansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftLoansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftLoansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftLoansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> account = const Value.absent(),
            Value<String?> institution = const Value.absent(),
            Value<double?> interestRate = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<String?> agreementNo = const Value.absent(),
            Value<String?> accountNo = const Value.absent(),
          }) =>
              DriftLoansCompanion(
            id: id,
            account: account,
            institution: institution,
            interestRate: interestRate,
            startDate: startDate,
            endDate: endDate,
            agreementNo: agreementNo,
            accountNo: accountNo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int account,
            Value<String?> institution = const Value.absent(),
            Value<double?> interestRate = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<String?> agreementNo = const Value.absent(),
            Value<String?> accountNo = const Value.absent(),
          }) =>
              DriftLoansCompanion.insert(
            id: id,
            account: account,
            institution: institution,
            interestRate: interestRate,
            startDate: startDate,
            endDate: endDate,
            agreementNo: agreementNo,
            accountNo: accountNo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DriftLoansTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({account = false}) {
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
                if (account) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.account,
                    referencedTable:
                        $$DriftLoansTableReferences._accountTable(db),
                    referencedColumn:
                        $$DriftLoansTableReferences._accountTable(db).id,
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

typedef $$DriftLoansTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $DriftLoansTable,
    DriftLoan,
    $$DriftLoansTableFilterComposer,
    $$DriftLoansTableOrderingComposer,
    $$DriftLoansTableAnnotationComposer,
    $$DriftLoansTableCreateCompanionBuilder,
    $$DriftLoansTableUpdateCompanionBuilder,
    (DriftLoan, $$DriftLoansTableReferences),
    DriftLoan,
    PrefetchHooks Function({bool account})>;
typedef $$DriftCCardsTableCreateCompanionBuilder = DriftCCardsCompanion
    Function({
  Value<int> id,
  required int account,
  Value<String?> institution,
  Value<int?> statementDate,
  Value<String?> cardNo,
  Value<String?> cardNetwork,
});
typedef $$DriftCCardsTableUpdateCompanionBuilder = DriftCCardsCompanion
    Function({
  Value<int> id,
  Value<int> account,
  Value<String?> institution,
  Value<int?> statementDate,
  Value<String?> cardNo,
  Value<String?> cardNetwork,
});

final class $$DriftCCardsTableReferences
    extends BaseReferences<_$AppDriftDatabase, $DriftCCardsTable, DriftCCard> {
  $$DriftCCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DriftAccountsTable _accountTable(_$AppDriftDatabase db) =>
      db.driftAccounts.createAlias(
          $_aliasNameGenerator(db.driftCCards.account, db.driftAccounts.id));

  $$DriftAccountsTableProcessedTableManager get account {
    final $_column = $_itemColumn<int>('account')!;

    final manager = $$DriftAccountsTableTableManager($_db, $_db.driftAccounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DriftCCardsTableFilterComposer
    extends Composer<_$AppDriftDatabase, $DriftCCardsTable> {
  $$DriftCCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get institution => $composableBuilder(
      column: $table.institution, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get statementDate => $composableBuilder(
      column: $table.statementDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cardNo => $composableBuilder(
      column: $table.cardNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cardNetwork => $composableBuilder(
      column: $table.cardNetwork, builder: (column) => ColumnFilters(column));

  $$DriftAccountsTableFilterComposer get account {
    final $$DriftAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableFilterComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftCCardsTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $DriftCCardsTable> {
  $$DriftCCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get institution => $composableBuilder(
      column: $table.institution, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get statementDate => $composableBuilder(
      column: $table.statementDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cardNo => $composableBuilder(
      column: $table.cardNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cardNetwork => $composableBuilder(
      column: $table.cardNetwork, builder: (column) => ColumnOrderings(column));

  $$DriftAccountsTableOrderingComposer get account {
    final $$DriftAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftCCardsTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $DriftCCardsTable> {
  $$DriftCCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get institution => $composableBuilder(
      column: $table.institution, builder: (column) => column);

  GeneratedColumn<int> get statementDate => $composableBuilder(
      column: $table.statementDate, builder: (column) => column);

  GeneratedColumn<String> get cardNo =>
      $composableBuilder(column: $table.cardNo, builder: (column) => column);

  GeneratedColumn<String> get cardNetwork => $composableBuilder(
      column: $table.cardNetwork, builder: (column) => column);

  $$DriftAccountsTableAnnotationComposer get account {
    final $$DriftAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftCCardsTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $DriftCCardsTable,
    DriftCCard,
    $$DriftCCardsTableFilterComposer,
    $$DriftCCardsTableOrderingComposer,
    $$DriftCCardsTableAnnotationComposer,
    $$DriftCCardsTableCreateCompanionBuilder,
    $$DriftCCardsTableUpdateCompanionBuilder,
    (DriftCCard, $$DriftCCardsTableReferences),
    DriftCCard,
    PrefetchHooks Function({bool account})> {
  $$DriftCCardsTableTableManager(_$AppDriftDatabase db, $DriftCCardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftCCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftCCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftCCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> account = const Value.absent(),
            Value<String?> institution = const Value.absent(),
            Value<int?> statementDate = const Value.absent(),
            Value<String?> cardNo = const Value.absent(),
            Value<String?> cardNetwork = const Value.absent(),
          }) =>
              DriftCCardsCompanion(
            id: id,
            account: account,
            institution: institution,
            statementDate: statementDate,
            cardNo: cardNo,
            cardNetwork: cardNetwork,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int account,
            Value<String?> institution = const Value.absent(),
            Value<int?> statementDate = const Value.absent(),
            Value<String?> cardNo = const Value.absent(),
            Value<String?> cardNetwork = const Value.absent(),
          }) =>
              DriftCCardsCompanion.insert(
            id: id,
            account: account,
            institution: institution,
            statementDate: statementDate,
            cardNo: cardNo,
            cardNetwork: cardNetwork,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DriftCCardsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({account = false}) {
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
                if (account) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.account,
                    referencedTable:
                        $$DriftCCardsTableReferences._accountTable(db),
                    referencedColumn:
                        $$DriftCCardsTableReferences._accountTable(db).id,
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

typedef $$DriftCCardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $DriftCCardsTable,
    DriftCCard,
    $$DriftCCardsTableFilterComposer,
    $$DriftCCardsTableOrderingComposer,
    $$DriftCCardsTableAnnotationComposer,
    $$DriftCCardsTableCreateCompanionBuilder,
    $$DriftCCardsTableUpdateCompanionBuilder,
    (DriftCCard, $$DriftCCardsTableReferences),
    DriftCCard,
    PrefetchHooks Function({bool account})>;
typedef $$DriftBalancesTableCreateCompanionBuilder = DriftBalancesCompanion
    Function({
  Value<int> id,
  required int account,
  Value<int> amount,
});
typedef $$DriftBalancesTableUpdateCompanionBuilder = DriftBalancesCompanion
    Function({
  Value<int> id,
  Value<int> account,
  Value<int> amount,
});

final class $$DriftBalancesTableReferences extends BaseReferences<
    _$AppDriftDatabase, $DriftBalancesTable, DriftBalance> {
  $$DriftBalancesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DriftAccountsTable _accountTable(_$AppDriftDatabase db) =>
      db.driftAccounts.createAlias(
          $_aliasNameGenerator(db.driftBalances.account, db.driftAccounts.id));

  $$DriftAccountsTableProcessedTableManager get account {
    final $_column = $_itemColumn<int>('account')!;

    final manager = $$DriftAccountsTableTableManager($_db, $_db.driftAccounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DriftBalancesTableFilterComposer
    extends Composer<_$AppDriftDatabase, $DriftBalancesTable> {
  $$DriftBalancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  $$DriftAccountsTableFilterComposer get account {
    final $$DriftAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableFilterComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftBalancesTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $DriftBalancesTable> {
  $$DriftBalancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  $$DriftAccountsTableOrderingComposer get account {
    final $$DriftAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftBalancesTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $DriftBalancesTable> {
  $$DriftBalancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  $$DriftAccountsTableAnnotationComposer get account {
    final $$DriftAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftBalancesTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $DriftBalancesTable,
    DriftBalance,
    $$DriftBalancesTableFilterComposer,
    $$DriftBalancesTableOrderingComposer,
    $$DriftBalancesTableAnnotationComposer,
    $$DriftBalancesTableCreateCompanionBuilder,
    $$DriftBalancesTableUpdateCompanionBuilder,
    (DriftBalance, $$DriftBalancesTableReferences),
    DriftBalance,
    PrefetchHooks Function({bool account})> {
  $$DriftBalancesTableTableManager(
      _$AppDriftDatabase db, $DriftBalancesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftBalancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftBalancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftBalancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> account = const Value.absent(),
            Value<int> amount = const Value.absent(),
          }) =>
              DriftBalancesCompanion(
            id: id,
            account: account,
            amount: amount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int account,
            Value<int> amount = const Value.absent(),
          }) =>
              DriftBalancesCompanion.insert(
            id: id,
            account: account,
            amount: amount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DriftBalancesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({account = false}) {
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
                if (account) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.account,
                    referencedTable:
                        $$DriftBalancesTableReferences._accountTable(db),
                    referencedColumn:
                        $$DriftBalancesTableReferences._accountTable(db).id,
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

typedef $$DriftBalancesTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $DriftBalancesTable,
    DriftBalance,
    $$DriftBalancesTableFilterComposer,
    $$DriftBalancesTableOrderingComposer,
    $$DriftBalancesTableAnnotationComposer,
    $$DriftBalancesTableCreateCompanionBuilder,
    $$DriftBalancesTableUpdateCompanionBuilder,
    (DriftBalance, $$DriftBalancesTableReferences),
    DriftBalance,
    PrefetchHooks Function({bool account})>;
typedef $$DriftBudgetAccountsTableCreateCompanionBuilder
    = DriftBudgetAccountsCompanion Function({
  Value<int> id,
  required int account,
  required int budget,
  Value<int> amount,
});
typedef $$DriftBudgetAccountsTableUpdateCompanionBuilder
    = DriftBudgetAccountsCompanion Function({
  Value<int> id,
  Value<int> account,
  Value<int> budget,
  Value<int> amount,
});

final class $$DriftBudgetAccountsTableReferences extends BaseReferences<
    _$AppDriftDatabase, $DriftBudgetAccountsTable, DriftBudgetAccount> {
  $$DriftBudgetAccountsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DriftAccountsTable _accountTable(_$AppDriftDatabase db) =>
      db.driftAccounts.createAlias($_aliasNameGenerator(
          db.driftBudgetAccounts.account, db.driftAccounts.id));

  $$DriftAccountsTableProcessedTableManager get account {
    final $_column = $_itemColumn<int>('account')!;

    final manager = $$DriftAccountsTableTableManager($_db, $_db.driftAccounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DriftBudgetsTable _budgetTable(_$AppDriftDatabase db) =>
      db.driftBudgets.createAlias($_aliasNameGenerator(
          db.driftBudgetAccounts.budget, db.driftBudgets.id));

  $$DriftBudgetsTableProcessedTableManager get budget {
    final $_column = $_itemColumn<int>('budget')!;

    final manager = $$DriftBudgetsTableTableManager($_db, $_db.driftBudgets)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_budgetTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DriftBudgetAccountsTableFilterComposer
    extends Composer<_$AppDriftDatabase, $DriftBudgetAccountsTable> {
  $$DriftBudgetAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  $$DriftAccountsTableFilterComposer get account {
    final $$DriftAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableFilterComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftBudgetsTableFilterComposer get budget {
    final $$DriftBudgetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budget,
        referencedTable: $db.driftBudgets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBudgetsTableFilterComposer(
              $db: $db,
              $table: $db.driftBudgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftBudgetAccountsTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $DriftBudgetAccountsTable> {
  $$DriftBudgetAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  $$DriftAccountsTableOrderingComposer get account {
    final $$DriftAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftBudgetsTableOrderingComposer get budget {
    final $$DriftBudgetsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budget,
        referencedTable: $db.driftBudgets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBudgetsTableOrderingComposer(
              $db: $db,
              $table: $db.driftBudgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftBudgetAccountsTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $DriftBudgetAccountsTable> {
  $$DriftBudgetAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  $$DriftAccountsTableAnnotationComposer get account {
    final $$DriftAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftBudgetsTableAnnotationComposer get budget {
    final $$DriftBudgetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budget,
        referencedTable: $db.driftBudgets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBudgetsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftBudgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftBudgetAccountsTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $DriftBudgetAccountsTable,
    DriftBudgetAccount,
    $$DriftBudgetAccountsTableFilterComposer,
    $$DriftBudgetAccountsTableOrderingComposer,
    $$DriftBudgetAccountsTableAnnotationComposer,
    $$DriftBudgetAccountsTableCreateCompanionBuilder,
    $$DriftBudgetAccountsTableUpdateCompanionBuilder,
    (DriftBudgetAccount, $$DriftBudgetAccountsTableReferences),
    DriftBudgetAccount,
    PrefetchHooks Function({bool account, bool budget})> {
  $$DriftBudgetAccountsTableTableManager(
      _$AppDriftDatabase db, $DriftBudgetAccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftBudgetAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftBudgetAccountsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftBudgetAccountsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> account = const Value.absent(),
            Value<int> budget = const Value.absent(),
            Value<int> amount = const Value.absent(),
          }) =>
              DriftBudgetAccountsCompanion(
            id: id,
            account: account,
            budget: budget,
            amount: amount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int account,
            required int budget,
            Value<int> amount = const Value.absent(),
          }) =>
              DriftBudgetAccountsCompanion.insert(
            id: id,
            account: account,
            budget: budget,
            amount: amount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DriftBudgetAccountsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({account = false, budget = false}) {
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
                if (account) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.account,
                    referencedTable:
                        $$DriftBudgetAccountsTableReferences._accountTable(db),
                    referencedColumn: $$DriftBudgetAccountsTableReferences
                        ._accountTable(db)
                        .id,
                  ) as T;
                }
                if (budget) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.budget,
                    referencedTable:
                        $$DriftBudgetAccountsTableReferences._budgetTable(db),
                    referencedColumn: $$DriftBudgetAccountsTableReferences
                        ._budgetTable(db)
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

typedef $$DriftBudgetAccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $DriftBudgetAccountsTable,
    DriftBudgetAccount,
    $$DriftBudgetAccountsTableFilterComposer,
    $$DriftBudgetAccountsTableOrderingComposer,
    $$DriftBudgetAccountsTableAnnotationComposer,
    $$DriftBudgetAccountsTableCreateCompanionBuilder,
    $$DriftBudgetAccountsTableUpdateCompanionBuilder,
    (DriftBudgetAccount, $$DriftBudgetAccountsTableReferences),
    DriftBudgetAccount,
    PrefetchHooks Function({bool account, bool budget})>;
typedef $$DriftBudgetFundsTableCreateCompanionBuilder
    = DriftBudgetFundsCompanion Function({
  Value<int> id,
  required int account,
  required int budget,
});
typedef $$DriftBudgetFundsTableUpdateCompanionBuilder
    = DriftBudgetFundsCompanion Function({
  Value<int> id,
  Value<int> account,
  Value<int> budget,
});

final class $$DriftBudgetFundsTableReferences extends BaseReferences<
    _$AppDriftDatabase, $DriftBudgetFundsTable, DriftBudgetFund> {
  $$DriftBudgetFundsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DriftAccountsTable _accountTable(_$AppDriftDatabase db) =>
      db.driftAccounts.createAlias($_aliasNameGenerator(
          db.driftBudgetFunds.account, db.driftAccounts.id));

  $$DriftAccountsTableProcessedTableManager get account {
    final $_column = $_itemColumn<int>('account')!;

    final manager = $$DriftAccountsTableTableManager($_db, $_db.driftAccounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DriftBudgetsTable _budgetTable(_$AppDriftDatabase db) =>
      db.driftBudgets.createAlias(
          $_aliasNameGenerator(db.driftBudgetFunds.budget, db.driftBudgets.id));

  $$DriftBudgetsTableProcessedTableManager get budget {
    final $_column = $_itemColumn<int>('budget')!;

    final manager = $$DriftBudgetsTableTableManager($_db, $_db.driftBudgets)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_budgetTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DriftBudgetFundsTableFilterComposer
    extends Composer<_$AppDriftDatabase, $DriftBudgetFundsTable> {
  $$DriftBudgetFundsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  $$DriftAccountsTableFilterComposer get account {
    final $$DriftAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableFilterComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftBudgetsTableFilterComposer get budget {
    final $$DriftBudgetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budget,
        referencedTable: $db.driftBudgets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBudgetsTableFilterComposer(
              $db: $db,
              $table: $db.driftBudgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftBudgetFundsTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $DriftBudgetFundsTable> {
  $$DriftBudgetFundsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  $$DriftAccountsTableOrderingComposer get account {
    final $$DriftAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftBudgetsTableOrderingComposer get budget {
    final $$DriftBudgetsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budget,
        referencedTable: $db.driftBudgets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBudgetsTableOrderingComposer(
              $db: $db,
              $table: $db.driftBudgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftBudgetFundsTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $DriftBudgetFundsTable> {
  $$DriftBudgetFundsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$DriftAccountsTableAnnotationComposer get account {
    final $$DriftAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftBudgetsTableAnnotationComposer get budget {
    final $$DriftBudgetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.budget,
        referencedTable: $db.driftBudgets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftBudgetsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftBudgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftBudgetFundsTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $DriftBudgetFundsTable,
    DriftBudgetFund,
    $$DriftBudgetFundsTableFilterComposer,
    $$DriftBudgetFundsTableOrderingComposer,
    $$DriftBudgetFundsTableAnnotationComposer,
    $$DriftBudgetFundsTableCreateCompanionBuilder,
    $$DriftBudgetFundsTableUpdateCompanionBuilder,
    (DriftBudgetFund, $$DriftBudgetFundsTableReferences),
    DriftBudgetFund,
    PrefetchHooks Function({bool account, bool budget})> {
  $$DriftBudgetFundsTableTableManager(
      _$AppDriftDatabase db, $DriftBudgetFundsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftBudgetFundsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftBudgetFundsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftBudgetFundsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> account = const Value.absent(),
            Value<int> budget = const Value.absent(),
          }) =>
              DriftBudgetFundsCompanion(
            id: id,
            account: account,
            budget: budget,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int account,
            required int budget,
          }) =>
              DriftBudgetFundsCompanion.insert(
            id: id,
            account: account,
            budget: budget,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DriftBudgetFundsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({account = false, budget = false}) {
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
                if (account) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.account,
                    referencedTable:
                        $$DriftBudgetFundsTableReferences._accountTable(db),
                    referencedColumn:
                        $$DriftBudgetFundsTableReferences._accountTable(db).id,
                  ) as T;
                }
                if (budget) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.budget,
                    referencedTable:
                        $$DriftBudgetFundsTableReferences._budgetTable(db),
                    referencedColumn:
                        $$DriftBudgetFundsTableReferences._budgetTable(db).id,
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

typedef $$DriftBudgetFundsTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $DriftBudgetFundsTable,
    DriftBudgetFund,
    $$DriftBudgetFundsTableFilterComposer,
    $$DriftBudgetFundsTableOrderingComposer,
    $$DriftBudgetFundsTableAnnotationComposer,
    $$DriftBudgetFundsTableCreateCompanionBuilder,
    $$DriftBudgetFundsTableUpdateCompanionBuilder,
    (DriftBudgetFund, $$DriftBudgetFundsTableReferences),
    DriftBudgetFund,
    PrefetchHooks Function({bool account, bool budget})>;
typedef $$DriftReceivablesTableCreateCompanionBuilder
    = DriftReceivablesCompanion Function({
  Value<int> id,
  required int accountId,
  Value<int?> totalAmount,
  Value<DateTime?> paidDate,
});
typedef $$DriftReceivablesTableUpdateCompanionBuilder
    = DriftReceivablesCompanion Function({
  Value<int> id,
  Value<int> accountId,
  Value<int?> totalAmount,
  Value<DateTime?> paidDate,
});

final class $$DriftReceivablesTableReferences extends BaseReferences<
    _$AppDriftDatabase, $DriftReceivablesTable, DriftReceivable> {
  $$DriftReceivablesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DriftAccountsTable _accountIdTable(_$AppDriftDatabase db) =>
      db.driftAccounts.createAlias($_aliasNameGenerator(
          db.driftReceivables.accountId, db.driftAccounts.id));

  $$DriftAccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$DriftAccountsTableTableManager($_db, $_db.driftAccounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DriftReceivablesTableFilterComposer
    extends Composer<_$AppDriftDatabase, $DriftReceivablesTable> {
  $$DriftReceivablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get paidDate => $composableBuilder(
      column: $table.paidDate, builder: (column) => ColumnFilters(column));

  $$DriftAccountsTableFilterComposer get accountId {
    final $$DriftAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableFilterComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftReceivablesTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $DriftReceivablesTable> {
  $$DriftReceivablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get paidDate => $composableBuilder(
      column: $table.paidDate, builder: (column) => ColumnOrderings(column));

  $$DriftAccountsTableOrderingComposer get accountId {
    final $$DriftAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftReceivablesTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $DriftReceivablesTable> {
  $$DriftReceivablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<DateTime> get paidDate =>
      $composableBuilder(column: $table.paidDate, builder: (column) => column);

  $$DriftAccountsTableAnnotationComposer get accountId {
    final $$DriftAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftReceivablesTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $DriftReceivablesTable,
    DriftReceivable,
    $$DriftReceivablesTableFilterComposer,
    $$DriftReceivablesTableOrderingComposer,
    $$DriftReceivablesTableAnnotationComposer,
    $$DriftReceivablesTableCreateCompanionBuilder,
    $$DriftReceivablesTableUpdateCompanionBuilder,
    (DriftReceivable, $$DriftReceivablesTableReferences),
    DriftReceivable,
    PrefetchHooks Function({bool accountId})> {
  $$DriftReceivablesTableTableManager(
      _$AppDriftDatabase db, $DriftReceivablesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftReceivablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftReceivablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftReceivablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<int?> totalAmount = const Value.absent(),
            Value<DateTime?> paidDate = const Value.absent(),
          }) =>
              DriftReceivablesCompanion(
            id: id,
            accountId: accountId,
            totalAmount: totalAmount,
            paidDate: paidDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int accountId,
            Value<int?> totalAmount = const Value.absent(),
            Value<DateTime?> paidDate = const Value.absent(),
          }) =>
              DriftReceivablesCompanion.insert(
            id: id,
            accountId: accountId,
            totalAmount: totalAmount,
            paidDate: paidDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DriftReceivablesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
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
                if (accountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.accountId,
                    referencedTable:
                        $$DriftReceivablesTableReferences._accountIdTable(db),
                    referencedColumn: $$DriftReceivablesTableReferences
                        ._accountIdTable(db)
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

typedef $$DriftReceivablesTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $DriftReceivablesTable,
    DriftReceivable,
    $$DriftReceivablesTableFilterComposer,
    $$DriftReceivablesTableOrderingComposer,
    $$DriftReceivablesTableAnnotationComposer,
    $$DriftReceivablesTableCreateCompanionBuilder,
    $$DriftReceivablesTableUpdateCompanionBuilder,
    (DriftReceivable, $$DriftReceivablesTableReferences),
    DriftReceivable,
    PrefetchHooks Function({bool accountId})>;
typedef $$DriftPeopleTableCreateCompanionBuilder = DriftPeopleCompanion
    Function({
  Value<int> id,
  required int accountId,
  Value<String?> address,
  Value<String?> zip,
  Value<String?> email,
  Value<String?> phone,
  Value<String?> tin,
});
typedef $$DriftPeopleTableUpdateCompanionBuilder = DriftPeopleCompanion
    Function({
  Value<int> id,
  Value<int> accountId,
  Value<String?> address,
  Value<String?> zip,
  Value<String?> email,
  Value<String?> phone,
  Value<String?> tin,
});

final class $$DriftPeopleTableReferences extends BaseReferences<
    _$AppDriftDatabase, $DriftPeopleTable, DriftPeopleData> {
  $$DriftPeopleTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DriftAccountsTable _accountIdTable(_$AppDriftDatabase db) =>
      db.driftAccounts.createAlias(
          $_aliasNameGenerator(db.driftPeople.accountId, db.driftAccounts.id));

  $$DriftAccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$DriftAccountsTableTableManager($_db, $_db.driftAccounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DriftPeopleTableFilterComposer
    extends Composer<_$AppDriftDatabase, $DriftPeopleTable> {
  $$DriftPeopleTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get zip => $composableBuilder(
      column: $table.zip, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tin => $composableBuilder(
      column: $table.tin, builder: (column) => ColumnFilters(column));

  $$DriftAccountsTableFilterComposer get accountId {
    final $$DriftAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableFilterComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftPeopleTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $DriftPeopleTable> {
  $$DriftPeopleTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get zip => $composableBuilder(
      column: $table.zip, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tin => $composableBuilder(
      column: $table.tin, builder: (column) => ColumnOrderings(column));

  $$DriftAccountsTableOrderingComposer get accountId {
    final $$DriftAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftPeopleTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $DriftPeopleTable> {
  $$DriftPeopleTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get zip =>
      $composableBuilder(column: $table.zip, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get tin =>
      $composableBuilder(column: $table.tin, builder: (column) => column);

  $$DriftAccountsTableAnnotationComposer get accountId {
    final $$DriftAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftPeopleTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $DriftPeopleTable,
    DriftPeopleData,
    $$DriftPeopleTableFilterComposer,
    $$DriftPeopleTableOrderingComposer,
    $$DriftPeopleTableAnnotationComposer,
    $$DriftPeopleTableCreateCompanionBuilder,
    $$DriftPeopleTableUpdateCompanionBuilder,
    (DriftPeopleData, $$DriftPeopleTableReferences),
    DriftPeopleData,
    PrefetchHooks Function({bool accountId})> {
  $$DriftPeopleTableTableManager(_$AppDriftDatabase db, $DriftPeopleTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftPeopleTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftPeopleTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftPeopleTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> zip = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> tin = const Value.absent(),
          }) =>
              DriftPeopleCompanion(
            id: id,
            accountId: accountId,
            address: address,
            zip: zip,
            email: email,
            phone: phone,
            tin: tin,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int accountId,
            Value<String?> address = const Value.absent(),
            Value<String?> zip = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> tin = const Value.absent(),
          }) =>
              DriftPeopleCompanion.insert(
            id: id,
            accountId: accountId,
            address: address,
            zip: zip,
            email: email,
            phone: phone,
            tin: tin,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DriftPeopleTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
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
                if (accountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.accountId,
                    referencedTable:
                        $$DriftPeopleTableReferences._accountIdTable(db),
                    referencedColumn:
                        $$DriftPeopleTableReferences._accountIdTable(db).id,
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

typedef $$DriftPeopleTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $DriftPeopleTable,
    DriftPeopleData,
    $$DriftPeopleTableFilterComposer,
    $$DriftPeopleTableOrderingComposer,
    $$DriftPeopleTableAnnotationComposer,
    $$DriftPeopleTableCreateCompanionBuilder,
    $$DriftPeopleTableUpdateCompanionBuilder,
    (DriftPeopleData, $$DriftPeopleTableReferences),
    DriftPeopleData,
    PrefetchHooks Function({bool accountId})>;
typedef $$DriftPaymentRemindersTableCreateCompanionBuilder
    = DriftPaymentRemindersCompanion Function({
  Value<int> id,
  Value<int?> account,
  Value<int?> fund,
  required int profile,
  required String details,
  Value<BudgetInterval?> interval,
  Value<int> day,
  Value<int> amount,
  Value<DateTime?> paymentDate,
  Value<DateTime> addedDate,
  Value<DateTime> updateDate,
  required PaymentStatus status,
});
typedef $$DriftPaymentRemindersTableUpdateCompanionBuilder
    = DriftPaymentRemindersCompanion Function({
  Value<int> id,
  Value<int?> account,
  Value<int?> fund,
  Value<int> profile,
  Value<String> details,
  Value<BudgetInterval?> interval,
  Value<int> day,
  Value<int> amount,
  Value<DateTime?> paymentDate,
  Value<DateTime> addedDate,
  Value<DateTime> updateDate,
  Value<PaymentStatus> status,
});

final class $$DriftPaymentRemindersTableReferences extends BaseReferences<
    _$AppDriftDatabase, $DriftPaymentRemindersTable, DriftPaymentReminder> {
  $$DriftPaymentRemindersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DriftAccountsTable _accountTable(_$AppDriftDatabase db) =>
      db.driftAccounts.createAlias($_aliasNameGenerator(
          db.driftPaymentReminders.account, db.driftAccounts.id));

  $$DriftAccountsTableProcessedTableManager? get account {
    final $_column = $_itemColumn<int>('account');
    if ($_column == null) return null;
    final manager = $$DriftAccountsTableTableManager($_db, $_db.driftAccounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DriftAccountsTable _fundTable(_$AppDriftDatabase db) =>
      db.driftAccounts.createAlias($_aliasNameGenerator(
          db.driftPaymentReminders.fund, db.driftAccounts.id));

  $$DriftAccountsTableProcessedTableManager? get fund {
    final $_column = $_itemColumn<int>('fund');
    if ($_column == null) return null;
    final manager = $$DriftAccountsTableTableManager($_db, $_db.driftAccounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fundTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DriftProfilesTable _profileTable(_$AppDriftDatabase db) =>
      db.driftProfiles.createAlias($_aliasNameGenerator(
          db.driftPaymentReminders.profile, db.driftProfiles.id));

  $$DriftProfilesTableProcessedTableManager get profile {
    final $_column = $_itemColumn<int>('profile')!;

    final manager = $$DriftProfilesTableTableManager($_db, $_db.driftProfiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DriftPaymentRemindersTableFilterComposer
    extends Composer<_$AppDriftDatabase, $DriftPaymentRemindersTable> {
  $$DriftPaymentRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<BudgetInterval?, BudgetInterval, int>
      get interval => $composableBuilder(
          column: $table.interval,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get paymentDate => $composableBuilder(
      column: $table.paymentDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedDate => $composableBuilder(
      column: $table.addedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<PaymentStatus, PaymentStatus, int>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$DriftAccountsTableFilterComposer get account {
    final $$DriftAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableFilterComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftAccountsTableFilterComposer get fund {
    final $$DriftAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fund,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableFilterComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftProfilesTableFilterComposer get profile {
    final $$DriftProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profile,
        referencedTable: $db.driftProfiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProfilesTableFilterComposer(
              $db: $db,
              $table: $db.driftProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftPaymentRemindersTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $DriftPaymentRemindersTable> {
  $$DriftPaymentRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get interval => $composableBuilder(
      column: $table.interval, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get paymentDate => $composableBuilder(
      column: $table.paymentDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedDate => $composableBuilder(
      column: $table.addedDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  $$DriftAccountsTableOrderingComposer get account {
    final $$DriftAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftAccountsTableOrderingComposer get fund {
    final $$DriftAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fund,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftProfilesTableOrderingComposer get profile {
    final $$DriftProfilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profile,
        referencedTable: $db.driftProfiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProfilesTableOrderingComposer(
              $db: $db,
              $table: $db.driftProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftPaymentRemindersTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $DriftPaymentRemindersTable> {
  $$DriftPaymentRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BudgetInterval?, int> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get paymentDate => $composableBuilder(
      column: $table.paymentDate, builder: (column) => column);

  GeneratedColumn<DateTime> get addedDate =>
      $composableBuilder(column: $table.addedDate, builder: (column) => column);

  GeneratedColumn<DateTime> get updateDate => $composableBuilder(
      column: $table.updateDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PaymentStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$DriftAccountsTableAnnotationComposer get account {
    final $$DriftAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftAccountsTableAnnotationComposer get fund {
    final $$DriftAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fund,
        referencedTable: $db.driftAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.driftAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DriftProfilesTableAnnotationComposer get profile {
    final $$DriftProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profile,
        referencedTable: $db.driftProfiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriftProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.driftProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DriftPaymentRemindersTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $DriftPaymentRemindersTable,
    DriftPaymentReminder,
    $$DriftPaymentRemindersTableFilterComposer,
    $$DriftPaymentRemindersTableOrderingComposer,
    $$DriftPaymentRemindersTableAnnotationComposer,
    $$DriftPaymentRemindersTableCreateCompanionBuilder,
    $$DriftPaymentRemindersTableUpdateCompanionBuilder,
    (DriftPaymentReminder, $$DriftPaymentRemindersTableReferences),
    DriftPaymentReminder,
    PrefetchHooks Function({bool account, bool fund, bool profile})> {
  $$DriftPaymentRemindersTableTableManager(
      _$AppDriftDatabase db, $DriftPaymentRemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftPaymentRemindersTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftPaymentRemindersTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftPaymentRemindersTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> account = const Value.absent(),
            Value<int?> fund = const Value.absent(),
            Value<int> profile = const Value.absent(),
            Value<String> details = const Value.absent(),
            Value<BudgetInterval?> interval = const Value.absent(),
            Value<int> day = const Value.absent(),
            Value<int> amount = const Value.absent(),
            Value<DateTime?> paymentDate = const Value.absent(),
            Value<DateTime> addedDate = const Value.absent(),
            Value<DateTime> updateDate = const Value.absent(),
            Value<PaymentStatus> status = const Value.absent(),
          }) =>
              DriftPaymentRemindersCompanion(
            id: id,
            account: account,
            fund: fund,
            profile: profile,
            details: details,
            interval: interval,
            day: day,
            amount: amount,
            paymentDate: paymentDate,
            addedDate: addedDate,
            updateDate: updateDate,
            status: status,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> account = const Value.absent(),
            Value<int?> fund = const Value.absent(),
            required int profile,
            required String details,
            Value<BudgetInterval?> interval = const Value.absent(),
            Value<int> day = const Value.absent(),
            Value<int> amount = const Value.absent(),
            Value<DateTime?> paymentDate = const Value.absent(),
            Value<DateTime> addedDate = const Value.absent(),
            Value<DateTime> updateDate = const Value.absent(),
            required PaymentStatus status,
          }) =>
              DriftPaymentRemindersCompanion.insert(
            id: id,
            account: account,
            fund: fund,
            profile: profile,
            details: details,
            interval: interval,
            day: day,
            amount: amount,
            paymentDate: paymentDate,
            addedDate: addedDate,
            updateDate: updateDate,
            status: status,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DriftPaymentRemindersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {account = false, fund = false, profile = false}) {
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
                if (account) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.account,
                    referencedTable: $$DriftPaymentRemindersTableReferences
                        ._accountTable(db),
                    referencedColumn: $$DriftPaymentRemindersTableReferences
                        ._accountTable(db)
                        .id,
                  ) as T;
                }
                if (fund) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.fund,
                    referencedTable:
                        $$DriftPaymentRemindersTableReferences._fundTable(db),
                    referencedColumn: $$DriftPaymentRemindersTableReferences
                        ._fundTable(db)
                        .id,
                  ) as T;
                }
                if (profile) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.profile,
                    referencedTable: $$DriftPaymentRemindersTableReferences
                        ._profileTable(db),
                    referencedColumn: $$DriftPaymentRemindersTableReferences
                        ._profileTable(db)
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

typedef $$DriftPaymentRemindersTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDriftDatabase,
        $DriftPaymentRemindersTable,
        DriftPaymentReminder,
        $$DriftPaymentRemindersTableFilterComposer,
        $$DriftPaymentRemindersTableOrderingComposer,
        $$DriftPaymentRemindersTableAnnotationComposer,
        $$DriftPaymentRemindersTableCreateCompanionBuilder,
        $$DriftPaymentRemindersTableUpdateCompanionBuilder,
        (DriftPaymentReminder, $$DriftPaymentRemindersTableReferences),
        DriftPaymentReminder,
        PrefetchHooks Function({bool account, bool fund, bool profile})>;
typedef $$DriftFilePathsTableCreateCompanionBuilder = DriftFilePathsCompanion
    Function({
  Value<int> id,
  required DBTableType tableType,
  required int parentTable,
  required String path,
});
typedef $$DriftFilePathsTableUpdateCompanionBuilder = DriftFilePathsCompanion
    Function({
  Value<int> id,
  Value<DBTableType> tableType,
  Value<int> parentTable,
  Value<String> path,
});

class $$DriftFilePathsTableFilterComposer
    extends Composer<_$AppDriftDatabase, $DriftFilePathsTable> {
  $$DriftFilePathsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DBTableType, DBTableType, int> get tableType =>
      $composableBuilder(
          column: $table.tableType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get parentTable => $composableBuilder(
      column: $table.parentTable, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnFilters(column));
}

class $$DriftFilePathsTableOrderingComposer
    extends Composer<_$AppDriftDatabase, $DriftFilePathsTable> {
  $$DriftFilePathsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tableType => $composableBuilder(
      column: $table.tableType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get parentTable => $composableBuilder(
      column: $table.parentTable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnOrderings(column));
}

class $$DriftFilePathsTableAnnotationComposer
    extends Composer<_$AppDriftDatabase, $DriftFilePathsTable> {
  $$DriftFilePathsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DBTableType, int> get tableType =>
      $composableBuilder(column: $table.tableType, builder: (column) => column);

  GeneratedColumn<int> get parentTable => $composableBuilder(
      column: $table.parentTable, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);
}

class $$DriftFilePathsTableTableManager extends RootTableManager<
    _$AppDriftDatabase,
    $DriftFilePathsTable,
    DriftFilePath,
    $$DriftFilePathsTableFilterComposer,
    $$DriftFilePathsTableOrderingComposer,
    $$DriftFilePathsTableAnnotationComposer,
    $$DriftFilePathsTableCreateCompanionBuilder,
    $$DriftFilePathsTableUpdateCompanionBuilder,
    (
      DriftFilePath,
      BaseReferences<_$AppDriftDatabase, $DriftFilePathsTable, DriftFilePath>
    ),
    DriftFilePath,
    PrefetchHooks Function()> {
  $$DriftFilePathsTableTableManager(
      _$AppDriftDatabase db, $DriftFilePathsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftFilePathsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftFilePathsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftFilePathsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DBTableType> tableType = const Value.absent(),
            Value<int> parentTable = const Value.absent(),
            Value<String> path = const Value.absent(),
          }) =>
              DriftFilePathsCompanion(
            id: id,
            tableType: tableType,
            parentTable: parentTable,
            path: path,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DBTableType tableType,
            required int parentTable,
            required String path,
          }) =>
              DriftFilePathsCompanion.insert(
            id: id,
            tableType: tableType,
            parentTable: parentTable,
            path: path,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DriftFilePathsTableProcessedTableManager = ProcessedTableManager<
    _$AppDriftDatabase,
    $DriftFilePathsTable,
    DriftFilePath,
    $$DriftFilePathsTableFilterComposer,
    $$DriftFilePathsTableOrderingComposer,
    $$DriftFilePathsTableAnnotationComposer,
    $$DriftFilePathsTableCreateCompanionBuilder,
    $$DriftFilePathsTableUpdateCompanionBuilder,
    (
      DriftFilePath,
      BaseReferences<_$AppDriftDatabase, $DriftFilePathsTable, DriftFilePath>
    ),
    DriftFilePath,
    PrefetchHooks Function()>;

class $AppDriftDatabaseManager {
  final _$AppDriftDatabase _db;
  $AppDriftDatabaseManager(this._db);
  $$DriftAccTypesTableTableManager get driftAccTypes =>
      $$DriftAccTypesTableTableManager(_db, _db.driftAccTypes);
  $$DriftProfilesTableTableManager get driftProfiles =>
      $$DriftProfilesTableTableManager(_db, _db.driftProfiles);
  $$DriftAccountsTableTableManager get driftAccounts =>
      $$DriftAccountsTableTableManager(_db, _db.driftAccounts);
  $$DriftBudgetsTableTableManager get driftBudgets =>
      $$DriftBudgetsTableTableManager(_db, _db.driftBudgets);
  $$DriftProjectsTableTableManager get driftProjects =>
      $$DriftProjectsTableTableManager(_db, _db.driftProjects);
  $$DriftTransactionsTableTableManager get driftTransactions =>
      $$DriftTransactionsTableTableManager(_db, _db.driftTransactions);
  $$DriftUsersTableTableManager get driftUsers =>
      $$DriftUsersTableTableManager(_db, _db.driftUsers);
  $$DriftBanksTableTableManager get driftBanks =>
      $$DriftBanksTableTableManager(_db, _db.driftBanks);
  $$DriftWalletsTableTableManager get driftWallets =>
      $$DriftWalletsTableTableManager(_db, _db.driftWallets);
  $$DriftLoansTableTableManager get driftLoans =>
      $$DriftLoansTableTableManager(_db, _db.driftLoans);
  $$DriftCCardsTableTableManager get driftCCards =>
      $$DriftCCardsTableTableManager(_db, _db.driftCCards);
  $$DriftBalancesTableTableManager get driftBalances =>
      $$DriftBalancesTableTableManager(_db, _db.driftBalances);
  $$DriftBudgetAccountsTableTableManager get driftBudgetAccounts =>
      $$DriftBudgetAccountsTableTableManager(_db, _db.driftBudgetAccounts);
  $$DriftBudgetFundsTableTableManager get driftBudgetFunds =>
      $$DriftBudgetFundsTableTableManager(_db, _db.driftBudgetFunds);
  $$DriftReceivablesTableTableManager get driftReceivables =>
      $$DriftReceivablesTableTableManager(_db, _db.driftReceivables);
  $$DriftPeopleTableTableManager get driftPeople =>
      $$DriftPeopleTableTableManager(_db, _db.driftPeople);
  $$DriftPaymentRemindersTableTableManager get driftPaymentReminders =>
      $$DriftPaymentRemindersTableTableManager(_db, _db.driftPaymentReminders);
  $$DriftFilePathsTableTableManager get driftFilePaths =>
      $$DriftFilePathsTableTableManager(_db, _db.driftFilePaths);
}
