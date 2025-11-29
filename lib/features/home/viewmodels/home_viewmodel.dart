import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/weather_model.dart';
import '../../../data/models/location_model.dart';
import '../../../data/models/forecast_model.dart';
import '../../../core/providers/providers.dart';

class HomeState {
  final bool isLoading;
  final WeatherModel? weather;
  final ForecastModel? forecast;
  final LocationModel? currentLocation;
  final String? error;

  HomeState({
    this.isLoading = false,
    this.weather,
    this.forecast,
    this.currentLocation,
    this.error,
  });

  HomeState copyWith({
    bool? isLoading,
    WeatherModel? weather,
    ForecastModel? forecast,
    LocationModel? currentLocation,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      weather: weather ?? this.weather,
      forecast: forecast ?? this.forecast,
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

      // Load both current weather and forecast in parallel
      final results = await Future.wait([
        weatherRepo.getCurrentWeather(location.lat, location.lon),
        weatherRepo.getForecast(location.lat, location.lon),
      ]);

      state = state.copyWith(
        isLoading: false,
        weather: results[0] as WeatherModel,
        forecast: results[1] as ForecastModel,
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

      // Load both current weather and forecast in parallel
      final results = await Future.wait([
        weatherRepo.getCurrentWeather(lat, lon),
        weatherRepo.getForecast(lat, lon),
      ]);

      state = state.copyWith(
        isLoading: false,
        weather: results[0] as WeatherModel,
        forecast: results[1] as ForecastModel,
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
