import 'dart:async';
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

import '../core/providers/assistant_provider.dart';
import '../core/providers/settings_provider.dart';
import '../core/services/api/groq_speech_to_text_service.dart';
import '../features/home/utils/model_display_helper.dart';
import '../features/model/widgets/model_select_sheet.dart';
import '../icons/lucide_adapter.dart';
import '../shared/widgets/snackbar.dart';

class LandingAppTarget {
  const LandingAppTarget({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String label;
  final String subtitle;
  final IconData icon;
}

const List<LandingAppTarget> kLandingAppTargets = <LandingAppTarget>[
  LandingAppTarget(
    id: 'general',
    label: 'Kelivo',
    subtitle: 'Ask anything',
    icon: Lucide.MessageCircle,
  ),
  LandingAppTarget(
    id: 'finance',
    label: 'Finance',
    subtitle: 'Spending, balance, budgets',
    icon: Lucide.databaseBackup,
  ),
  LandingAppTarget(
    id: 'tasks',
    label: 'Tasks',
    subtitle: 'Plans, reminders, priorities',
    icon: Lucide.CheckSquare,
  ),
  LandingAppTarget(
    id: 'focus',
    label: 'Focus',
    subtitle: 'Work sessions and routines',
    icon: Lucide.Timer,
  ),
];

class CodexHomeLandingPage extends StatefulWidget {
  const CodexHomeLandingPage({
    super.key,
    required this.onSubmit,
    required this.onOpenPrevious,
    required this.onOpenFullApp,
  });

  final Future<void> Function(String prompt, LandingAppTarget app) onSubmit;
  final VoidCallback onOpenPrevious;
  final VoidCallback onOpenFullApp;

  @override
  State<CodexHomeLandingPage> createState() => _CodexHomeLandingPageState();
}

class _CodexHomeLandingPageState extends State<CodexHomeLandingPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final GroqSpeechToTextService _speechToTextService =
      GroqSpeechToTextService();

  LandingAppTarget _selectedApp = kLandingAppTargets.first;
  bool _recording = false;
  bool _transcribing = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    unawaited(_audioRecorder.dispose());
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _submitting) return;
    setState(() => _submitting = true);
    try {
      await widget.onSubmit(text, _selectedApp);
      _controller.clear();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _toggleSpeechToText() async {
    if (_transcribing) return;

    final settings = context.read<SettingsProvider>();
    final assistant = context.read<AssistantProvider>().currentAssistant;
    final cfg = getActiveProviderConfig(settings, assistant: assistant);
    if (cfg == null) {
      showAppSnackBar(
        context,
        message: 'No provider is configured for speech-to-text.',
        type: NotificationType.warning,
      );
      return;
    }

    final isGroq =
        ProviderConfig.classify(cfg.id, explicitType: cfg.providerType) ==
        ProviderKind.groq;
    if (!isGroq || !(cfg.speechToTextEnabled ?? false)) {
      showAppSnackBar(
        context,
        message: 'Enable Speech-to-Text on a Groq provider first.',
        type: NotificationType.info,
      );
      return;
    }

    if (!_recording) {
      try {
        final hasPermission = await _audioRecorder.hasPermission();
        if (!hasPermission) {
          if (!mounted) return;
          showAppSnackBar(
            context,
            message: 'Microphone permission is required for speech input.',
            type: NotificationType.warning,
          );
          return;
        }
        final tempDir = await getTemporaryDirectory();
        final path =
            '${tempDir.path}/kelivo_landing_stt_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );
        if (mounted) setState(() => _recording = true);
      } catch (e) {
        if (!mounted) return;
        showAppSnackBar(
          context,
          message: 'Unable to start recording: $e',
          type: NotificationType.error,
        );
      }
      return;
    }

    String? audioPath;
    try {
      audioPath = await _audioRecorder.stop();
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _recording = false;
      _transcribing = true;
    });

    try {
      if (audioPath == null || audioPath.trim().isEmpty) {
        throw Exception('No recording file was produced.');
      }
      final transcript = await _speechToTextService.transcribeFile(
        config: cfg,
        audioPath: audioPath,
        model: cfg.speechToTextModel,
      );
      if (!mounted) return;
      _insertText(transcript.trim());
      _focusNode.requestFocus();
    } catch (e) {
      if (!mounted) return;
      showAppSnackBar(
        context,
        message: 'Speech-to-text failed: $e',
        type: NotificationType.error,
      );
    } finally {
      try {
        if (audioPath != null && audioPath.isNotEmpty) {
          final file = File(audioPath);
          if (await file.exists()) await file.delete();
        }
      } catch (_) {}
      if (mounted) setState(() => _transcribing = false);
    }
  }

