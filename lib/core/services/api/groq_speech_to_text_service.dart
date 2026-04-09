import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../providers/settings_provider.dart';

class GroqSpeechToTextService {
  static const List<String> supportedModels = <String>[
    'whisper-large-v3-turbo',
    'whisper-large-v3',
  ];

  Future<String> transcribeFile({
    required ProviderConfig config,
    required String audioPath,
    String? model,
    String? language,
  }) async {
    final apiKey = config.apiKey.trim();
    if (apiKey.isEmpty) {
      throw Exception('Groq API key is missing.');
    }

    final selectedModel =
        (model != null && model.trim().isNotEmpty) ? model.trim() : 'whisper-large-v3-turbo';
    final base = config.baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    final uri = Uri.parse('$base/audio/transcriptions');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $apiKey'
      ..fields['model'] = selectedModel
      ..fields['response_format'] = 'json'
      ..fields['temperature'] = '0';

    final lang = language?.trim();
    if (lang != null && lang.isNotEmpty) {
      request.fields['language'] = lang;
    }

    request.files.add(await http.MultipartFile.fromPath('file', audioPath));

    final streamed = await request.send();
    final body = await streamed.stream.bytesToString();

    if (streamed.statusCode < 200 || streamed.statusCode >= 300) {
      throw Exception('Groq STT failed (${streamed.statusCode}): $body');
    }

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final text = (decoded['text'] ?? '').toString().trim();
        if (text.isNotEmpty) return text;
      }
    } catch (_) {
      // Some responses may be plain text depending on response_format.
    }

    final fallback = body.trim();
    if (fallback.isNotEmpty) return fallback;
    throw Exception('Speech-to-text returned an empty response.');
  }
}
