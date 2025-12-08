import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../data/models/weather_alert_model.dart';
import '../viewmodels/alerts_viewmodel.dart';
import '../../home/viewmodels/home_viewmodel.dart';

class AuraAlertsScreen extends ConsumerStatefulWidget {
  const AuraAlertsScreen({super.key});

  @override
  ConsumerState<AuraAlertsScreen> createState() => _AuraAlertsScreenState();
}

class _AuraAlertsScreenState extends ConsumerState<AuraAlertsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAlerts();
    });
  }

  void _loadAlerts() {
    final weather = ref.read(homeProvider).weather;
    if (weather != null) {
      ref.read(alertsProvider.notifier).loadWeatherAlerts(
            weather.lat,
            weather.lon,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final alertsState = ref.watch(alertsProvider);
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: AuraColors.deepSpace,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AuraColors.deepSpace,
              AuraColors.surfaceDark,
              AuraColors.deepSpace,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildBody(alertsState, homeState),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AuraColors.glassLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weather Alerts',
                style: AuraTypography.headline.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                ref.watch(homeProvider).weather?.cityName ?? 'Your Location',
                style: AuraTypography.body.copyWith(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(AlertsState alertsState, HomeState homeState) {
    if (alertsState.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AuraColors.skyBlue,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading alerts...',
              style: AuraTypography.body.copyWith(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    if (alertsState.alerts.isEmpty) {
      return _buildNoAlerts();
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (homeState.weather != null) {
          await ref.read(alertsProvider.notifier).refreshAlerts(
                homeState.weather!.lat,
                homeState.weather!.lon,
              );
        }
      },
      backgroundColor: AuraColors.surfaceDark,
      color: AuraColors.skyBlue,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: alertsState.sortedAlerts.length,
        itemBuilder: (context, index) {
          return _buildAlertCard(alertsState.sortedAlerts[index]);
        },
      ),
    );
  }

  Widget _buildNoAlerts() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AuraColors.skyBlue.withOpacity(0.2),
                  AuraColors.twilightPurple.withOpacity(0.2),
                ],
              ),
            ),
            child: Icon(
              Icons.check_circle_outline_rounded,
              size: 80,
              color: AuraColors.skyBlue,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Active Alerts',
            style: AuraTypography.headline.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'There are currently no weather alerts for your location. We\'ll notify you if conditions change.',
              textAlign: TextAlign.center,
              style: AuraTypography.body.copyWith(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(WeatherAlertModel alert) {
    final severity = alert.getSeverity();
    final severityColor = _getSeverityColor(severity);
    final severityText = _getSeverityText(severity);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    color: severityColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    alert.event,
                    style: AuraTypography.title.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: severityColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    severityText,
                    style: AuraTypography.body.copyWith(
                      color: severityColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AuraColors.glassLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Text(
                alert.description,
                style: AuraTypography.body.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
            ),
            if (alert.isActive())
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: severityColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_active_rounded,
                        color: severityColor,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ACTIVE NOW',
                        style: AuraTypography.body.copyWith(
                          color: severityColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.extreme:
        return const Color(0xFFEF4444);
      case AlertSeverity.severe:
        return const Color(0xFFF97316);
      case AlertSeverity.moderate:
        return AuraColors.sunYellow;
      case AlertSeverity.minor:
        return AuraColors.skyBlue;
    }
  }

  String _getSeverityText(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.extreme:
        return 'EXTREME';
      case AlertSeverity.severe:
        return 'SEVERE';
      case AlertSeverity.moderate:
        return 'MODERATE';
      case AlertSeverity.minor:
        return 'MINOR';
    }
  }
}
