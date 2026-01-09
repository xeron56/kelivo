import 'package:finance_tracker/core/enums/primary_type.dart';

class AccountType {
  final int dbID;
  final String name;
  final PrimaryType primary;
  final DateTime addedDate;
  final DateTime updateDate;
  final bool isEditable;

  AccountType({
    required this.dbID,
    required this.name,
    required this.primary,
    required this.addedDate,
    required this.updateDate,
    required this.isEditable,
  });

  @override
  bool operator ==(covariant AccountType other) {
    if (identical(this, other)) return true;

    return other.dbID == dbID &&
        other.name == name &&
        other.primary == primary &&
        other.addedDate == addedDate &&
        other.updateDate == updateDate &&
        other.isEditable == isEditable;
  }

  @override
  int get hashCode {
    return dbID.hashCode ^
        name.hashCode ^
        primary.hashCode ^
        addedDate.hashCode ^
        updateDate.hashCode ^
        isEditable.hashCode;
  }

  @override
  String toString() {
    return '$name ${primary.name}'.toLowerCase();
  }
}

