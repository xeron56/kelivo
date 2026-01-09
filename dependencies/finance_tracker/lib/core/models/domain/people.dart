import 'package:finance_tracker/core/models/domain/account.dart';

class People {
  final int dbID;
  final Account account;
  final String? address;
  final String? zip;
  final String? email;
  final String? phone;
  final String? tin;

  People({
    required this.dbID,
    required this.account,
    this.address,
    this.zip,
    this.email,
    this.phone,
    this.tin,
  });
}

