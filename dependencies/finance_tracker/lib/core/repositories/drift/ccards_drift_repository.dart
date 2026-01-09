import 'package:drift/drift.dart';
import 'package:finance_tracker/app/extensions/drift_models.dart';
import 'package:finance_tracker/core/abstracts/credit_cards_repository.dart';
import 'package:finance_tracker/core/db/app_drift_database.dart';
import 'package:finance_tracker/core/models/domain/credit_card.dart';
import 'package:finance_tracker/utils/app_logger.dart';

class CCardsDriftRepository implements CreditCardsRepository {
  CCardsDriftRepository(this.db);
  final AppDriftDatabase db;

  @override
  Future<int> insertCCard({
    required int account,
    required String? institution,
    required String? cardNetwork,
    required String? cardNo,
    required int? statementDate,
  }) async {
    try {
      final card = DriftCCardsCompanion(
        account: Value(account),
        institution: Value(institution),
        cardNetwork: Value(cardNetwork),
        cardNo: Value(cardNo),
        statementDate: Value(statementDate),
      );
      return await db.insertCCard(card);
    } catch (e) {
      AppLogger.instance.error("Failed to insert card. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<bool> updateCCard({
    required int id,
    required int account,
    required String? institution,
    required String? cardNetwork,
    required String? cardNo,
    required int? statementDate,
  }) async {
    try {
      final card = DriftCCardsCompanion(
        id: Value(id),
        account: Value(account),
        institution: Value(institution),
        cardNetwork: Value(cardNetwork),
        cardNo: Value(cardNo),
        statementDate: Value(statementDate),
      );
      return await db.updateCCard(card);
    } catch (e) {
      AppLogger.instance.error("Failed to update card. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<int> delete(int id) async {
    try {
      return await db.deleteCCard(id);
    } catch (e) {
      AppLogger.instance.error("Failed to delete card. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<CreditCard> getById(int id) async {
    try {
      final account = (await db.getAccountbyId(id)).toDomain();
      return (await db.getCCardById(id)).toDomain(account);
    } catch (e) {
      AppLogger.instance.error("Failed to get card. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<CreditCard> getByAccount(int id) async {
    try {
      final account = (await db.getAccountbyId(id)).toDomain();
      return (await db.getCCardByAccount(id)).toDomain(account);
    } catch (e) {
      AppLogger.instance.error("Failed to get Bank. ${e.toString()}");
      rethrow;
    }
  }
}

