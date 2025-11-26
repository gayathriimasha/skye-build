import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/weather_utils.dart';
import '../../../data/models/weather_model.dart';

class WeatherMetricsGrid extends StatelessWidget {
  final WeatherModel weather;

  const WeatherMetricsGrid({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 16),
            child: Text(
              'Weather Details',
              style: AppTextStyles.title.copyWith(fontSize: 22),
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.s,
            crossAxisSpacing: AppSpacing.s,
            childAspectRatio: 1.5,
            children: [
              _buildMetricCard(
                icon: Icons.air,
                label: 'Wind Speed',
                value: WeatherUtils.formatWindSpeed(weather.windSpeed),
                delay: 0,
              ),
              _buildMetricCard(
                icon: Icons.water_drop,
                label: 'Humidity',
                value: '${weather.humidity}%',
                delay: 100,
              ),
              _buildMetricCard(
                icon: Icons.speed,
                label: 'Pressure',
                value: '${weather.pressure} hPa',
                delay: 200,
              ),
              _buildMetricCard(
                icon: Icons.visibility,
                label: 'Visibility',
                value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
                delay: 300,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required int delay,
  }) {
    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      delay: Duration(milliseconds: delay),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              AppColors.softBlueWhite,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.skyBlue.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.skyBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.skyBlue,
                size: 28,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.metricValue.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: AppTextStyles.metricLabel.copyWith(fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
