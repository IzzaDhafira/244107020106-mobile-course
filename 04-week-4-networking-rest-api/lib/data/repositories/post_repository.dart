import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../api_client.dart';

class PostRepository {
  final Dio _dio;

  PostRepository(this._dio);

  // Ambil data dengan pagination (_page dan _limit)
  Future<List<Post>> fetchPostsPage({required int page, int limit = 10}) async {
    final response = await _dio.get(
      '/posts',
      queryParameters: {'_page': page, '_limit': limit},
    );
    final List<dynamic> data = response.data;
    return data.map((json) => Post.fromJson(json)).toList();
  }
}

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(ref.read(dioProvider));
});