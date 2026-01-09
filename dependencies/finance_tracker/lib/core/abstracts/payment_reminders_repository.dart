import 'package:finance_tracker/core/enums/budget_interval.dart';
import 'package:finance_tracker/core/enums/payment_status.dart';
import 'package:finance_tracker/core/models/domain/account.dart';
import 'package:finance_tracker/core/models/domain/payment_reminder.dart';

abstract class PaymentRemindersRepository {
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
  });

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
  });

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
    int day = 1,
  });

  Future<int> delete(int id);
  Future<int> deletePaymentReminder(
    int id,
  );
  Future<PaymentReminder> getById(int id);
  Future<List<PaymentReminder>> getAllPaymentReminders(int profile);
  Future<PaymentReminder?> getPaymentReminderByID(int id);
}

