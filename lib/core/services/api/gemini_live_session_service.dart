import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../providers/settings_provider.dart';

typedef GeminiLiveToolHandler =
    Future<String> Function(String name, Map<String, dynamic> arguments);

class GeminiLiveSessionService extends ChangeNotifier {
  GeminiLiveSessionService({
    required ProviderConfig providerConfig,
    required String modelId,
    required String systemInstruction,
    required List<Map<String, dynamic>> functionDeclarations,
    required GeminiLiveToolHandler? toolHandler,
    this.voiceName = 'Zephyr',
  }) : _providerConfig = providerConfig,
       _modelId = modelId.startsWith('models/') ? modelId : 'models/$modelId',
       _systemInstruction = systemInstruction.trim(),
       _functionDeclarations = List<Map<String, dynamic>>.unmodifiable(
         functionDeclarations,
       ),
       _toolHandler = toolHandler {
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((
      PlayerState state,
    ) {
      final bool playing = state == PlayerState.playing;
      if (_playingResponseAudio == playing) {
        return;
      }
      _playingResponseAudio = playing;
      if (_connected) {
        if (playing) {
          _status = 'Gemini is speaking…';
        } else if (!_awaitingModelTurn) {
          _status = 'Listening…';
        }
      }
      if (!playing) {
        _outputLevel = 0.0;
        _activeOutputFrames.clear();
      }
      _notifyListenersIfActive();
    });
    _playerPositionSubscription = _audioPlayer.onPositionChanged.listen(
      _handlePlayerPositionChanged,
    );
  }

  final ProviderConfig _providerConfig;
  final String _modelId;
  final String _systemInstruction;
  final List<Map<String, dynamic>> _functionDeclarations;
  final GeminiLiveToolHandler? _toolHandler;
  final String voiceName;

  final AudioPlayer _audioPlayer = AudioPlayer();

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _playerPositionSubscription;
  Completer<void>? _setupCompleter;

  final List<String> _outputAudioParts = <String>[];
  final List<_AudioLevelFrame> _pendingOutputFrames = <_AudioLevelFrame>[];
  final List<_AudioLevelFrame> _activeOutputFrames = <_AudioLevelFrame>[];
  StringBuffer _textResponseBuffer = StringBuffer();
  String? _lastAudioFilePath;

  bool _isDisposed = false;
  bool _connecting = false;
  bool _connected = false;
  bool _awaitingModelTurn = false;
  bool _receivingInputTurn = false;
  bool _playingResponseAudio = false;
  int _turnSequence = 0;
  double _outputLevel = 0.0;
  String _status = 'Disconnected';
  String _inputTranscript = '';
  String _outputTranscript = '';
  String _lastTextResponse = '';
  String? _audioMimeType;
  String? _lastError;

  bool get connecting => _connecting;
  bool get connected => _connected;
  bool get awaitingModelTurn => _awaitingModelTurn;
  bool get receivingInputTurn => _receivingInputTurn;
  bool get playingResponseAudio => _playingResponseAudio;
  int get turnSequence => _turnSequence;
  double get outputLevel => _outputLevel;
  String get status => _status;
  String get inputTranscript => _inputTranscript;
  String get outputTranscript => _outputTranscript;
  String get lastTextResponse => _lastTextResponse;
  String? get lastError => _lastError;

