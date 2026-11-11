import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/comment.dart';
import '../api_client.dart';

class CommentRepository {
  final Dio _dio;

  CommentRepository(this._dio);

  Future<List<Comment>> fetchComments(int postId) async {
    // UI tidak memanggil Dio langsung, melainkan lewat sini
    final response = await _dio.get(
      '/comments',
      queryParameters: {'postId': postId},
    );

    final List<dynamic> data = response.data;
    return data.map((json) => Comment.fromJson(json)).toList();
  }
}

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  return CommentRepository(ref.read(dioProvider));
});