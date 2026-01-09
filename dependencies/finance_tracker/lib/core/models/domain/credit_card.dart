import 'package:finance_tracker/core/models/domain/account.dart';

class CreditCard {
  final int dbID;
  final Account account;
  final String? institution;
  final int? statementDate;
  final String? cardNo;
  final String? cardNetwork;

  CreditCard({
    required this.dbID,
    required this.account,
    this.institution,
    this.statementDate,
    this.cardNo,
    this.cardNetwork,
  });
}

