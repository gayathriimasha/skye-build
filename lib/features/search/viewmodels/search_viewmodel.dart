import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/location_model.dart';
import '../../../core/providers/providers.dart';

class SearchState {
  final bool isLoading;
  final List<LocationModel> results;
  final String? error;

  SearchState({
    this.isLoading = false,
    this.results = const [],
    this.error,
  });

  SearchState copyWith({
    bool? isLoading,
    List<LocationModel>? results,
    String? error,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
      error: error,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final Ref ref;

  SearchNotifier(this.ref) : super(SearchState());

  Future<void> searchLocation(String query) async {
    if (query.isEmpty) {
      state = SearchState();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final locationRepo = ref.read(locationRepositoryProvider);
      final results = await locationRepo.searchLocation(query);

      state = state.copyWith(
        isLoading: false,
        results: results,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clear() {
    state = SearchState();
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref);
});
