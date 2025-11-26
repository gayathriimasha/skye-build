import '../models/location_model.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

class LocationRepository {
  final ApiService _apiService;
  final LocationService _locationService;
  final StorageService _storageService;

  LocationRepository(
    this._apiService,
    this._locationService,
    this._storageService,
  );

  Future<List<LocationModel>> searchLocation(String query) async {
    try {
      return await _apiService.searchLocation(query);
    } catch (e) {
      rethrow;
    }
  }

  Future<LocationModel> getCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();
      final cityName = await _locationService.getCityName(
        position.latitude,
        position.longitude,
      );

      return LocationModel(
        name: cityName,
        lat: position.latitude,
        lon: position.longitude,
        country: '',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addFavorite(LocationModel location) async {
    await _storageService.addFavorite(location);
  }

  Future<void> removeFavorite(int index) async {
    await _storageService.removeFavorite(index);
  }

  Future<List<LocationModel>> getFavorites() async {
    return await _storageService.getFavorites();
  }

  Future<bool> isFavorite(double lat, double lon) async {
    return await _storageService.isFavorite(lat, lon);
  }
}
