import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/aura_colors.dart';
import '../../data/models/weather_model.dart';

class WeatherUtils {
  static LinearGradient getWeatherGradient(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return AuraColors.sunnyGradient;
      case WeatherCondition.cloudy:
        return AuraColors.cloudyGradient;
      case WeatherCondition.rainy:
        return AuraColors.rainyGradient;
      case WeatherCondition.thunderstorm:
        return AuraColors.thunderstormGradient;
      case WeatherCondition.snowy:
        return AuraColors.snowyGradient;
      case WeatherCondition.clearNight:
        return AuraColors.clearNightGradient;
    }
  }

  static String getWeatherIcon(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return 'assets/icons/sun.png';
      case WeatherCondition.clearNight:
        return 'assets/icons/moon.png';
      case WeatherCondition.cloudy:
        return 'assets/icons/cloudy.png';
      case WeatherCondition.rainy:
        return 'assets/icons/rainy.png';
      case WeatherCondition.snowy:
        return 'assets/icons/snowy.png';
      case WeatherCondition.thunderstorm:
        return 'assets/icons/storm.png';
    }
  }

  static String getLottieAnimation(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return 'assets/animations/sunny.json';
      case WeatherCondition.clearNight:
        return 'assets/animations/night.json';
      case WeatherCondition.cloudy:
        return 'assets/animations/cloudy.json';
      case WeatherCondition.rainy:
        return 'assets/animations/rainy.json';
      case WeatherCondition.snowy:
        return 'assets/animations/snowy.json';
      case WeatherCondition.thunderstorm:
        return 'assets/animations/storm.json';
    }
  }

  static String formatTemperature(double temp, {bool useCelsius = true}) {
    if (useCelsius) {
      return '${temp.round()}°';
    } else {
      final fahrenheit = (temp * 9 / 5) + 32;
      return '${fahrenheit.round()}°';
    }
  }

  static String formatWindSpeed(double speed, {String unit = 'm/s'}) {
    switch (unit) {
      case 'mph':
        final mph = speed * 2.237;
        return '${mph.toStringAsFixed(1)} mph';
      case 'km/h':
        final kmh = speed * 3.6;
        return '${kmh.toStringAsFixed(1)} km/h';
      default:
        return '${speed.toStringAsFixed(1)} m/s';
    }
  }

  static String getUVIndexLevel(int uvIndex) {
    if (uvIndex <= 2) return 'Low';
    if (uvIndex <= 5) return 'Moderate';
    if (uvIndex <= 7) return 'High';
    if (uvIndex <= 10) return 'Very High';
    return 'Extreme';
  }

  static Color getUVIndexColor(int uvIndex) {
    if (uvIndex <= 2) return AppColors.successColor;
    if (uvIndex <= 5) return AppColors.warningColor;
    return AppColors.errorColor;
  }
}
