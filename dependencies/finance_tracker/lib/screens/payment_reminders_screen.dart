import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/core/enums/loading_status.dart';
import 'package:finance_tracker/core/enums/voucher_type.dart';
import 'package:finance_tracker/core/models/domain/payment_reminder.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/core/repositories/drift/payment_reminders_drift_repository.dart';
import 'package:finance_tracker/screens/payment_reminder_entry_screen.dart';
import 'package:finance_tracker/screens/transaction_entry_screen.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';
import 'package:finance_tracker/viewmodels/payment_reminders_viewmodel.dart';
import 'package:finance_tracker/widgets/shared/empty_list.dart';
import 'package:finance_tracker/widgets/shared/image_carousel.dart';
import 'package:finance_tracker/widgets/shared/loading_body.dart';
import 'package:finance_tracker/widgets/shared/search_field.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/widgets/shared/the_divider.dart';

class PaymentRemindersScreen extends StatelessWidget {
  const PaymentRemindersScreen({super.key, required this.profile});
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final paymentRemindersDriftRepository =
        Provider.of<PaymentRemindersDriftRepository>(context, listen: false);

    return ChangeNotifierProvider<PaymentRemindersViewmodel>(
      create: (context) => PaymentRemindersViewmodel(
        paymentRemindersDriftRepository,
        profile: profile,
      )..init(),
      builder: (context, child) => Consumer<PaymentRemindersViewmodel>(
        builder: (context, viewmodel, child) => Scaffold(
          backgroundColor: const Color(0xFFF7F8FC),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            actions: const [SizedBox.shrink()],
          ),
          body: LoadingBody(
            loadingStatus: viewmodel.loadingStatus,
            errorText: viewmodel.errorText,
            resetErrorTextFn: () {
              viewmodel.resetErrorText();
            },
            widget: LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 800;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1480),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: isWide,
                            child: SizedBox(
                              width: 320,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 18),
                                child: SingleChildScrollView(
                                  child: _buildFilterPanel(
                                    context,
                                    viewmodel,
                                    child: Column(
                                      spacing: 8,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: createFilterMenu(
                                        viewmodel,
                                        context,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: PaymentRemindersList(
                              viewmodel: viewmodel,
                              isWide: isWide,
                              profile: profile,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PaymentReminderEntryScreen(profile: profile),
                ),
              ).then((_) {
                viewmodel.init();
              });
            },
            heroTag: "addPaymentReminder",
            child: const Icon(Icons.add),
          ),
          endDrawer: Drawer(
            backgroundColor: const Color(0xFFF7F8FC),
            shape: const RoundedRectangleBorder(),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildFilterPanel(
                  context,
                  viewmodel,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: createFilterMenu(viewmodel, context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentRemindersList extends StatelessWidget {
  const PaymentRemindersList({
    super.key,
    required this.viewmodel,
    required this.isWide,
    required this.profile,
  });

  final PaymentRemindersViewmodel viewmodel;
  final bool isWide;
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final appViewmodel = Provider.of<AppViewmodel>(context);
    final colorScheme = Theme.of(context).colorScheme;

    final ebStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(0, 52),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isWide ? 1080 : smallWidth),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFE7EAF2)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x120C2340),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
                decoration: const BoxDecoration(
                  color: Color(0xFFFDFDFF),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.myPaymentReminders,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${viewmodel.fPaymentReminders.length} active reminders tracked for ${profile.name}.',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: const Color(0xFF6F7692),
                                      height: 1.4,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (!isWide)
                          Container(
                            margin: const EdgeInsets.only(left: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F4FA),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Scaffold.of(context).openEndDrawer();
                              },
                              icon: const Icon(Icons.tune_rounded),
                              tooltip: AppLocalizations.of(context)!.filters,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8FC),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFE6EAF3)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SearchField(
                              initValue: viewmodel.searchTerm,
                              searchFn: (term) {
                                viewmodel.searchTerm = term;
                              },
                            ),
                          ),
                          if (isWide) ...[
                            const SizedBox(width: 12),
                            _SummaryChip(
                              icon: Icons.notifications_active_outlined,
                              label:
                                  '${viewmodel.fPaymentReminders.length} reminders',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE8ECF4)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                  child: Visibility(
                    visible: viewmodel.fPaymentReminders.isEmpty,
                    child: EmptyList(
                      items: AppLocalizations.of(context)!.reminders,
                      addFn: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentReminderEntryScreen(
                              profile: viewmodel.profile,
                            ),
                          ),
                        ).then((_) {
                          viewmodel.init();
                        });
                      },
                      isListFiltered:
                          viewmodel.paymentReminders.isNotEmpty ||
                          (viewmodel.paymentReminders.isNotEmpty &&
                              viewmodel.fPaymentReminders.length ==
                                  viewmodel.paymentReminders.length),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Visibility(
                  visible: viewmodel.fPaymentReminders.isNotEmpty,
                  child: Builder(
                    builder: (_) {
                      if (viewmodel.searchLoadingStatus ==
                          LoadingStatus.completed) {
                        return ListView.separated(
                              itemCount: viewmodel.fPaymentReminders.length,
                              padding: const EdgeInsets.fromLTRB(
                                18,
                                18,
                                18,
                                90,
                              ),
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 14),
                              itemBuilder: (context, index) {
                                final p = viewmodel.fPaymentReminders[index];

                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(24),
                                    onTap: () {
                                      showReminderDialog(
                                        context,
                                        p,
                                        appViewmodel,
                                        ebStyle,
                                      );
                                    },
                                    child: Ink(
                                      padding: const EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFDFDFF),
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: const Color(0xFFE7EAF2),
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x0A0C2340),
                                            blurRadius: 18,
                                            offset: Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 52,
                                                height: 52,
                                                decoration: BoxDecoration(
                                                  color: colorScheme.primary
                                                      .withAlpha(22),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Icon(
                                                  Icons.alarm_rounded,
                                                  color: colorScheme.primary,
                                                ),
                                              ),
                                              const SizedBox(width: 14),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      p.details,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Wrap(
                                                      spacing: 8,
                                                      runSpacing: 8,
                                                      children: [
                                                        _InfoPill(
                                                          icon: Icons
                                                              .schedule_rounded,
                                                          label:
                                                              p.paymentDate !=
                                                                      null
                                                                  ? appViewmodel
                                                                      .dateFormat
                                                                      .format(
                                                                        p.paymentDate!,
                                                                      )
                                                                  : 'No date',
                                                        ),
                                                        _InfoPill(
                                                          icon: Icons
                                                              .repeat_rounded,
                                                          label:
                                                              p.interval?.label ??
                                                              AppLocalizations.of(
                                                                context,
                                                              )!
                                                                  .oneTime,
                                                        ),
                                                        _StatusPill(
                                                          label: p
                                                              .paymentStatus
                                                              .label,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    p.amount
                                                        .toCurrencyStringWSymbol(
                                                          profile.currency,
                                                        ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    'Tap for details',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium
                                                        ?.copyWith(
                                                          color: const Color(
                                                            0xFF7D849E,
                                                          ),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          if (p.fund != null ||
                                              p.account != null) ...[
                                            const SizedBox(height: 16),
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF5F7FC),
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              child: Wrap(
                                                spacing: 8,
                                                runSpacing: 8,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  if (p.fund != null)
                                                    _LinkPill(
                                                      label: p.fund!.name,
                                                    ),
                                                  if (p.fund != null &&
                                                      p.account != null)
                                                    const Icon(
                                                      Icons.arrow_right_alt,
                                                      size: 18,
                                                      color: Color(0xFF8991AA),
                                                    ),
                                                  if (p.account != null)
                                                    _LinkPill(
                                                      label: p.account!.name,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          .animate(delay: 100.ms)
                          .scale(
                            begin: const Offset(1.02, 1.02),
                            duration: 100.ms,
                          )
                          .fade(curve: Curves.easeInOut, duration: 100.ms);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showReminderDialog(
    BuildContext context,
    PaymentReminder p,
    AppViewmodel appViewmodel,
    ButtonStyle ebStyle,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: smallWidth),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FD),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.withAlpha(20)),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withAlpha(22),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.notifications_active_rounded,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  textAlign: TextAlign.start,
                                  p.details,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _StatusPill(label: p.paymentStatus.label),
                                    _InfoPill(
                                      icon: Icons.repeat_rounded,
                                      label:
                                          p.interval?.label ??
                                          AppLocalizations.of(
                                            context,
                                          )!
                                              .oneTime,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          p.amount.toCurrencyStringWSymbol(profile.currency),
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F8FC),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFE7EAF2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Schedule',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: const Color(0xFF737A94),
                                      ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _InfoPill(
                                      icon: Icons.event_rounded,
                                      label: p.paymentDate != null
                                          ? appViewmodel.dateFormat.format(
                                              p.paymentDate!,
                                            )
                                          : 'No date selected',
                                    ),
                                    if (p.fund != null)
                                      _LinkPill(label: p.fund!.name),
                                    if (p.account != null)
                                      _LinkPill(label: p.account!.name),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          if (p.filePaths.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: ImageCarousel(
                                filePaths: p.filePaths,
                                maxHeight: 300,
                              ),
                            ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ebStyle,
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransactionEntryScreen(
                                    profile: profile,
                                    selectedAccount: p.account,
                                    selectedFund: p.fund,
                                    voucherType: VoucherType.payment,
                                    amount: p.amount,
                                  ),
                                ),
                              ).then((_) {
                                viewmodel.init();
                              });
                            },
                            child: Text(AppLocalizations.of(context)!.pay),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ebStyle.copyWith(
                              backgroundColor: WidgetStatePropertyAll(
                                const Color(0xFFEFF2F8),
                              ),
                              foregroundColor: const WidgetStatePropertyAll(
                                Color(0xFF1E2438),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PaymentReminderEntryScreen(
                                        profile: profile,
                                        paymentReminder: p,
                                      ),
                                ),
                              ).then((_) {
                                viewmodel.init();
                              });
                            },
                            icon: const Icon(Icons.edit),
                            label: Text(AppLocalizations.of(context)!.edit),
                          ),
                        ),
                        const SizedBox(width: 4),
                        ElevatedButton(
                          style: ebStyle.copyWith(
                            backgroundColor: const WidgetStatePropertyAll(
                              Color(0xFFFFEFEF),
                            ),
                            foregroundColor: const WidgetStatePropertyAll(
                              Color(0xFFB42318),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      final hasDeleted = await viewmodel
                                          .deleteReminder(p.dbID);

                                      if (hasDeleted && context.mounted) {
                                        viewmodel.init();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.delete,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.cancel,
                                    ),
                                  ),
                                ],
                                title: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.deleteThisReminderQn,
                                ),
                              ),
                            );
                          },
                          child: const Icon(Icons.delete_outline_rounded),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

List<Widget> createFilterMenu(
  PaymentRemindersViewmodel viewmodel,
  BuildContext context,
) {
  return [
    Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              AppLocalizations.of(context)!.filters,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        if (viewmodel.statusFilters.isNotEmpty)
          TextButton(
            onPressed: () {
              for (final status in List.of(viewmodel.statusFilters)) {
                viewmodel.addToFilter(status: status);
              }
            },
            child: const Text('Clear'),
          ),
      ],
    ),
    Text(
      'Refine reminders by payment status.',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: const Color(0xFF737A94),
      ),
    ),
    const SizedBox(height: 18),
    Visibility(
      visible: viewmodel.paymentReminders.isNotEmpty,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FD),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE7EAF2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.status,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Expanded(child: TheDivider()),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...viewmodel.statusCriterias.toList().map(
                  (v) => FilterChip(
                    selected: !viewmodel.statusFilters.contains(v),
                    label: Text(v.label),
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    backgroundColor: Colors.white,
                    selectedColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withAlpha(18),
                    side: BorderSide(
                      color: viewmodel.statusFilters.contains(v)
                          ? const Color(0xFFD6DBE8)
                          : Theme.of(context).colorScheme.primary.withAlpha(60),
                    ),
                    onSelected: (s) {
                      viewmodel.addToFilter(status: v);
                    },
                  ),
                ),
              ],
            )
                .animate(delay: 50.ms)
                .scale(begin: const Offset(1.02, 1.02), duration: 100.ms)
                .fade(curve: Curves.easeInOut, duration: 100.ms),
          ],
        ),
      ),
    ),
    const SizedBox(height: 24),
  ];
}

Widget _buildFilterPanel(
  BuildContext context,
  PaymentRemindersViewmodel viewmodel, {
  required Widget child,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: const Color(0xFFE7EAF2)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0D0C2340),
          blurRadius: 18,
          offset: Offset(0, 10),
        ),
      ],
    ),
    child: child,
  );
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E5F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2E7F1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF6D7590)),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: const Color(0xFF47506A)),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _LinkPill extends StatelessWidget {
  const _LinkPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: const Color(0xFF3E4761),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
