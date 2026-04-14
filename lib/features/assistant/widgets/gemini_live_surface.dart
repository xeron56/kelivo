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
import '../../../shared/widgets/snackbar.dart';
import '../../../theme/design_tokens.dart';
import '../../home/services/tool_handler_service.dart';

class GeminiLiveSurface extends StatefulWidget {
  const GeminiLiveSurface({
    super.key,
    required this.providerConfig,
    required this.assistant,
    this.modelId = 'gemini-3.1-flash-live-preview',
    this.autoStart = false,
    this.embedded = false,
    this.showHeader = true,
  });

  final ProviderConfig providerConfig;
  final Assistant? assistant;
  final String modelId;
  final bool autoStart;
  final bool embedded;
  final bool showHeader;

  @override
  State<GeminiLiveSurface> createState() => _GeminiLiveSurfaceState();
}

class _GeminiLiveSurfaceState extends State<GeminiLiveSurface> {
  static const int _waveHistorySize = 24;

  final AudioRecorder _audioRecorder = AudioRecorder();
  final ScrollController _transcriptScrollController = ScrollController();

  GeminiLiveSessionService? _service;
  StreamSubscription<Uint8List>? _audioSubscription;
  Timer? _waveTicker;

  final List<_LiveTranscriptTurn> _turns = <_LiveTranscriptTurn>[];
  final List<double> _userWaveHistory = List<double>.generate(
    _waveHistorySize,
    (_) => 0.0,
    growable: true,
  );
  final List<double> _assistantWaveHistory = List<double>.generate(
    _waveHistorySize,
    (_) => 0.0,
    growable: true,
  );

  bool _initializing = false;
  bool _sessionActive = false;
  bool _recording = false;
  bool _userSpeaking = false;
  bool _lastAwaitingModelTurn = false;
  bool _lastPlayingResponseAudio = false;
  bool _pendingTurnReady = false;
  bool _micPermissionDenied = false;
  String? _microphoneError;
  double _inputLevel = 0.0;
  DateTime? _lastInputFrameAt;
  int _observedTurnSequence = 0;
  String _draftUserText = '';
  String _draftAssistantText = '';

