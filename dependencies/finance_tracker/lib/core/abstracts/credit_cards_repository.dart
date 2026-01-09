import 'package:finance_tracker/core/models/domain/credit_card.dart';

abstract class CreditCardsRepository {
  Future<int> insertCCard({
    required int account,
    required String? institution,
    required String? cardNetwork,
    required String? cardNo,
    required int? statementDate,
  });
  Future<bool> updateCCard({
    required int id,
    required int account,
    required String? institution,
    required String? cardNetwork,
    required String? cardNo,
    required int? statementDate,
  });
  Future<int> delete(int id);
  Future<CreditCard> getById(int id);
  Future<CreditCard> getByAccount(int id);
}

