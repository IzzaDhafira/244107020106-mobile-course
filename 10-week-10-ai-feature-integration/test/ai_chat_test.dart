import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:week10_ai_integration/ai/ai_service.dart';
import 'package:week10_ai_integration/features/chat_screen.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({'ai_api_key': 'TEST_KEY'});
  });

  test('AiService mengembalikan teks respons saat status 200', () async {
    final mockClient = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'candidates': [
            {
              'content': {
                'parts': [
                  {'text': 'Ringkasan catatan berhasil dibuat.'}
                ]
              }
            }
          ]
        }),
        200,
      );
    });

    final service = AiService(client: mockClient);
    final result = await service.ask('Buatkan ringkasan rapat');
    expect(result, 'Ringkasan catatan berhasil dibuat.');
  });

  test('AiService melempar exception jika API key kosong', () async {
    FlutterSecureStorage.setMockInitialValues({});
    final service = AiService();
    expect(() => service.ask('Halo AI'), throwsException);
  });

  testWidgets('ChatScreen menampilkan dialog fallback saat API error',
      (tester) async {
    final errorClient = MockClient((_) async => http.Response('Error', 500));
    final service = AiService(client: errorClient);

    await tester.pumpWidget(
      MaterialApp(home: ChatScreen(aiService: service)),
    );

    await tester.enterText(find.byType(TextField), 'Bantu rangkum tugas');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(find.text('Layanan AI Sibuk'), findsOneWidget);
    expect(
      find.text('Coba lagi nanti atau gunakan mode catatan offline.'),
      findsOneWidget,
    );
  });
}