  Future<void> connect() async {
    if (_isDisposed || _connecting || _connected) {
      return;
    }

    final String apiKey = _providerConfig.apiKey.trim();
    if (apiKey.isEmpty) {
      throw StateError('Gemini API key is missing for the selected provider.');
    }
    if (_providerConfig.vertexAI == true) {
      throw StateError(
        'Gemini Live is currently wired for Google AI API keys, not Vertex AI service accounts.',
      );
    }

    _turnSequence = 0;
    _resetResponseBuffers();
    _connecting = true;
    _status = 'Connecting…';
    _lastError = null;
    _notifyListenersIfActive();

    final Uri uri = Uri.parse(
      'wss://generativelanguage.googleapis.com/ws/'
      'google.ai.generativelanguage.v1beta.GenerativeService.BidiGenerateContent'
      '?key=$apiKey',
    );

    try {
      _channel = WebSocketChannel.connect(uri);
      _setupCompleter = Completer<void>();
      _subscription = _channel!.stream.listen(
        _handleMessage,
        onError: (Object error, StackTrace stackTrace) {
          _lastError = error.toString();
          _status = 'Connection error';
          _connected = false;
          _connecting = false;
          _completePendingSetup(error);
          _notifyListenersIfActive();
        },
        onDone: () {
          _connected = false;
          _connecting = false;
          _awaitingModelTurn = false;
          _status = 'Disconnected';
          _completePendingSetup(
            StateError('Gemini Live websocket closed before setup completed.'),
          );
          _notifyListenersIfActive();
        },
      );

      // Await the WebSocket handshake before sending. In web_socket_channel v3
      // this surfaces rejection errors (bad API key, network failure) as a
      // thrown exception rather than a silent onDone close.
      await _channel!.ready;

      _send(<String, dynamic>{
        'setup': <String, dynamic>{
          'model': _modelId,
          'generationConfig': <String, dynamic>{
            'responseModalities': <String>['AUDIO'],
            'speechConfig': <String, dynamic>{
              'voiceConfig': <String, dynamic>{
                'prebuiltVoiceConfig': <String, dynamic>{
                  'voiceName': voiceName,
                },
              },
            },
          },
          if (_systemInstruction.isNotEmpty)
            'systemInstruction': <String, dynamic>{
              'parts': <Map<String, dynamic>>[
                <String, dynamic>{'text': _systemInstruction},
              ],
            },
          if (_functionDeclarations.isNotEmpty)
            'tools': <Map<String, dynamic>>[
              <String, dynamic>{'functionDeclarations': _functionDeclarations},
            ],
          'inputAudioTranscription': <String, dynamic>{},
          'outputAudioTranscription': <String, dynamic>{},
          'realtimeInputConfig': <String, dynamic>{
            'automaticActivityDetection': <String, dynamic>{
              'startOfSpeechSensitivity': 'START_SENSITIVITY_HIGH',
              'endOfSpeechSensitivity': 'END_SENSITIVITY_HIGH',
              'silenceDurationMs': 700,
            },
          },
        },
      });

      await _setupCompleter!.future.timeout(const Duration(seconds: 15));
      _connected = true;
      _connecting = false;
      _status = 'Ready';
      _notifyListenersIfActive();
    } catch (e) {
      _lastError = e.toString();
      _status = 'Connection failed';
      _connected = false;
      _connecting = false;
      _notifyListenersIfActive();
      rethrow;
    }
  }

  Future<void> disconnect({bool notify = true, bool stopAudio = true}) async {
    _completePendingSetup(
      StateError('Gemini Live session disconnected before setup completed.'),
    );
    final StreamSubscription<dynamic>? subscription = _subscription;
    _subscription = null;
    final WebSocketChannel? channel = _channel;
    _channel = null;
    try {
      await subscription?.cancel();
    } catch (_) {}
    try {
      await channel?.sink.close();
    } catch (_) {}
    if (stopAudio && !_isDisposed) {
      try {
        await _audioPlayer.stop();
      } catch (_) {}
    }
    await _deleteLastAudioFile();
    _connected = false;
    _connecting = false;
    _awaitingModelTurn = false;
    _receivingInputTurn = false;
    _playingResponseAudio = false;
    _turnSequence = 0;
    _outputLevel = 0.0;
    _activeOutputFrames.clear();
    _pendingOutputFrames.clear();
    _resetResponseBuffers();
    _status = 'Disconnected';
    if (notify) {
      _notifyListenersIfActive();
    }
  }

  Future<void> sendTextTurn(String text) async {
    final String trimmed = text.trim();
    if (_isDisposed || trimmed.isEmpty) {
      return;
    }
    _turnSequence++;
    _awaitingModelTurn = true;
    _receivingInputTurn = false;
    _status = 'Waiting for Gemini…';
    _resetResponseBuffers();
    _inputTranscript = trimmed;
    _notifyListenersIfActive();
    _send(<String, dynamic>{
      'realtimeInput': <String, dynamic>{'text': trimmed},
    });
  }

