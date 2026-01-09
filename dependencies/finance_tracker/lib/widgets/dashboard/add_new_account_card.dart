import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/core/models/domain/account_type.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/screens/account_entry_screen.dart';
import 'package:finance_tracker/viewmodels/dashboard_viewmodel.dart';
import 'package:finance_tracker/widgets/shared/acc_type_icon.dart';
import 'package:finance_tracker/widgets/shared/the_divider.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';

class AddNewAccountCard extends StatelessWidget {
  const AddNewAccountCard({super.key, required this.viewmodel});
  final DashboardViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: cardWidth),
      child:
          Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            const Expanded(child: TheDivider()),
                            Text(
                              AppLocalizations.of(context)!.addAccount,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Expanded(child: TheDivider()),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...viewmodel.fAccountTypes.map(
                        (a) => _createAddNewAccountBtn(
                          context,
                          viewmodel.selectedProfile,
                          a.name,
                          a,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              )
              .animate(delay: 200.ms)
              .scale(begin: const Offset(1.02, 1.02), duration: 100.ms)
              .fade(curve: Curves.easeInOut, duration: 100.ms),
    );
  }

  Padding _createAddNewAccountBtn(
    BuildContext context,
    Profile profile,
    String label,
    AccountType accountType,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      child: SizedBox(
        width: double.maxFinite,
        height: 42,
        child: FilledButton.tonal(
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.secondaryContainer,
            foregroundColor: colorScheme.onSecondaryContainer,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => AccountEntryScreen(
                      profile: profile,
                      accountType: accountType,
                    ),
                  ),
                )
                .then((_) {
                  viewmodel.init();
                });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Icon(
                getAccTypeIcon(accountType.dbID),
                size: 18,
                color: colorScheme.onSecondaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
