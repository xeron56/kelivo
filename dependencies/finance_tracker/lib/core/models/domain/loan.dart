import 'package:finance_tracker/core/models/domain/account.dart';

class Loan {
  final int dbID;
  final Account account;
  final String? institution;
  final double? interestRate;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? agreementNo;
  final String? accountNo;

  Loan({
    required this.dbID,
    required this.account,
    this.institution,
    this.interestRate,
    this.startDate,
    this.endDate,
    this.agreementNo,
    this.accountNo,
  });
}

