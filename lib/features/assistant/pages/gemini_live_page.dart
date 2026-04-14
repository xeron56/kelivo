import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

import '../../../core/models/assistant.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/services/api/gemini_live_session_service.dart';
import '../../../features/home/services/tool_handler_service.dart';
import '../../../theme/design_tokens.dart';
import '../../../shared/widgets/snackbar.dart';

class GeminiLivePage extends StatefulWidget {
  const GeminiLivePage({
    super.key,
    required this.providerConfig,
    required this.assistant,
    this.modelId = 'gemini-3.1-flash-live-preview',
  });

  final ProviderConfig providerConfig;
  final Assistant? assistant;
  final String modelId;

  @override
  State<GeminiLivePage> createState() => _GeminiLivePageState();
}

class _GeminiLivePageState extends State<GeminiLivePage> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final ScrollController _transcriptScrollController = ScrollController();

  GeminiLiveSessionService? _service;
  StreamSubscription<Uint8List>? _audioSubscription;
  StreamSubscription<Amplitude>? _amplitudeSubscription;

  final List<_LiveTranscriptTurn> _turns = <_LiveTranscriptTurn>[];

  bool _initializing = true;
  bool _recording = false;
  bool _userSpeaking = false;
  bool _lastAwaitingModelTurn = false;
  bool _micPermissionDenied = false;
  String? _microphoneError;
  double _inputLevel = 0.04;

  @override
  void initState() {
    super.initState();
    _createService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_connect());
    });
  }

  @override
  void dispose() {
    unawaited(_stopPassiveListening(sendAudioStreamEnd: false));
    _service?.removeListener(_handleServiceChanged);
    _transcriptScrollController.dispose();
    unawaited(_audioRecorder.dispose());
    _service?.dispose();
    super.dispose();
  }

  void _createService() {
    final SettingsProvider settings = context.read<SettingsProvider>();
    final ToolHandlerService toolHandler = ToolHandlerService(
      contextProvider: context,
    );
    final List<Map<String, dynamic>> toolDefinitions = toolHandler
        .buildToolDefinitions(
          settings,
          widget.assistant,
          widget.providerConfig.id,
          widget.modelId,
          false,
          isToolModel: (String _, String __) => true,
        );

    final List<Map<String, dynamic>> functionDeclarations = toolDefinitions
        .map(
          (Map<String, dynamic> tool) =>
              Map<String, dynamic>.from(tool['function'] as Map),
        )
        .toList(growable: false);

    final String systemInstruction = _buildSystemInstruction(
      widget.assistant,
      functionDeclarations.isNotEmpty,
    );

    _service = GeminiLiveSessionService(
      providerConfig: widget.providerConfig,
      modelId: widget.modelId,
      systemInstruction: systemInstruction,
      functionDeclarations: functionDeclarations,
      toolHandler: toolHandler.buildToolCallHandler(settings, widget.assistant),
    );
    _service!.addListener(_handleServiceChanged);
  }

  void _handleServiceChanged() {
    if (!mounted) {
      return;
    }

    final GeminiLiveSessionService? service = _service;
    final bool awaiting = service?.awaitingModelTurn ?? false;
    bool shouldScroll = false;

    setState(() {
      if (_lastAwaitingModelTurn && !awaiting && service != null) {
        shouldScroll = _appendCommittedTurn(service);
      }
      _lastAwaitingModelTurn = awaiting;
    });

    if (service != null && !service.connected && _recording && !_initializing) {
      unawaited(_stopPassiveListening(sendAudioStreamEnd: false));
    }

    if (shouldScroll) {
      _scheduleTranscriptScroll();
    }
  }

  bool _appendCommittedTurn(GeminiLiveSessionService service) {
    final String user = service.inputTranscript.trim();
    final String assistant = _assistantText(service).trim();
    if (user.isEmpty && assistant.isEmpty) {
      return false;
    }
    _turns.add(
      _LiveTranscriptTurn(
        userText: user,
        assistantText: assistant,
        timestamp: DateTime.now(),
      ),
    );
    if (_turns.length > 20) {
      _turns.removeAt(0);
    }
    return true;
  }

  static String _buildSystemInstruction(Assistant? assistant, bool hasTools) {
    final List<String> parts = <String>[
      if ((assistant?.systemPrompt ?? '').trim().isNotEmpty)
        assistant!.systemPrompt.trim(),
      'You are in Kelivo live voice mode.',
      'Keep spoken answers concise, natural, and easy to follow.',
      'When the user asks to record spending or income, use the finance tools instead of only describing what should happen.',
      if (hasTools)
        'If account or category names are unclear, inspect the available tools and ask a short follow-up only when you still cannot create the transaction safely.',
      'When you finish a finance action, confirm the amount, date, fund account, and category that were used.',
    ];
    return parts.join('\n\n');
  }

  Future<void> _connect() async {
    final GeminiLiveSessionService? service = _service;
    if (service == null) {
      return;
    }

    setState(() {
      _initializing = true;
      _microphoneError = null;
      _micPermissionDenied = false;
    });

    try {
      await service.connect();
      await _startPassiveListening();
    } catch (e) {
      if (mounted) {
        showAppSnackBar(
          context,
          message: 'Gemini Live connection failed: $e',
          type: NotificationType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _initializing = false);
      }
    }
  }

  Future<void> _retrySession() async {
    final GeminiLiveSessionService? service = _service;
    if (service == null) {
      return;
    }

    await _stopPassiveListening(sendAudioStreamEnd: false);
    try {
      await service.disconnect();
    } catch (_) {}

    if (!mounted) {
      return;
    }

    setState(() {
      _inputLevel = 0.04;
      _userSpeaking = false;
      _microphoneError = null;
      _micPermissionDenied = false;
    });

    await _connect();
  }

  Future<void> _startPassiveListening() async {
    if (_recording) {
      return;
    }
    final GeminiLiveSessionService? service = _service;
    if (service == null || !service.connected) {
      return;
    }

    final bool hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      if (!mounted) {
        return;
      }
      setState(() {
        _micPermissionDenied = true;
        _microphoneError =
            'Microphone access is required for hands-free live voice.';
      });
      showAppSnackBar(
        context,
        message: 'Microphone permission is required for live voice mode.',
        type: NotificationType.warning,
      );
      return;
    }

    try {
      final Stream<Uint8List> stream = await _audioRecorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
        ),
      );

      _audioSubscription = stream.listen(
        (Uint8List chunk) {
          service.sendAudioChunk(chunk, sampleRate: 16000);
        },
        onError: (Object error, StackTrace stackTrace) {
          if (!mounted) {
            return;
          }
          setState(() {
            _microphoneError = 'Microphone stream failed: $error';
            _recording = false;
          });
        },
      );

      _amplitudeSubscription = _audioRecorder
          .onAmplitudeChanged(const Duration(milliseconds: 80))
          .listen((Amplitude amplitude) {
            if (!mounted) {
              return;
            }
            final double nextLevel = _normalizeAmplitude(amplitude.current);
            final bool speaking = nextLevel > 0.18;
            setState(() {
              _inputLevel = (_inputLevel * 0.42) + (nextLevel * 0.58);
              _userSpeaking = speaking;
            });
          });

      if (!mounted) {
        return;
      }

      setState(() {
        _recording = true;
        _inputLevel = 0.08;
        _microphoneError = null;
        _micPermissionDenied = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _microphoneError = 'Unable to start live microphone: $e';
      });
      showAppSnackBar(
        context,
        message: 'Unable to start live microphone: $e',
        type: NotificationType.error,
      );
    }
  }

  Future<void> _stopPassiveListening({bool sendAudioStreamEnd = true}) async {
    final GeminiLiveSessionService? service = _service;

    try {
      await _audioSubscription?.cancel();
    } catch (_) {}
    _audioSubscription = null;

    try {
      await _amplitudeSubscription?.cancel();
    } catch (_) {}
    _amplitudeSubscription = null;

    try {
      await _audioRecorder.stop();
    } catch (_) {}

    if (sendAudioStreamEnd && service?.connected == true) {
      service!.endAudioStream();
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _recording = false;
      _userSpeaking = false;
      _inputLevel = 0.04;
    });
  }

  static double _normalizeAmplitude(double decibels) {
    if (!decibels.isFinite) {
      return 0.0;
    }
    final double normalized = (decibels + 60.0) / 60.0;
    return normalized.clamp(0.0, 1.0);
  }

  void _scheduleTranscriptScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_transcriptScrollController.hasClients) {
        return;
      }
      final double target =
          _transcriptScrollController.position.maxScrollExtent;
      _transcriptScrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    });
  }

  String _assistantText(GeminiLiveSessionService service) {
    final String transcript = service.outputTranscript.trim();
    if (transcript.isNotEmpty) {
      return transcript;
    }
    return service.lastTextResponse.trim();
  }

  String _liveStatusLabel(GeminiLiveSessionService? service) {
    if (_initializing) {
      return 'Connecting';
    }
    if (_microphoneError != null) {
      return 'Needs attention';
    }
    if (service?.playingResponseAudio == true) {
      return 'Gemini speaking';
    }
    if (service?.awaitingModelTurn == true) {
      return 'Processing';
    }
    if (_userSpeaking) {
      return 'You are speaking';
    }
    if ((service?.connected ?? false) && _recording) {
      return 'Auto listening';
    }
    if (service?.connected == true) {
      return 'Connected';
    }
    return 'Offline';
  }

  String _liveStatusMessage(GeminiLiveSessionService? service) {
    if (_microphoneError != null) {
      return _microphoneError!;
    }
    if (_initializing) {
      return 'Opening the Gemini Live session and bringing the microphone online.';
    }
    if (service?.playingResponseAudio == true) {
      return 'Gemini is replying out loud and the text transcript stays visible below.';
    }
    if (service?.awaitingModelTurn == true) {
      return 'Pause naturally after speaking. Kelivo is sending the turn and waiting for Gemini.';
    }
    if (_userSpeaking) {
      return 'Microphone input is live. Keep talking and the waveform will follow your voice.';
    }
    if ((service?.connected ?? false) && _recording) {
      return 'Live mode is always on while this page is open. Speak naturally and pause when you are done.';
    }
    if (service?.lastError?.trim().isNotEmpty == true) {
      return service!.lastError!.trim();
    }
    return 'Live voice is idle until the session reconnects.';
  }

  String _waveCaption(GeminiLiveSessionService? service, String assistantName) {
    final String liveUserText = service?.inputTranscript.trim() ?? '';
    final String liveAssistantText = service == null
        ? ''
        : _assistantText(service);

    if (_micPermissionDenied) {
      return 'Microphone access is blocked. Allow microphone access and retry live voice.';
    }
    if (_userSpeaking && liveUserText.isNotEmpty) {
      return liveUserText;
    }
    if (service?.playingResponseAudio == true && liveAssistantText.isNotEmpty) {
      return liveAssistantText;
    }
    if (service?.awaitingModelTurn == true) {
      if (liveAssistantText.isNotEmpty) {
        return liveAssistantText;
      }
      if (liveUserText.isNotEmpty) {
        return liveUserText;
      }
      return '$assistantName is preparing a response.';
    }
    if ((service?.connected ?? false) && _recording) {
      return 'Speak whenever you want. Kelivo keeps listening and sends your turn automatically after you pause.';
    }
    return 'Retry the live session to bring the microphone back online.';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;
    final GeminiLiveSessionService? service = _service;
    final NavigatorState navigator = Navigator.of(context);
    final String assistantName =
        (widget.assistant?.name.trim().isNotEmpty ?? false)
        ? widget.assistant!.name.trim()
        : 'Gemini';

    final List<Widget> transcriptItems = _buildTranscriptItems(
      cs: cs,
      isDark: isDark,
      assistantName: assistantName,
      service: service,
    );

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$assistantName live'),
            Text(
              widget.modelId,
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          if (_microphoneError != null || service?.connected != true)
            IconButton(
              tooltip: 'Retry live voice',
              onPressed: _retrySession,
              icon: const Icon(LucideIcons.rotateCcw),
            ),
          TextButton(onPressed: navigator.maybePop, child: const Text('Close')),
          const SizedBox(width: 8),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              cs.surface,
              Color.alphaBlend(
                cs.primary.withValues(alpha: isDark ? 0.08 : 0.03),
                cs.surface,
              ),
              cs.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                _LiveHeaderCard(
                  assistantName: assistantName,
                  statusLabel: _liveStatusLabel(service),
                  statusMessage: _liveStatusMessage(service),
                  modelId: widget.modelId,
                  connected: service?.connected == true,
                  needsAttention: _microphoneError != null,
                ),
                const SizedBox(height: 16),
                _LiveWaveCard(
                  assistantName: assistantName,
                  caption: _waveCaption(service, assistantName),
                  onRetry:
                      (_microphoneError != null || service?.connected != true)
                      ? _retrySession
                      : null,
                  userSpeaking: _userSpeaking,
                  listening: _recording,
                  thinking: service?.awaitingModelTurn == true,
                  assistantSpeaking: service?.playingResponseAudio == true,
                  inputLevel: _inputLevel,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _TranscriptPanel(
                    scrollController: _transcriptScrollController,
                    assistantName: assistantName,
                    items: transcriptItems,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTranscriptItems({
    required ColorScheme cs,
    required bool isDark,
    required String assistantName,
    required GeminiLiveSessionService? service,
  }) {
    final List<Widget> items = <Widget>[];

    for (final _LiveTranscriptTurn turn in _turns) {
      if (turn.userText.isNotEmpty) {
        items.add(
          _TranscriptBubble(
            label: 'You',
            text: turn.userText,
            icon: LucideIcons.mic,
            alignRight: true,
            isPreview: false,
          ),
        );
      }
      if (turn.assistantText.isNotEmpty) {
        items.add(
          _TranscriptBubble(
            label: assistantName,
            text: turn.assistantText,
            icon: LucideIcons.bot,
            alignRight: false,
            isPreview: false,
          ),
        );
      }
    }

    final String liveUserText = service?.inputTranscript.trim() ?? '';
    final String liveAssistantText = service == null
        ? ''
        : _assistantText(service).trim();
    final bool showLivePreview =
        _userSpeaking ||
        service?.awaitingModelTurn == true ||
        service?.playingResponseAudio == true;

    if (showLivePreview && liveUserText.isNotEmpty) {
      items.add(
        _TranscriptBubble(
          label: 'You',
          text: liveUserText,
          icon: LucideIcons.mic,
          alignRight: true,
          isPreview: true,
        ),
      );
    }

    if (showLivePreview && liveAssistantText.isNotEmpty) {
      items.add(
        _TranscriptBubble(
          label: assistantName,
          text: liveAssistantText,
          icon: LucideIcons.bot,
          alignRight: false,
          isPreview: true,
        ),
      );
    }

    return items;
  }
}

class _LiveHeaderCard extends StatelessWidget {
  const _LiveHeaderCard({
    required this.assistantName,
    required this.statusLabel,
    required this.statusMessage,
    required this.modelId,
    required this.connected,
    required this.needsAttention,
  });

  final String assistantName;
  final String statusLabel;
  final String statusMessage;
  final String modelId;
  final bool connected;
  final bool needsAttention;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _panelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AssistantGlyph(name: assistantName, connected: connected),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assistantName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hands-free live voice assistant',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(
                label: statusLabel,
                color: needsAttention
                    ? cs.error
                    : connected
                    ? cs.primary
                    : cs.outline,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            statusMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
              color: cs.onSurface.withValues(alpha: isDark ? 0.88 : 0.78),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetaChip(icon: LucideIcons.mic, label: 'Always listening'),
              _MetaChip(
                icon: LucideIcons.badgeCheck,
                label: 'Auto send after pause',
              ),
              _MetaChip(icon: LucideIcons.cpu, label: modelId),
            ],
          ),
        ],
      ),
    );
  }
}

