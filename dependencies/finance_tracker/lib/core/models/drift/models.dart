import 'package:drift/drift.dart';
import 'package:finance_tracker/core/enums/budget_interval.dart';
import 'package:finance_tracker/core/enums/currency.dart';
import 'package:finance_tracker/core/enums/db_table_type.dart';
import 'package:finance_tracker/core/enums/payment_status.dart';
import 'package:finance_tracker/core/enums/primary_type.dart';
import 'package:finance_tracker/core/enums/project_status.dart';
import 'package:finance_tracker/core/enums/voucher_type.dart';
import 'package:uuid/uuid.dart';

/// Stores user information.
/// Currently, the app supports only one user per device, but multiple profiles.
class DriftUsers extends Table {
  IntColumn get id => integer().autoIncrement()(); // Unique user ID
  TextColumn get name => text().withLength(min: 0, max: 32)(); // User's name
  TextColumn get deviceID => text()(); // Unique device identifier
  TextColumn get photoPath => text()(); // User photo path
}

/// Represents financial profiles (personal/business).
/// Each profile is tied to a specific currency.
class DriftProfiles extends Table {
  IntColumn get id => integer().autoIncrement()(); // Unique profile ID
  TextColumn get name => text().withLength(min: 0, max: 32)(); // Profile name
  TextColumn get alias =>
      text().withLength(min: 0, max: 32).nullable()(); // Alternative name
  TextColumn get address =>
      text().withLength(min: 0, max: 512).nullable()(); // Address
  TextColumn get zip =>
      text().withLength(min: 4, max: 9).nullable()(); // ZIP code
  TextColumn get email =>
      text().withLength(min: 0, max: 32).nullable()(); // Contact email
  TextColumn get phone =>
      text().withLength(min: 0, max: 15).nullable()(); // Contact phone
  TextColumn get tin =>
      text().withLength(min: 0, max: 24).nullable()(); // Taxpayer ID
  BoolColumn get isSelected => boolean()
      .withDefault(const Constant(false))(); // Whether this profile is active
  IntColumn get currency => intEnum<Currency>()(); // Currency type
  TextColumn get globalID => text()
      .nullable()
      .clientDefault(() => const Uuid().v4())(); // Unique profile identifier
  BoolColumn get isLocal => boolean()
      .withDefault(const Constant(true))(); // Whether the profile is local
  DateTimeColumn get addedDate =>
      dateTime().clientDefault(() => DateTime.now())(); // Creation date
  DateTimeColumn get updateDate =>
      dateTime().clientDefault(() => DateTime.now())(); // Last update date
}

/// Defines types of accounts (e.g., liabilities, loans).
class DriftAccTypes extends Table {
  IntColumn get id => integer().autoIncrement()(); // Unique type ID
  TextColumn get name => text().withLength(min: 0, max: 32)(); // Type name
  IntColumn get primary => intEnum<PrimaryType>()(); // Primary classification
  DateTimeColumn get addedDate =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updateDate =>
      dateTime().clientDefault(() => DateTime.now())();
  BoolColumn get isEditable => boolean()
      .withDefault(const Constant(true))(); // Whether the type is modifiable
}

/// Represents financial accounts (e.g., cash, bank, loan).
class DriftAccounts extends Table {
  IntColumn get id => integer().autoIncrement()(); // Unique account ID
  TextColumn get name => text().withLength(min: 0, max: 32)(); // Account name
  IntColumn get openBal =>
      integer().withDefault(const Constant(0))(); // Opening balance
  DateTimeColumn get openDate =>
      dateTime().clientDefault(() => DateTime.now())(); // Account opening date
  IntColumn get accType => integer().references(DriftAccTypes, #id,
      onDelete: KeyAction.cascade)(); // Account type reference
  DateTimeColumn get addedDate =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updateDate =>
      dateTime().clientDefault(() => DateTime.now())();
  BoolColumn get isEditable => boolean().withDefault(const Constant(true))();
  IntColumn get profile => integer().references(DriftProfiles, #id,
      onDelete: KeyAction.cascade)(); // Profile association
}

