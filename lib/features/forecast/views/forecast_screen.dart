import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/forecast_viewmodel.dart';
import '../../home/viewmodels/home_viewmodel.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/weather_utils.dart';
import '../../../core/utils/date_utils.dart';

class ForecastScreen extends ConsumerStatefulWidget {
  const ForecastScreen({super.key});

  @override
  ConsumerState<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends ConsumerState<ForecastScreen> {
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Forecast', style: AppTextStyles.title),
        backgroundColor: AppColors.skyBlue,
      ),
      body: forecastState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : forecastState.error != null
              ? Center(child: Text(forecastState.error!))
              : forecastState.forecast == null
                  ? const Center(child: Text('No forecast data'))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSpacing.m),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                            child: Text('Hourly Forecast', style: AppTextStyles.title),
                          ),
                          const SizedBox(height: AppSpacing.s),
                          _buildHourlyForecast(forecastState.forecast!),
                          const SizedBox(height: AppSpacing.l),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                            child: Text('7-Day Forecast', style: AppTextStyles.title),
                          ),
                          const SizedBox(height: AppSpacing.s),
                          _buildDailyForecast(forecastState.forecast!),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildHourlyForecast(forecast) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        itemCount: forecast.hourlyForecasts.length,
        itemBuilder: (context, index) {
          final hourly = forecast.hourlyForecasts[index];
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppDateUtils.getHourFromTimestamp(hourly.dt),
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.xs),
                const Icon(Icons.wb_sunny, size: 40, color: AppColors.skyBlue),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  WeatherUtils.formatTemperature(hourly.temperature),
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailyForecast(forecast) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      itemCount: forecast.dailyForecasts.length,
      itemBuilder: (context, index) {
        final daily = forecast.dailyForecasts[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.s),
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  daily.getDayName(),
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const Icon(Icons.wb_sunny, size: 48, color: AppColors.skyBlue),
              const Spacer(),
              Text(
                WeatherUtils.formatTemperature(daily.minTemp),
                style: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(width: AppSpacing.s),
              Text(
                WeatherUtils.formatTemperature(daily.maxTemp),
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      },
    );
  }
}
