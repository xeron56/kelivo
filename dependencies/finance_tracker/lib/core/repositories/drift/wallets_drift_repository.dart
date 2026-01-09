import 'package:drift/drift.dart';
import 'package:finance_tracker/app/extensions/drift_models.dart';
import 'package:finance_tracker/core/abstracts/wallets_repository.dart';
import 'package:finance_tracker/core/db/app_drift_database.dart';
import 'package:finance_tracker/core/models/domain/wallet.dart';
import 'package:finance_tracker/utils/app_logger.dart';

class WalletsDriftRepository implements WalletsRepository {
  WalletsDriftRepository(this.db);
  final AppDriftDatabase db;

  @override
  Future<int> insertWallet({required int account}) async {
    try {
      final wallet = DriftWalletsCompanion(
        account: Value(account),
      );
      return await db.insertWallet(wallet);
    } catch (e) {
      AppLogger.instance.error("Failed to insert wallet. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<bool> updateWallet({required int account, required int id}) async {
    try {
      final wallet = DriftWalletsCompanion(
        account: Value(account),
        id: Value(id),
      );
      return await db.updateWallet(wallet);
    } catch (e) {
      AppLogger.instance.error("Failed to update wallet. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<int> delete(int id) async {
    try {
      return await db.deleteWallet(id);
    } catch (e) {
      AppLogger.instance.error("Failed to delete wallet. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<Wallet> getById(int id) async {
    try {
      final account = (await db.getAccountbyId(id)).toDomain();
      return (await db.getWalletById(id)).toDomain(account);
    } catch (e) {
      AppLogger.instance.error("Failed to get wallet. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<Wallet> getByAccount(int id) async {
    try {
      final account = (await db.getAccountbyId(id)).toDomain();
      return (await db.getWalletByAccount(id)).toDomain(account);
    } catch (e) {
      AppLogger.instance.error("Failed to get Bank. ${e.toString()}");
      rethrow;
    }
  }
}

