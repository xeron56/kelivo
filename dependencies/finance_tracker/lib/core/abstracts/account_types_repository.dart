import 'package:finance_tracker/core/models/domain/account_type.dart';

abstract class AccountTypesRepository {
  Future<List<AccountType>> getAll();
  Future<int> delete(int id);
  Future<AccountType> getById(int id);
  Future<AccountType> getAccTypeByType(int type);
  Future<List<AccountType>> getAccTypesByCategory(List<int> accTypeIDs);
}

