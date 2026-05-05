import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/settings_provider.dart';
import '../../core/services/api/groq_speech_to_text_service.dart';
import '../../features/provider/widgets/provider_avatar.dart';
import '../../shared/widgets/ios_switch.dart';

class DesktopSttServicesPane extends StatelessWidget {
  const DesktopSttServicesPane({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final settings = context.watch<SettingsProvider>();

    final groqProviders = settings.providerConfigs.entries.where((e) {
      final kind = ProviderConfig.classify(e.key, explicitType: e.value.providerType);
      return kind == ProviderKind.groq;
    }).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Speech-to-Text',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Voice input via Groq Whisper. Enable on a Groq provider to use voice commands in Finance AI.',
            style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          if (groqProviders.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'No Groq providers configured. Add a Groq provider in Providers settings.',
                style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: groqProviders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final key = groqProviders[i].key;
                  final cfg = groqProviders[i].value;
                  return _GroqProviderCard(providerKey: key, config: cfg);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _GroqProviderCard extends StatelessWidget {
  const _GroqProviderCard({required this.providerKey, required this.config});

  final String providerKey;
  final ProviderConfig config;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final enabled = config.speechToTextEnabled ?? false;
    final model = config.speechToTextModel ?? 'whisper-large-v3-turbo';
    final name = config.name.isNotEmpty ? config.name : providerKey;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: isDark ? 0.1 : 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
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
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        enabled ? 'Enabled · $model' : 'Disabled',
                        style: TextStyle(
                          fontSize: 12,
                          color: enabled ? cs.primary : cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IosSwitch(
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
              color: cs.outlineVariant.withValues(alpha: 0.2),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
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
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: GroqSpeechToTextService.supportedModels.map((m) {
                      final selected = model == m;
                      return InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          final settings = context.read<SettingsProvider>();
                          await settings.setProviderConfig(
                            providerKey,
                            config.copyWith(speechToTextModel: m),
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? cs.primary.withValues(alpha: 0.12)
                                : cs.surfaceContainerHighest.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selected
                                  ? cs.primary.withValues(alpha: 0.4)
                                  : cs.outlineVariant.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (selected)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Icon(
                                    Icons.check_rounded,
                                    size: 14,
                                    color: cs.primary,
                                  ),
                                ),
                              Text(
                                m,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: selected ? cs.primary : cs.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
