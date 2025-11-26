import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/api_service.dart';
import '../../data/services/location_service.dart';
import '../../data/services/storage_service.dart';
import '../../data/repositories/weather_repository.dart';
import '../../data/repositories/location_repository.dart';

// Services
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final locationServiceProvider = Provider<LocationService>((ref) => LocationService());

final storageServiceProvider = Provider<StorageService>((ref) => StorageService());

// Repositories
final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return WeatherRepository(apiService);
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  final locationService = ref.read(locationServiceProvider);
  final storageService = ref.read(storageServiceProvider);
  return LocationRepository(apiService, locationService, storageService);
});