  @override
  void initState() {
    super.initState();
    _createService();
    _startWaveTicker();
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_startSession());
      });
    }
  }

  @override
  void didUpdateWidget(covariant GeminiLiveSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool configChanged =
        oldWidget.providerConfig.id != widget.providerConfig.id ||
        oldWidget.providerConfig.apiKey != widget.providerConfig.apiKey ||
        oldWidget.modelId != widget.modelId ||
        oldWidget.assistant?.id != widget.assistant?.id ||
        oldWidget.assistant?.systemPrompt != widget.assistant?.systemPrompt;
    if (configChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(
          _recreateService(restart: _sessionActive || widget.autoStart),
        );
      });
    }
  }

  @override
  void dispose() {
    _waveTicker?.cancel();
    unawaited(_stopSession());
    _service?.removeListener(_handleServiceChanged);
    _service?.dispose();
    _transcriptScrollController.dispose();
    unawaited(_audioRecorder.dispose());
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

    _service = GeminiLiveSessionService(
      providerConfig: widget.providerConfig,
      modelId: widget.modelId,
      systemInstruction: _buildSystemInstruction(
        widget.assistant,
        functionDeclarations.isNotEmpty,
      ),
      functionDeclarations: functionDeclarations,
      toolHandler: toolHandler.buildToolCallHandler(settings, widget.assistant),
    )..addListener(_handleServiceChanged);
  }

  Future<void> _recreateService({required bool restart}) async {
    final GeminiLiveSessionService? oldService = _service;
    oldService?.removeListener(_handleServiceChanged);
    await _stopSession();
    oldService?.dispose();
    if (!mounted) {
      return;
    }
    _createService();
    if (restart) {
      await _startSession();
    }
  }

  void _handleServiceChanged() {
    if (!mounted) {
      return;
    }

    final GeminiLiveSessionService? service = _service;
    final bool awaiting = service?.awaitingModelTurn ?? false;
    final bool receivingInputTurn = service?.receivingInputTurn ?? false;
    final bool playingResponseAudio = service?.playingResponseAudio ?? false;
    final int turnSequence = service?.turnSequence ?? _observedTurnSequence;
    final String liveUserText = service?.inputTranscript.trim() ?? '';
    final String liveAssistantText = service == null
        ? ''
        : _assistantText(service).trim();
    bool shouldScroll = false;

    setState(() {
      if (turnSequence != _observedTurnSequence) {
        shouldScroll =
            _appendCommittedTurn(
              userText: _draftUserText,
              assistantText: _draftAssistantText,
            ) ||
            shouldScroll;
        _draftUserText = '';
        _draftAssistantText = '';
        _pendingTurnReady = false;
        _observedTurnSequence = turnSequence;
      }

      if (liveUserText.isNotEmpty) {
        _draftUserText = liveUserText;
      }
      if (receivingInputTurn) {
        _draftAssistantText = '';
      } else if (liveAssistantText.isNotEmpty) {
        _draftAssistantText = liveAssistantText;
      }

      if (_lastAwaitingModelTurn && !awaiting) {
        _pendingTurnReady = true;
        if (!playingResponseAudio) {
          shouldScroll = _finalizePendingTurn();
        }
      } else if (_lastPlayingResponseAudio &&
          !playingResponseAudio &&
          _pendingTurnReady) {
        shouldScroll = _finalizePendingTurn();
      }

      if (_sessionActive &&
          service != null &&
          !service.connected &&
          !_initializing) {
        _sessionActive = false;
      }

      _lastAwaitingModelTurn = awaiting;
      _lastPlayingResponseAudio = playingResponseAudio;
    });

    if (service != null && !service.connected && _recording && !_initializing) {
      unawaited(_stopMicrophone(sendAudioStreamEnd: false));
    }

    if (shouldScroll) {
      _scheduleTranscriptScroll();
    }
  }

  static String _buildSystemInstruction(Assistant? assistant, bool hasTools) {
    final List<String> parts = <String>[
      if ((assistant?.systemPrompt ?? '').trim().isNotEmpty)
        assistant!.systemPrompt.trim(),
      'You are Kelivo live voice mode.',
      'Keep spoken answers natural, short, and direct.',
      'Use any available tools when the user asks you to act inside the app or fetch live app data.',
      if (hasTools)
        'If a requested action is ambiguous, ask one short follow-up instead of guessing.',
    ];
    return parts.join('\n\n');
  }

  Future<void> _startSession() async {
    final GeminiLiveSessionService? service = _service;
    if (service == null || _initializing || _sessionActive) {
      return;
    }

    setState(() {
      _initializing = true;
      _microphoneError = null;
      _micPermissionDenied = false;
    });

    try {
      await service.connect();
      final bool microphoneReady = await _startMicrophone();
      if (!microphoneReady) {
        await service.disconnect(notify: false);
        return;
      }
      if (!mounted) {
        return;
      }
      setState(() {
        _sessionActive = true;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      showAppSnackBar(
        context,
        message: 'Gemini Live connection failed: $e',
        type: NotificationType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _initializing = false;
        });
      }
    }
  }

  Future<void> _stopSession() async {
    final GeminiLiveSessionService? service = _service;
    await _stopMicrophone(sendAudioStreamEnd: false);
    try {
      await service?.disconnect(notify: false);
    } catch (_) {}

    if (!mounted) {
      return;
    }

    setState(() {
      _sessionActive = false;
      _initializing = false;
      _userSpeaking = false;
      _inputLevel = 0.0;
      _lastInputFrameAt = null;
      _observedTurnSequence = 0;
      _lastAwaitingModelTurn = false;
      _lastPlayingResponseAudio = false;
      _pendingTurnReady = false;
      _draftUserText = '';
      _draftAssistantText = '';
      _userWaveHistory.fillRange(0, _userWaveHistory.length, 0.0);
      _assistantWaveHistory.fillRange(0, _assistantWaveHistory.length, 0.0);
    });
  }

  Future<void> _toggleSession() async {
    if (_sessionActive || _initializing) {
      await _stopSession();
      return;
    }
    await _startSession();
  }

  Future<void> _retrySession() async {
    await _stopSession();
    await _startSession();
  }

  Future<bool> _startMicrophone() async {
    if (_recording) {
      return true;
    }
    final GeminiLiveSessionService? service = _service;
    if (service == null || !service.connected) {
      return false;
    }

    final bool hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      if (!mounted) {
        return false;
      }
      setState(() {
        _micPermissionDenied = true;
        _microphoneError =
            'Microphone access is required to start the live voice session.';
      });
      showAppSnackBar(
        context,
        message: 'Microphone permission is required for live voice mode.',
        type: NotificationType.warning,
      );
      return false;
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
          _inputLevel = _estimatePcmLevel(chunk);
          _userSpeaking = _inputLevel > 0.055;
          _lastInputFrameAt = DateTime.now();
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

      if (!mounted) {
        return false;
      }
      setState(() {
        _recording = true;
        _microphoneError = null;
        _micPermissionDenied = false;
      });
      return true;
    } catch (e) {
      if (!mounted) {
        return false;
      }
      setState(() {
        _microphoneError = 'Unable to start live microphone: $e';
      });
      showAppSnackBar(
        context,
        message: 'Unable to start live microphone: $e',
        type: NotificationType.error,
      );
      return false;
    }
  }

  Future<void> _stopMicrophone({bool sendAudioStreamEnd = true}) async {
    final GeminiLiveSessionService? service = _service;

    try {
      await _audioSubscription?.cancel();
    } catch (_) {}
    _audioSubscription = null;

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
      _inputLevel = 0.0;
      _lastInputFrameAt = null;
    });
  }

  void _startWaveTicker() {
    _waveTicker?.cancel();
    _waveTicker = Timer.periodic(const Duration(milliseconds: 52), (_) {
      if (!mounted) {
        return;
      }
      final GeminiLiveSessionService? service = _service;
      final DateTime now = DateTime.now();
      final bool inputSignalFresh =
          _lastInputFrameAt != null &&
          now.difference(_lastInputFrameAt!) <
              const Duration(milliseconds: 180);
      if (!inputSignalFresh) {
        _inputLevel = 0.0;
        _userSpeaking = false;
      }
      final double userSample = (_sessionActive && _recording)
          ? (inputSignalFresh ? _inputLevel.clamp(0.0, 1.0) : 0.0)
          : 0.0;
      final double assistantSample = (service?.playingResponseAudio == true)
          ? service!.outputLevel.clamp(0.0, 1.0)
          : 0.0;
      setState(() {
        _pushHistoryValue(
          _userWaveHistory,
          userSample < 0.04 ? 0.0 : userSample,
        );
        _pushHistoryValue(
          _assistantWaveHistory,
          assistantSample < 0.03 ? 0.0 : assistantSample,
        );
      });
    });
  }

  void _pushHistoryValue(List<double> history, double value) {
    history
      ..removeAt(0)
      ..add(value);
  }

  bool _appendCommittedTurn({
    required String userText,
    required String assistantText,
  }) {
    final String user = userText.trim();
    final String assistant = assistantText.trim();
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
    if (_turns.length > 24) {
      _turns.removeAt(0);
    }
    return true;
  }

  bool _finalizePendingTurn() {
    final bool committed = _appendCommittedTurn(
      userText: _draftUserText,
      assistantText: _draftAssistantText,
    );
    _draftUserText = '';
    _draftAssistantText = '';
    _pendingTurnReady = false;
    return committed;
  }

  static double _estimatePcmLevel(Uint8List chunk) {
    if (chunk.lengthInBytes < 2) {
      return 0.0;
    }

    final ByteData bytes = chunk.buffer.asByteData();
    double sumSquares = 0.0;
    int sampleCount = 0;
    for (int offset = 0; offset + 1 < chunk.lengthInBytes; offset += 2) {
      final int sample = bytes.getInt16(offset, Endian.little);
      final double normalized = sample / 32768.0;
      sumSquares += normalized * normalized;
      sampleCount++;
    }

    if (sampleCount == 0) {
      return 0.0;
    }

    final double rms = math.sqrt(sumSquares / sampleCount);
    if (rms < 0.015) {
      return 0.0;
    }
    return (rms * 3.6).clamp(0.0, 1.0);
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
        duration: const Duration(milliseconds: 240),
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

  String _statusLabel(GeminiLiveSessionService? service) {
    if (_initializing) {
      return 'Starting';
    }
    if (_microphoneError != null) {
      return 'Needs attention';
    }
    if (!_sessionActive) {
      return 'Inactive';
    }
    if (service?.playingResponseAudio == true) {
      return 'Assistant speaking';
    }
    if (service?.awaitingModelTurn == true) {
      return 'Processing';
    }
    if (_userSpeaking) {
      return 'Listening to you';
    }
    return 'Waiting for voice';
  }

  String _statusMessage(
    GeminiLiveSessionService? service,
    String assistantName,
  ) {
    if (_microphoneError != null) {
      return _microphoneError!;
    }
    if (!_sessionActive) {
      return 'Tap the center button to start a live voice session with $assistantName, or type below to chat by text.';
    }
    if (_initializing) {
      return 'Starting the microphone and opening the live session.';
    }
    if (service?.playingResponseAudio == true) {
      return '$assistantName is speaking now, and the transcript below stays separated by speaker.';
    }
    if (service?.awaitingModelTurn == true) {
      return '$assistantName is processing your last turn.';
    }
    if (_userSpeaking) {
      return 'Your microphone signal is live. The waveform follows your voice in real time.';
    }
    return 'Session is active. Start speaking whenever you are ready.';
  }

  String _centerCaption(
    GeminiLiveSessionService? service,
    String assistantName,
  ) {
    final String liveUserText = _draftUserText.trim();
    final String liveAssistantText = _draftAssistantText.trim();

    if (!_sessionActive) {
      return 'Live mode ready';
    }
    if (_micPermissionDenied) {
      return 'Microphone permission is blocked.';
    }
    if (service?.playingResponseAudio == true && liveAssistantText.isNotEmpty) {
      return liveAssistantText;
    }
    if (_userSpeaking && liveUserText.isNotEmpty) {
      return liveUserText;
    }
    if (service?.awaitingModelTurn == true) {
      return liveAssistantText.isNotEmpty
          ? liveAssistantText
          : '$assistantName is preparing a response.';
    }
    return 'Listening for your next question';
  }

  List<_LiveTranscriptTurn> _transcriptTurns() {
    final List<_LiveTranscriptTurn> turns = List<_LiveTranscriptTurn>.of(
      _turns,
    );
    if (_draftUserText.trim().isNotEmpty ||
        _draftAssistantText.trim().isNotEmpty) {
      turns.add(
        _LiveTranscriptTurn(
          userText: _draftUserText.trim(),
          assistantText: _draftAssistantText.trim(),
          timestamp: DateTime.now(),
          isLive: true,
        ),
      );
    }
    return turns;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final GeminiLiveSessionService? service = _service;
    final String assistantName =
        (widget.assistant?.name.trim().isNotEmpty ?? false)
        ? widget.assistant!.name.trim()
        : 'Assistant';

    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showHeader)
          _LiveHeaderCard(
            assistantName: assistantName,
            modelId: widget.modelId,
            statusLabel: _statusLabel(service),
            statusMessage: _statusMessage(service, assistantName),
            sessionActive: _sessionActive,
            needsAttention: _microphoneError != null,
          ),
        if (widget.showHeader) const SizedBox(height: 14),
        _InteractiveLiveCard(
          assistantName: assistantName,
          userSamples: _userWaveHistory,
          assistantSamples: _assistantWaveHistory,
          compact: widget.embedded,
          sessionActive: _sessionActive,
          userSpeaking: _userSpeaking,
          assistantSpeaking: service?.playingResponseAudio == true,
          thinking: service?.awaitingModelTurn == true,
          initializing: _initializing,
          onPrimaryAction: _toggleSession,
          onRetry: (_microphoneError != null && !_initializing)
              ? _retrySession
              : null,
          caption: _centerCaption(service, assistantName),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: widget.embedded ? 184 : 340,
          child: _TranscriptPanel(
            scrollController: _transcriptScrollController,
            assistantName: assistantName,
            turns: _transcriptTurns(),
            compact: widget.embedded,
          ),
        ),
      ],
    );

    if (widget.embedded) {
      return content;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            cs.surface,
            Color.alphaBlend(cs.primary.withValues(alpha: 0.04), cs.surface),
            cs.surface,
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: content,
        ),
      ),
    );
  }
}

