import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/app/global/values.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/core/enums/app_date_format.dart';
import 'package:finance_tracker/core/enums/loading_status.dart';
import 'package:finance_tracker/core/enums/voucher_type.dart';
import 'package:finance_tracker/core/models/domain/account.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/core/models/domain/project.dart';
import 'package:finance_tracker/core/models/domain/transaction.dart';
import 'package:finance_tracker/core/repositories/drift/account_types_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/accounts_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/balances_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/file_paths_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/projects_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/transactions_drift_repository.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';
import 'package:finance_tracker/viewmodels/transaction_entry_viewmodel.dart';
import 'package:finance_tracker/widgets/shared/acc_type_dialog.dart';
import 'package:finance_tracker/widgets/shared/accounts_search_dialog.dart';
import 'package:finance_tracker/widgets/shared/calculated_field.dart';
import 'package:finance_tracker/widgets/shared/images_selector.dart';
import 'package:finance_tracker/widgets/shared/loading_body.dart';
import 'package:finance_tracker/widgets/shared/the_date_picker.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';

class TransactionEntryScreen extends StatelessWidget {
  const TransactionEntryScreen({
    super.key,
    this.transaction,
    required this.profile,
    this.selectedFund,
    this.selectedAccount,
    this.voucherType,
    this.dupeTransaction,
    this.amount = 0,
  });
  final Transaction? transaction;
  final Profile profile;
  final Account? selectedFund;
  final Account? selectedAccount;
  final VoucherType? voucherType;
  final Transaction? dupeTransaction;
  final int amount;

