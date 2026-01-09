import 'package:drift/drift.dart';
import 'package:finance_tracker/app/extensions/drift_models.dart';
import 'package:finance_tracker/core/abstracts/payment_reminders_repository.dart';
import 'package:finance_tracker/core/db/app_drift_database.dart';
import 'package:finance_tracker/core/enums/budget_interval.dart';
import 'package:finance_tracker/core/enums/payment_status.dart';
import 'package:finance_tracker/core/models/domain/account.dart';
import 'package:finance_tracker/core/models/domain/payment_reminder.dart';
import 'package:finance_tracker/utils/app_logger.dart';

class PaymentRemindersDriftRepository implements PaymentRemindersRepository {
  PaymentRemindersDriftRepository(this.db);
  final AppDriftDatabase db;

  @override
  Future<int> insertPaymentReminder({
    Account? account,
    required int profile,
    PaymentStatus status = PaymentStatus.pending,
    required int amount,
    BudgetInterval? interval,
    required String details,
    DateTime? paymentDate,
    Account? fund,
    int day = 1,
  }) async {
    try {
      final reminder = DriftPaymentRemindersCompanion.insert(
        profile: profile,
        status: status,
        account: Value(account?.dbID),
        amount: Value(amount),
        day: Value(day),
        fund: Value(fund?.dbID),
        interval: Value(interval),
        paymentDate: Value(paymentDate),
        details: details,
      );

      final p = await db.insertPaymentReminder(reminder);
      return p;
    } catch (e) {
      AppLogger.instance.error("Failed to insert reminder. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<bool> updatePaymentReminder({
    required int id,
    Account? account,
    required int profile,
    PaymentStatus status = PaymentStatus.pending,
    required int amount,
    BudgetInterval? interval,
    required String details,
    DateTime? paymentDate,
    Account? fund,
    int day = 1,
  }) async {
    try {
      db.deleteFilePathByParentID(id);
      final reminder = DriftPaymentRemindersCompanion(
        id: Value(id),
        profile: Value(profile),
        status: Value(status),
        account: Value(account?.dbID),
        amount: Value(amount),
        day: Value(day),
        fund: Value(fund?.dbID),
        interval: Value(interval),
        paymentDate: Value(paymentDate),
        details: Value(details),
      );

      return await db.updatePaymentReminder(reminder);
    } catch (e) {
      AppLogger.instance.error("Failed to update reminder. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<int> delete(int id) async {
    try {
      return await db.deletePaymentReminder(id);
    } catch (e) {
      AppLogger.instance.error("Failed to delete reminder. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<PaymentReminder> getById(int id) async {
    try {
      final reminder = await db.getPaymentReminderById(id);
      final account = reminder.account != null
          ? (await db.getAccountbyId(reminder.account!)).toDomain()
          : null;
      final fund = reminder.fund != null
          ? (await db.getAccountbyId(reminder.fund!)).toDomain()
          : null;

      final photoPaths =
          (await db.getFilePathByParentId(id)).map((p) => p.path).toList();
      return reminder.toDomain(account, fund, photoPaths);
    } catch (e) {
      AppLogger.instance.error("Failed to get reminder. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<List<PaymentReminder>> getAllPaymentReminders(int profile) async {
    try {
      return (await db.getReminders(profile)).map((r) {
        final pr = r.item1;
        return PaymentReminder(
            dbID: pr.id,
            paymentStatus: pr.status,
            profile: pr.profile,
            amount: pr.amount,
            addedDate: pr.addedDate,
            updateDate: pr.updateDate,
            account: r.item2?.toDomain(),
            fund: r.item3?.toDomain(),
            day: pr.day,
            interval: pr.interval,
            details: pr.details,
            paymentDate: pr.paymentDate,
            filePaths: r.item4.map((i) => i.path).toList());
      }).toList();
    } catch (e) {
      AppLogger.instance.error("Failed to get reminder. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<PaymentReminder?> getPaymentReminderByID(int id) async {
    try {
      final r = await db.getReminder(id);
      final pr = r.item1;
      return PaymentReminder(
          dbID: pr.id,
          paymentStatus: pr.status,
          profile: pr.profile,
          amount: pr.amount,
          addedDate: pr.addedDate,
          updateDate: pr.updateDate,
          account: r.item2?.toDomain(),
          fund: r.item3?.toDomain(),
          day: pr.day,
          details: pr.details,
          interval: pr.interval,
          paymentDate: pr.paymentDate,
          filePaths: r.item4.map((i) => i.path).toList());
    } catch (e) {
      AppLogger.instance.error("Failed to get reminder plan. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<int> deletePaymentReminder(int id) async {
    try {
      await db.deletePaymentReminder(id);
      return 1;
    } catch (e) {
      AppLogger.instance.error("Failed to get reminder plan. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<bool> updatePaymentReminderStatus({
    required int id,
    Account? account,
    required int profile,
    PaymentStatus status = PaymentStatus.pending,
    required int amount,
    BudgetInterval? interval,
    required String details,
    DateTime? paymentDate,
    Account? fund,
    int? budget,
    int day = 1,
  }) async {
    final reminder = DriftPaymentRemindersCompanion(
      id: Value(id),
      profile: Value(profile),
      status: Value(status),
      account: Value(account?.dbID),
      amount: Value(amount),
      day: Value(day),
      fund: Value(fund?.dbID),
      interval: Value(interval),
      paymentDate: Value(paymentDate),
      details: Value(details),
    );

    return await db.updatePaymentReminder(reminder);
  }
}

