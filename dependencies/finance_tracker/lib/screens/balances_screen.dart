import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/core/models/domain/account_type.dart';
import 'package:finance_tracker/core/models/domain/ledger.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/core/repositories/drift/account_types_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/accounts_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/banks_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/ccards_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/loans_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/wallets_drift_repository.dart';
import 'package:finance_tracker/screens/account_entry_screen.dart';
import 'package:finance_tracker/screens/balance_account_screen.dart';
import 'package:finance_tracker/viewmodels/balances_viewmodel.dart';
import 'package:finance_tracker/widgets/shared/acc_type_dialog.dart';
import 'package:finance_tracker/widgets/shared/acc_type_icon.dart';
import 'package:finance_tracker/widgets/shared/loading_body.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';

class BalancesScreen extends StatelessWidget {
  const BalancesScreen({super.key, required this.profile});
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final accountTypesDriftRepository =
        Provider.of<AccountTypesDriftRepository>(context, listen: false);
    final accountsDriftRepository = Provider.of<AccountsDriftRepository>(
      context,
      listen: false,
    );
    final banksDriftRepository = Provider.of<BanksDriftRepository>(
      context,
      listen: false,
    );
    final cCardsDriftRepository = Provider.of<CCardsDriftRepository>(
      context,
      listen: false,
    );
    final loansDriftRepository = Provider.of<LoansDriftRepository>(
      context,
      listen: false,
    );
    final walletsDriftRepository = Provider.of<WalletsDriftRepository>(
      context,
      listen: false,
    );

    return ChangeNotifierProvider<BalancesViewmodel>(
      create: (context) => BalancesViewmodel(
        accountsDriftRepository,
        accountTypesDriftRepository,
        banksDriftRepository,
        cCardsDriftRepository,
        loansDriftRepository,
        walletsDriftRepository,
        profile: profile,
      )..init(),
      builder: (context, child) => Consumer<BalancesViewmodel>(
        builder: (context, viewmodel, child) => Scaffold(
          backgroundColor: const Color(0xFFF7F7FA),
          body: LoadingBody(
            resetErrorTextFn: () => viewmodel.resetErrorText(),
            loadingStatus: viewmodel.loadingStatus,
            errorText: viewmodel.errorText,
            widget: LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > smallWidth;
                final isVeryWide = constraints.maxWidth > mediumWidth;

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                  child: Column(
                    crossAxisAlignment: isVeryWide
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      _SurfaceCard(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.myFunds,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppLocalizations.of(context)!.otherAccounts,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withValues(alpha: 0.75),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _BalanceSection(
                        title: AppLocalizations.of(context)!.myFunds,
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            ...viewmodel.fundAccountTypes.map(
                              (a) => FundsCard(
                                accountType: a,
                                profile: profile,
                                viewmodel: viewmodel,
                                width: isWide ? 420 : null,
                                balanceAccounts: viewmodel.funds
                                    .where(
                                      (ac) => ac.account.accountType == a.dbID,
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _BalanceSection(
                        title: AppLocalizations.of(context)!.myCredits,
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: [
                            ...viewmodel.creditAccountTypes.map(
                              (a) => FundsCard(
                                accountType: a,
                                profile: profile,
                                viewmodel: viewmodel,
                                width: isWide ? 420 : null,
                                balanceAccounts: viewmodel.credits
                                    .where(
                                      (ac) => ac.account.accountType == a.dbID,
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _BalanceSection(
                        title: AppLocalizations.of(context)!.otherAccounts,
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: [
                            ...viewmodel.otherAccountAccountTypes.map(
                              (a) => FundsCard(
                                accountType: a,
                                profile: profile,
                                viewmodel: viewmodel,
                                width: isWide ? 420 : null,
                                balanceAccounts: viewmodel.otherAccounts
                                    .where(
                                      (ac) => ac.account.accountType == a.dbID,
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => AccountTypeDialog(
                  profile: profile,
                  accountTypes: viewmodel.balanceAccountTypes,
                  initFn: () {
                    viewmodel.init();
                  },
                ),
              );
            },
            heroTag: "addFund",
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

class FundsCard extends StatelessWidget {
  const FundsCard({
    super.key,
    required this.accountType,
    required this.profile,
    required this.viewmodel,
    required this.balanceAccounts,
    this.width,
  });

  final AccountType accountType;
  final Profile profile;
  final BalancesViewmodel viewmodel;
  final double? width;
  final List<Ledger> balanceAccounts;

  @override
  Widget build(BuildContext context) {
    int balance = viewmodel.getBalanceByAccountType(accountType.dbID);
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: SizedBox(
        width: width,
        child:
            Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(22)),
                    border: Border.all(color: const Color(0xFFE5E8F0)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x120F172A),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(22)),
                    onTap: () {
                      if (balanceAccounts.isEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountEntryScreen(
                              profile: profile,
                              accountType: accountType,
                            ),
                          ),
                        ).then((_) {
                          viewmodel.init();
                        });
                      }
                    },
                    child: ExpansionTile(
                      enabled: balanceAccounts.isNotEmpty,
                      initiallyExpanded: balanceAccounts.isNotEmpty,
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      minTileHeight: 76,
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: .08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          getAccTypeIcon(accountType.dbID),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            accountType.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            balanceAccounts.isEmpty
                                ? AppLocalizations.of(context)!.add
                                : "${balanceAccounts.length} ${AppLocalizations.of(context)!.accounts}",
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color
                                      ?.withValues(alpha: 0.75),
                                ),
                          ),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F7FB),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE6E8EF)),
                        ),
                        child: Text(
                          balance.toCurrencyStringWSymbol(profile.currency),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      children: [
                        ...balanceAccounts.map((f) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBFBFD),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFE8EAF1),
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 2,
                              ),
                              title: Text(
                                f.account.name,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              trailing: Text(
                                f.balance.toCurrencyString(profile.currency),
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              onTap: () async {
                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BalanceAccountScreen(
                                            profile: profile,
                                            account: f.account,
                                          ),
                                    ),
                                  ).then((_) {
                                    viewmodel.init();
                                  });
                                }
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                )
                .animate()
                .scale(begin: const Offset(1.02, 1.02), duration: 100.ms)
                .fade(curve: Curves.easeInOut, duration: 100.ms),
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE6E8EF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _BalanceSection extends StatelessWidget {
  const _BalanceSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