  void sendAudioChunk(Uint8List pcmChunk, {int sampleRate = 16000}) {
    if (_isDisposed || pcmChunk.isEmpty) {
      return;
    }
    if (!_playingResponseAudio) {
      _status = 'Listening…';
    }
    _notifyListenersIfActive();
    _send(<String, dynamic>{
      'realtimeInput': <String, dynamic>{
        'audio': <String, dynamic>{
          'data': base64Encode(pcmChunk),
          'mimeType': 'audio/pcm;rate=$sampleRate',
        },
      },
    });
  }

  void endAudioStream() {
    if (_isDisposed) {
      return;
    }
    _status = 'Processing…';
    _notifyListenersIfActive();
    _send(<String, dynamic>{
      'realtimeInput': <String, dynamic>{'audioStreamEnd': true},
    });
  }

  void _handleMessage(dynamic rawMessage) {
    if (_isDisposed) {
      return;
    }
    try {
      final String messageText = _decodeSocketMessage(rawMessage);
      final Map<String, dynamic> message =
          jsonDecode(messageText) as Map<String, dynamic>;

      if (message.containsKey('setupComplete')) {
        _completePendingSetup();
        return;
      }

      if (message['serverContent'] is Map<String, dynamic>) {
        _handleServerContent(message['serverContent'] as Map<String, dynamic>);
      }

      if (message['toolCall'] is Map<String, dynamic>) {
        unawaited(_handleToolCall(message['toolCall'] as Map<String, dynamic>));
      }
    } catch (e) {
      _lastError = e.toString();
      _status = 'Message error';
      _notifyListenersIfActive();
    }
  }

  static String _decodeSocketMessage(dynamic rawMessage) {
    if (rawMessage is String) {
      return rawMessage;
    }
    if (rawMessage is Uint8List) {
      return utf8.decode(rawMessage);
    }
    if (rawMessage is List<int>) {
      return utf8.decode(rawMessage);
    }
    if (rawMessage is ByteBuffer) {
      return utf8.decode(rawMessage.asUint8List());
    }
    throw StateError(
      'Unsupported Gemini Live message type: ${rawMessage.runtimeType}',
    );
  }

  void _handleServerContent(Map<String, dynamic> serverContent) {
    if (serverContent['interrupted'] == true) {
      _clearBufferedAudio();
      unawaited(_audioPlayer.stop());
      _awaitingModelTurn = false;
      _receivingInputTurn = false;
      _outputLevel = 0.0;
      _activeOutputFrames.clear();
      _status = 'Interrupted';
    }

    final Map<String, dynamic>? inputTranscription = _asMap(
      serverContent['inputTranscription'],
    );
    if (inputTranscription != null) {
      if (!_receivingInputTurn && !_awaitingModelTurn) {
        _turnSequence++;
        _receivingInputTurn = true;
        _resetResponseBuffers();
      }
      _inputTranscript = _mergeTranscriptFragment(
        current: _inputTranscript,
        incoming: (inputTranscription['text'] ?? '').toString(),
        concatenateOnNoOverlap: true,
      );
    }

    final Map<String, dynamic>? outputTranscription = _asMap(
      serverContent['outputTranscription'],
    );
    if (outputTranscription != null) {
      _receivingInputTurn = false;
      _awaitingModelTurn = true;
      _outputTranscript = _mergeTranscriptFragment(
        current: _outputTranscript,
        incoming: (outputTranscription['text'] ?? '').toString(),
        concatenateOnNoOverlap: true,
      );
    }

    final Map<String, dynamic>? modelTurn = _asMap(serverContent['modelTurn']);
    if (modelTurn != null) {
      _receivingInputTurn = false;
      _awaitingModelTurn = true;
      final List<dynamic> parts =
          (modelTurn['parts'] as List<dynamic>? ?? const <dynamic>[]);
      for (final dynamic rawPart in parts) {
        final Map<String, dynamic>? part = _asMap(rawPart);
        if (part == null) {
          continue;
        }
        final String text = (part['text'] ?? '').toString();
        if (text.isNotEmpty) {
          _textResponseBuffer.write(text);
          _lastTextResponse = _textResponseBuffer.toString().trim();
        }
        final Map<String, dynamic>? inlineData = _asMap(part['inlineData']);
        if (inlineData != null) {
          final String data = (inlineData['data'] ?? '').toString();
          if (data.isNotEmpty) {
            _outputAudioParts.add(data);
            _audioMimeType = (inlineData['mimeType'] ?? '').toString();
            final _AudioLevelFrame? frame = _buildAudioLevelFrame(
              data,
              _audioMimeType!,
            );
            if (frame != null) {
              _pendingOutputFrames.add(frame);
            }
          }
        }
      }
    }

    if (serverContent['generationComplete'] == true) {
      _receivingInputTurn = false;
      _awaitingModelTurn = true;
      _status = 'Finishing audio…';
    }

    if (serverContent['turnComplete'] == true) {
      _receivingInputTurn = false;
      _awaitingModelTurn = false;
      _status = _playingResponseAudio ? 'Gemini is speaking…' : 'Listening…';
      unawaited(_playBufferedAudio());
    }

    _notifyListenersIfActive();
  }