/// Records financial transactions between accounts.
class DriftTransactions extends Table {
  IntColumn get id => integer().autoIncrement()(); // Unique transaction ID
  DateTimeColumn get vchDate => dateTime()(); // Transaction date
  TextColumn get narr =>
      text().withLength(min: 0, max: 128)(); // Transaction description
  TextColumn get refNo =>
      text().withLength(min: 0, max: 32)(); // Reference number
  IntColumn get vchType => intEnum<VoucherType>()(); // Voucher type
  @ReferenceName('drAccount')
  IntColumn get dr => integer().references(DriftAccounts, #id,
      onDelete: KeyAction.cascade)(); // Debit account
  @ReferenceName('crAccount')
  IntColumn get cr => integer().references(DriftAccounts, #id,
      onDelete: KeyAction.cascade)(); // Credit account
  IntColumn get amount =>
      integer().withDefault(const Constant(0))(); // Transaction amount
  IntColumn get profile => integer().references(DriftProfiles, #id,
      onDelete: KeyAction.cascade)(); // Profile association
  IntColumn get project => integer()
      .nullable()
      .references(DriftProjects, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get addedDate =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updateDate =>
      dateTime().clientDefault(() => DateTime.now())();
}

/// Stores bank-related details for an account.
class DriftBanks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get account => integer().references(DriftAccounts, #id,
      onDelete: KeyAction.cascade)(); // Related account
  TextColumn get holderName =>
      text().withLength(min: 0, max: 32).nullable()(); // Account holder name
  TextColumn get institution =>
      text().withLength(min: 0, max: 32).nullable()(); // Bank name
  TextColumn get branch =>
      text().withLength(min: 0, max: 32).nullable()(); // Branch name
  TextColumn get branchCode =>
      text().withLength(min: 0, max: 32).nullable()(); // Branch code
  TextColumn get accountNo =>
      text().withLength(min: 0, max: 32).nullable()(); // Account number
}

/// Represents digital wallets linked to accounts.
class DriftWallets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get account =>
      integer().references(DriftAccounts, #id, onDelete: KeyAction.cascade)();
}

/// Stores information about loans linked to accounts.
class DriftLoans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get account =>
      integer().references(DriftAccounts, #id, onDelete: KeyAction.cascade)();
  TextColumn get institution =>
      text().withLength(min: 0, max: 32).nullable()(); // Loan provider
  RealColumn get interestRate => real().nullable()(); // Interest rate
  DateTimeColumn get startDate =>
      dateTime().clientDefault(() => DateTime.now()).nullable()();
  DateTimeColumn get endDate =>
      dateTime().clientDefault(() => DateTime.now()).nullable()();
  TextColumn get agreementNo =>
      text().withLength(min: 0, max: 32).nullable()(); // Agreement number
  TextColumn get accountNo =>
      text().withLength(min: 0, max: 32).nullable()(); // Account number
}

/// Stores details of credit cards linked to accounts.
class DriftCCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get account =>
      integer().references(DriftAccounts, #id, onDelete: KeyAction.cascade)();
  TextColumn get institution =>
      text().withLength(min: 0, max: 32).nullable()(); // Card issuer
  IntColumn get statementDate =>
      integer().withDefault(const Constant(1)).nullable()(); // Statement date
  TextColumn get cardNo =>
      text().withLength(min: 0, max: 32).nullable()(); // Card number
  TextColumn get cardNetwork =>
      text().withLength(min: 0, max: 32).nullable()(); // Visa, Mastercard, etc.
}

/// Stores balance snapshots for accounts.
class DriftBalances extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get account =>
      integer().references(DriftAccounts, #id, onDelete: KeyAction.cascade)();
  IntColumn get amount => integer().withDefault(const Constant(0))();
}

/// Stores budgets for accounts.
class DriftBudgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name =>
      text().withLength(min: 0, max: 128)(); // Unique name for budget
  IntColumn get interval =>
      intEnum<BudgetInterval>()(); // The interval for the budget
  TextColumn get details => text().withLength(min: 0, max: 128)();
  IntColumn get startDay => integer().withDefault(const Constant(
      1))(); // The day the budget resets in a cycle. 23rd on a month, 6th day of the week etc.
  DateTimeColumn get startDate => dateTime().clientDefault(
      () => DateTime.now())(); // When the budget is supposed to go active
  IntColumn get profile => integer().references(DriftProfiles, #id,
      onDelete: KeyAction.cascade)(); // Linked profile
  DateTimeColumn get addedDate =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updateDate =>
      dateTime().clientDefault(() => DateTime.now())();
}

