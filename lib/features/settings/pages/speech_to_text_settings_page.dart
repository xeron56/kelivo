import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/settings_provider.dart';
import '../../../core/services/api/groq_speech_to_text_service.dart';
import '../../../icons/lucide_adapter.dart';
import '../../provider/widgets/provider_avatar.dart';

class SpeechToTextSettingsPage extends StatelessWidget {
  const SpeechToTextSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        leading: _TactileIconButton(
          icon: Lucide.ArrowLeft,
          color: cs.onSurface,
          size: 22,
          onTap: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Speech-to-Text'),
      ),
      body: const _SttSettingsBody(),
    );
  }
}

class _SttSettingsBody extends StatelessWidget {
  const _SttSettingsBody();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final settings = context.watch<SettingsProvider>();

    final groqProviders = settings.providerConfigs.entries.where((e) {
      final kind = ProviderConfig.classify(e.key, explicitType: e.value.providerType);
      return kind == ProviderKind.groq;
    }).toList();

    Widget sectionHeader(String text, {bool first = false}) => Padding(
          padding: EdgeInsets.fromLTRB(12, first ? 2 : 20, 12, 6),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withValues(alpha: 0.8),
            ),
          ),
        );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        // Info card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.primary.withValues(alpha: 0.14)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.mic_none_rounded, size: 18, color: cs.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Speech-to-Text (STT)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Voice input is powered by Groq Whisper. Enable STT on a Groq provider to use voice commands in Finance AI.',
                      style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        sectionHeader('Groq Providers', first: true),

        if (groqProviders.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              'No Groq providers configured. Add a Groq provider in Settings → Providers.',
              style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
            ),
          )
        else
          _iosSectionCard(
            context: context,
            children: [
              for (int i = 0; i < groqProviders.length; i++) ...[
                if (i > 0) _iosDivider(context),
                _GroqProviderTile(
                  providerKey: groqProviders[i].key,
                  config: groqProviders[i].value,
                ),
              ],
            ],
          ),

        sectionHeader('Available Models'),
        _iosSectionCard(
          context: context,
          children: [
            for (int i = 0; i < GroqSpeechToTextService.supportedModels.length; i++) ...[
              if (i > 0) _iosDivider(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.hearing_rounded, size: 18, color: cs.onSurfaceVariant),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            GroqSpeechToTextService.supportedModels[i],
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            i == 0
                                ? 'Faster, recommended for real-time use'
                                : 'Higher accuracy, slower transcription',
                            style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _GroqProviderTile extends StatelessWidget {
  const _GroqProviderTile({
    required this.providerKey,
    required this.config,
  });

  final String providerKey;
  final ProviderConfig config;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final enabled = config.speechToTextEnabled ?? false;
    final model = config.speechToTextModel ?? 'whisper-large-v3-turbo';
    final name = config.name.isNotEmpty ? config.name : providerKey;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              ProviderAvatar(
                providerKey: providerKey,
                displayName: name,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      enabled ? 'STT enabled · $model' : 'STT disabled',
                      style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              _IosSwitch(
                value: enabled,
                onChanged: (v) async {
                  final settings = context.read<SettingsProvider>();
                  await settings.setProviderConfig(
                    providerKey,
                    config.copyWith(speechToTextEnabled: v),
                  );
                },
              ),
            ],
          ),
        ),
        if (enabled) ...[
          Divider(
            height: 1,
            thickness: 0.5,
            indent: 56,
            color: cs.outlineVariant.withValues(alpha: 0.2),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(56, 6, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transcription Model',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                ...GroqSpeechToTextService.supportedModels.map((m) {
                  final selected = model == m;
                  return GestureDetector(
                    onTap: () async {
                      final settings = context.read<SettingsProvider>();
                      await settings.setProviderConfig(
                        providerKey,
                        config.copyWith(speechToTextModel: m),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected ? cs.primary : cs.outlineVariant,
                                width: selected ? 5 : 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            m,
                            style: TextStyle(
                              fontSize: 13,
                              color: selected ? cs.primary : cs.onSurface,
                              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// Minimal iOS-style switch
class _IosSwitch extends StatelessWidget {
  const _IosSwitch({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: value
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 1)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _iosSectionCard({
  required BuildContext context,
  required List<Widget> children,
}) {
  final theme = Theme.of(context);
  final cs = theme.colorScheme;
  final isDark = theme.brightness == Brightness.dark;
  final Color bg = isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.96);
  return Container(
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: cs.outlineVariant.withValues(alpha: isDark ? 0.08 : 0.06),
        width: 0.6,
      ),
    ),
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(children: children),
    ),
  );
}

Widget _iosDivider(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return Divider(
    height: 6,
    thickness: 0.6,
    indent: 56,
    endIndent: 12,
    color: cs.outlineVariant.withValues(alpha: 0.18),
  );
}

class _TactileIconButton extends StatefulWidget {
  const _TactileIconButton({
    required this.icon,
    required this.color,
    required this.size,
    required this.onTap,
  });
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;

  @override
  State<_TactileIconButton> createState() => _TactileIconButtonState();
}

class _TactileIconButtonState extends State<_TactileIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        opacity: _pressed ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(widget.icon, color: widget.color, size: widget.size),
        ),
      ),
    );
  }
}
