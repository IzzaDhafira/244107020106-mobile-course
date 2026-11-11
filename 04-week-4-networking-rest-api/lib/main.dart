import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'pages/post_list_page.dart';
import 'pages/post_detail_page.dart';
import 'data/models/post.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const PostListPage(),
        ),
        GoRoute(
          path: '/post/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            final post = state.extra as Post?;
            return PostDetailPage(id: id, post: post);
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Mini Project API',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}