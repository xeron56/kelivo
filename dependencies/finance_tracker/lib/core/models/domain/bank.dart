import 'package:finance_tracker/core/models/domain/account.dart';

class Bank {
  final int dbID;
  final Account account;
  final String? holderName;
  final String? institution;
  final String? branch;
  final String? branchCode;
  final String? accountNo;

  Bank({
    required this.dbID,
    required this.account,
    this.holderName,
    this.institution,
    this.branch,
    this.branchCode,
    this.accountNo,
  });
}