  Future<void> _handleToolCall(Map<String, dynamic> toolCall) async {
    final List<dynamic> functionCalls =
        toolCall['functionCalls'] as List<dynamic>? ?? const <dynamic>[];
    final GeminiLiveToolHandler? toolHandler = _toolHandler;
    if (functionCalls.isEmpty || toolHandler == null) {
      return;
    }

    final List<Map<String, dynamic>> responses = <Map<String, dynamic>>[];
    for (final dynamic rawCall in functionCalls) {
      final Map<String, dynamic>? functionCall = _asMap(rawCall);
      if (functionCall == null) {
        continue;
      }

      final String id = (functionCall['id'] ?? '').toString();
      final String name = (functionCall['name'] ?? '').toString();
      final Map<String, dynamic> arguments =
          _asMap(functionCall['args']) ?? const <String, dynamic>{};

      try {
        final String rawResult = await toolHandler(name, arguments);
        responses.add(<String, dynamic>{
          'id': id,
          'name': name,
          'response': _decodeToolResult(rawResult),
        });
      } catch (e) {
        responses.add(<String, dynamic>{
          'id': id,
          'name': name,
          'response': <String, dynamic>{'error': e.toString()},
        });
      }
    }

    if (responses.isEmpty) {
      return;
    }

    _send(<String, dynamic>{
      'toolResponse': <String, dynamic>{'functionResponses': responses},
    });
  }

  Object _decodeToolResult(String rawResult) {
    final String trimmed = rawResult.trim();
    if (trimmed.isEmpty) {
      return <String, dynamic>{'ok': true};
    }
    try {
      return jsonDecode(trimmed);
    } catch (_) {
      return <String, dynamic>{'text': trimmed};
    }
  }

  Future<void> _playBufferedAudio() async {
    if (_outputAudioParts.isEmpty) {
      return;
    }
    try {
      final Uint8List wavData = _buildWav(
        _outputAudioParts,
        _audioMimeType ?? 'audio/pcm;rate=24000',
      );
      await _audioPlayer.stop();
      await Future.delayed(const Duration(milliseconds: 20));
      await _deleteLastAudioFile();
      final io.Directory dir = await getTemporaryDirectory();
      final String path = p.join(
        dir.path,
        'kelivo_gemini_live_${DateTime.now().millisecondsSinceEpoch}.wav',
      );
      final io.File file = io.File(path);
      await file.writeAsBytes(wavData, flush: true);
      _lastAudioFilePath = path;
      _activeOutputFrames
        ..clear()
        ..addAll(_pendingOutputFrames);
      _outputLevel = _activeOutputFrames.isEmpty
          ? 0.0
          : _activeOutputFrames.first.level;
      await _audioPlayer.play(DeviceFileSource(path));
    } catch (e) {
      _lastError = 'Audio playback failed: $e';
      _notifyListenersIfActive();
    } finally {
      _clearBufferedAudio();
    }
  }

  void _resetResponseBuffers() {
    _outputTranscript = '';
    _inputTranscript = '';
    _lastTextResponse = '';
    _textResponseBuffer = StringBuffer();
    _clearBufferedAudio();
  }

  void _clearBufferedAudio() {
    _outputAudioParts.clear();
    _pendingOutputFrames.clear();
    _audioMimeType = null;
  }

