import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/glassmorphic_card.dart';
import '../../../core/utils/weather_utils.dart';
import '../../../data/models/weather_model.dart';

class TemperatureCard extends StatelessWidget {
  final WeatherModel weather;

  const TemperatureCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        child: GlassmorphicCard(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            children: [
              // Temperature
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0, end: weather.temperature),
                builder: (context, value, child) {
                  return Text(
                    WeatherUtils.formatTemperature(value),
                    style: AppTextStyles.display,
                  );
                },
              ),

              const SizedBox(height: AppSpacing.xs),

              // Weather Condition
              Text(
                weather.description.toUpperCase(),
                style: AppTextStyles.weatherCondition,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.s),

              // Location
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    weather.cityName,
                    style: AppTextStyles.location,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xs),

              // Feels Like
              Text(
                'Feels like ${WeatherUtils.formatTemperature(weather.feelsLike)}',
                style: AppTextStyles.feelsLike,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
