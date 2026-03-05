import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:path/path.dart' as p;

// Finance imports
import 'package:finance_tracker/core/db/app_drift_database.dart';
import 'package:finance_tracker/core/repositories/drift/account_types_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/accounts_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/balances_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/banks_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/budgets_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/ccards_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/database_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/file_paths_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/loans_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/payment_reminders_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/people_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/profiles_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/projects_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/receivables_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/transactions_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/user_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/wallets_drift_repository.dart';
import 'package:finance_tracker/providers/theme_provider.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';
import 'package:finance_tracker/utils/app_paths.dart';
import 'package:finance_tracker/utils/services/notification_service.dart'
    as fn_notify;
import 'package:finance_tracker/utils/app_logger.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:finance_tracker/main.dart' as fn_main;
import '../../features/home/services/finance_context_service.dart';

class FinanceIntegration {
  static Future<List<SingleChildWidget>> init() async {
    AppLogger.instance.info("Finance Tracker initializing (Integrated)");

    await AppPaths.init();

    // Note: fn_main.requestNotificationPermission() logic might be needed if not handled by main app
    // For now we assume main app handles basic permissions or we skip explicitly requesting here to avoid double prompts at startup

    tz.initializeTimeZones();

    await fn_notify.NotificationService.init((String? payload) {
      if (payload != null) {
        fn_main.financeNavigatorKey.currentState
            ?.pushNamed(payload)
            .then((_) {});
      }
    });

    final dbPath = await _getDatabasePath();
    final isolate = await DriftIsolate.spawn(
      () => _backgroundConnection(dbPath),
    );
    final connection = await isolate.connect();

    // We can also initialize ThemeProvider if needed, but we might only need it within the finance submodule widgets
    final themeProvider = ThemeProvider();
    await themeProvider.init();

    return [
      Provider<AppDriftDatabase>(
        create: (context) => AppDriftDatabase(connection, "b"),
        dispose: (context, db) => db.close(),
      ),
      Provider<DatabaseDriftRepository>(
        create: (context) =>
            DatabaseDriftRepository(context.read<AppDriftDatabase>()),
      ),
      Provider<ProfilesDriftRepository>(
        create: (context) =>
            ProfilesDriftRepository(context.read<AppDriftDatabase>()),
      ),
      Provider<AccountTypesDriftRepository>(
        create: (context) =>
            AccountTypesDriftRepository(context.read<AppDriftDatabase>()),
      ),
      Provider<AccountsDriftRepository>(
        create: (context) =>
            AccountsDriftRepository(context.read<AppDriftDatabase>()),
      ),
      ChangeNotifierProvider<AppViewmodel>(
        create: (context) => AppViewmodel(
          context.read<ProfilesDriftRepository>(),
          context.read<DatabaseDriftRepository>(),
          context.read<AccountsDriftRepository>(), // Add AccountsRepository
        )..init(),
      ),
      Provider<BalancesDriftRepository>(
        create: (context) =>
            BalancesDriftRepository(context.read<AppDriftDatabase>()),
      ),
      Provider<BanksDriftRepository>(
        create: (context) =>
            BanksDriftRepository(context.read<AppDriftDatabase>()),
      ),
      Provider<BudgetsDriftRepository>(
        create: (context) =>
            BudgetsDriftRepository(context.read<AppDriftDatabase>()),
      ),
      Provider<CCardsDriftRepository>(
        create: (context) =>
            CCardsDriftRepository(context.read<AppDriftDatabase>()),
      ),
      Provider<LoansDriftRepository>(
        create: (context) =>
            LoansDriftRepository(context.read<AppDriftDatabase>()),
      ),
      Provider<PeopleDriftRepository>(
        create: (context) =>
            PeopleDriftRepository(context.read<AppDriftDatabase>()),
      ),
      Provider<ReceivablesDriftRepository>(
        create: (context) =>
            ReceivablesDriftRepository(context.read<AppDriftDatabase>()),
      ),
      Provider<WalletsDriftRepository>(
        create: (context) =>
            WalletsDriftRepository(context.read<AppDriftDatabase>()),
      ),
      Provider<TransactionsDriftRepository>(
        create: (context) =>
            TransactionsDriftRepository(context.read<AppDriftDatabase>()),
      ),
      Provider<ProjectsDriftRepository>(
        create: (context) =>
            ProjectsDriftRepository(context.read<AppDriftDatabase>()),
      ),
      Provider<PaymentRemindersDriftRepository>(
        create: (context) =>
            PaymentRemindersDriftRepository(context.read<AppDriftDatabase>()),
      ),
      Provider<FilePathsDriftRepository>(
        create: (context) =>
            FilePathsDriftRepository(context.read<AppDriftDatabase>()),
      ),
      Provider<UserDriftRepository>(
        create: (context) =>
            UserDriftRepository(context.read<AppDriftDatabase>()),
      ),
      ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
      Provider<FinanceContextService>(
        create: (context) => FinanceContextService(
          transactionsRepository: context.read<TransactionsDriftRepository>(),
          balancesRepository: context.read<BalancesDriftRepository>(),
          accountsRepository: context.read<AccountsDriftRepository>(),
          appViewmodel: context.read<AppViewmodel>(),
        ),
      ),
    ];
  }

  static Future<String> _getDatabasePath() async {
    final appDir = await getApplicationSupportDirectory();
    final dbPath = p.join(appDir.path, 'db', 'app_drift_database.sqlite');
    // Ensure directory exists
    final dbDir = Directory(p.dirname(dbPath));
    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }
    return dbPath;
  }

  static DatabaseConnection _backgroundConnection(String path) {
    final database = NativeDatabase(File(path));
    return DatabaseConnection(database);
  }
}
