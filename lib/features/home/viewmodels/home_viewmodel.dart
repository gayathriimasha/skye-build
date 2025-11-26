import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/weather_model.dart';
import '../../../data/models/location_model.dart';
import '../../../core/providers/providers.dart';

class HomeState {
  final bool isLoading;
  final WeatherModel? weather;
  final LocationModel? currentLocation;
  final String? error;

  HomeState({
    this.isLoading = false,
    this.weather,
    this.currentLocation,
    this.error,
  });

  HomeState copyWith({
    bool? isLoading,
    WeatherModel? weather,
    LocationModel? currentLocation,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      weather: weather ?? this.weather,
      currentLocation: currentLocation ?? this.currentLocation,
      error: error,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final Ref ref;

  HomeNotifier(this.ref) : super(HomeState());

  Future<void> loadCurrentLocationWeather() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final locationRepo = ref.read(locationRepositoryProvider);
      final weatherRepo = ref.read(weatherRepositoryProvider);

      final location = await locationRepo.getCurrentLocation();
      final weather = await weatherRepo.getCurrentWeather(location.lat, location.lon);

      state = state.copyWith(
        isLoading: false,
        weather: weather,
        currentLocation: location,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadWeatherForLocation(double lat, double lon) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final weatherRepo = ref.read(weatherRepositoryProvider);
      final weather = await weatherRepo.getCurrentWeather(lat, lon);

      state = state.copyWith(
        isLoading: false,
        weather: weather,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refreshWeather() async {
    if (state.currentLocation != null) {
      await loadWeatherForLocation(
        state.currentLocation!.lat,
        state.currentLocation!.lon,
      );
    } else {
      await loadCurrentLocationWeather();
    }
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(ref);
});
