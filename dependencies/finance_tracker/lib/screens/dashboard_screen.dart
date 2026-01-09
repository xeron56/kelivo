import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/core/repositories/drift/account_types_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/accounts_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/balances_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/profiles_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/transactions_drift_repository.dart';
import 'package:finance_tracker/screens/accounts_screen.dart';
import 'package:finance_tracker/screens/budgets_screen.dart';
import 'package:finance_tracker/screens/payment_reminders_screen.dart';
import 'package:finance_tracker/screens/projects_screen.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';
import 'package:finance_tracker/viewmodels/dashboard_viewmodel.dart';
import 'package:finance_tracker/widgets/dashboard/add_new_account_card.dart';
import 'package:finance_tracker/widgets/dashboard/add_transaction_card.dart';
import 'package:finance_tracker/widgets/dashboard/my_balance_card.dart';
import 'package:finance_tracker/widgets/dashboard/transactions_card.dart';
import 'package:finance_tracker/widgets/dashboard/nav_button1.dart';
import 'package:finance_tracker/widgets/shared/loading_body.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.profile});
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final profilesDriftRepository = Provider.of<ProfilesDriftRepository>(
      context,
      listen: false,
    );
    final accountsDriftRepository = Provider.of<AccountsDriftRepository>(
      context,
      listen: false,
    );
    final transactionsDriftRepository =
        Provider.of<TransactionsDriftRepository>(context, listen: false);
    final balancesDriftRepository = Provider.of<BalancesDriftRepository>(
      context,
      listen: false,
    );
    final accountTypesDriftRepository =
        Provider.of<AccountTypesDriftRepository>(context, listen: false);

    final appViewmodel = Provider.of<AppViewmodel>(context);
    return ChangeNotifierProvider<DashboardViewmodel>(
      create: (context) => DashboardViewmodel(
        profilesDriftRepository,
        accountsDriftRepository,
        transactionsDriftRepository,
        balancesDriftRepository,
        accountTypesDriftRepository,
        profile: profile,
      )..init(),
      builder: (context, child) => Consumer<DashboardViewmodel>(
        builder: (context, viewmodel, child) => LayoutBuilder(
          builder: (context, constraints) {
            final isVeryWide = constraints.maxWidth > cardWidth * 2;
            return Scaffold(
              body: LoadingBody(
                loadingStatus: viewmodel.loadingStatus,
                errorText: viewmodel.errorText,
                widget: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.myDashboard,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: MyBalanceCard(
                              profile: profile,
                              viewmodel: viewmodel,
                              isWide: isVeryWide,
                            ),
                          ),
                          if (viewmodel.canAddTransaction && !isVeryWide)
                            Center(
                              child: AddTransactionCard(
                                appViewmodel: appViewmodel,
                                profile: profile,
                                viewmodel: viewmodel,
                              ),
                            ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              "Quick Actions",
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                // Calculate item width for a responsive grid look using Wrap
                                // On wide screens, we might want 4 items in a row.
                                // On narrow, maybe 2 items per row.
                                final width = constraints.maxWidth;
                                final itemWidth = width / (width > 600 ? 4 : 2);

                                return Wrap(
                                  alignment: WrapAlignment.start,
                                  runSpacing: 0,
                                  spacing: 0,
                                  children: [
                                    SizedBox(
                                      width: itemWidth,
                                      height: 50,
                                      child: NavButton1(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BudgetsScreen(
                                                    profile: viewmodel
                                                        .selectedProfile,
                                                  ),
                                            ),
                                          );
                                        },
                                        title: AppLocalizations.of(
                                          context,
                                        )!.budgets,
                                        icon: Icons.calculate_outlined,
                                      ),
                                    ),
                                    SizedBox(
                                      width: itemWidth,
                                      height: 50,
                                      child: NavButton1(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProjectsScreen(
                                                    profile: viewmodel
                                                        .selectedProfile,
                                                  ),
                                            ),
                                          );
                                        },
                                        title: AppLocalizations.of(
                                          context,
                                        )!.projects,
                                        icon: Icons.assignment_outlined,
                                      ),
                                    ),
                                    SizedBox(
                                      width: itemWidth,
                                      height: 50,
                                      child: NavButton1(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentRemindersScreen(
                                                    profile: profile,
                                                  ),
                                            ),
                                          );
                                        },
                                        title: AppLocalizations.of(
                                          context,
                                        )!.reminders,
                                        icon: Icons.event_available_outlined,
                                      ),
                                    ),
                                    SizedBox(
                                      width: itemWidth,
                                      height: 50,
                                      child: NavButton1(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AccountsScreen(
                                                    profile: viewmodel
                                                        .selectedProfile,
                                                  ),
                                            ),
                                          );
                                        },
                                        title: AppLocalizations.of(
                                          context,
                                        )!.accounts,
                                        icon: Icons
                                            .account_balance_wallet_outlined,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (viewmodel.recentTransactions.isNotEmpty)
                            Center(
                              child: TransactionsCard(viewmodel: viewmodel),
                            ),
                          if (viewmodel.fAccountTypes.isNotEmpty)
                            Center(
                              child: AddNewAccountCard(viewmodel: viewmodel),
                            ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ],
                  ),
                ),
                resetErrorTextFn: () => viewmodel.resetErrorText(),
              ),
            );
          },
        ),
      ),
    );
  }
}