  void _insertText(String text) {
    if (text.isEmpty) return;
    final value = _controller.value;
    final selection = value.selection;
    if (!selection.isValid) {
      final next = value.text.isEmpty ? text : '${value.text} $text';
      _controller.value = value.copyWith(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
        composing: TextRange.empty,
      );
      return;
    }

    final start = selection.start;
    final end = selection.end;
    final prefix = value.text.substring(0, start);
    final suffix = value.text.substring(end);
    final insert =
        '${prefix.isNotEmpty && !RegExp(r'\s$').hasMatch(prefix) ? ' ' : ''}'
        '$text'
        '${suffix.isNotEmpty && !RegExp(r'^\s').hasMatch(suffix) ? ' ' : ''}';
    final next = value.text.replaceRange(start, end, insert);
    _controller.value = value.copyWith(
      text: next,
      selection: TextSelection.collapsed(offset: start + insert.length),
      composing: TextRange.empty,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: cs.surface,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 900;
            final veryCompact = constraints.maxWidth < 680;
            final horizontalPadding = veryCompact
                ? 18.0
                : (compact ? 28.0 : 42.0);
            final maxWidth = compact ? 720.0 : 820.0;
            final titleSize = veryCompact ? 24.0 : (compact ? 28.0 : 31.0);
            final topGap = veryCompact ? 24.0 : (compact ? 34.0 : 54.0);

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: veryCompact ? 16 : 22,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Column(
                        children: [
                          SizedBox(height: topGap),
                          Text(
                            'How can Kelivo help today?',
                            textAlign: TextAlign.center,
                            style: textTheme.displaySmall?.copyWith(
                              fontSize: titleSize,
                              height: 1.16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your personal assistant for chat, finance, tasks, and focus.',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge?.copyWith(
                              color: cs.onSurfaceVariant,
                              height: 1.35,
                              letterSpacing: 0,
                            ),
                          ),
                          SizedBox(height: veryCompact ? 18 : 24),
                          _PromptComposer(
                            controller: _controller,
                            focusNode: _focusNode,
                            selectedApp: _selectedApp,
                            recording: _recording,
                            transcribing: _transcribing,
                            submitting: _submitting,
                            compact: compact,
                            onSelectApp: (target) =>
                                setState(() => _selectedApp = target),
                            onPickModel: () => showModelSelectSheet(context),
                            onOpenPrevious: widget.onOpenPrevious,
                            onOpenFullApp: widget.onOpenFullApp,
                            onVoice: _toggleSpeechToText,
                            onSubmit: _submit,
                          ),
                          SizedBox(height: veryCompact ? 14 : 18),
                          _ScopeChips(
                            selectedApp: _selectedApp,
                            onSelect: (target) =>
                                setState(() => _selectedApp = target),
                          ),
                          SizedBox(height: veryCompact ? 22 : 36),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PromptComposer extends StatelessWidget {
  const _PromptComposer({
    required this.controller,
    required this.focusNode,
    required this.selectedApp,
    required this.recording,
    required this.transcribing,
    required this.submitting,
    required this.onSelectApp,
    required this.onPickModel,
    required this.onOpenPrevious,
    required this.onOpenFullApp,
    required this.onVoice,
    required this.onSubmit,
    required this.compact,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final LandingAppTarget selectedApp;
  final bool recording;
  final bool transcribing;
  final bool submitting;
  final ValueChanged<LandingAppTarget> onSelectApp;
  final VoidCallback onPickModel;
  final VoidCallback onOpenPrevious;
  final VoidCallback onOpenFullApp;
  final VoidCallback onVoice;
  final VoidCallback onSubmit;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.68)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.07),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: compact ? 68 : 74,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: 'Ask Kelivo anything...',
                hintStyle: textTheme.titleMedium?.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.46),
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(18, 16, 18, 6),
              ),
              style: textTheme.titleMedium?.copyWith(
                height: 1.42,
                letterSpacing: 0,
              ),
              onSubmitted: (_) => onSubmit(),
            ),
          ),
          Container(
            height: 1,
            color: cs.outlineVariant.withValues(alpha: 0.32),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: _InlineToolRow(
              onPickModel: onPickModel,
              onVoice: onVoice,
              onOpenFullApp: onOpenFullApp,
              onClearPrompt: controller.clear,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _AppPickerButton(
                            selectedApp: selectedApp,
                            onSelectApp: onSelectApp,
                          ),
                          const SizedBox(width: 8),
                          _ModelButton(onTap: onPickModel),
                          const SizedBox(width: 8),
                          _PlainPillButton(
                            icon: Lucide.History,
                            label: 'Previous',
                            onTap: onOpenPrevious,
                          ),
                          const SizedBox(width: 8),
                          _PlainPillButton(
                            icon: Lucide.LayoutDashboard,
                            label: 'Full app',
                            onTap: onOpenFullApp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _IconButton(
                  icon: transcribing
                      ? Lucide.Loader
                      : (recording ? Lucide.Square : Lucide.AudioWaveform),
                  tooltip: recording ? 'Stop voice input' : 'Voice input',
                  active: recording,
                  onPressed: onVoice,
                ),
                const SizedBox(width: 6),
                _SendButton(submitting: submitting, onSubmit: onSubmit),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineToolRow extends StatelessWidget {
  const _InlineToolRow({
    required this.onPickModel,
    required this.onVoice,
    required this.onOpenFullApp,
    required this.onClearPrompt,
  });

  final VoidCallback onPickModel;
  final VoidCallback onVoice;
  final VoidCallback onOpenFullApp;
  final VoidCallback onClearPrompt;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 14,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _InlineToolButton(
          icon: Lucide.Globe,
          tooltip: 'Web search',
          color: const Color(0xFF1A73E8),
          onTap: onOpenFullApp,
        ),
        _InlineToolButton(
          icon: Lucide.Search,
          tooltip: 'Search',
          color: const Color(0xFF4B5FA8),
          onTap: onOpenFullApp,
        ),
        _InlineToolButton(
          icon: Lucide.Hammer,
          tooltip: 'Tools',
          onTap: onOpenFullApp,
        ),
        _InlineToolButton(
          icon: Lucide.AudioWaveform,
          tooltip: 'Voice input',
          onTap: onVoice,
        ),
        _InlineToolButton(
          icon: Lucide.Bot,
          tooltip: 'Assistant',
          onTap: onOpenFullApp,
        ),
        _InlineToolButton(
          icon: Lucide.Paperclip,
          tooltip: 'Attach files',
          onTap: onOpenFullApp,
        ),
        _InlineToolButton(
          icon: Lucide.Layers,
          tooltip: 'Context layers',
          onTap: onOpenFullApp,
        ),
        _InlineToolButton(
          icon: Lucide.Eraser,
          tooltip: 'Clear prompt',
          onTap: onClearPrompt,
        ),
        _InlineToolButton(
          icon: Lucide.Map,
          tooltip: 'Mini map',
          onTap: onOpenFullApp,
        ),
        _InlineToolButton(
          icon: Lucide.ChevronDown,
          tooltip: 'Model picker',
          onTap: onPickModel,
        ),
      ],
    );
  }
}

class _InlineToolButton extends StatelessWidget {
  const _InlineToolButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        radius: 18,
        onTap: onTap,
        child: SizedBox.square(
          dimension: 28,
          child: Icon(
            icon,
            size: 21,
            color: color ?? cs.onSurfaceVariant.withValues(alpha: 0.86),
          ),
        ),
      ),
    );
  }
}

