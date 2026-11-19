import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AiService {
  final FlutterSecureStorage _storage;
  final http.Client _client;

  static const String _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  AiService({
    FlutterSecureStorage? storage,
    http.Client? client,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _client = client ?? http.Client();

  Future<String> ask(String question) async {
    final cleanQuestion = question.trim();
    if (cleanQuestion.isEmpty) {
      throw Exception('Pertanyaan tidak boleh kosong.');
    }

    final apiKey = await _storage.read(key: 'ai_api_key');
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key tidak tersedia. Silakan atur di pengaturan.');
    }

    final response = await _client.post(
      Uri.parse('$_apiUrl?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'systemInstruction': {
          'parts': [
            {
              'text':
                  'Kamu adalah asisten catatan produktivitas. Jawab singkat, jelas, dan jangan pernah meminta data pribadi sensitif.'
            }
          ]
        },
        'contents': [
          {
            'parts': [
              {'text': cleanQuestion}
            ]
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = data['candidates'] as List<dynamic>?;
      if (candidates != null && candidates.isNotEmpty) {
        return candidates[0]['content']['parts'][0]['text'] as String;
      }
      throw Exception('Respons AI kosong.');
    } else {
      throw Exception('Gagal memanggil AI API: ${response.statusCode}');
    }
  }

  Future<void> saveApiKey(String key) async {
    await _storage.write(key: 'ai_api_key', value: key.trim());
  }
}