import 'package:dio/dio.dart';

String handleError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Koneksi internet lambat atau timeout.';
    case DioExceptionType.connectionError:
      return 'Tidak ada koneksi internet (offline).';
    case DioExceptionType.badResponse:
      if (e.response?.statusCode == 401) {
        return 'Sesi habis, silakan login ulang.';
      }
      return 'Terjadi kesalahan pada server (${e.response?.statusCode}).';
    default:
      return 'Terjadi kesalahan yang tidak diketahui.';
  }
}