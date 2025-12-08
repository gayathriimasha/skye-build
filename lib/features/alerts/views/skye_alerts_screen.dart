import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/skye_colors.dart';
import '../../../core/theme/skye_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../data/models/weather_alert_model.dart';
import '../viewmodels/alerts_viewmodel.dart';
import '../../home/viewmodels/home_viewmodel.dart';
import '../../user_alerts/views/user_alerts_screen.dart';

class SkyeAlertsScreen extends ConsumerStatefulWidget {
  const SkyeAlertsScreen({super.key});

  @override
  ConsumerState<SkyeAlertsScreen> createState() => _SkyeAlertsScreenState();
}

class _SkyeAlertsScreenState extends ConsumerState<SkyeAlertsScreen> {
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
      backgroundColor: SkyeColors.deepSpace,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              SkyeColors.deepSpace,
              SkyeColors.surfaceDark,
              SkyeColors.deepSpace,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: _buildBody(alertsState, homeState),
                  ),
                ],
              ),
              Positioned(
                right: 20,
                bottom: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserAlertsScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          SkyeColors.skyBlue,
                          const Color.fromARGB(255, 54, 122, 185),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: SkyeColors.skyBlue.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'My Alerts',
                          style: SkyeTypography.body.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                color: SkyeColors.glassLight,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weather Alerts',
                  style: SkyeTypography.headline.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ref.watch(homeProvider).weather?.cityName ?? 'Your Location',
                  style: SkyeTypography.body.copyWith(
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
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
              color: SkyeColors.skyBlue,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading alerts...',
              style: SkyeTypography.body.copyWith(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    if (alertsState.alerts.isEmpty && alertsState.userAlerts.isEmpty) {
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
      backgroundColor: SkyeColors.surfaceDark,
      color: SkyeColors.skyBlue,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: alertsState.sortedAlerts.length + alertsState.userAlerts.length,
        itemBuilder: (context, index) {
          if (index < alertsState.userAlerts.length) {
            return _buildUserAlertCard(alertsState.userAlerts[index]);
          } else {
            return _buildAlertCard(alertsState.sortedAlerts[index - alertsState.userAlerts.length]);
          }
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
                  SkyeColors.skyBlue.withOpacity(0.2),
                  SkyeColors.twilightPurple.withOpacity(0.2),
                ],
              ),
            ),
            child: Icon(
              Icons.check_circle_outline_rounded,
              size: 80,
              color: SkyeColors.skyBlue,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Active Alerts',
            style: SkyeTypography.headline.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'There are currently no weather alerts for your location. We\'ll notify you if conditions change.',
              textAlign: TextAlign.center,
              style: SkyeTypography.body.copyWith(
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
                    style: SkyeTypography.title.copyWith(
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
                    style: SkyeTypography.body.copyWith(
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
                color: SkyeColors.glassLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Text(
                alert.description,
                style: SkyeTypography.body.copyWith(
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
                        style: SkyeTypography.body.copyWith(
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
        return SkyeColors.sunYellow;
      case AlertSeverity.minor:
        return SkyeColors.skyBlue;
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

  Widget _buildUserAlertCard(alert) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        borderRadius: 24,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.notifications_active_rounded,
                      color: SkyeColors.skyBlue,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'MY ALERT',
                      style: SkyeTypography.bodySmall.copyWith(
                        color: SkyeColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: SkyeColors.skyBlue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: SkyeColors.skyBlue,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ACTIVE',
                        style: SkyeTypography.caption.copyWith(
                          color: SkyeColors.skyBlue,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              alert.name,
              style: SkyeTypography.title.copyWith(
                color: SkyeColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.thermostat_rounded,
                  size: 16,
                  color: SkyeColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  alert.conditionDescription,
                  style: SkyeTypography.body.copyWith(
                    color: SkyeColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