/// Stores funds tracked in a budget.
class DriftBudgetFunds extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get account =>
      integer().references(DriftAccounts, #id, onDelete: KeyAction.cascade)();
  IntColumn get budget =>
      integer().references(DriftBudgets, #id, onDelete: KeyAction.cascade)();
}

/// Stores expenses tracked in a budget.
class DriftBudgetAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get account =>
      integer().references(DriftAccounts, #id, onDelete: KeyAction.cascade)();
  IntColumn get budget =>
      integer().references(DriftBudgets, #id, onDelete: KeyAction.cascade)();
  IntColumn get amount => integer().withDefault(const Constant(0))();
}

/// Project that has asssociated transactions.
class DriftProjects extends Table {
  IntColumn get id => integer().autoIncrement()(); // Unique project ID
  TextColumn get name => text().withLength(min: 1, max: 128)(); // Project name
  TextColumn get description => text().nullable()(); // Project description
  DateTimeColumn get startDate => dateTime().nullable()(); // Start date
  IntColumn get profile => integer().references(DriftProfiles, #id,
      onDelete: KeyAction.cascade)(); // Profile association
  DateTimeColumn get endDate => dateTime().nullable()(); // End date
  IntColumn get status => intEnum<ProjectStatus>()();
  IntColumn get budget => integer().nullable().references(DriftBudgets, #id,
      onDelete: KeyAction.setNull)(); // Linked budget
  DateTimeColumn get addedDate =>
      dateTime().clientDefault(() => DateTime.now())(); // Date added
  DateTimeColumn get updateDate =>
      dateTime().clientDefault(() => DateTime.now())(); // Last update date
}

// Advances receivable back to the user
class DriftReceivables extends Table {
  IntColumn get id => integer().autoIncrement()(); // dbID
  IntColumn get accountId =>
      integer().references(DriftAccounts, #id, onDelete: KeyAction.cascade)();
  IntColumn get totalAmount => integer().nullable()();
  DateTimeColumn get paidDate => dateTime().nullable()();
}

// People. You know.
class DriftPeople extends Table {
  IntColumn get id => integer().autoIncrement()(); // dbID
  IntColumn get accountId =>
      integer().references(DriftAccounts, #id, onDelete: KeyAction.cascade)();
  TextColumn get address => text().nullable()();
  TextColumn get zip => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get tin => text().nullable()();
}

// Reminder for one time and recurring payments
class DriftPaymentReminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  @ReferenceName('account')
  IntColumn get account => integer()
      .nullable()
      .references(DriftAccounts, #id, onDelete: KeyAction.cascade)();
  @ReferenceName('fund')
  IntColumn get fund => integer()
      .nullable()
      .references(DriftAccounts, #id, onDelete: KeyAction.setNull)();
  IntColumn get profile => integer().references(DriftProfiles, #id,
      onDelete: KeyAction.cascade)(); // Profile association
  TextColumn get details => text()();
  IntColumn get interval => intEnum<BudgetInterval>()
      .nullable()(); // The interval for the subscription
  IntColumn get day => integer().withDefault(const Constant(1))();
  IntColumn get amount => integer().withDefault(const Constant(0))();
  DateTimeColumn get paymentDate => dateTime().nullable()();
  DateTimeColumn get addedDate =>
      dateTime().clientDefault(() => DateTime.now())(); // Date added
  DateTimeColumn get updateDate =>
      dateTime().clientDefault(() => DateTime.now())(); // Last update date
  IntColumn get status => intEnum<PaymentStatus>()();
}

class DriftFilePaths extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tableType => intEnum<DBTableType>()();
  IntColumn get parentTable => integer()();
  TextColumn get path => text().withLength(min: 0, max: 512)(); // File path
}