  void _handlePlayerPositionChanged(Duration position) {
    if (!_playingResponseAudio || _activeOutputFrames.isEmpty) {
      return;
    }

    final int elapsedMs = position.inMilliseconds;
    int consumedMs = 0;
    double nextLevel = 0.0;
    for (final _AudioLevelFrame frame in _activeOutputFrames) {
      consumedMs += frame.durationMs;
      if (elapsedMs <= consumedMs) {
        nextLevel = frame.level;
        break;
      }
    }

    if ((nextLevel - _outputLevel).abs() < 0.015) {
      return;
    }
    _outputLevel = nextLevel;
    _notifyListenersIfActive();
  }

  Future<void> _deleteLastAudioFile() async {
    final String? path = _lastAudioFilePath;
    if (path == null || path.isEmpty) {
      return;
    }
    _lastAudioFilePath = null;
    try {
      final io.File file = io.File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }

  void _send(Map<String, dynamic> payload) {
    if (_isDisposed) {
      return;
    }
    _channel?.sink.add(jsonEncode(payload));
  }

  void _completePendingSetup([Object? error]) {
    final Completer<void>? completer = _setupCompleter;
    if (completer == null || completer.isCompleted) {
      return;
    }
    _setupCompleter = null;
    if (error == null) {
      completer.complete();
      return;
    }
    completer.completeError(error);
  }

  void _notifyListenersIfActive() {
    if (_isDisposed) {
      return;
    }
    notifyListeners();
  }

  static Map<String, dynamic>? _asMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.cast<String, dynamic>();
    }
    return null;
  }

  static String _mergeTranscriptFragment({
    required String current,
    required String incoming,
    bool concatenateOnNoOverlap = false,
  }) {
    final String existing = current.trim();
    final String next = incoming.trim();

    if (next.isEmpty) {
      return existing;
    }
    if (existing.isEmpty) {
      return next;
    }
    if (next == existing ||
        next.startsWith(existing) ||
        next.endsWith(existing)) {
      return next;
    }
    if (existing.startsWith(next) || existing.endsWith(next)) {
      return existing;
    }

    final int overlap = _suffixPrefixOverlap(existing, next);
    if (overlap > 0) {
      return '$existing${next.substring(overlap)}'.trim();
    }

    if (concatenateOnNoOverlap) {
      return _joinTranscriptChunks(existing, next);
    }

    return next;
  }

  static String _joinTranscriptChunks(String left, String right) {
    if (left.isEmpty) {
      return right;
    }
    if (right.isEmpty) {
      return left;
    }

    final bool needsSpace =
        !_endsWithJoinPunctuation(left) && !_startsWithJoinPunctuation(right);
    return needsSpace ? '$left $right' : '$left$right';
  }

  static bool _endsWithJoinPunctuation(String value) {
    if (value.isEmpty) {
      return false;
    }
    const String punctuation = " \t\r\n([{'\":/-";
    return punctuation.contains(value[value.length - 1]);
  }

  static bool _startsWithJoinPunctuation(String value) {
    if (value.isEmpty) {
      return false;
    }
    const String punctuation = " \t\r\n)]}\",.!?:;/-";
    return punctuation.contains(value[0]);
  }

  static int _suffixPrefixOverlap(String left, String right) {
    final int maxOverlap = left.length < right.length
        ? left.length
        : right.length;
    for (int size = maxOverlap; size > 0; size--) {
      if (left.substring(left.length - size) == right.substring(0, size)) {
        return size;
      }
    }
    return 0;
  }

  static Uint8List _buildWav(List<String> rawData, String mimeType) {
    final _WavOptions options = _parseMimeType(mimeType);
    final List<Uint8List> buffers = rawData
        .map((String chunk) => Uint8List.fromList(base64Decode(chunk)))
        .toList(growable: false);
    final int dataLength = buffers.fold<int>(
      0,
      (int total, Uint8List chunk) => total + chunk.length,
    );
    final BytesBuilder builder = BytesBuilder(copy: false);
    builder.add(_createWavHeader(dataLength, options));
    for (final Uint8List chunk in buffers) {
      builder.add(chunk);
    }
    return builder.takeBytes();
  }

  static _WavOptions _parseMimeType(String mimeType) {
    final List<String> sections = mimeType.split(';');
    int sampleRate = 24000;
    int bitsPerSample = 16;

    for (final String rawSection in sections.skip(1)) {
      final List<String> kv = rawSection.split('=');
      if (kv.length != 2) {
        continue;
      }
      final String key = kv.first.trim();
      final String value = kv.last.trim();
      if (key == 'rate') {
        sampleRate = int.tryParse(value) ?? sampleRate;
      }
    }

    final String format = sections.first.trim().split('/').last;
    if (format.startsWith('L')) {
      bitsPerSample = int.tryParse(format.substring(1)) ?? bitsPerSample;
    }

    return _WavOptions(
      numChannels: 1,
      sampleRate: sampleRate,
      bitsPerSample: bitsPerSample,
    );
  }

  static Uint8List _createWavHeader(int dataLength, _WavOptions options) {
    final ByteData header = ByteData(44);
    final int byteRate =
        options.sampleRate * options.numChannels * options.bitsPerSample ~/ 8;
    final int blockAlign = options.numChannels * options.bitsPerSample ~/ 8;

    void writeAscii(int offset, String value) {
      for (int i = 0; i < value.length; i++) {
        header.setUint8(offset + i, value.codeUnitAt(i));
      }
    }

    writeAscii(0, 'RIFF');
    header.setUint32(4, 36 + dataLength, Endian.little);
    writeAscii(8, 'WAVE');
    writeAscii(12, 'fmt ');
    header.setUint32(16, 16, Endian.little);
    header.setUint16(20, 1, Endian.little);
    header.setUint16(22, options.numChannels, Endian.little);
    header.setUint32(24, options.sampleRate, Endian.little);
    header.setUint32(28, byteRate, Endian.little);
    header.setUint16(32, blockAlign, Endian.little);
    header.setUint16(34, options.bitsPerSample, Endian.little);
    writeAscii(36, 'data');
    header.setUint32(40, dataLength, Endian.little);
    return header.buffer.asUint8List();
  }

  @override
  void dispose() {
    _isDisposed = true;
    unawaited(disconnect(notify: false, stopAudio: false));
    unawaited(_playerStateSubscription?.cancel());
    unawaited(_playerPositionSubscription?.cancel());
    _audioPlayer.dispose();
    super.dispose();
  }
}

