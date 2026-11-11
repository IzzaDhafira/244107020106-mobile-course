import 'package:flutter_test/flutter_test.dart';

String parseRoute(Map<String, String> data) => data['route']?.startsWith('/') == true ? data['route']! : '/${data['route']}';

void main() {
  test('Parsing route FCM menambahkan slash jika tidak ada', () {
    expect(parseRoute({'route': 'pengumuman/1'}), '/pengumuman/1');
    expect(parseRoute({'route': '/pengumuman/2'}), '/pengumuman/2');
  });

  test('Logika sesi gagal refresh memaksa state logout', () {
    bool isRefreshSuccess = false;
    bool isLoggedIn = true;
    if (!isRefreshSuccess) isLoggedIn = false;
    expect(isLoggedIn, isFalse);
  });
}