class _LiveWaveCard extends StatelessWidget {
  const _LiveWaveCard({
    required this.assistantName,
    required this.caption,
    required this.onRetry,
    required this.userSpeaking,
    required this.listening,
    required this.thinking,
    required this.assistantSpeaking,
    required this.inputLevel,
  });

  final String assistantName;
  final String caption;
  final VoidCallback? onRetry;
  final bool userSpeaking;
  final bool listening;
  final bool thinking;
  final bool assistantSpeaking;
  final double inputLevel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _panelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.audioWaveform, size: 18, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                'Voice channel',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              if (onRetry != null)
                TextButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(LucideIcons.rotateCcw, size: 16),
                  label: const Text('Retry'),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cs.primary.withValues(alpha: 0.12),
                  cs.secondary.withValues(alpha: 0.06),
                ],
              ),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.12),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 152,
                  child: _AnimatedVoiceWaveform(
                    level: inputLevel,
                    listening: listening,
                    userSpeaking: userSpeaking,
                    assistantSpeaking: assistantSpeaking,
                    thinking: thinking,
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Text(
                    caption,
                    key: ValueKey<String>(caption),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TranscriptPanel extends StatelessWidget {
  const _TranscriptPanel({
    required this.scrollController,
    required this.assistantName,
    required this.items,
  });

  final ScrollController scrollController;
  final String assistantName;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: _panelDecoration(context),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
            child: Row(
              children: [
                Icon(LucideIcons.messagesSquare, size: 18, color: cs.primary),
                const SizedBox(width: 8),
                Text(
                  'Transcript',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text(
                  items.isEmpty ? 'No speech yet' : 'Live text output',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Start speaking and the live conversation with $assistantName will appear here.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ),
                  )
                : Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    child: ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, int index) => items[index],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _TranscriptBubble extends StatelessWidget {
  const _TranscriptBubble({
    required this.label,
    required this.text,
    required this.icon,
    required this.alignRight,
    required this.isPreview,
  });

  final String label;
  final String text;
  final IconData icon;
  final bool alignRight;
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;
    final Color bubbleColor = alignRight
        ? cs.primaryContainer.withValues(alpha: isDark ? 0.52 : 0.94)
        : cs.surfaceContainerHighest.withValues(alpha: isDark ? 0.72 : 0.98);

    return Align(
      alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: cs.outlineVariant.withValues(
                alpha: isPreview ? 0.22 : 0.12,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 15, color: cs.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(
                    isPreview ? '$label now' : label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedVoiceWaveform extends StatefulWidget {
  const _AnimatedVoiceWaveform({
    required this.level,
    required this.listening,
    required this.userSpeaking,
    required this.assistantSpeaking,
    required this.thinking,
  });

  final double level;
  final bool listening;
  final bool userSpeaking;
  final bool assistantSpeaking;
  final bool thinking;

  @override
  State<_AnimatedVoiceWaveform> createState() => _AnimatedVoiceWaveformState();
}

class _AnimatedVoiceWaveformState extends State<_AnimatedVoiceWaveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final int bars = constraints.maxWidth > 680 ? 29 : 21;
            final double spacing = constraints.maxWidth > 680 ? 6 : 5;
            final double barWidth =
                (constraints.maxWidth - (bars - 1) * spacing) / bars;
            final double maxBarHeight = constraints.maxHeight * 0.88;

            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            cs.primary.withValues(alpha: 0.14),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List<Widget>.generate(bars, (int index) {
                    final double phase =
                        (_controller.value * 2 * math.pi) + (index * 0.46);
                    final double wave = (math.sin(phase) + 1) / 2;
                    final double intensity = _barIntensity(index, wave);
                    final double barHeight =
                        14 + (maxBarHeight - 14) * intensity.clamp(0.0, 1.0);
                    final Color barColor = _barColor(cs, wave);

                    return Padding(
                      padding: EdgeInsets.only(
                        right: index == bars - 1 ? 0 : spacing,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 90),
                          width: barWidth.clamp(4.0, 10.0),
                          height: barHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: barColor,
                            boxShadow:
                                widget.userSpeaking || widget.assistantSpeaking
                                ? [
                                    BoxShadow(
                                      color: barColor.withValues(alpha: 0.18),
                                      blurRadius: 14,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        );
      },
    );
  }

  double _barIntensity(int index, double wave) {
    if (widget.userSpeaking) {
      final double seeded = 0.35 + 0.65 * wave;
      return (0.18 + widget.level * 0.82) * seeded;
    }
    if (widget.assistantSpeaking) {
      return 0.18 + 0.34 * wave;
    }
    if (widget.thinking) {
      return 0.12 + 0.16 * wave;
    }
    if (widget.listening) {
      return 0.05 + 0.08 * wave;
    }
    return 0.03 + 0.02 * wave;
  }

  Color _barColor(ColorScheme cs, double wave) {
    if (widget.userSpeaking) {
      return Color.lerp(
            cs.primary.withValues(alpha: 0.78),
            cs.secondary.withValues(alpha: 0.92),
            wave,
          ) ??
          cs.primary;
    }
    if (widget.assistantSpeaking) {
      return Color.lerp(
            cs.secondary.withValues(alpha: 0.76),
            cs.tertiary.withValues(alpha: 0.92),
            wave,
          ) ??
          cs.secondary;
    }
    if (widget.thinking) {
      return cs.tertiary.withValues(alpha: 0.58 + 0.18 * wave);
    }
    if (widget.listening) {
      return cs.primary.withValues(alpha: 0.26 + 0.10 * wave);
    }
    return cs.outlineVariant.withValues(alpha: 0.26);
  }
}

class _AssistantGlyph extends StatelessWidget {
  const _AssistantGlyph({required this.name, required this.connected});

  final String name;
  final bool connected;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final String initial = name.trim().isEmpty
        ? 'G'
        : name.trim()[0].toUpperCase();

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            cs.primary.withValues(alpha: 0.88),
            cs.secondary.withValues(alpha: 0.74),
          ],
        ),
      ),
      alignment: Alignment.center,
      child: connected
          ? Text(
              initial,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: cs.onPrimary,
                fontWeight: FontWeight.w800,
              ),
            )
          : Icon(LucideIcons.sparkles, color: cs.onPrimary),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(AppRadii.capsule),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _LiveTranscriptTurn {
  const _LiveTranscriptTurn({
    required this.userText,
    required this.assistantText,
    required this.timestamp,
  });

  final String userText;
  final String assistantText;
  final DateTime timestamp;
}

BoxDecoration _panelDecoration(BuildContext context) {
  final ThemeData theme = Theme.of(context);
  final ColorScheme cs = theme.colorScheme;
  final bool isDark = theme.brightness == Brightness.dark;

  return BoxDecoration(
    color: cs.surfaceContainerHigh.withValues(alpha: isDark ? 0.62 : 0.96),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: cs.outlineVariant.withValues(alpha: isDark ? 0.14 : 0.10),
    ),
  );
}
