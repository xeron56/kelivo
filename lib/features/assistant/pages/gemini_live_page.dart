import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

import '../../../core/models/assistant.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/providers/tts_provider.dart';
import '../../../core/services/api/gemini_live_session_service.dart';
import '../../../features/home/services/tool_handler_service.dart';
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
  final TextEditingController _textController = TextEditingController();

  GeminiLiveSessionService? _service;
  StreamSubscription<Uint8List>? _audioSubscription;
  bool _initializing = true;
  bool _recording = false;
  String _lastSpokenResponse = '';

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
    unawaited(_stopRecording());
    _service?.removeListener(_handleServiceChanged);
    _textController.dispose();
    _audioRecorder.dispose();
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
    if (service != null && !service.awaitingModelTurn) {
      final String response = service.lastTextResponse.trim();
      if (response.isNotEmpty && response != _lastSpokenResponse) {
        _lastSpokenResponse = response;
        unawaited(_speakAssistantResponse(response));
      }
    }
    setState(() {});
  }

  Future<void> _speakAssistantResponse(String text) async {
    try {
      await context.read<TtsProvider>().speak(text);
    } catch (_) {}
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
    setState(() => _initializing = true);
    try {
      await service.connect();
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

  Future<void> _toggleRecording() async {
    if (_recording) {
      await _stopRecording();
      return;
    }

    final GeminiLiveSessionService? service = _service;
    if (service == null || !service.connected) {
      showAppSnackBar(
        context,
        message: 'Live session is not connected yet.',
        type: NotificationType.warning,
      );
      return;
    }

    final bool hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      if (!mounted) {
        return;
      }
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
      _audioSubscription = stream.listen((Uint8List chunk) {
        service.sendAudioChunk(chunk, sampleRate: 16000);
      });
      if (mounted) {
        setState(() => _recording = true);
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      showAppSnackBar(
        context,
        message: 'Unable to start live recording: $e',
        type: NotificationType.error,
      );
    }
  }

  Future<void> _stopRecording() async {
    if (!_recording) {
      return;
    }
    try {
      await _audioSubscription?.cancel();
    } catch (_) {}
    _audioSubscription = null;
    try {
      await _audioRecorder.stop();
    } catch (_) {}
    _service?.endAudioStream();
    if (mounted) {
      setState(() => _recording = false);
    }
  }

  Future<void> _sendText() async {
    final GeminiLiveSessionService? service = _service;
    final String text = _textController.text.trim();
    if (service == null || text.isEmpty) {
      return;
    }
    _textController.clear();
    await service.sendTextTurn(text);
  }

  @override
  Widget build(BuildContext context) {
    final GeminiLiveSessionService? service = _service;
    final ColorScheme cs = Theme.of(context).colorScheme;
    final NavigatorState navigator = Navigator.of(context);
    final String assistantText =
        (service?.outputTranscript ?? '').trim().isNotEmpty
        ? service!.outputTranscript
        : (service?.lastTextResponse ?? '');
    final String inputText = service?.inputTranscript ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF07111F),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        leadingWidth: 88,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: TextButton.icon(
            onPressed: navigator.maybePop,
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            icon: const Icon(LucideIcons.arrowLeft, size: 18),
            label: const Text('Back'),
          ),
        ),
        title: const Text('Live Voice'),
        actions: [
          TextButton(
            onPressed: navigator.maybePop,
            style: TextButton.styleFrom(foregroundColor: Colors.white70),
            child: const Text('Close'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                widget.modelId,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    const Color(0xFF0A1731),
                    const Color(0xFF07111F),
                    const Color(0xFF050B14),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: -30,
            child: _GlowBlob(
              color: const Color(0xFF63A4FF).withValues(alpha: 0.28),
              size: 180,
            ),
          ),
          Positioned(
            right: -20,
            top: 120,
            child: _GlowBlob(
              color: const Color(0xFFA47BFF).withValues(alpha: 0.24),
              size: 200,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                children: [
                  _buildHeroCard(cs, service),
                  const SizedBox(height: 18),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildOrb(service),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: const <Widget>[
                              _HintChip(
                                text:
                                    '“I spent 250 on groceries yesterday from cash.”',
                              ),
                              _HintChip(
                                text: '“I earned 1500 from freelance work.”',
                              ),
                              _HintChip(
                                text: '“How much did I spend this week?”',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _TranscriptCard(
                            title: 'You',
                            icon: LucideIcons.mic,
                            text: inputText.isEmpty
                                ? 'Your live transcription will appear here.'
                                : inputText,
                          ),
                          const SizedBox(height: 12),
                          _TranscriptCard(
                            title: 'Gemini',
                            icon: LucideIcons.bot,
                            text: assistantText.isEmpty
                                ? 'Gemini replies and transaction confirmations will appear here.'
                                : assistantText,
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: navigator.maybePop,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            icon: const Icon(LucideIcons.house, size: 18),
                            label: const Text('Back to assistant'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildComposer(cs),
                  if ((service?.lastError ?? '').isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      service!.lastError!,
                      style: TextStyle(
                        color: cs.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_initializing)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x55000000),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(ColorScheme cs, GeminiLiveSessionService? service) {
    final bool ready = service?.connected == true;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: ready
                      ? const Color(0xFF6BFFB0)
                      : const Color(0xFFFFC857),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                ready ? 'Gemini Live ready' : 'Connecting Gemini Live',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            service?.status ?? 'Preparing session…',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            'Voice actions can read finance data and create income or expense entries from your speech.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrb(GeminiLiveSessionService? service) {
    final bool active = _recording || (service?.awaitingModelTurn ?? false);
    final double size = _recording ? 220 : (active ? 200 : 180);
    final List<Color> colors = _recording
        ? <Color>[const Color(0xFF64B6FF), const Color(0xFFA47BFF)]
        : <Color>[const Color(0xFF2D5BFF), const Color(0xFF69D2FF)];

    return Column(
      children: [
        AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    colors.first.withValues(alpha: 0.95),
                    colors.last.withValues(alpha: 0.5),
                    const Color(0xFF08101A),
                  ],
                  stops: const <double>[0, 0.45, 1],
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colors.first.withValues(alpha: 0.35),
                    blurRadius: 60,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  _recording ? LucideIcons.audioWaveform : LucideIcons.sparkles,
                  color: Colors.white,
                  size: 56,
                ),
              ),
            )
            .animate(
              onPlay: (AnimationController controller) =>
                  controller.repeat(reverse: true),
            )
            .scale(
              duration: 1400.ms,
              begin: const Offset(0.96, 0.96),
              end: const Offset(1.03, 1.03),
              curve: Curves.easeInOut,
            ),
        const SizedBox(height: 22),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: _recording
                ? const Color(0xFF001B34)
                : const Color(0xFF062640),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          onPressed: _initializing ? null : _toggleRecording,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_recording ? LucideIcons.square : LucideIcons.mic),
              const SizedBox(width: 10),
              Text(
                _recording ? 'Stop listening' : 'Start live mode',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComposer(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Type a prompt if you want to test without speaking…',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendText(),
            ),
          ),
          IconButton.filled(
            onPressed: _sendText,
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF174B7A),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(LucideIcons.send),
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: <Color>[color, Colors.transparent]),
        ),
      ),
    );
  }
}

class _HintChip extends StatelessWidget {
  const _HintChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }
}

class _TranscriptCard extends StatelessWidget {
  const _TranscriptCard({
    required this.title,
    required this.icon,
    required this.text,
  });

  final String title;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.white70, height: 1.45),
          ),
        ],
      ),
    );
  }
}
