import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/utils/aura_weather_utils.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/weather_animation.dart';
import '../../../data/models/weather_model.dart';

class AuraHeroSection extends StatelessWidget {
  final WeatherModel weather;
  final VoidCallback? onForecastTap;

  const AuraHeroSection({
    super.key,
    required this.weather,
    this.onForecastTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final gradient = AuraWeatherUtils.getWeatherGradient(
      weather.getWeatherCondition(),
    );

    return Container(
      width: size.width,
      height: size.height * 1,
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: Stack(
        children: [
          // Main content
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 120, 24, 16),
              child: Column(
                children: [
                  // Location & Date
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: AuraColors.textPrimary.withOpacity(0.9),
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              weather.cityName,
                              style: AuraTypography.headline,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppDateUtils.formatDayMonth(DateTime.now()),
                          style: AuraTypography.body.copyWith(
                            color: AuraColors.textSecondary.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Weather Animation
                  FadeIn(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 200),
                    child: WeatherAnimation(
                      condition: weather.getWeatherCondition(),
                      size: 120,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Temperature
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 300),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1400),
                      tween: Tween(begin: 0, end: weather.temperature),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Text(
                          AuraWeatherUtils.formatTemperature(value),
                          style: AuraTypography.display,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Condition
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 400),
                    child: Text(
                      AuraWeatherUtils.getConditionText(weather.description),
                      style: AuraTypography.condition.copyWith(
                        letterSpacing: 2,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const Spacer(),

                  // Quick stats row
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 500),
                    child: _buildQuickStats(),
                  ),

                  const SizedBox(height: 16),

                  // Forecast hint
                  if (onForecastTap != null)
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 600),
                      child: _buildForecastButton(),
                    ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickStat(
            'Feels Like',
            AuraWeatherUtils.formatTemperature(weather.feelsLike),
          ),
          _buildDivider(),
          _buildQuickStat(
            'Humidity',
            AuraWeatherUtils.formatHumidity(weather.humidity),
          ),
          _buildDivider(),
          _buildQuickStat(
            'Wind',
            AuraWeatherUtils.formatWindSpeed(weather.windSpeed),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastButton() {
    return GestureDetector(
      onTap: onForecastTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '7-Day Forecast',
              style: AuraTypography.label.copyWith(
                color: AuraColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_up_rounded,
              color: AuraColors.textPrimary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AuraTypography.subtitle.copyWith(
            color: AuraColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AuraTypography.caption.copyWith(
            color: AuraColors.textSecondary.withOpacity(0.85),
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white.withOpacity(0.25),
    );
  }

}
