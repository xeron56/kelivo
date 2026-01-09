import 'package:finance_tracker/core/models/domain/wallet.dart';

abstract class WalletsRepository {
  Future<int> insertWallet({required int account});
  Future<bool> updateWallet({required int account, required int id});
  Future<int> delete(int id);
  Future<Wallet> getById(int id);
  Future<Wallet> getByAccount(int id);
}

