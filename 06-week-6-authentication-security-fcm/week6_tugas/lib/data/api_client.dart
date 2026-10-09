import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

final dio = Dio(BaseOptions(baseUrl: 'https://mockapi.com'));
const storage = FlutterSecureStorage();

void setupDioInterceptor(void Function() onLogout) {
  dio.interceptors.add(InterceptorsWrapper(
    onError: (DioException e, handler) async {
      if (e.response?.statusCode == 401) {
        debugPrint('401 Terdeteksi. Mencoba refresh token...');
        // Simulasi logika refresh
        bool refreshSukses = false; // Ganti true jika berhasil
        if (!refreshSukses) {
          await storage.delete(key: 'token');
          onLogout();
          return handler.reject(e);
        }
      }
      return handler.next(e);
    },
  ));
}