import 'dart:io' show File, Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/widgets/emoji_text.dart';
import '../l10n/app_localizations.dart';
import '../core/providers/user_provider.dart';
import '../core/providers/settings_provider.dart';
import 'user_profile_dialog.dart';
import '../icons/lucide_adapter.dart' as lucide;
import '../utils/sandbox_path_resolver.dart';

/// A compact left rail for desktop with avatar, primary actions, and bottom system toggles.
class DesktopNavRail extends StatelessWidget {
  const DesktopNavRail({
    super.key,
    required this.activeIndex,
    required this.onTapHome,
    required this.onTapChat,
    required this.onTapTranslate,
    required this.onTapStorage,
    required this.onTapFocus,
    required this.onTapLive,
    required this.onTapSettings,
    required this.onTapFinance,
    required this.onTapFinanceAssistant,
  });

  final int
  activeIndex; // -1=Home,0=Chat,1=Translate,2=Storage,3=Focus,4=Live,5=Settings,6=Finance,7=Finance Assistant
  final VoidCallback onTapHome;
  final VoidCallback onTapChat;
  final VoidCallback onTapTranslate;
  final VoidCallback onTapStorage;
  final VoidCallback onTapFocus;
  final VoidCallback onTapLive;
  final VoidCallback onTapSettings;
  final VoidCallback onTapFinance;
  final VoidCallback onTapFinanceAssistant;

  static const double width = 64.0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isMac = Platform.isMacOS;
    final double topGap = isMac ? 36.0 : 8.0;
    final isHomeActive = activeIndex == -1;
    final isChatActive = activeIndex == 0;
    final isTranslateActive = activeIndex == 1;
    final isStorageActive = activeIndex == 2;
    final isFocusActive = activeIndex == 3;
    final isLiveActive = activeIndex == 4;
    final isSettingsActive = activeIndex == 5;
    final isFinanceActive = activeIndex == 6;
    final isFinanceAssistantActive = activeIndex == 7;

    return Container(
      width: width,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          SizedBox(height: topGap),
          _UserAvatarButton(),
          const SizedBox(height: 12),
          _CircleAction(
            tooltip: 'Home',
            icon: lucide.Lucide.Home,
            onTap: onTapHome,
            size: 40,
            iconSize: 18,
            iconColor: isHomeActive ? cs.primary : null,
          ),
          const SizedBox(height: 8),
          _CircleAction(
            tooltip: l10n.desktopNavChatTooltip,
            icon: lucide.Lucide.MessageCircle,
            onTap: onTapChat,
            size: 40,
            iconSize: 18,
            iconColor: isChatActive ? cs.primary : null,
          ),
          const SizedBox(height: 8),
          _CircleAction(
            tooltip: l10n.desktopNavTranslateTooltip,
            icon: lucide.Lucide.Languages,
            onTap: onTapTranslate,
            size: 40,
            iconSize: 18,
            iconColor: isTranslateActive ? cs.primary : null,
          ),
          const SizedBox(height: 8),
          _CircleAction(
            tooltip: l10n.desktopNavStorageTooltip,
            icon: lucide.Lucide.Folder,
            onTap: onTapStorage,
            size: 40,
            iconSize: 18,
            iconColor: isStorageActive ? cs.primary : null,
          ),
          const SizedBox(height: 8),
          _CircleAction(
            tooltip: 'Focus',
            icon: lucide.Lucide.checkCheck,
            onTap: onTapFocus,
            size: 40,
            iconSize: 18,
            iconColor: isFocusActive ? cs.primary : null,
          ),
          const SizedBox(height: 8),
          _CircleAction(
            tooltip: 'Live Voice',
            icon: lucide.Lucide.AudioWaveform,
            onTap: onTapLive,
            size: 40,
            iconSize: 18,
            iconColor: isLiveActive ? cs.primary : null,
          ),
          const SizedBox(height: 8),
          _CircleAction(
            tooltip: "Finance Tracker",
            icon: lucide.Lucide.Wallet,
            onTap: onTapFinance,
            size: 40,
            iconSize: 18,
            iconColor: isFinanceActive ? cs.primary : null,
          ),
          const SizedBox(height: 8),
          _CircleAction(
            tooltip: "Finance Assistant",
            icon: lucide.Lucide.Bot,
            onTap: onTapFinanceAssistant,
            size: 40,
            iconSize: 18,
            iconColor: isFinanceAssistantActive ? cs.primary : null,
          ),
          const Spacer(),
          _ThemeCycleButton(),
          const SizedBox(height: 8),
          _CircleAction(
            tooltip: l10n.desktopNavSettingsTooltip,
            icon: lucide.Lucide.Settings,
            onTap: onTapSettings,
            size: 40,
            iconSize: 18,
            iconColor: isSettingsActive ? cs.primary : null,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _UserAvatarButton extends StatefulWidget {
  @override
  State<_UserAvatarButton> createState() => _UserAvatarButtonState();
}

class _UserAvatarButtonState extends State<_UserAvatarButton> {
  @override
  Widget build(BuildContext context) {
    final up = context.watch<UserProvider>();
    final cs = Theme.of(context).colorScheme;
    Widget avatar;
    final type = up.avatarType;
    final value = up.avatarValue;
    if (type == 'emoji' && value != null && value.isNotEmpty) {
      avatar = Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: cs.primary.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: EmojiText(value, fontSize: 18, optimizeEmojiAlign: true),
      );
    } else if (type == 'url' && value != null && value.isNotEmpty) {
      avatar = ClipOval(
        child: Image.network(
          value,
          width: 36,
          height: 36,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return _initialAvatar(up.name, cs);
          },
        ),
      );
    } else if (type == 'file' && value != null && value.isNotEmpty) {
      // Local file path (gracefully handle missing files from imported backups)
      final fixed = SandboxPathResolver.fix(value);
      final f = File(fixed);
      if (f.existsSync()) {
        avatar = ClipOval(
          child: Image(
            image: FileImage(f),
            width: 36,
            height: 36,
            fit: BoxFit.cover,
          ),
        );
      } else {
        avatar = _initialAvatar(up.name, cs);
      }
    } else {
      avatar = _initialAvatar(up.name, cs);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () {
          // Open centered profile dialog
          showUserProfileDialog(context);
        },
        onSecondaryTap: () {
          // Also open dialog on right-click for consistency
          showUserProfileDialog(context);
        },
        child: _HoverCircle(child: avatar, size: 42),
      ),
    );
  }

