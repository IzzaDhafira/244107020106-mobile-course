import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/post.dart';
import 'repositories/post_repository.dart';

// --- STATE UNTUK PAGINATION ---
class PagedState {
  final List<Post> items;
  final int page;
  final bool hasMore;
  final bool isLoading;
  final Object? error;

  PagedState({
    this.items = const [],
    this.page = 1,
    this.hasMore = true,
    this.isLoading = false,
    this.error,
  });

  PagedState copyWith({
    List<Post>? items, int? page, bool? hasMore, bool? isLoading, Object? error,
  }) {
    return PagedState(
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// --- PROVIDER PAGINATION ---
class PagedPostsNotifier extends Notifier<PagedState> {
  @override
  PagedState build() => PagedState();

  Future<void> loadFirstPage() async {
    state = PagedState(isLoading: true);
    try {
      final repo = ref.read(postRepositoryProvider);
      final newItems = await repo.fetchPostsPage(page: 1, limit: 10);
      state = state.copyWith(
        items: newItems,
        page: 1,
        hasMore: newItems.length == 10,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> loadNextPage() async {
    // GUARD: Cegah request ganda saat sedang loading atau data sudah habis
    if (state.isLoading || !state.hasMore) return;
    
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(postRepositoryProvider);
      final nextPage = state.page + 1;
      final newItems = await repo.fetchPostsPage(page: nextPage, limit: 10);
      
      state = state.copyWith(
        items: [...state.items, ...newItems],
        page: nextPage,
        hasMore: newItems.length == 10,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }
}

final pagedPostsProvider = NotifierProvider<PagedPostsNotifier, PagedState>(
  PagedPostsNotifier.new,
);