import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/aura_hero_section.dart';
import '../widgets/aura_metrics_section.dart';
import '../widgets/hourly_forecast_strip.dart';
import '../widgets/plant_care_alert.dart';
import '../widgets/moon_phase_card.dart';
import '../../search/views/aura_search_screen.dart';
import '../../forecast/views/aura_forecast_screen.dart';
import '../../settings/views/aura_settings_screen.dart';
import '../../alerts/views/aura_alerts_screen.dart';
import '../../alerts/viewmodels/alerts_viewmodel.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/widgets/aura_search_bar.dart';
import '../../../core/widgets/weather_particles.dart';

class AuraHomeScreen extends ConsumerStatefulWidget {
  const AuraHomeScreen({super.key});

  @override
  ConsumerState<AuraHomeScreen> createState() => _AuraHomeScreenState();
}

class _AuraHomeScreenState extends ConsumerState<AuraHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(homeProvider.notifier).loadCurrentLocationWeather();
      // Load alerts after weather is loaded
      final weather = ref.read(homeProvider).weather;
      if (weather != null) {
        ref.read(alertsProvider.notifier).loadWeatherAlerts(
              weather.lat,
              weather.lon,
            );
      }
    });
  }

  void _openSearch() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuraSearchScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _openForecast() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AuraForecastScreen(),
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuraSettingsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _openAlerts() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuraAlertsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AuraColors.deepSpace,
      extendBodyBehindAppBar: true,
      body: homeState.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AuraColors.skyBlue,
              ),
            )
          : homeState.error != null
              ? _buildErrorState(homeState.error!)
              : homeState.weather == null
                  ? _buildEmptyState()
                  : Stack(
                      children: [
                        // Full-screen weather particles
                        Positioned.fill(
                          child: WeatherParticles(
                            condition: homeState.weather!.getWeatherCondition(),
                            isDay: homeState.weather!.isDay(),
                          ),
                        ),

                        // Main scrollable content
                        RefreshIndicator(
                          onRefresh: () async {
                            await ref.read(homeProvider.notifier).refreshWeather();
                          },
                          color: AuraColors.skyBlue,
                          backgroundColor: AuraColors.surfaceDark,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                // Hero weather section
                                AuraHeroSection(
                                  weather: homeState.weather!,
                                  onForecastTap: _openForecast,
                                ),
                                const SizedBox(height: 15),
                                // Hourly forecast strip (Apple-style)
                                if (homeState.forecast != null &&
                                    homeState.forecast!.hourlyForecasts.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                                    child: HourlyForecastStrip(
                                      hours: homeState.forecast!.hourlyForecasts,
                                    ),
                                  ),

                                const SizedBox(height: 8),

                                // Moon Phase Card
                                const MoonPhaseCard(),

                                const SizedBox(height: 8),

                                // Plant Care Alert
                                PlantCareAlert(
                                  temperature: homeState.weather!.temperature,
                                  humidity: homeState.weather!.humidity,
                                ),

                                // Metrics section
                                AuraMetricsSection(
                                  weather: homeState.weather!,
                                ),

                                SizedBox(height: size.height * 0.1),
                              ],
                            ),
                          ),
                        ),

                        // Floating search bar at top
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 16,
                          left: 20,
                          right: 20,
                          child: Row(
                            children: [
                              Expanded(
                                child: AuraSearchBar(
                                  onTap: _openSearch,
                                ),
                              ),
                              const SizedBox(width: 12),
                              _buildAlertButton(),
                              const SizedBox(width: 12),
                              _buildIconButton(
                                icon: Icons.settings_rounded,
                                onTap: _openSettings,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: AuraColors.textPrimary,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildAlertButton() {
    final alertsState = ref.watch(alertsProvider);
    final hasAlerts = alertsState.hasActiveAlerts;
    final alertCount = alertsState.activeAlertsCount;

    return GestureDetector(
      onTap: _openAlerts,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: hasAlerts
                  ? const Color(0xFFEF4444).withOpacity(0.2)
                  : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: hasAlerts
                  ? Border.all(
                      color: const Color(0xFFEF4444).withOpacity(0.3),
                      width: 1.5,
                    )
                  : null,
            ),
            child: Icon(
              Icons.warning_rounded,
              color: hasAlerts ? const Color(0xFFEF4444) : AuraColors.textPrimary,
              size: 22,
            ),
          ),
          if (hasAlerts && alertCount > 0)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AuraColors.deepSpace,
                    width: 2,
                  ),
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Center(
                  child: Text(
                    alertCount > 9 ? '9+' : alertCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
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
              size: 64,
              color: AuraColors.error,
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(homeProvider.notifier).refreshWeather();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No weather data available',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