class _WavOptions {
  const _WavOptions({
    required this.numChannels,
    required this.sampleRate,
    required this.bitsPerSample,
  });

  final int numChannels;
  final int sampleRate;
  final int bitsPerSample;
}

class _AudioLevelFrame {
  const _AudioLevelFrame({required this.durationMs, required this.level});

  final int durationMs;
  final double level;
}

_AudioLevelFrame? _buildAudioLevelFrame(String data, String mimeType) {
  try {
    final Uint8List bytes = Uint8List.fromList(base64Decode(data));
    if (bytes.isEmpty) {
      return null;
    }

    final _WavOptions options = GeminiLiveSessionService._parseMimeType(
      mimeType,
    );
    final int bytesPerSample = (options.bitsPerSample ~/ 8).clamp(1, 8);
    final int totalSamples = bytes.length ~/ bytesPerSample;
    if (totalSamples <= 0 || options.sampleRate <= 0) {
      return null;
    }

    double peak = 0.0;
    if (options.bitsPerSample == 16) {
      final ByteData byteData = bytes.buffer.asByteData();
      for (int offset = 0; offset + 1 < bytes.length; offset += 2) {
        final int sample = byteData.getInt16(offset, Endian.little);
        final double normalized = sample.abs() / 32768.0;
        if (normalized > peak) {
          peak = normalized;
        }
      }
    } else {
      for (final int sample in bytes) {
        final double normalized = ((sample - 128).abs() / 128.0).clamp(
          0.0,
          1.0,
        );
        if (normalized > peak) {
          peak = normalized;
        }
      }
    }

    final int durationMs = ((totalSamples / options.sampleRate) * 1000)
        .round()
        .clamp(24, 4000);

    return _AudioLevelFrame(
      durationMs: durationMs,
      level: peak.clamp(0.0, 1.0),
    );
  } catch (_) {
    return null;
  }
}
