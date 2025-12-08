import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/location_model.dart';
import '../../../core/providers/providers.dart';

enum RegionFilter {
  all,
  africa,
  asia,
  europe,
  northAmerica,
  southAmerica,
  oceania,
}

class SearchState {
  final bool isLoading;
  final List<LocationModel> results;
  final List<LocationModel> favorites;
  final String? error;
  final RegionFilter regionFilter;
  final bool showFavoritesOnly;

  SearchState({
    this.isLoading = false,
    this.results = const [],
    this.favorites = const [],
    this.error,
    this.regionFilter = RegionFilter.all,
    this.showFavoritesOnly = false,
  });

  List<LocationModel> get filteredResults {
    var filtered = showFavoritesOnly ? favorites : results;

    if (regionFilter != RegionFilter.all && !showFavoritesOnly) {
      filtered = filtered.where((location) {
        final country = location.country.toLowerCase();
        switch (regionFilter) {
          case RegionFilter.africa:
            return _isAfricanCountry(country);
          case RegionFilter.asia:
            return _isAsianCountry(country);
          case RegionFilter.europe:
            return _isEuropeanCountry(country);
          case RegionFilter.northAmerica:
            return _isNorthAmericanCountry(country);
          case RegionFilter.southAmerica:
            return _isSouthAmericanCountry(country);
          case RegionFilter.oceania:
            return _isOceaniaCountry(country);
          default:
            return true;
        }
      }).toList();
    }

    return filtered;
  }

  SearchState copyWith({
    bool? isLoading,
    List<LocationModel>? results,
    List<LocationModel>? favorites,
    String? error,
    RegionFilter? regionFilter,
    bool? showFavoritesOnly,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
      favorites: favorites ?? this.favorites,
      error: error,
      regionFilter: regionFilter ?? this.regionFilter,
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
    );
  }

  static bool _isAfricanCountry(String country) {
    final african = ['eg', 'za', 'ng', 'ke', 'ma', 'tz', 'gh', 'ug', 'ao', 'mz'];
    return african.contains(country);
  }

  static bool _isAsianCountry(String country) {
    final asian = ['cn', 'in', 'jp', 'kr', 'th', 'vn', 'ph', 'id', 'my', 'sg', 'bd', 'pk'];
    return asian.contains(country);
  }

  static bool _isEuropeanCountry(String country) {
    final european = ['gb', 'de', 'fr', 'es', 'it', 'nl', 'be', 'pl', 'ro', 'gr', 'pt', 'se', 'no', 'fi', 'dk'];
    return european.contains(country);
  }

  static bool _isNorthAmericanCountry(String country) {
    final northAmerican = ['us', 'ca', 'mx', 'cu', 'gt', 'hn', 'ni', 'cr', 'pa'];
    return northAmerican.contains(country);
  }

  static bool _isSouthAmericanCountry(String country) {
    final southAmerican = ['br', 'ar', 'co', 've', 'pe', 'cl', 'ec', 'bo', 'py', 'uy'];
    return southAmerican.contains(country);
  }

  static bool _isOceaniaCountry(String country) {
    final oceania = ['au', 'nz', 'fj', 'pg', 'nc'];
    return oceania.contains(country);
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final Ref ref;

  SearchNotifier(this.ref) : super(SearchState()) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final storageService = ref.read(storageServiceProvider);
      final favorites = await storageService.getFavorites();
      state = state.copyWith(favorites: favorites);
    } catch (e) {
      // Ignore errors when loading favorites
    }
  }

  Future<void> searchLocation(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(results: [], error: null);
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final locationRepo = ref.read(locationRepositoryProvider);
      final results = await locationRepo.searchLocation(query);

      final matchingFavorites = state.favorites.where((fav) {
        final customName = fav.customName?.toLowerCase() ?? '';
        final queryLower = query.toLowerCase();
        return customName.isNotEmpty && customName.contains(queryLower);
      }).toList();

      final allResults = [...matchingFavorites, ...results];
      final uniqueResults = <LocationModel>[];
      final seenCoordinates = <String>{};

      for (final result in allResults) {
        final key = '${result.lat},${result.lon}';
        if (!seenCoordinates.contains(key)) {
          seenCoordinates.add(key);
          uniqueResults.add(result);
        }
      }

      state = state.copyWith(
        isLoading: false,
        results: uniqueResults,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> toggleFavorite(LocationModel location, {String? customName}) async {
    try {
      final storageService = ref.read(storageServiceProvider);
      final isFav = await storageService.isFavorite(location.lat, location.lon);

      if (isFav) {
        final favorites = state.favorites;
        final index = favorites.indexWhere(
          (loc) => loc.lat == location.lat && loc.lon == location.lon
        );
        if (index != -1) {
          await storageService.removeFavorite(index);
        }
      } else {
        final locationWithCustomName = location.copyWith(customName: customName);
        await storageService.addFavorite(locationWithCustomName);
      }

      await _loadFavorites();
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> updateCustomName(LocationModel location, String? customName) async {
    try {
      final storageService = ref.read(storageServiceProvider);
      await storageService.updateFavoriteCustomName(location.lat, location.lon, customName);
      await _loadFavorites();
    } catch (e) {
      // Handle error silently
    }
  }

  bool isFavorite(LocationModel location) {
    return state.favorites.any(
      (loc) => loc.lat == location.lat && loc.lon == location.lon
    );
  }

  void setRegionFilter(RegionFilter filter) {
    state = state.copyWith(regionFilter: filter);
  }

  void toggleShowFavorites() {
    state = state.copyWith(showFavoritesOnly: !state.showFavoritesOnly);
  }

  void clear() {
    state = state.copyWith(
      results: [],
      error: null,
      showFavoritesOnly: false,
    );
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref);
});
