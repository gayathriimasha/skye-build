import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../viewmodels/forecast_viewmodel.dart';
import '../../home/viewmodels/home_viewmodel.dart';
import '../../../core/theme/skye_colors.dart';
import '../../../core/theme/skye_typography.dart';
import '../../../core/utils/skye_weather_utils.dart';
import '../../../core/utils/date_utils.dart';

class SkyeForecastScreen extends ConsumerStatefulWidget {
  const SkyeForecastScreen({super.key});

  @override
  ConsumerState<SkyeForecastScreen> createState() =>
      _SkyeForecastScreenState();
}

class _SkyeForecastScreenState extends ConsumerState<SkyeForecastScreen> {
  bool _showHourly = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final homeState = ref.read(homeProvider);
      if (homeState.currentLocation != null) {
        ref.read(forecastProvider.notifier).loadForecast(
              homeState.currentLocation!.lat,
              homeState.currentLocation!.lon,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final forecastState = ref.watch(forecastProvider);
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.85,
      decoration: BoxDecoration(
        color: SkyeColors.deepSpace,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: SkyeColors.textMuted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Forecast',
                  style: SkyeTypography.headline,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: SkyeColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Toggle between hourly and daily
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: SkyeColors.surfaceDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildToggleButton(
                      'Hourly',
                      _showHourly,
                      () => setState(() => _showHourly = true),
                    ),
                  ),
                  Expanded(
                    child: _buildToggleButton(
                      'Daily',
                      !_showHourly,
                      () => setState(() => _showHourly = false),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Content
          Expanded(
            child: forecastState.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: SkyeColors.skyBlue,
                    ),
                  )
                : forecastState.error != null
                    ? _buildErrorState(forecastState.error!)
                    : forecastState.forecast == null
                        ? _buildEmptyState()
                        : _showHourly
                            ? _buildHourlyForecast(forecastState.forecast!)
                            : _buildDailyForecast(forecastState.forecast!),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? SkyeColors.skyBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: SkyeTypography.subtitle.copyWith(
            color: isActive ? SkyeColors.deepSpace : SkyeColors.textTertiary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildHourlyForecast(dynamic forecast) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: forecast.hourlyForecasts.length,
      itemBuilder: (context, index) {
        final hourly = forecast.hourlyForecasts[index];
        return FadeInUp(
          duration: const Duration(milliseconds: 400),
          delay: Duration(milliseconds: index * 50),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: SkyeColors.glassLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Text(
                    AppDateUtils.getHourFromTimestamp(hourly.dt),
                    style: SkyeTypography.subtitle,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  SkyeWeatherUtils.getIconFromCondition(
                    hourly.condition,
                    iconCode: hourly.icon,
                  ),
                  color: SkyeWeatherUtils.getIconColor(
                    hourly.condition,
                    iconCode: hourly.icon,
                  ),
                  size: 32,
                ),
                const Spacer(),
                Text(
                  SkyeWeatherUtils.formatTemperature(hourly.temperature),
                  style: SkyeTypography.temperature.copyWith(
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDailyForecast(dynamic forecast) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: forecast.dailyForecasts.length,
      itemBuilder: (context, index) {
        final daily = forecast.dailyForecasts[index];
        return FadeInUp(
          duration: const Duration(milliseconds: 400),
          delay: Duration(milliseconds: index * 50),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: SkyeColors.glassLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    daily.getDayName(),
                    style: SkyeTypography.subtitle,
                  ),
                ),
                Icon(
                  SkyeWeatherUtils.getIconFromCondition(
                    daily.condition,
                    iconCode: daily.icon,
                  ),
                  color: SkyeWeatherUtils.getIconColor(
                    daily.condition,
                    iconCode: daily.icon,
                  ),
                  size: 40,
                ),
                const Spacer(),
                Text(
                  SkyeWeatherUtils.formatTemperature(
                    daily.minTemp,
                    showUnit: false,
                  ),
                  style: SkyeTypography.body.copyWith(
                    color: SkyeColors.textTertiary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '/',
                  style: SkyeTypography.body.copyWith(
                    color: SkyeColors.textMuted,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  SkyeWeatherUtils.formatTemperature(daily.maxTemp),
                  style: SkyeTypography.temperature,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: SkyeColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              style: SkyeTypography.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No forecast data available',
        style: SkyeTypography.body,
      ),
    );
  }
}
