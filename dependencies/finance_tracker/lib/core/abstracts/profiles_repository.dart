import 'package:finance_tracker/core/enums/currency.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';

abstract class ProfilesRepository {
  Future<List<Profile>> getAll();
  Future<int> insertProfile({
    required String name,
    required String? alias,
    required Currency currency,
    required String? address,
    required String? zip,
    required String? email,
    required String? phone,
    required String? tin,
  });
  Future<bool> updateProfile({
    required int id,
    required String name,
    required String? alias,
    required Currency currency,
    required String? address,
    required String? zip,
    required String? email,
    required String? phone,
    required String? tin,
  });
  Future<int> delete(int id);
  Future<Profile> getById(int id);
  Future<Profile?> getSelectedProfile();
  Future<void> setSelectedProfile(int id);
}