  @override
  Widget build(BuildContext context) {
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
    final projectsDriftRepository = Provider.of<ProjectsDriftRepository>(
      context,
      listen: false,
    );
    final filePathsDriftRepository = Provider.of<FilePathsDriftRepository>(
      context,
      listen: false,
    );

    return ChangeNotifierProvider<TransactionEntryViewmodel>(
      create: (context) => TransactionEntryViewmodel(
        accountsDriftRepository,
        transactionsDriftRepository,
        balancesDriftRepository,
        accountTypesDriftRepository,
        projectsDriftRepository,
        filePathsDriftRepository,
        transaction: transaction,
        profile: profile,
        selectedAccount: selectedAccount,
        selectedFund: selectedFund,
        vchType: voucherType,
        dupeTransaction: dupeTransaction,
        amount: amount,
      )..init(),
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<TransactionEntryViewmodel>(
            builder: (context, viewmodel, child) => Text(
              "${transaction != null
                  ? AppLocalizations.of(context)!.edit
                  : dupeTransaction != null
                  ? AppLocalizations.of(context)!.copy
                  : AppLocalizations.of(context)!.add} ${AppLocalizations.of(context)!.transactionNo(viewmodel.vchNo.toString())}",
            ),
          ),
        ),
        body: Consumer<TransactionEntryViewmodel>(
          builder: (context, viewmodel, child) {
            return LoadingBody(
              errorText: viewmodel.errorText,
              loadingStatus: viewmodel.loadingStatus,
              resetErrorTextFn: () {
                viewmodel.resetErrorText();
              },
              widget: TransactionForm(
                transaction: transaction,
                profile: profile,
                viewmodel: viewmodel,
                autoFocusAmount:
                    (voucherType != null &&
                    selectedAccount != null &&
                    selectedFund != null),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TransactionForm extends StatelessWidget {
  const TransactionForm({
    super.key,
    required this.transaction,
    required this.viewmodel,
    this.autoFocusAmount = false,
    required this.profile,
  });

  final Transaction? transaction;
  final TransactionEntryViewmodel viewmodel;
  final bool autoFocusAmount;
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final appViewmodel = Provider.of<AppViewmodel>(context);
    InputDecorationTheme mainInputsTheme = InputDecorationTheme(
      fillColor: Theme.of(context).cardColor.withValues(alpha: .7),
      filled: true,
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      floatingLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(width: 0),
      ),
    );
    const animationDuration = Duration(milliseconds: 500);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: animationDuration,
                  curve: Curves.fastOutSlowIn,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: viewmodel.isPayment
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      end: viewmodel.isPayment
                          ? Alignment.bottomLeft
                          : Alignment.bottomRight,
                      colors: viewmodel.isPayment
                          ? [
                              appViewmodel.paymentColor.withValues(alpha: 0.5),
                              appViewmodel.paymentColor.withValues(alpha: 0.1),
                              Colors.transparent,
                            ]
                          : [
                              appViewmodel.receiptColor.withValues(alpha: 0.5),
                              appViewmodel.receiptColor.withValues(alpha: 0.1),
                              Colors.transparent,
                            ],
                      stops: const [0, 0.5, 1],
                    ),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: smallWidth,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          inputDecorationTheme: mainInputsTheme,
                          dropdownMenuTheme: DropdownMenuThemeData(
                            inputDecorationTheme: mainInputsTheme,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: SizedBox(
                                height: 50,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          viewmodel.isPayment = false;
                                        },
                                        child: Center(
                                          child: AnimatedContainer(
                                            duration: animationDuration,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                    bottomLeft: Radius.circular(
                                                      14,
                                                    ),
                                                    topLeft: Radius.circular(
                                                      14,
                                                    ),
                                                  ),
                                              gradient: viewmodel.isPayment
                                                  ? null
                                                  : LinearGradient(
                                                      colors: [
                                                        Theme.of(context)
                                                            .scaffoldBackgroundColor
                                                            .withValues(
                                                              alpha: .5,
                                                            ),
                                                        Theme.of(context)
                                                            .scaffoldBackgroundColor
                                                            .withValues(
                                                              alpha: 0,
                                                            ),
                                                      ],
                                                    ),
                                            ),
                                            child: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.receipt,
                                              style: viewmodel.isPayment
                                                  ? Theme.of(
                                                      context,
                                                    ).textTheme.bodyMedium
                                                  : Theme.of(context)
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Switch(
                                      value: viewmodel.isPayment,
                                      onChanged: (value) {
                                        viewmodel.isPayment = value;
                                      },

                                      thumbColor:
                                          WidgetStateProperty.resolveWith<
                                            Color
                                          >((Set<WidgetState> states) {
                                            if (states.containsAll([
                                              WidgetState.disabled,
                                              WidgetState.selected,
                                            ])) {
                                              return appViewmodel.receiptColor;
                                            }

                                            if (states.contains(
                                              WidgetState.disabled,
                                            )) {
                                              return Theme.of(
                                                context,
                                              ).primaryColor;
                                            }

                                            if (states.contains(
                                              WidgetState.selected,
                                            )) {
                                              return appViewmodel.paymentColor;
                                            }

                                            return appViewmodel.receiptColor;
                                          }),
                                      thumbIcon:
                                          WidgetStateProperty.resolveWith<Icon>(
                                            (Set<WidgetState> states) {
                                              if (states.containsAll([
                                                WidgetState.disabled,
                                                WidgetState.selected,
                                              ])) {
                                                return Icon(
                                                  Icons.circle,
                                                  color:
                                                      appViewmodel.receiptColor,
                                                );
                                              }

                                              if (states.contains(
                                                WidgetState.disabled,
                                              )) {
                                                return Icon(
                                                  Icons.circle,
                                                  color: Theme.of(
                                                    context,
                                                  ).primaryColor,
                                                );
                                              }

                                              if (states.contains(
                                                WidgetState.selected,
                                              )) {
                                                return Icon(
                                                  Icons.circle,
                                                  color:
                                                      appViewmodel.paymentColor,
                                                );
                                              }

                                              return Icon(
                                                Icons.circle,
                                                color:
                                                    appViewmodel.receiptColor,
                                              );
                                            },
                                          ),
                                      trackOutlineColor:
                                          WidgetStateProperty.resolveWith<
                                            Color
                                          >((Set<WidgetState> states) {
                                            if (states.containsAll([
                                              WidgetState.disabled,
                                              WidgetState.selected,
                                            ])) {
                                              return appViewmodel.receiptColor;
                                            }

                                            if (states.contains(
                                              WidgetState.disabled,
                                            )) {
                                              return Theme.of(
                                                context,
                                              ).primaryColor;
                                            }

                                            if (states.contains(
                                              WidgetState.selected,
                                            )) {
                                              return appViewmodel.paymentColor;
                                            }

                                            return appViewmodel.receiptColor;
                                          }),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        child: Center(
                                          child: AnimatedContainer(
                                            duration: animationDuration,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(14),
                                                    topRight: Radius.circular(
                                                      14,
                                                    ),
                                                  ),
                                              gradient: !viewmodel.isPayment
                                                  ? null
                                                  : LinearGradient(
                                                      colors: [
                                                        Theme.of(
                                                          context,
                                                        ).cardColor.withValues(
                                                          alpha: 0,
                                                        ),
                                                        Theme.of(context)
                                                            .scaffoldBackgroundColor
                                                            .withValues(
                                                              alpha: .5,
                                                            ),
                                                      ],
                                                    ),
                                            ),
                                            child: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.payment,
                                              textAlign: TextAlign.center,
                                              style: !viewmodel.isPayment
                                                  ? Theme.of(
                                                      context,
                                                    ).textTheme.bodyMedium
                                                  : Theme.of(context)
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          viewmodel.isPayment = true;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AccountsSearchDialog(
                                                    ledgers: viewmodel.funds,
                                                    currency: profile.currency,
                                                  ),
                                            ).then((f) {
                                              if (f != null &&
                                                  f.runtimeType == Account) {
                                                viewmodel.selectedFund = f;
                                              }
                                            });
                                          },
                                          child: InputDecorator(
                                            decoration: InputDecoration(
                                              errorText:
                                                  viewmodel
                                                      .selectedFundError
                                                      .isNotEmpty
                                                  ? viewmodel.selectedFundError
                                                  : null,
                                              label: Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.fund,
                                              ),
                                              labelStyle: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(
                                                  context,
                                                ).hintColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const SizedBox(width: 14),
                                                Expanded(
                                                  child: Text(
                                                    viewmodel
                                                            .selectedFund
                                                            ?.name ??
                                                        AppLocalizations.of(
                                                          context,
                                                        )!.select(
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.fund,
                                                        ),
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.bodyLarge,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.arrow_drop_down,
                                                ),
                                                const SizedBox(width: 14),
                                                InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AccountTypeDialog(
                                                            profile: profile,
                                                            initFn: () {
                                                              viewmodel
                                                                  .getAccounts();
                                                            },
                                                            accountTypes: viewmodel
                                                                .accountTypes
                                                                .where((a) {
                                                                  return fundingAccountIDs
                                                                      .contains(
                                                                        a.dbID,
                                                                      );
                                                                })
                                                                .toList(),
                                                          ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(
                                                        context,
                                                      ).primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .animate()
                                .scale(
                                  begin: const Offset(1.02, 1.02),
                                  duration: 100.ms,
                                )
                                .fade(
                                  curve: Curves.easeInOut,
                                  duration: 100.ms,
                                ),
                            Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  child: TheDatePicker(
                                    initialDate: viewmodel.vchDate,
                                    onChanged: (d) {
                                      viewmodel.vchDate = d;
                                    },
                                    label: AppLocalizations.of(
                                      context,
                                    )!.transactionDate,
                                    errorText: viewmodel.vchDateError.isNotEmpty
                                        ? viewmodel.vchDateError
                                        : null,
                                    firstDate: viewmodel.startDate,
                                    lastDate: DateTime.now(),
                                    datePattern:
                                        appViewmodel.dateFormat.pattern ??
                                        AppDateFormat.date1.pattern,
                                  ),
                                )
                                .animate(delay: 20.ms)
                                .scale(
                                  begin: const Offset(1.02, 1.02),
                                  duration: 100.ms,
                                )
                                .fade(
                                  curve: Curves.easeInOut,
                                  duration: 100.ms,
                                ),
                            Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AccountsSearchDialog(
                                                    ledgers:
                                                        viewmodel.fAccounts,
                                                    currency: profile.currency,
                                                  ),
                                            ).then((f) {
                                              if (f != null &&
                                                  f.runtimeType == Account) {
                                                viewmodel.selectedAccount = f;
                                              }
                                            });
                                          },
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: InputDecorator(
                                              decoration: InputDecoration(
                                                errorText:
                                                    viewmodel
                                                        .selectedAccountError
                                                        .isNotEmpty
                                                    ? viewmodel
                                                          .selectedAccountError
                                                    : null,
                                                label: Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.account,
                                                ),
                                                labelStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(
                                                    context,
                                                  ).hintColor,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const SizedBox(width: 14),
                                                  Expanded(
                                                    child: Text(
                                                      viewmodel
                                                              .selectedAccount
                                                              ?.name ??
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.select(
                                                            AppLocalizations.of(
                                                              context,
                                                            )!.account,
                                                          ),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.copyWith(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.arrow_drop_down,
                                                  ),
                                                  const SizedBox(width: 14),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AccountTypeDialog(
                                                              profile: profile,
                                                              initFn: () {
                                                                viewmodel
                                                                    .getAccounts();
                                                              },
                                                              accountTypes:
                                                                  viewmodel
                                                                      .accountTypes,
                                                            ),
                                                      );
                                                    },
                                                    child: MouseRegion(
                                                      cursor: SystemMouseCursors
                                                          .click,
                                                      child: Container(
                                                        width: 40,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                          color: Theme.of(
                                                            context,
                                                          ).primaryColor,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: const Center(
                                                          child: Icon(
                                                            Icons.add,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .animate(delay: 40.ms)
                                .scale(
                                  begin: const Offset(1.02, 1.02),
                                  duration: 100.ms,
                                )
                                .fade(
                                  curve: Curves.easeInOut,
                                  duration: 100.ms,
                                ),
                            Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  child: CalculatedField(
                                    currency: profile.currency,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontSize: 20),
                                    onChanged: (value) {
                                      viewmodel.amount =
                                          value?.toIntCurrency() ?? 0;
                                    },
                                    amount: viewmodel.amount.toCurrency(),
                                    label: AppLocalizations.of(context)!.amount,
                                    errorText: viewmodel.amountError.isNotEmpty
                                        ? viewmodel.amountError
                                        : null,
                                    autoFocus: autoFocusAmount,
                                  ),
                                )
                                .animate(delay: 60.ms)
                                .scale(
                                  begin: const Offset(1.02, 1.02),
                                  duration: 100.ms,
                                )
                                .fade(
                                  curve: Curves.easeInOut,
                                  duration: 100.ms,
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: smallWidth,
                    child: Column(
                      children: [
                        Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: ImagesSelector(
                                addPathFn: (path) {
                                  viewmodel.addImage(path);
                                },
                                deletePathFn: (path) {
                                  viewmodel.removeImage(path);
                                },
                                paths: viewmodel.images,
                              ),
                            )
                            .animate(delay: 80.ms)
                            .scale(
                              begin: const Offset(1.02, 1.02),
                              duration: 100.ms,
                            )
                            .fade(curve: Curves.easeInOut, duration: 100.ms),
                        Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: TextFormField(
                                maxLines: 3,
                                maxLength: 128,
                                initialValue:
                                    transaction?.narration ?? viewmodel.narr,
                                onChanged: (value) => viewmodel.narr = value,
                                decoration: InputDecoration(
                                  counterText: '',
                                  errorText: viewmodel.narrError.isNotEmpty
                                      ? viewmodel.narrError
                                      : null,
                                  labelText: AppLocalizations.of(
                                    context,
                                  )!.narration,
                                ),
                              ),
                            )
                            .animate(delay: 100.ms)
                            .scale(
                              begin: const Offset(1.02, 1.02),
                              duration: 100.ms,
                            )
                            .fade(curve: Curves.easeInOut, duration: 100.ms),
                        Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: TextFormField(
                                maxLength: 32,
                                initialValue:
                                    transaction?.refNo ?? viewmodel.refNo,
                                onChanged: (value) => viewmodel.refNo = value,
                                decoration: InputDecoration(
                                  counterText: '',
                                  errorText: viewmodel.narrError.isNotEmpty
                                      ? viewmodel.narrError
                                      : null,
                                  labelText: AppLocalizations.of(
                                    context,
                                  )!.referenceNo,
                                ),
                              ),
                            )
                            .animate(delay: 120.ms)
                            .scale(
                              begin: const Offset(1.02, 1.02),
                              duration: 100.ms,
                            )
                            .fade(curve: Curves.easeInOut, duration: 100.ms),
                        Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: DropdownMenu<Project>(
                                width: smallWidth,
                                enableSearch: false,
                                label: Text(
                                  AppLocalizations.of(context)!.project,
                                ),
                                initialSelection: viewmodel.selectedProject,
                                dropdownMenuEntries: [
                                  ...viewmodel.projects.map(
                                    (p) => DropdownMenuEntry<Project>(
                                      value: p,
                                      label: p.name,
                                      trailingIcon: Text(p.status.label),
                                    ),
                                  ),
                                ],
                                onSelected: (p) {
                                  viewmodel.selectedProject = p;
                                },
                              ),
                            )
                            .animate(delay: 120.ms)
                            .scale(
                              begin: const Offset(1.02, 1.02),
                              duration: 100.ms,
                            )
                            .fade(curve: Curves.easeInOut, duration: 100.ms),
                      ],
                    ),
                  ),
                ),
                // Bulk sample entries insert button for debug version.
                if (!kReleaseMode)
                  IconButton(
                    onPressed: () async {
                      final exps = viewmodel.fAccounts
                          .where((a) => a.account.accountType == expenseTypeID)
                          .toList();
                      final incs = viewmodel.fAccounts
                          .where((a) => a.account.accountType == incomeTypeID)
                          .toList();
                      const noOfTransactionsToInsert = 10000;
                      const maxNoOfDaysBack = 800;

                      for (var i = 0; i < noOfTransactionsToInsert; i++) {
                        viewmodel.isPayment = !viewmodel.isPayment;
                        viewmodel.selectedFund = viewmodel.funds
                            .map((l) => l.account)
                            .toList()[Random().nextInt(viewmodel.funds.length)];

                        viewmodel.selectedAccount = viewmodel.isPayment
                            ? exps.map((l) => l.account).toList()[Random()
                                  .nextInt(exps.length)]
                            : incs.map((l) => l.account).toList()[Random()
                                  .nextInt(incs.length)];

                        viewmodel.amount =
                            (Random().nextInt(1000) + 500) * 1000;
                        viewmodel.vchDate = DateTime.now().subtract(
                          Duration(days: Random().nextInt(maxNoOfDaysBack)),
                        );

                        viewmodel.narr =
                            "${viewmodel.selectedFund?.name} ${viewmodel.selectedAccount?.name}";

                        await viewmodel.save();
                        await viewmodel.init();
                      }
                    },
                    icon: const Icon(Icons.run_circle_outlined),
                  ),
              ],
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: smallWidth,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (viewmodel.loadingStatus != LoadingStatus.submitting) {
                    bool isSaved = await viewmodel.save();
                    if (isSaved && context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: viewmodel.loadingStatus == LoadingStatus.submitting
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text(
                        AppLocalizations.of(context)!.save,
                        style: const TextStyle(fontSize: 22),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
