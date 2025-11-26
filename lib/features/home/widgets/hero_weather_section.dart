import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/utils/weather_utils.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/weather_model.dart';

class HeroWeatherSection extends StatelessWidget {
  final WeatherModel weather;
  final double heightPercentage;

  const HeroWeatherSection({
    super.key,
    required this.weather,
    this.heightPercentage = 0.65,
  });

  IconData _getWeatherIcon() {
    switch (weather.getWeatherCondition()) {
      case WeatherCondition.sunny:
        return Icons.wb_sunny;
      case WeatherCondition.clearNight:
        return Icons.nightlight_round;
      case WeatherCondition.cloudy:
        return Icons.cloud;
      case WeatherCondition.rainy:
        return Icons.water_drop;
      case WeatherCondition.snowy:
        return Icons.ac_unit;
      case WeatherCondition.thunderstorm:
        return Icons.thunderstorm;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final gradient = WeatherUtils.getWeatherGradient(weather.getWeatherCondition());
    final now = DateTime.now();

    return SizedBox(
      width: size.width,
      height: size.height * heightPercentage,
      child: Stack(
        children: [
          // Animated Gradient Background
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: gradient,
            ),
          ),

          // Particle Effects for Rain
          if (weather.getWeatherCondition() == WeatherCondition.rainy ||
              weather.getWeatherCondition() == WeatherCondition.thunderstorm)
            Newton(
              activeEffects: [
                RainEffect(
                  particleConfiguration: ParticleConfiguration(
                    shape: CircleShape(),
                    size: const Size(3, 20),
                    color: const SingleParticleColor(color: Colors.white),
                  ),
                  effectConfiguration: EffectConfiguration(
                    particleCount: 100,
                  ),
                ),
              ],
            ),

          // Particle Effects for Snow
          if (weather.getWeatherCondition() == WeatherCondition.snowy)
            Newton(
              activeEffects: [
                RainEffect(
                  particleConfiguration: ParticleConfiguration(
                    shape: CircleShape(),
                    size: const Size(5, 5),
                    color: const SingleParticleColor(color: Colors.white),
                  ),
                  effectConfiguration: EffectConfiguration(
                    particleCount: 50,
                  ),
                ),
              ],
            ),

          // Main Content - PROPERLY ALIGNED AND FILLED
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  // Top Bar - Location and Date
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              weather.cityName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          AppDateUtils.formatDayMonth(now),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Massive Weather Icon
                  FadeIn(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 200),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1000),
                      tween: Tween(begin: 0.8, end: 1.0),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Icon(
                            _getWeatherIcon(),
                            size: 140,
                            color: Colors.white.withOpacity(0.95),
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.15),
                                offset: const Offset(0, 4),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Massive Temperature
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 300),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1200),
                      tween: Tween(begin: 0, end: weather.temperature),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Text(
                          WeatherUtils.formatTemperature(value),
                          style: TextStyle(
                            fontSize: 110,
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                            height: 1.0,
                            letterSpacing: -4,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 4),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Weather Description
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 400),
                    child: Text(
                      weather.description.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Feels Like and High/Low Row
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 500),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildQuickStat(
                            'Feels Like',
                            WeatherUtils.formatTemperature(weather.feelsLike),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          _buildQuickStat(
                            'Humidity',
                            '${weather.humidity}%',
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          _buildQuickStat(
                            'Wind',
                            '${weather.windSpeed.toStringAsFixed(1)}m/s',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Sunrise/Sunset Row
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 600),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSunInfo(
                          Icons.wb_sunny,
                          'Sunrise',
                          AppDateUtils.getTimeFromTimestamp(weather.sunrise),
                        ),
                        _buildSunInfo(
                          Icons.nightlight_round,
                          'Sunset',
                          AppDateUtils.getTimeFromTimestamp(weather.sunset),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildSunInfo(IconData icon, String label, String time) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.9),
          size: 24,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              time,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
