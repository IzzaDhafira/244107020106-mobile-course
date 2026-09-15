import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// baseUrl dan timeout terpusat di satu tempat
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 10), // Timeout 10 detik
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
});