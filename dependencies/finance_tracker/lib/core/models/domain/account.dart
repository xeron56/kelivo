class Account {
  final int dbID;
  final String name;
  final int openBalance;
  final DateTime openDate;
  final int accountType;
  final bool isEditable;
  final DateTime addedDate;
  final DateTime updateDate;

  Account({
    required this.dbID,
    required this.name,
    required this.openBalance,
    required this.openDate,
    required this.isEditable,
    required this.addedDate,
    required this.updateDate,
    required this.accountType,
  });

  @override
  bool operator ==(covariant Account other) {
    if (identical(this, other)) return true;

    return other.dbID == dbID &&
        other.name == name &&
        other.openBalance == openBalance &&
        other.openDate == openDate &&
        other.accountType == accountType &&
        other.isEditable == isEditable &&
        other.addedDate == addedDate &&
        other.updateDate == updateDate;
  }

  @override
  int get hashCode {
    return dbID.hashCode ^
        name.hashCode ^
        openBalance.hashCode ^
        openDate.hashCode ^
        accountType.hashCode ^
        isEditable.hashCode ^
        addedDate.hashCode ^
        updateDate.hashCode;
  }

  @override
  String toString() {
    return name.toLowerCase();
  }
}
