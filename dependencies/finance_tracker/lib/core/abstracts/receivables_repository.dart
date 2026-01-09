import 'package:finance_tracker/core/models/domain/receivable.dart';

abstract class ReceivablesRepository {
  Future<int> insertReceivable({
    required int account,
    DateTime? paidDate,
    int? paidAmount,
  });
  Future<bool> updateReceivable({
    required int account,
    required int id,
    DateTime? paidDate,
    int? paidAmount,
  });
  Future<int> delete(int id);
  Future<Receivable> getById(int id);
  Future<Receivable> getByAccount(int id);
}

