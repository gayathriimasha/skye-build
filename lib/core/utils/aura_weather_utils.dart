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

  /// Get weather icon from condition string
  static IconData getIconFromCondition(String condition, {String? iconCode}) {
    // OpenWeatherMap icon codes: https://openweathermap.org/weather-conditions
    // 01d = clear day, 01n = clear night, 02d = few clouds, 03d = scattered clouds
    // 04d = broken clouds, 09d = shower rain, 10d = rain, 11d = thunderstorm
    // 13d = snow, 50d = mist

    if (iconCode != null) {
      if (iconCode.startsWith('01d')) return Icons.wb_sunny_rounded;
      if (iconCode.startsWith('01n')) return Icons.nightlight_round;
      if (iconCode.startsWith('02')) return Icons.wb_cloudy_rounded;
      if (iconCode.startsWith('03') || iconCode.startsWith('04')) {
        return Icons.cloud_rounded;
      }
      if (iconCode.startsWith('09') || iconCode.startsWith('10')) {
        return Icons.water_drop_rounded;
      }
      if (iconCode.startsWith('11')) return Icons.thunderstorm_rounded;
      if (iconCode.startsWith('13')) return Icons.ac_unit_rounded;
      if (iconCode.startsWith('50')) return Icons.foggy;
    }

    // Fallback to condition string
    final conditionLower = condition.toLowerCase();
    if (conditionLower.contains('clear')) {
      return Icons.wb_sunny_rounded;
    } else if (conditionLower.contains('cloud')) {
      return Icons.cloud_rounded;
    } else if (conditionLower.contains('rain') || conditionLower.contains('drizzle')) {
      return Icons.water_drop_rounded;
    } else if (conditionLower.contains('thunder')) {
      return Icons.thunderstorm_rounded;
    } else if (conditionLower.contains('snow')) {
      return Icons.ac_unit_rounded;
    } else if (conditionLower.contains('mist') || conditionLower.contains('fog')) {
      return Icons.foggy;
    }

    return Icons.wb_cloudy_rounded;
  }

  /// Get weather icon color from condition
  static Color getIconColor(String condition, {String? iconCode}) {
    if (iconCode != null) {
      if (iconCode.startsWith('01d')) return AuraColors.sunYellow;
      if (iconCode.startsWith('01n')) return AuraColors.moonLight;
      if (iconCode.startsWith('09') || iconCode.startsWith('10')) {
        return AuraColors.rainBlue;
      }
      if (iconCode.startsWith('11')) return AuraColors.stormPurple;
      if (iconCode.startsWith('13')) return AuraColors.snowWhite;
    }

    final conditionLower = condition.toLowerCase();
    if (conditionLower.contains('clear')) {
      return AuraColors.sunYellow;
    } else if (conditionLower.contains('rain') || conditionLower.contains('drizzle')) {
      return AuraColors.rainBlue;
    } else if (conditionLower.contains('thunder')) {
      return AuraColors.stormPurple;
    } else if (conditionLower.contains('snow')) {
      return AuraColors.snowWhite;
    }

    return AuraColors.cloudGray;
  }
}
