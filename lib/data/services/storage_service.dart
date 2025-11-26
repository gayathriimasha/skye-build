import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';

class StorageService {
  static const String _favoritesKey = 'favorites';

  Future<void> init() async {
    // Initialize if needed
  }

  // Favorites Management
  Future<List<LocationModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
    return favoritesJson
        .map((json) => LocationModel.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> addFavorite(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.add(location);
    final favoritesJson = favorites.map((loc) => jsonEncode(loc.toJson())).toList();
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }

  Future<void> removeFavorite(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    if (index >= 0 && index < favorites.length) {
      favorites.removeAt(index);
      final favoritesJson = favorites.map((loc) => jsonEncode(loc.toJson())).toList();
      await prefs.setStringList(_favoritesKey, favoritesJson);
    }
  }

  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }

  Future<bool> isFavorite(double lat, double lon) async {
    final favorites = await getFavorites();
    return favorites.any((location) =>
        location.lat == lat && location.lon == lon);
  }

  // Settings Management
  Future<void> saveSetting(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getSetting(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> saveBoolSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<bool> getBoolSetting(String key, {bool defaultValue = false}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }
}