class _LiveHeaderCard extends StatelessWidget {
  const _LiveHeaderCard({
    required this.assistantName,
    required this.modelId,
    required this.statusLabel,
    required this.statusMessage,
    required this.sessionActive,
    required this.needsAttention,
  });

  final String assistantName;
  final String modelId;
  final String statusLabel;
  final String statusMessage;
  final bool sessionActive;
  final bool needsAttention;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AssistantGlyph(
                name: assistantName,
                active: sessionActive && !needsAttention,
              ),
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
                      'Live voice on the home screen',
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
                    : sessionActive
                    ? cs.primary
                    : cs.outline,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            statusMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.45,
              color: cs.onSurface.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetaChip(icon: LucideIcons.mic, label: 'Voice + text'),
              _MetaChip(
                icon: LucideIcons.audioWaveform,
                label: 'Live waveform',
              ),
              _MetaChip(icon: LucideIcons.cpu, label: modelId),
            ],
          ),
        ],
      ),
    );
  }
}

class _InteractiveLiveCard extends StatelessWidget {
  const _InteractiveLiveCard({
    required this.assistantName,
    required this.userSamples,
    required this.assistantSamples,
    required this.compact,
    required this.sessionActive,
    required this.userSpeaking,
    required this.assistantSpeaking,
    required this.thinking,
    required this.initializing,
    required this.onPrimaryAction,
    required this.onRetry,
    required this.caption,
  });