  Widget _initialAvatar(String name, ColorScheme cs) {
    final letter = name.isNotEmpty ? name.characters.first : '?';
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          color: cs.primary,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.none,
          fontSize: 36 * 0.44, // keep initial scaled to avatar size
        ),
      ),
    );
  }

  // Context menu moved into the centered dialog (avatar tap opens menu there).
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.size = 44,
    this.iconSize = 20,
    this.iconColor,
  });
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final double size;
  final double iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: onTap,
        child: _HoverCircle(
          size: size,
          child: Icon(
            icon,
            size: iconSize,
            color: (iconColor ?? cs.onSurface.withOpacity(0.8)),
          ),
        ),
      ),
    );
  }
}

class _HoverCircle extends StatefulWidget {
  const _HoverCircle({required this.child, this.size = 44});
  final Widget child;
  final double size;
  @override
  State<_HoverCircle> createState() => _HoverCircleState();
}

class _HoverCircleState extends State<_HoverCircle> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: _hovered ? cs.primary.withOpacity(0.10) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}

class _ThemeCycleButton extends StatefulWidget {
  @override
  State<_ThemeCycleButton> createState() => _ThemeCycleButtonState();
}

class _ThemeCycleButtonState extends State<_ThemeCycleButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SettingsProvider>();
    final cs = Theme.of(context).colorScheme;
    final icon = _iconFor(sp.themeMode);
    final l10n = AppLocalizations.of(context)!;
    return Tooltip(
      message: l10n.desktopNavThemeToggleTooltip,
      waitDuration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: () => _cycleTheme(context),
        child: _HoverCircle(
          size: 40,
          child: Icon(icon, size: 20, color: cs.onSurface.withOpacity(0.8)),
        ),
      ),
    );
  }

  IconData _iconFor(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return lucide.Lucide.Sun;
      case ThemeMode.dark:
        return lucide.Lucide.Moon;
      case ThemeMode.system:
      default:
        return lucide.Lucide.Monitor;
    }
  }

  void _cycleTheme(BuildContext context) {
    final sp = context.read<SettingsProvider>();
    final current = sp.themeMode;
    final next = () {
      switch (current) {
        case ThemeMode.system:
          return ThemeMode.light;
        case ThemeMode.light:
          return ThemeMode.dark;
        case ThemeMode.dark:
          return ThemeMode.system;
      }
    }();
    sp.setThemeMode(next);
  }
}
