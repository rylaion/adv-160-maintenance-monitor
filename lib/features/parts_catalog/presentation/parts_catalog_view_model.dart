import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/providers.dart';
import '../data/parts_catalog_repository.dart';
import '../domain/parts_catalog_models.dart';

final partsCatalogRepositoryProvider = Provider<PartsCatalogRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return PartsCatalogRepository(db);
});

class PartsFilterState {
  const PartsFilterState({
    this.query = '',
    this.selectedCategory = 'All',
  });

  final String query;
  final String selectedCategory;

  PartsFilterState copyWith({
    String? query,
    String? selectedCategory,
  }) {
    return PartsFilterState(
      query: query ?? this.query,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class PartsFilterNotifier extends StateNotifier<PartsFilterState> {
  PartsFilterNotifier() : super(const PartsFilterState());

  void setQuery(String q) => state = state.copyWith(query: q);
  void setCategory(String c) => state = state.copyWith(selectedCategory: c);
  void reset() => state = const PartsFilterState();
}

final partsCatalogFilterProvider =
    StateNotifierProvider<PartsFilterNotifier, PartsFilterState>(
        (ref) => PartsFilterNotifier());

final partsCatalogCategoriesProvider = FutureProvider<List<String>>((ref) {
  return ref.watch(partsCatalogRepositoryProvider).getCategories();
});

final partsCatalogItemsProvider = StreamProvider<List<PartsCatalogItem>>((ref) {
  final filter = ref.watch(partsCatalogFilterProvider);
  final repo = ref.watch(partsCatalogRepositoryProvider);
  return repo.watchParts(
    query: filter.query,
    category: filter.selectedCategory,
  );
});

final partsCatalogDiagramsProvider =
    StreamProvider<List<PartsCatalogDiagramInfo>>((ref) {
  final repo = ref.watch(partsCatalogRepositoryProvider);
  return repo.watchDiagrams();
});
