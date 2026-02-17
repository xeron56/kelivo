import 'package:flutter/material.dart';
import 'package:finance_tracker/core/enums/voucher_type.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';
import 'package:finance_tracker/viewmodels/dashboard_viewmodel.dart';
import 'package:finance_tracker/widgets/shared/transaction_options_dialog.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';

class AddTransactionButtonGroup extends StatelessWidget {
  const AddTransactionButtonGroup({
    super.key,
    required this.appViewmodel,
    required this.profile,
    required this.viewmodel,
    this.isWide = false,
  });
  final AppViewmodel appViewmodel;
  final Profile profile;
  final DashboardViewmodel viewmodel;
  final bool isWide;
  @override
  Widget build(BuildContext context) {
    final double buttonRadius = isWide ? 24 : 12;
    // Compact height settings
    const double totalHeight = 90;
    const double buttonHeight = 45;
    const double centerCircleSize = 40;
    const double iconSize = 24;

    return Center(
      child: SizedBox(
        height: totalHeight,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: InkWell(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(buttonRadius),
                ),
                onTap: () async {
                  await showDialog(
                    context: context,
                    useRootNavigator: false,
                    builder: (context) => TransactionOptionsDialog(
                      currency: profile.currency,
                      ledgers: viewmodel.allLedgers,
                      profile: profile,
                      appViewmodel: appViewmodel,
                      vType: VoucherType.receipt,
                      reloadFn: () async {
                        await viewmodel.init();
                      },
                    ),
                  );
                },
                child: Container(
                  height: buttonHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: appViewmodel.receiptColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(buttonRadius),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)?.receipt ?? 'Receipt',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(buttonRadius),
                ),
                onTap: () async {
                  await showDialog(
                    context: context,
                    useRootNavigator: false,
                    builder: (context) => TransactionOptionsDialog(
                      currency: profile.currency,
                      ledgers: viewmodel.allLedgers,
                      profile: profile,
                      appViewmodel: appViewmodel,
                      vType: VoucherType.payment,
                      reloadFn: () async {
                        await viewmodel.init();
                      },
                    ),
                  );
                },
                child: Container(
                  height: buttonHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: appViewmodel.paymentColor,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(buttonRadius),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)?.payment ?? 'Payment',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // White Hole (Center Text Area) -> Scaled down
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: centerCircleSize,
                height: centerCircleSize,
                margin: const EdgeInsets.only(left: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(centerCircleSize / 2),
                  color: Theme.of(context).primaryColor.withOpacity(0.4),
                ),
                child: const Center(
                  child: Icon(Icons.add, size: iconSize, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
