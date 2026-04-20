import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/core/enums/app_date_format.dart';
import 'package:finance_tracker/core/enums/loading_status.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/core/repositories/drift/accounts_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/transactions_drift_repository.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';
import 'package:finance_tracker/viewmodels/transactions_viewmodel.dart';
import 'package:finance_tracker/widgets/shared/empty_list.dart';
import 'package:finance_tracker/widgets/shared/transaction_options_dialog.dart';
import 'package:finance_tracker/widgets/shared/export_button.dart';
import 'package:finance_tracker/widgets/shared/loading_body.dart';
import 'package:finance_tracker/widgets/shared/search_field.dart';
import 'package:finance_tracker/widgets/shared/the_date_picker.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/widgets/shared/transactions_list.dart';
import 'package:finance_tracker/widgets/shared/transactions_list_wide.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key, required this.profile});
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final transactionsDriftRepository =
        Provider.of<TransactionsDriftRepository>(context, listen: false);
    final accountsDriftRepository = Provider.of<AccountsDriftRepository>(
      context,
      listen: false,
    );

    final appViewmodel = Provider.of<AppViewmodel>(context);
    return ChangeNotifierProvider<TransactionsViewmodel>(
      create: (context) => TransactionsViewmodel(
        transactionsDriftRepository,
        accountsDriftRepository,
        profile: profile,
      )..init(),
      builder: (context, child) => Consumer<TransactionsViewmodel>(
        builder: (context, viewmodel, child) => Scaffold(
          backgroundColor: const Color(0xFFF7F7FA),
          body: LoadingBody(
            feedbackText: viewmodel.feedbackText,
            loadingStatus: viewmodel.loadingStatus,
            errorText: viewmodel.errorText,
            resetErrorTextFn: () {
              viewmodel.resetErrorText();
            },
            widget: LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 800;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: isWide,
                        child: SizedBox(
                          width: 320,
                          child: SingleChildScrollView(
                            child: _PanelCard(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                spacing: 8,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: createFilterMenu(
                                  viewmodel,
                                  context,
                                  appViewmodel.dateFormat.pattern ??
                                      AppDateFormat.date1.pattern,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isWide,
                        child: const SizedBox(width: 16),
                      ),
                      Expanded(
                        child: TransactionsSection(
                          viewmodel: viewmodel,
                          isWide: isWide,
                          constraints: constraints,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          endDrawer: Drawer(
            backgroundColor: const Color(0xFFF7F7FA),
            shape: const RoundedRectangleBorder(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _PanelCard(
                padding: const EdgeInsets.all(18),
                child: ListView(
                  shrinkWrap: true,
                  children: createFilterMenu(
                    viewmodel,
                    context,
                    appViewmodel.dateFormat.pattern ??
                        AppDateFormat.date1.pattern,
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              final vm = Provider.of<TransactionsViewmodel>(
                context,
                listen: false,
              );
              showDialog(
                context: context,
                builder: (_) => TransactionOptionsDialog(
                  currency: profile.currency,
                  ledgers: viewmodel.allLedgers,
                  profile: profile,
                  appViewmodel: appViewmodel,
                  reloadFn: () {
                    vm.init();
                  },
                ),
              );
            },
            heroTag: "addAccount",
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

List<Widget> createFilterMenu(
  TransactionsViewmodel viewmodel,
  BuildContext context,
  String datePattern,
) {
  final theme = Theme.of(context);
  final headerDateFormat = DateFormat(datePattern);
  return [
    Text(
      AppLocalizations.of(context)!.filters,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    ),
    Text(
      AppLocalizations.of(context)!.fromToDate(
        headerDateFormat.format(viewmodel.startDate),
        headerDateFormat.format(viewmodel.endDate),
      ),
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.75),
      ),
    ),
    const SizedBox(height: 10),
    _FilterSection(
      title: AppLocalizations.of(context)!.dates,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TheDatePicker(
              initialDate: viewmodel.startDate,
              onChanged: (d) {
                viewmodel.addToFilter(sDate: d);
              },
              label: AppLocalizations.of(context)!.startDate,
              needTime: false,
              datePattern: datePattern,
            ),
          ),
          TheDatePicker(
            initialDate: viewmodel.endDate,
            onChanged: (d) {
              viewmodel.addToFilter(eDate: d);
            },
            label: AppLocalizations.of(context)!.endDate,
            needTime: false,
            datePattern: datePattern,
          ),
        ],
      ),
    ),
    Visibility(
          visible: viewmodel.transactions.isNotEmpty,
          child: _FilterSection(
            title: AppLocalizations.of(context)!.transactionTypes,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...viewmodel.voucherTypes.toList().map(
                  (v) => FilterChip(
                    selected: !viewmodel.voucherTypeFilters.contains(v),
                    label: Text(v.label),
                    showCheckmark: false,
                    selectedColor: theme.primaryColor.withValues(alpha: 0.12),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: theme.dividerColor.withValues(alpha: 0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (s) {
                      viewmodel.addToFilter(voucherType: v);
                    },
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(delay: 50.ms)
        .scale(begin: const Offset(1.02, 1.02), duration: 100.ms)
        .fade(curve: Curves.easeInOut, duration: 100.ms),
    Visibility(
          visible: viewmodel.transactions.isNotEmpty,
          child: _FilterSection(
            title: AppLocalizations.of(context)!.funds,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...viewmodel.fundCriterias.toList().map(
                  (v) => FilterChip(
                    selected: !viewmodel.fundFilters.contains(v.dbID),
                    label: Text(v.name),
                    showCheckmark: false,
                    selectedColor: theme.primaryColor.withValues(alpha: 0.12),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: theme.dividerColor.withValues(alpha: 0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (s) {
                      viewmodel.addToFilter(fAcc: v);
                    },
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(delay: 100.ms)
        .scale(begin: const Offset(1.02, 1.02), duration: 100.ms)
        .fade(curve: Curves.easeInOut, duration: 100.ms),
    Visibility(
          visible: viewmodel.transactions.isNotEmpty,
          child: _FilterSection(
            title: AppLocalizations.of(context)!.accounts,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...viewmodel.otherAccounts.toList().map(
                  (v) => FilterChip(
                    selected: !viewmodel.otherAccountFilters.contains(v.dbID),
                    label: Text(v.name),
                    showCheckmark: false,
                    selectedColor: theme.primaryColor.withValues(alpha: 0.12),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: theme.dividerColor.withValues(alpha: 0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (s) {
                      viewmodel.addToFilter(oAcc: v);
                    },
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(delay: 150.ms)
        .scale(begin: const Offset(1.02, 1.02), duration: 100.ms)
        .fade(curve: Curves.easeInOut, duration: 100.ms),
    const SizedBox(height: 16),
  ];
}

class TransactionsSection extends StatelessWidget {
  const TransactionsSection({
    super.key,
    required this.viewmodel,
    required this.isWide,
    required this.constraints,
  });

  final TransactionsViewmodel viewmodel;
  final bool isWide;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final appViewmodel = Provider.of<AppViewmodel>(context);
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: appViewmodel.isPhone ? smallWidth : double.maxFinite,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _PanelCard(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.myTransactions,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () {
                                if (!isWide) {
                                  Scaffold.of(context).openEndDrawer();
                                }
                              },
                              child: Text(
                                AppLocalizations.of(context)!.fromToDate(
                                  appViewmodel.dateFormat.format(
                                    viewmodel.startDate,
                                  ),
                                  appViewmodel.dateFormat.format(
                                    viewmodel.endDate,
                                  ),
                                ),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withValues(alpha: 0.75),
                                    ),
                              ),
                            ),
                          ],
                        ),
                        ExportButton(
                          pdfExportFn: () async {
                            await viewmodel.exportPDF();
                          },
                          xlsxExportFn: () async {
                            await viewmodel.exportXLSX();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _StatChip(
                          label: AppLocalizations.of(context)!.transactions,
                          value: "${viewmodel.fTransactions.length}",
                        ),
                        _StatChip(
                          label: AppLocalizations.of(context)!.filters,
                          value: [
                            viewmodel.voucherTypeFilters.length,
                            viewmodel.fundFilters.length,
                            viewmodel.otherAccountFilters.length,
                          ].reduce((a, b) => a + b).toString(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: SearchField(
                            initValue: viewmodel.searchTerm,
                            searchFn: (term) {
                              viewmodel.searchTerm = term;
                            },
                          ),
                        ),
                        Visibility(
                          visible: !isWide,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: FilledButton.tonalIcon(
                              onPressed: () {
                                Scaffold.of(context).openEndDrawer();
                              },
                              icon: const Icon(Icons.tune_rounded),
                              label: Text(
                                AppLocalizations.of(context)!.filters,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _PanelCard(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Visibility(
                  visible: viewmodel.fTransactions.isNotEmpty,
                  replacement: EmptyList(
                    items: AppLocalizations.of(context)!.transactions,
                    addFn: () {
                      final vm = Provider.of<TransactionsViewmodel>(
                        context,
                        listen: false,
                      );
                      showDialog(
                        context: context,
                        useRootNavigator: false,
                        builder: (_) => TransactionOptionsDialog(
                          currency: viewmodel.profile.currency,
                          ledgers: viewmodel.allLedgers,
                          profile: viewmodel.profile,
                          appViewmodel: appViewmodel,
                          reloadFn: () {
                            vm.init();
                          },
                        ),
                      );
                    },
                    isListFiltered: true,
                  ),
                  child: Builder(
                    builder: (_) {
                      if (viewmodel.searchLoadingStatus ==
                          LoadingStatus.completed) {
                        if (!appViewmodel.isPhone) {
                          return TransactionsListWide(
                            scrollController: viewmodel.scrollController,
                            fTransactions: viewmodel.fTransactions,
                            profile: viewmodel.profile,
                            initFn: () {
                              viewmodel.init();
                            },
                          );
                        }
                        return TransactionsList(
                          scrollController: viewmodel.scrollController,
                          fDates: viewmodel.fDates,
                          fTransactions: viewmodel.fTransactions,
                          profile: viewmodel.profile,
                          initFn: () {
                            viewmodel.init();
                          },
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelCard extends StatelessWidget {
  const _PanelCard({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE6E8EF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFD),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8EAF1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E8EF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
