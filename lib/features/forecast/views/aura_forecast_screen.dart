import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../viewmodels/forecast_viewmodel.dart';
import '../../home/viewmodels/home_viewmodel.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/utils/aura_weather_utils.dart';
import '../../../core/utils/date_utils.dart';

class AuraForecastScreen extends ConsumerStatefulWidget {
  const AuraForecastScreen({super.key});

  @override
  ConsumerState<AuraForecastScreen> createState() =>
      _AuraForecastScreenState();
}

class _AuraForecastScreenState extends ConsumerState<AuraForecastScreen> {
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
        color: AuraColors.deepSpace,
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
              color: AuraColors.textMuted,
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
                  style: AuraTypography.headline,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: AuraColors.textPrimary,
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
                color: AuraColors.surfaceDark,
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
                      color: AuraColors.skyBlue,
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
          color: isActive ? AuraColors.skyBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AuraTypography.subtitle.copyWith(
            color: isActive ? AuraColors.deepSpace : AuraColors.textTertiary,
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
              color: AuraColors.glassLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Text(
                    AppDateUtils.getHourFromTimestamp(hourly.dt),
                    style: AuraTypography.subtitle,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.wb_sunny_rounded,
                  color: AuraColors.sunYellow,
                  size: 32,
                ),
                const Spacer(),
                Text(
                  AuraWeatherUtils.formatTemperature(hourly.temperature),
                  style: AuraTypography.temperature.copyWith(
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
              color: AuraColors.glassLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    daily.getDayName(),
                    style: AuraTypography.subtitle,
                  ),
                ),
                Icon(
                  Icons.wb_sunny_rounded,
                  color: AuraColors.sunYellow,
                  size: 40,
                ),
                const Spacer(),
                Text(
                  AuraWeatherUtils.formatTemperature(
                    daily.minTemp,
                    showUnit: false,
                  ),
                  style: AuraTypography.body.copyWith(
                    color: AuraColors.textTertiary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '/',
                  style: AuraTypography.body.copyWith(
                    color: AuraColors.textMuted,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  AuraWeatherUtils.formatTemperature(daily.maxTemp),
                  style: AuraTypography.temperature,
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
              color: AuraColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              style: AuraTypography.body,
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
        style: AuraTypography.body,
      ),
    );
  }
}
