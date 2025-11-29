import 'package:flutter/material.dart';
import '../theme/aura_colors.dart';
import '../../data/models/weather_model.dart';

/// Weather utilities for Aura design system
class AuraWeatherUtils {
  /// Get weather gradient based on condition
  static LinearGradient getWeatherGradient(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return AuraColors.sunnyGradient;
      case WeatherCondition.clearNight:
        return AuraColors.clearNightGradient;
      case WeatherCondition.cloudy:
        return AuraColors.cloudyGradient;
      case WeatherCondition.rainy:
        return AuraColors.rainyGradient;
      case WeatherCondition.snowy:
        return AuraColors.snowyGradient;
      case WeatherCondition.thunderstorm:
        return AuraColors.thunderstormGradient;
    }
  }

  /// Get weather icon based on condition
  static IconData getWeatherIcon(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return Icons.wb_sunny_rounded;
      case WeatherCondition.clearNight:
        return Icons.nightlight_round;
      case WeatherCondition.cloudy:
        return Icons.cloud_rounded;
      case WeatherCondition.rainy:
        return Icons.water_drop_rounded;
      case WeatherCondition.snowy:
        return Icons.ac_unit_rounded;
      case WeatherCondition.thunderstorm:
        return Icons.thunderstorm_rounded;
    }
  }

  /// Format temperature with degree symbol
  static String formatTemperature(double temp, {bool showUnit = true}) {
    return '${temp.round()}${showUnit ? '°' : ''}';
  }

  /// Format wind speed
  static String formatWindSpeed(double speed) {
    return '${speed.toStringAsFixed(1)} m/s';
  }

  /// Format humidity
  static String formatHumidity(int humidity) {
    return '$humidity%';
  }

  /// Format pressure
  static String formatPressure(int pressure) {
    return '$pressure hPa';
  }

  /// Format visibility in km
  static String formatVisibility(int visibility) {
    return '${(visibility / 1000).toStringAsFixed(1)} km';
  }

  /// Get condition text with proper casing
  static String getConditionText(String condition) {
    return condition.isNotEmpty
        ? condition[0].toUpperCase() + condition.substring(1).toLowerCase()
        : '';
  }
}
