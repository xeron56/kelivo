import 'package:finance_tracker/core/enums/currency.dart';

class Profile {
  final int dbID;
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

  Profile({
    required this.dbID,
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
    required this.updateDate,
  });

  @override
  bool operator ==(covariant Profile other) {
    if (identical(this, other)) return true;

    return other.dbID == dbID &&
        other.name == name &&
        other.alias == alias &&
        other.address == address &&
        other.zip == zip &&
        other.email == email &&
        other.phone == phone &&
        other.tin == tin &&
        other.isSelected == isSelected &&
        other.currency == currency &&
        other.globalID == globalID &&
        other.isLocal == isLocal &&
        other.addedDate == addedDate &&
        other.updateDate == updateDate;
  }

  @override
  int get hashCode {
    return dbID.hashCode ^
        name.hashCode ^
        alias.hashCode ^
        address.hashCode ^
        zip.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        tin.hashCode ^
        isSelected.hashCode ^
        currency.hashCode ^
        globalID.hashCode ^
        isLocal.hashCode ^
        addedDate.hashCode ^
        updateDate.hashCode;
  }

  @override
  String toString() {
    return '$name $alias $address $email $tin'.toLowerCase();
  }
}

