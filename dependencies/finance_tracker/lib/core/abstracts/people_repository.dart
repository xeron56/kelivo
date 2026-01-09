import 'package:finance_tracker/core/models/domain/people.dart';

abstract class PeopleRepository {
  Future<int> insertPeople({
    required int account,
    String? address,
    String? email,
    String? tin,
    String? phone,
    String? zip,
  });
  Future<bool> updatePeople({
    required int account,
    required int id,
    String? address,
    String? email,
    String? tin,
    String? phone,
    String? zip,
  });
  Future<int> delete(int id);
  Future<People> getById(int id);
  Future<People> getByAccount(int id);
}