class _AppPickerButton extends StatelessWidget {
  const _AppPickerButton({
    required this.selectedApp,
    required this.onSelectApp,
  });

  final LandingAppTarget selectedApp;
  final ValueChanged<LandingAppTarget> onSelectApp;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return PopupMenuButton<LandingAppTarget>(
      tooltip: 'Choose app',
      onSelected: onSelectApp,
      itemBuilder: (context) => [
        for (final target in kLandingAppTargets)
          PopupMenuItem<LandingAppTarget>(
            value: target,
            child: Row(
              children: [
                Icon(target.icon, size: 18),
                const SizedBox(width: 10),
                Text(target.label),
              ],
            ),
          ),
      ],
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.56)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selectedApp.icon, size: 17, color: cs.primary),
            const SizedBox(width: 8),
            Text(
              selectedApp.label,
              style: TextStyle(
                color: cs.onSurface,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Lucide.ChevronDown, size: 15, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _ModelButton extends StatelessWidget {
  const _ModelButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final assistant = context.watch<AssistantProvider>().currentAssistant;
    final modelInfo = getModelDisplayInfo(settings, assistant: assistant);
    final label = modelInfo.modelDisplay ?? 'Model';
    final shortLabel = label.length > 18
        ? '${label.substring(0, 18)}...'
        : label;

    return _PlainPillButton(
      label: shortLabel,
      trailing: Lucide.ChevronDown,
      onTap: onTap,
    );
  }
}

class _PlainPillButton extends StatelessWidget {
  const _PlainPillButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.trailing,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final IconData? trailing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 17, color: cs.onSurfaceVariant),
              const SizedBox(width: 7),
            ],
            Text(
              label,
              style: TextStyle(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 5),
              Icon(trailing, size: 15, color: cs.onSurfaceVariant),
            ],
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.active = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        radius: 20,
        onTap: onPressed,
        child: SizedBox.square(
          dimension: 34,
          child: Icon(
            icon,
            size: 21,
            color: active ? cs.primary : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.submitting, required this.onSubmit});

  final bool submitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Tooltip(
      message: 'Send',
      child: InkResponse(
        radius: 26,
        onTap: submitting ? null : onSubmit,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: cs.onSurface.withValues(alpha: 0.48),
            shape: BoxShape.circle,
          ),
          child: Icon(
            submitting ? Lucide.Loader : Lucide.ArrowUp,
            color: cs.surface,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _ScopeChips extends StatelessWidget {
  const _ScopeChips({required this.selectedApp, required this.onSelect});

  final LandingAppTarget selectedApp;
  final ValueChanged<LandingAppTarget> onSelect;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final target in kLandingAppTargets)
          _ScopeChip(
            target: target,
            selected: target.id == selectedApp.id,
            colorScheme: cs,
            onTap: () => onSelect(target),
          ),
      ],
    );
  }
}

class _ScopeChip extends StatelessWidget {
  const _ScopeChip({
    required this.target,
    required this.selected,
    required this.colorScheme,
    required this.onTap,
  });

  final LandingAppTarget target;
  final bool selected;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primaryContainer.withValues(alpha: 0.48)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? colorScheme.primary.withValues(alpha: 0.54)
                : colorScheme.outlineVariant.withValues(alpha: 0.62),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              target.icon,
              size: 17,
              color: selected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              target.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
                color: selected ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
