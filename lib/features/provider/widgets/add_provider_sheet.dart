// import 'dart:convert';
// import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../shared/widgets/ios_switch.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../icons/lucide_adapter.dart';
// import 'package:file_picker/file_picker.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/services/haptics.dart';
import '../../../shared/widgets/ios_tile_button.dart';

Future<String?> showAddProviderSheet(BuildContext context) async {
  final cs = Theme.of(context).colorScheme;
  return showModalBottomSheet<String?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: cs.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => const _AddProviderSheet(),
  );
}

class _AddProviderSheet extends StatefulWidget {
  const _AddProviderSheet();
  @override
  State<_AddProviderSheet> createState() => _AddProviderSheetState();
}

class _AddProviderSheetState extends State<_AddProviderSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 1, vsync: this);

  @override
  void initState() {
    super.initState();
    _tab.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tab.removeListener(_onTabChanged);
    _tab.dispose();
    super.dispose();
  }

  // Groq
  bool _groqEnabled = true;
  late final TextEditingController _groqName = TextEditingController(
    text: 'Groq',
  );
  late final TextEditingController _groqKey = TextEditingController();
  late final TextEditingController _groqBase = TextEditingController(
    text: 'https://api.groq.com/openai/v1',
  );
  late final TextEditingController _groqPath = TextEditingController(
    text: '/chat/completions',
  );

  Widget _inputRow({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool obscure = false,
    bool enabled = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.8)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: isDark ? Colors.white10 : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cs.outlineVariant.withOpacity(0.4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cs.outlineVariant.withOpacity(0.4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cs.primary.withOpacity(0.5)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _switchRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        IosSwitch(value: value, onChanged: onChanged),
      ],
    );
  }

  Widget _iosCard({required List<Widget> children}) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cs.outlineVariant.withOpacity(isDark ? 0.08 : 0.06),
          width: 0.6,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              if (i > 0)
                Divider(
                  height: 10,
                  thickness: 0.6,
                  color: cs.outlineVariant.withOpacity(0.18),
                ),
              children[i],
            ],
          ],
        ),
      ),
    );
  }

  Widget _groqForm(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _iosCard(
          children: [
            _switchRow(
              label: l10n.addProviderSheetEnabledLabel,
              value: _groqEnabled,
              onChanged: (v) => setState(() => _groqEnabled = v),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _inputRow(label: l10n.addProviderSheetNameLabel, controller: _groqName),
        const SizedBox(height: 10),
        _inputRow(label: 'API Key', controller: _groqKey),
        const SizedBox(height: 10),
        _inputRow(label: 'API Base Url', controller: _groqBase),
        const SizedBox(height: 10),
        _inputRow(
          label: l10n.addProviderSheetApiPathLabel,
          controller: _groqPath,
          hint: '/chat/completions',
        ),
      ],
    );
  }

  Future<void> _onAdd() async {
    final settings = context.read<SettingsProvider>();
    String uniqueKey(String prefix, String display) {
      final existing = context
          .read<SettingsProvider>()
          .providerConfigs
          .keys
          .toSet();
      if (display.toLowerCase() == prefix.toLowerCase()) {
        int i = 1;
        String candidate = '$prefix - $i';
        while (existing.contains(candidate)) {
          i++;
          candidate = '$prefix - $i';
        }
        return candidate;
      }
      String base = '$prefix - $display';
      if (!existing.contains(base)) return base;
      int i = 2;
      String candidate = '$base ($i)';
      while (existing.contains(candidate)) {
        i++;
        candidate = '$base ($i)';
      }
      return candidate;
    }

    // Always Groq
    final rawName = _groqName.text.trim();
    final display = rawName.isEmpty ? 'Groq' : rawName;
    final keyName = uniqueKey('Groq', display);
    final base = _groqBase.text.trim().isEmpty
        ? 'https://api.groq.com/openai/v1'
        : _groqBase.text.trim();

    final cfg = ProviderConfig(
      id: keyName,
      enabled: _groqEnabled,
      name: display,
      apiKey: _groqKey.text.trim(),
      baseUrl: base,
      providerType: ProviderKind.groq,
      chatPath: _groqPath.text.trim().isEmpty
          ? '/chat/completions'
          : _groqPath.text.trim(),
      useResponseApi: false,
      models: const [],
      modelOverrides: const {},
      proxyEnabled: false,
      proxyHost: '',
      proxyPort: '8080',
      proxyUsername: '',
      proxyPassword: '',
      aihubmixAppCodeEnabled: false,
    );
    await settings.setProviderConfig(keyName, cfg);
    final createdKey = keyName;

    // Ensure providers appear in order list at least once
    final order = List<String>.of(
      context.read<SettingsProvider>().providersOrder,
    );
    // Put the newly created provider at the front
    order.remove(createdKey);
    order.insert(0, createdKey);
    await context.read<SettingsProvider>().setProvidersOrder(order);

    if (mounted) Navigator.of(context).pop(createdKey);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          maxChildSize: 0.8,
          minChildSize: 0.5,
          builder: (c, controller) => Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 36,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        l10n.addProviderSheetTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _TactileIconButton(
                          icon: Lucide.X,
                          color: cs.onSurface,
                          size: 22,
                          onTap: () => Navigator.of(context).maybePop(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _SegTabBar(controller: _tab, tabs: const ['Groq']),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    controller: controller,
                    children: [_groqForm(l10n), const SizedBox(height: 20)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: SizedBox(
                  width: double.infinity,
                  child: IosTileButton(
                    icon: Lucide.Plus,
                    label: l10n.addProviderSheetAddButton,
                    backgroundColor: cs.primary,
                    onTap: _onAdd,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Copy of assistant _SegTabBar to ensure consistency
class _SegTabBar extends StatelessWidget {
  const _SegTabBar({required this.controller, required this.tabs});
  final TabController controller;
  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    const double outerHeight = 44;
    const double innerPadding = 4;
    const double gap = 6;
    const double minSegWidth = 88;
    final double pillRadius = 18;
    final double innerRadius = ((pillRadius - innerPadding).clamp(
      0.0,
      pillRadius,
    )).toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availWidth = constraints.maxWidth;
        final double innerAvailWidth = availWidth - innerPadding * 2;
        final double segWidth = math.max(
          minSegWidth,
          (innerAvailWidth - gap * (tabs.length - 1)) / tabs.length,
        );
        final double rowWidth =
            segWidth * tabs.length + gap * (tabs.length - 1);

        final Color shellBg = isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.white;

        List<Widget> children = [];
        for (int index = 0; index < tabs.length; index++) {
          final bool selected = controller.index == index;
          children.add(
            SizedBox(
              width: segWidth,
              height: double.infinity,
              child: _TactileRow(
                onTap: () => controller.animateTo(index),
                builder: (pressed) {
                  final Color baseBg = selected
                      ? cs.primary.withOpacity(0.14)
                      : Colors.transparent;
                  final Color bg = baseBg;
                  final Color baseTextColor = selected
                      ? cs.primary
                      : cs.onSurface.withOpacity(0.82);
                  final Color targetTextColor = pressed
                      ? Color.lerp(baseTextColor, Colors.white, 0.22) ??
                            baseTextColor
                      : baseTextColor;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(innerRadius),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TweenAnimationBuilder<Color?>(
                        tween: ColorTween(end: targetTextColor),
                        duration: const Duration(milliseconds: 160),
                        curve: Curves.easeOutCubic,
                        builder: (context, color, _) {
                          return Text(
                            tabs[index],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: color ?? baseTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          );
          if (index != tabs.length - 1)
            children.add(const SizedBox(width: gap));
        }

        return Container(
          height: outerHeight,
          decoration: BoxDecoration(
            color: shellBg,
            borderRadius: BorderRadius.circular(pillRadius),
          ),
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.all(innerPadding),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: innerAvailWidth),
                child: SizedBox(
                  width: rowWidth,
                  child: Row(children: children),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TactileRow extends StatefulWidget {
  const _TactileRow({required this.builder, this.onTap});
  final Widget Function(bool pressed) builder;
  final VoidCallback? onTap;
  @override
  State<_TactileRow> createState() => _TactileRowState();
}

class _TactileRowState extends State<_TactileRow> {
  bool _pressed = false;
  void _set(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.onTap == null ? null : (_) => _set(true),
      onTapUp: widget.onTap == null ? null : (_) => _set(false),
      onTapCancel: widget.onTap == null ? null : () => _set(false),
      onTap: widget.onTap,
      child: widget.builder(_pressed),
    );
  }
}

class _TactileIconButton extends StatefulWidget {
  const _TactileIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.size = 22,
  });
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;
  @override
  State<_TactileIconButton> createState() => _TactileIconButtonState();
}

class _TactileIconButtonState extends State<_TactileIconButton> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    final base = widget.color;
    final press = base.withOpacity(0.7);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        Haptics.light();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 110),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            widget.icon,
            size: widget.size,
            color: _pressed ? press : base,
          ),
        ),
      ),
    );
  }
}
