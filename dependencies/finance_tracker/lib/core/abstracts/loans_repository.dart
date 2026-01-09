import 'package:finance_tracker/core/models/domain/loan.dart';

abstract class LoansRepository {
  Future<int> insertLoan(
      {required int account,
      required String? institution,
      required String? accountNo,
      required String? agreementNo,
      required double? interestRate,
      required DateTime? startDate,
      required DateTime? endDate});
  Future<bool> updateLoan(
      {required int id,
      required int account,
      required String? institution,
      required String? accountNo,
      required String? agreementNo,
      required double? interestRate,
      required DateTime? startDate,
      required DateTime? endDate});
  Future<int> delete(int id);
  Future<Loan> getById(int id);
  Future<Loan> getByAccount(int id);
}