  final String assistantName;
  final List<double> userSamples;
  final List<double> assistantSamples;
  final bool compact;
  final bool sessionActive;
  final bool userSpeaking;
  final bool assistantSpeaking;
  final bool thinking;
  final bool initializing;
  final VoidCallback onPrimaryAction;
  final VoidCallback? onRetry;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 14 : 18),
      decoration: _panelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.audioWaveform, size: 18, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                'Live mode',
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
          SizedBox(height: compact ? 12 : 18),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              compact ? 14 : 16,
              compact ? 14 : 18,
              compact ? 14 : 16,
              compact ? 14 : 18,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cs.primary.withValues(alpha: 0.10),
                  cs.secondary.withValues(alpha: 0.05),
                ],
              ),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.14),
              ),
            ),
            child: Column(
              children: [
                _WaveLane(
                  compact: compact,
                  label: 'You',
                  samples: userSamples,
                  color: cs.primary,
                  active: sessionActive,
                  emphasis: userSpeaking,
                  status: userSpeaking
                      ? 'Speaking'
                      : sessionActive
                      ? 'Microphone ready'
                      : 'Idle',
                ),
                SizedBox(height: compact ? 12 : 18),
                _CenterLiveButton(
                  compact: compact,
                  sessionActive: sessionActive,
                  initializing: initializing,
                  onTap: onPrimaryAction,
                ),
                SizedBox(height: compact ? 10 : 14),
                Text(
                  caption,
                  textAlign: TextAlign.center,
                  maxLines: compact ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                ),
                SizedBox(height: compact ? 12 : 18),
                _WaveLane(
                  compact: compact,
                  label: assistantName,
                  samples: assistantSamples,
                  color: cs.secondary,
                  active: sessionActive,
                  emphasis: assistantSpeaking,
                  status: assistantSpeaking
                      ? 'Speaking'
                      : thinking
                      ? 'Thinking'
                      : sessionActive
                      ? 'Waiting'
                      : 'Inactive',
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
    required this.turns,
    required this.compact,
  });

  final ScrollController scrollController;
  final String assistantName;
  final List<_LiveTranscriptTurn> turns;
  final bool compact;

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
            padding: EdgeInsets.fromLTRB(18, compact ? 12 : 16, 18, 10),
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
                  turns.isEmpty ? 'No live turns yet' : 'Separated by speaker',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: turns.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Start live mode to capture voice turns here. Your speech and the assistant response stay in separate sections.',
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
                      padding: EdgeInsets.fromLTRB(
                        18,
                        compact ? 10 : 14,
                        18,
                        compact ? 14 : 18,
                      ),
                      itemCount: turns.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, int index) {
                        final _LiveTranscriptTurn turn = turns[index];
                        return _TranscriptTurnCard(
                          assistantName: assistantName,
                          turn: turn,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _TranscriptTurnCard extends StatelessWidget {
  const _TranscriptTurnCard({required this.assistantName, required this.turn});

  final String assistantName;
  final _LiveTranscriptTurn turn;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(
          alpha: isDark ? 0.52 : 0.92,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: turn.isLive
              ? cs.primary.withValues(alpha: 0.20)
              : cs.outlineVariant.withValues(alpha: 0.12),
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                turn.isLive ? LucideIcons.activity : LucideIcons.history,
                size: 16,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                turn.isLive ? 'Live turn' : _formatTimestamp(turn.timestamp),
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (turn.userText.isNotEmpty) ...[
            const SizedBox(height: 12),
            _TranscriptSpeakerBlock(
              title: 'You said',
              icon: LucideIcons.mic,
              text: turn.userText,
              color: cs.primary,
              alignRight: true,
            ),
          ],
          if (turn.assistantText.isNotEmpty) ...[
            const SizedBox(height: 10),
            _TranscriptSpeakerBlock(
              title: '$assistantName replied',
              icon: LucideIcons.bot,
              text: turn.assistantText,
              color: cs.secondary,
              alignRight: false,
            ),
          ],
        ],
      ),
    );
  }

  static String _formatTimestamp(DateTime timestamp) {
    final String hour = timestamp.hour.toString().padLeft(2, '0');
    final String minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _TranscriptSpeakerBlock extends StatelessWidget {
  const _TranscriptSpeakerBlock({
    required this.title,
    required this.icon,
    required this.text,
    required this.color,
    required this.alignRight,
  });

  final String title;
  final IconData icon;
  final String text;
  final Color color;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final Color fill = Color.alphaBlend(
      color.withValues(alpha: isDark ? 0.18 : 0.12),
      cs.surface,
    );

    return Align(
      alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withValues(alpha: 0.18)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 15, color: color),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: color,
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

class _WaveLane extends StatelessWidget {
  const _WaveLane({
    required this.compact,
    required this.label,
    required this.samples,
    required this.color,
    required this.active,
    required this.emphasis,
    required this.status,
  });

  final String label;
  final bool compact;
  final List<double> samples;
  final Color color;
  final bool active;
  final bool emphasis;
  final String status;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Text(
              status,
              style: theme.textTheme.labelMedium?.copyWith(
                color: emphasis ? color : cs.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: compact ? 6 : 8),
        SizedBox(
          height: compact ? 48 : 58,
          child: CustomPaint(
            painter: _WaveformPainter(
              samples: samples,
              color: color,
              idleColor: cs.outlineVariant,
              active: active,
              emphasis: emphasis,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ],
    );
  }
}

class _CenterLiveButton extends StatelessWidget {
  const _CenterLiveButton({
    required this.compact,
    required this.sessionActive,
    required this.initializing,
    required this.onTap,
  });

  final bool compact;
  final bool sessionActive;
  final bool initializing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: compact ? 76 : 92,
            height: compact ? 76 : 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: sessionActive
                    ? [
                        cs.secondary.withValues(alpha: 0.92),
                        cs.primary.withValues(alpha: 0.82),
                      ]
                    : [
                        cs.primary.withValues(alpha: 0.92),
                        cs.tertiary.withValues(alpha: 0.72),
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: (sessionActive ? cs.secondary : cs.primary).withValues(
                    alpha: 0.20,
                  ),
                  blurRadius: 28,
                  spreadRadius: 2,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: initializing
                ? SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.6,
                      valueColor: AlwaysStoppedAnimation<Color>(cs.onPrimary),
                    ),
                  )
                : Icon(
                    sessionActive ? LucideIcons.square : LucideIcons.mic,
                    color: cs.onPrimary,
                    size: compact ? 24 : 28,
                  ),
          ),
        ),
        SizedBox(height: compact ? 8 : 10),
        Text(
          initializing
              ? 'Starting'
              : sessionActive
              ? 'Stop live'
              : 'Start live',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _WaveformPainter extends CustomPainter {
  const _WaveformPainter({
    required this.samples,
    required this.color,
    required this.idleColor,
    required this.active,
    required this.emphasis,
  });

  final List<double> samples;
  final Color color;
  final Color idleColor;
  final bool active;
  final bool emphasis;

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.isEmpty) {
      return;
    }

    final Paint baseline = Paint()
      ..color = idleColor.withValues(alpha: 0.16)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      baseline,
    );

    final double slotWidth = size.width / samples.length;
    final double barWidth = slotWidth.clamp(2.0, 12.0) * 0.62;
    final double radius = barWidth / 2;

    for (int index = 0; index < samples.length; index++) {
      final double sample = samples[index].clamp(0.0, 1.0);
      final double visibleLevel = active ? sample : sample * 0.35;
      final double barHeight = visibleLevel == 0.0
          ? 2.0
          : 2.0 + (size.height - 6) * visibleLevel;
      final double x = (index * slotWidth) + ((slotWidth - barWidth) / 2);
      final double y = (size.height - barHeight) / 2;

      final Paint paint = Paint()
        ..color =
            Color.lerp(
              idleColor.withValues(alpha: active ? 0.18 : 0.10),
              color.withValues(alpha: emphasis ? 0.96 : 0.78),
              visibleLevel == 0.0 ? 0.0 : (0.25 + (visibleLevel * 0.75)),
            ) ??
            color;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight),
          Radius.circular(radius),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return true;
  }
}

class _AssistantGlyph extends StatelessWidget {
  const _AssistantGlyph({required this.name, required this.active});

  final String name;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final String initial = name.trim().isEmpty
        ? 'A'
        : name.trim()[0].toUpperCase();

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: active
              ? [
                  cs.primary.withValues(alpha: 0.92),
                  cs.secondary.withValues(alpha: 0.78),
                ]
              : [cs.surfaceContainerHighest, cs.surfaceContainerHigh],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: active ? cs.onPrimary : cs.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
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
        borderRadius: BorderRadius.circular(AppRadii.capsule),
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
        color: cs.surfaceContainerHighest.withValues(alpha: 0.78),
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
    this.isLive = false,
  });

  final String userText;
  final String assistantText;
  final DateTime timestamp;
  final bool isLive;
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
