import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/hero_weather_section.dart';
import '../widgets/weather_metrics_grid.dart';
import '../../../core/constants/app_colors.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(homeProvider.notifier).loadCurrentLocationWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: AppColors.softBlueWhite,
      body: homeState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : homeState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: AppColors.errorColor),
                      const SizedBox(height: 16),
                      Text(homeState.error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(homeProvider.notifier).refreshWeather();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : homeState.weather == null
                  ? const Center(child: Text('No weather data'))
                  : RefreshIndicator(
                      onRefresh: () async {
                        await ref.read(homeProvider.notifier).refreshWeather();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            HeroWeatherSection(
                              weather: homeState.weather!,
                            ),
                            const SizedBox(height: 20),
                            WeatherMetricsGrid(
                              weather: homeState.weather!,
                            ),
                          ],
                        ),
                      ),
                    ),
    );
  }
}
