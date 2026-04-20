import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/app/global/values.dart';
import 'package:finance_tracker/screens/about_us_screen.dart';
import 'package:finance_tracker/screens/profile_entry_screen.dart';
import 'package:finance_tracker/screens/settings_screen.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';
import 'package:finance_tracker/viewmodels/main_viewmodel.dart';
import 'package:finance_tracker/widgets/shared/the_divider.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class TheDrawer extends StatelessWidget {
  const TheDrawer({super.key, required this.viewmodel});
  final MainViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final Color primary = Theme.of(context).colorScheme.primary;
    return Drawer(
      backgroundColor: const Color(0xFFFDFDFE),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                decoration: BoxDecoration(
                  color: primary.withAlpha(12),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Finance workspace',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF161C2D),
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            loc?.profile ?? 'Profile',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: const Color(0xFF667085)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Consumer<MainViewmodel>(
                      builder: (context, viewmodel, child) => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFE9ECF5)),
                        ),
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            childrenPadding: const EdgeInsets.fromLTRB(
                              12,
                              0,
                              12,
                              12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            trailing: CircleAvatar(
                              backgroundColor: primary,
                              child: Text(
                                viewmodel.selectedProfile.currency.symbol,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              viewmodel.selectedProfile.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF161C2D),
                                  ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _InfoPill(
                                    icon: Icons.payments_outlined,
                                    text:
                                        loc?.cashAccounts(
                                          viewmodel.cashCountinProfile,
                                        ) ??
                                        'Cash ${viewmodel.cashCountinProfile}',
                                  ),
                                  _InfoPill(
                                    icon: Icons.account_balance_outlined,
                                    text:
                                        loc?.bankAccounts(
                                          viewmodel.bankCountinProfile,
                                        ) ??
                                        'Bank ${viewmodel.bankCountinProfile}',
                                  ),
                                ],
                              ),
                            ),
                            children: [
                              _DrawerActionTile(
                                label:
                                    loc?.editThisProfile ?? 'Edit This Profile',
                                icon: Icons.edit_outlined,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileEntryScreen(
                                        profile: viewmodel.selectedProfile,
                                      ),
                                    ),
                                  ).then((_) async {
                                    await viewmodel.setLastUpdatedTimeStamp();
                                    await viewmodel.init();
                                  });
                                },
                              ),
                              _DrawerActionTile(
                                label: loc?.newProfile ?? 'New Profile',
                                icon: Icons.add_circle_outline,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileEntryScreen(),
                                    ),
                                  ).then((_) async {
                                    await viewmodel.setLastUpdatedTimeStamp();
                                    await viewmodel.init();
                                  });
                                },
                              ),
                              _DrawerActionTile(
                                label: loc?.allProfiles ?? 'All Profiles',
                                icon: Icons.people_outline_rounded,
                                onTap: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) => SimpleDialog(
                                      title: Text(
                                        loc?.myProfiles ?? 'My Profiles',
                                      ),
                                      children: [
                                        ...viewmodel.profiles.map(
                                          (p) => ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: primary,
                                              child: Text(
                                                p.currency.symbol,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              p.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            onTap: () {
                                              viewmodel.selectedProfile = p;
                                              viewmodel.setIndex(0);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ).then((_) async {
                                    await viewmodel.setLastUpdatedTimeStamp();
                                    await viewmodel.init();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Preferences',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: const Color(0xFF98A2B3),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Builder(
                      builder: (context) {
                        final AdaptiveThemeManager<ThemeData> adaptiveTheme =
                            AdaptiveTheme.of(context);
                        final AppViewmodel appViewmodel =
                            Provider.of<AppViewmodel>(context);
                        if (appViewmodel.isSystemDefaultTheme) {
                          return const SizedBox.shrink();
                        }
                        return _DrawerSection(
                          child: ValueListenableBuilder(
                            valueListenable: AdaptiveTheme.of(
                              context,
                            ).modeChangeNotifier,
                            builder: (_, mode, child) => _DrawerActionTile(
                              label:
                                  AppLocalizations.of(context)?.toggleTheme ??
                                  'Toggle Theme',
                              icon: mode == AdaptiveThemeMode.dark
                                  ? Icons.dark_mode_outlined
                                  : Icons.light_mode_outlined,
                              trailing: Text(
                                mode == AdaptiveThemeMode.dark
                                    ? 'Dark'
                                    : 'Light',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: const Color(0xFF667085),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              onTap: () async {
                                await AdaptiveTheme.getThemeMode() ==
                                        AdaptiveThemeMode.light
                                    ? adaptiveTheme.setDark()
                                    : await AdaptiveTheme.getThemeMode() ==
                                          AdaptiveThemeMode.dark
                                    ? adaptiveTheme.setLight()
                                    : adaptiveTheme.setDark();
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'App',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: const Color(0xFF98A2B3),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _DrawerSection(
                      child: Column(
                        children: [
                          _DrawerActionTile(
                            label: loc?.settings ?? 'Settings',
                            icon: Icons.settings_outlined,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(),
                                ),
                              );
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: TheDivider(),
                          ),
                          _DrawerActionTile(
                            label: loc?.aboutUs ?? 'About Us',
                            icon: Icons.info_outline,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AboutUsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE9ECF5)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          final url = Uri.parse(gitHubURL);
                          if (!await launchUrl(url)) {
                            throw Exception('Could not launch $url');
                          }
                        },
                        child: Text(
                          'GitHub',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: const Color(0xFF475467),
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: const Color(0xFFE4E7EC),
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          final url = Uri.parse(supportURL);
                          if (!await launchUrl(url)) {
                            throw Exception('Could not launch $url');
                          }
                        },
                        child: Text(
                          loc?.supportUs ?? 'Support Us',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerSection extends StatelessWidget {
  const _DrawerSection({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9ECF5)),
      ),
      child: child,
    );
  }
}

class _DrawerActionTile extends StatelessWidget {
  const _DrawerActionTile({
    required this.label,
    required this.icon,
    required this.onTap,
    this.trailing,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Icon(icon, color: const Color(0xFF667085)),
        title: Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: const Color(0xFF1D2939),
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing:
            trailing ??
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF98A2B3)),
        onTap: onTap,
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF667085)),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF475467),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
