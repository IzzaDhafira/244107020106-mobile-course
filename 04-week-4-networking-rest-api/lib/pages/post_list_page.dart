import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers.dart';
import '../data/network_errors.dart';
import '../widgets/post_tile.dart';

class PostListPage extends ConsumerStatefulWidget {
  const PostListPage({super.key});

  @override
  ConsumerState<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends ConsumerState<PostListPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Tarik data saat aplikasi pertama buka
    Future.microtask(() => ref.read(pagedPostsProvider.notifier).loadFirstPage());
    
    // Deteksi scroll mentok bawah
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        ref.read(pagedPostsProvider.notifier).loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pagedPostsProvider);

    // 1. STATE ERROR (Saat pertama buka)
    if (state.error != null && state.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mini Project API')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(friendlyErrorMessage(state.error!), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(pagedPostsProvider.notifier).loadFirstPage(),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    // 2. STATE LOADING (Saat pertama buka)
    if (state.isLoading && state.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mini Project API')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // 3. STATE EMPTY
    if (state.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mini Project API')),
        body: const Center(child: Text('Tidak ada data post.')),
      );
    }

    // 4. STATE SUCCESS (+ Infinite Scroll)
    return Scaffold(
      appBar: AppBar(title: const Text('Mini Project API')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: state.items.length + 1, // +1 untuk widget loading/error di bawah
        itemBuilder: (context, index) {
          if (index == state.items.length) {
            // Bagian paling bawah (Indikator loading scroll atau error scroll)
            if (state.error != null) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(friendlyErrorMessage(state.error!)),
                    TextButton(
                      onPressed: () => ref.read(pagedPostsProvider.notifier).loadNextPage(),
                      child: const Text('Coba Lagi'),
                    )
                  ],
                ),
              );
            }
            if (state.hasMore) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: Text('✅ Semua data berhasil dimuat')),
            );
          }
          // Tampilkan baris data
          return PostTile(post: state.items[index]);
        },
      ),
    );
  }
}