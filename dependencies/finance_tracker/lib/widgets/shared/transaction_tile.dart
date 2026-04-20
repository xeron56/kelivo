import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/app/global/date_formats.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/core/enums/currency.dart';
import 'package:finance_tracker/core/enums/voucher_type.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';

class TransactionTile extends StatelessWidget {
  /// A list tile for a single transaction : wide screens
  const TransactionTile({
    super.key,
    required this.vchDate,
    required this.accountName,
    required this.amount,
    required this.onClick,
    required this.vchType,
    required this.transactionID,
    this.fundName,
    required this.narr,
    this.isTransfer = false,
    required this.currency,
    this.isColorful = false,
    this.isNegative = false,
  });

  /// Transaction voucher date
  final DateTime vchDate;

  /// Transaction account
  final String accountName;

  /// Transaction amount
  final int amount;

  /// On click callback function
  final Function onClick;

  /// Transaction voucher type
  final VoucherType vchType;

  /// Transaction id
  final int transactionID;

  /// Fund used for transaction
  final String? fundName;

  /// Transaction details text
  final String narr;

  /// Whether fund is a transfer to another fund
  final bool isTransfer;

  /// Whether the tile should show the amount with a negative sign
  final bool isNegative;

  /// Currency from profile
  final Currency currency;

  /// Whether to show different color for elements
  final bool isColorful;

  @override
  Widget build(BuildContext context) {
    final appViewmodel = Provider.of<AppViewmodel>(context);
    final theme = Theme.of(context);
    final amountText =
        "${isTransfer
            ? ""
            : isNegative
            ? "-"
            : "+"} ${amount.toCurrencyString(currency)}";
    final accentColor = (isTransfer) || !isColorful
        ? theme.textTheme.titleMedium?.color ?? Colors.black87
        : isNegative
        ? appViewmodel.paymentColor
        : appViewmodel.receiptColor;
    final descriptor = fundName != null
        ? isTransfer
              ? AppLocalizations.of(context)!.transferFrom(fundName!)
              : vchType == VoucherType.payment
              ? AppLocalizations.of(context)!.paidFrom(fundName!)
              : AppLocalizations.of(context)!.receivedIn(fundName!)
        : "";

    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE6E8EF)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x100F172A),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                onClick();
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: isWide
                    ? Row(
                        children: [
                          _DateBadge(vchDate: vchDate),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      accountName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    _MetaPill(label: "#$transactionID"),
                                    if (descriptor.isNotEmpty)
                                      _MetaPill(label: descriptor),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  narr,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.textTheme.bodySmall?.color
                                        ?.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  appViewmodel.dateFormat.format(vchDate),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.textTheme.bodySmall?.color
                                        ?.withValues(alpha: 0.8),
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accentColor.withValues(alpha: 0.10),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    amountText,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: accentColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DateBadge(vchDate: vchDate),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      accountName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        _MetaPill(label: "#$transactionID"),
                                        if (descriptor.isNotEmpty)
                                          _MetaPill(label: descriptor),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: accentColor.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  amountText,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: accentColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            narr,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            appViewmodel.dateFormat.format(vchDate),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.vchDate});

  final DateTime vchDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E8EF)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            vchDate.day.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Text(
            monthString.format(vchDate),
            style: const TextStyle(fontSize: 11),
          ),
          Text(
            yearString.format(vchDate),
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFD),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE6E8EF)),
      ),
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
