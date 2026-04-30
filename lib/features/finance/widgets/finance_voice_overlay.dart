import 'dart:async';
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

import '../../../core/providers/assistant_provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/services/api/groq_speech_to_text_service.dart';
import '../../../core/services/finance/finance_voice_command_service.dart';
import '../../model/widgets/model_select_sheet.dart';
import '../../provider/widgets/provider_avatar.dart';

class FinanceVoiceOverlay extends StatefulWidget {
  const FinanceVoiceOverlay({super.key});

  @override
  State<FinanceVoiceOverlay> createState() => _FinanceVoiceOverlayState();
}

class _FinanceVoiceOverlayState extends State<FinanceVoiceOverlay> {
  final TextEditingController _controller = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final GroqSpeechToTextService _speechToTextService =
      GroqSpeechToTextService();

  bool _expanded = false;
  bool _running = false;
  bool _recording = false;
  bool _transcribing = false;
  FinanceVoiceCommandResult? _lastResult;

  _FinanceModelBinding _resolveBinding(
    SettingsProvider settings,
    AssistantProvider assistants,
  ) {
    final financeAssistant = assistants.financeAssistant;
    final currentAssistant = assistants.currentAssistant;

    bool hasExplicitModel(dynamic assistant) {
      return assistant != null &&
          (assistant.chatModelProvider ?? '').toString().trim().isNotEmpty &&
          (assistant.chatModelId ?? '').toString().trim().isNotEmpty;
    }

    final boundAssistant = hasExplicitModel(financeAssistant)
        ? financeAssistant
        : (hasExplicitModel(currentAssistant) ? currentAssistant : financeAssistant);

    final String? providerKey =
        boundAssistant?.chatModelProvider ?? settings.currentModelProvider;
    final String? modelId =
        boundAssistant?.chatModelId ?? settings.currentModelId;
    final ProviderConfig? config = providerKey == null
        ? null
        : settings.getProviderConfig(providerKey);
    final String providerName = providerKey == null
        ? 'No provider'
        : ((config?.name ?? '').trim().isNotEmpty
              ? config!.name
              : providerKey);
    return _FinanceModelBinding(
      financeAssistant: financeAssistant,
      boundAssistant: boundAssistant,
      providerKey: providerKey,
      modelId: modelId,
      providerName: providerName,
      config: config,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    unawaited(_audioRecorder.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final settings = context.watch<SettingsProvider>();
    final assistants = context.watch<AssistantProvider>();
    final _FinanceModelBinding binding = _resolveBinding(settings, assistants);
    final ProviderConfig? config = binding.config;
    final String? modelId = binding.modelId;
    final bool canRun = config != null && modelId != null && modelId.isNotEmpty;
    final bool speechEnabled = _speechToTextAvailable(config);

    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: _expanded ? 360 : 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Material(
              color: cs.surface.withValues(alpha: 0.96),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.55),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: _expanded
                    ? _buildExpanded(
                        context,
                        cs: cs,
                        canRun: canRun,
                        speechEnabled: speechEnabled,
                        binding: binding,
                        config: config,
                        modelId: modelId,
                      )
                    : _buildCollapsed(cs),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsed(ColorScheme cs) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => setState(() => _expanded = true),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.mic_none_rounded, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _lastResult?.message ?? 'Ask finance AI',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpanded(
    BuildContext context, {
    required ColorScheme cs,
    required bool canRun,
    required bool speechEnabled,
    required _FinanceModelBinding binding,
    required ProviderConfig? config,
    required String? modelId,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Finance AI',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: _running || _recording || _transcribing
                        ? null
                        : () => _selectModel(context, binding),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: cs.primary.withValues(alpha: 0.16),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (binding.providerKey != null)
                            ProviderAvatar(
                              providerKey: binding.providerKey!,
                              displayName: binding.providerName,
                              size: 18,
                            )
                          else
                            Icon(
                              Icons.hub_outlined,
                              size: 18,
                              color: cs.primary,
                            ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              binding.modelId == null || binding.modelId!.isEmpty
                                  ? 'Select model'
                                  : '${binding.providerName} · ${binding.modelId}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: cs.onSurface,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.expand_more_rounded,
                            size: 18,
                            color: cs.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: _running || _recording || _transcribing
                  ? null
                  : () => setState(() => _expanded = false),
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
        TextField(
          controller: _controller,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText:
                'Examples: add salary 2500 to bank account, create a bank account, make a rent reminder...',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: !canRun || _running || _recording || _transcribing
                  ? null
                  : () => _runCommand(
                        context,
                        config: config!,
                        modelId: modelId!,
                      ),
              icon: _running
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome_rounded),
              label: Text(_running ? 'Running' : 'Run'),
            ),
            OutlinedButton.icon(
              onPressed: !speechEnabled || _running || _transcribing
                  ? null
                  : () => _toggleRecording(
                        context,
                        config: config,
                        modelId: modelId,
                      ),
              icon: Icon(
                _transcribing
                    ? Icons.hourglass_top_rounded
                    : (_recording
                          ? Icons.stop_circle_outlined
                          : Icons.mic_none_rounded),
              ),
              label: Text(
                _transcribing
                    ? 'Transcribing'
                    : (_recording ? 'Stop' : 'Voice'),
              ),
            ),
          ],
        ),
        if (!canRun) ...[
          const SizedBox(height: 10),
          Text(
            'Configure a model for the Finance Assistant or set a global model first.',
            style: TextStyle(color: cs.error, fontSize: 12),
          ),
        ] else if (!speechEnabled) ...[
          const SizedBox(height: 10),
          Text(
            'Voice input is unavailable for ${binding.providerName} · ${binding.modelId ?? 'no model'}. Select a Groq model with Speech-to-Text enabled if you want voice commands.',
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
          ),
        ],
        if (_lastResult != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _lastResult!.ok
                  ? Colors.green.withValues(alpha: 0.08)
                  : cs.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _lastResult!.ok
                    ? Colors.green.withValues(alpha: 0.22)
                    : cs.error.withValues(alpha: 0.22),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _lastResult!.message,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if ((_lastResult!.transcript ?? '').isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    _lastResult!.transcript!,
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
                if (_lastResult!.warnings.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    _lastResult!.warnings.join('\n'),
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  bool _speechToTextAvailable(ProviderConfig? config) {
    if (config == null) {
      return false;
    }
    final ProviderKind kind = ProviderConfig.classify(
      config.id,
      explicitType: config.providerType,
    );
    return kind == ProviderKind.groq && (config.speechToTextEnabled ?? false);
  }

  Future<void> _selectModel(
    BuildContext context,
    _FinanceModelBinding binding,
  ) async {
    final AssistantProvider assistants = context.read<AssistantProvider>();
    final SettingsProvider settings = context.read<SettingsProvider>();
    final ModelSelection? selection = await showModelSelector(context);
    if (selection == null) {
      return;
    }
    final financeAssistant = binding.financeAssistant ?? assistants.financeAssistant;
    if (financeAssistant != null) {
      await assistants.updateAssistant(
        financeAssistant.copyWith(
          chatModelProvider: selection.providerKey,
          chatModelId: selection.modelId,
        ),
      );
      return;
    }
    await settings.setCurrentModel(
      selection.providerKey,
      selection.modelId,
    );
  }

  Future<void> _runCommand(
    BuildContext context, {
    required ProviderConfig config,
    required String modelId,
    String? transcript,
  }) async {
    final FinanceVoiceCommandService service =
        context.read<FinanceVoiceCommandService>();
    await _runCommandWithService(
      service: service,
      config: config,
      modelId: modelId,
      transcript: transcript,
    );
  }

  Future<void> _runCommandWithService({
    required FinanceVoiceCommandService service,
    required ProviderConfig config,
    required String modelId,
    String? transcript,
  }) async {
    final String command = _controller.text.trim();
    if (command.isEmpty) {
      return;
    }

    setState(() => _running = true);
    try {
      final FinanceVoiceCommandResult result = await service.execute(
        command: command,
        config: config,
        modelId: modelId,
        transcript: transcript,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _lastResult = result;
        if (result.ok) {
          _controller.clear();
        }
      });
    } finally {
      if (mounted) {
        setState(() => _running = false);
      }
    }
  }

  Future<void> _toggleRecording(
    BuildContext context, {
    required ProviderConfig? config,
    required String? modelId,
  }) async {
    if (config == null || modelId == null || !_speechToTextAvailable(config)) {
      return;
    }

    final FinanceVoiceCommandService service =
        context.read<FinanceVoiceCommandService>();

    if (!_recording) {
      final bool hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        if (!mounted) {
          return;
        }
        setState(() {
          _lastResult = const FinanceVoiceCommandResult(
            ok: false,
            message: 'Microphone permission is required for voice commands.',
          );
        });
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final String path =
          '${tempDir.path}/finance_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );
      if (!mounted) {
        return;
      }
      setState(() => _recording = true);
      return;
    }

    String? audioPath;
    try {
      audioPath = await _audioRecorder.stop();
    } finally {
      if (mounted) {
        setState(() {
          _recording = false;
          _transcribing = true;
        });
      }
    }

    try {
      if (audioPath == null || audioPath.trim().isEmpty) {
        throw Exception('No recording file was produced.');
      }
      final String transcript = await _speechToTextService.transcribeFile(
        config: config,
        audioPath: audioPath,
        model: config.speechToTextModel,
      );
      if (!mounted) {
        return;
      }
      setState(() => _controller.text = transcript.trim());
      await _runCommandWithService(
        service: service,
        config: config,
        modelId: modelId,
        transcript: transcript.trim(),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _lastResult = FinanceVoiceCommandResult(
          ok: false,
          message: 'Voice command failed: $e',
        );
      });
    } finally {
      try {
        if (audioPath != null && audioPath.isNotEmpty) {
          final File file = File(audioPath);
          if (await file.exists()) {
            await file.delete();
          }
        }
      } catch (_) {}
      if (mounted) {
        setState(() => _transcribing = false);
      }
    }
  }
}

class _FinanceModelBinding {
  const _FinanceModelBinding({
    required this.financeAssistant,
    required this.boundAssistant,
    required this.providerKey,
    required this.modelId,
    required this.providerName,
    required this.config,
  });

  final dynamic financeAssistant;
  final dynamic boundAssistant;
  final String? providerKey;
  final String? modelId;
  final String providerName;
  final ProviderConfig? config;
}
