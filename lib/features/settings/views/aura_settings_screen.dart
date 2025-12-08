import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/settings_tile.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../viewmodels/settings_state.dart';

class AuraSettingsScreen extends ConsumerWidget {
  const AuraSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AuraColors.deepSpace,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: AuraColors.textPrimary,
                ),
              ),
              title: Text(
                'Settings',
                style: AuraTypography.headline,
              ),
            ),

            // Content
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Units Section
                  _buildSectionHeader('Units'),
                  const SizedBox(height: 16),

                  SettingsTile(
                    icon: Icons.thermostat_rounded,
                    title: 'Temperature',
                    subtitle: settingsState.temperatureUnitString,
                    onTap: () => _showTemperatureDialog(context, ref, settingsState),
                    iconColor: AuraColors.skyBlue,
                  ),
                  const SizedBox(height: 12),

                  SettingsTile(
                    icon: Icons.air_rounded,
                    title: 'Wind Speed',
                    subtitle: settingsState.windSpeedUnitString,
                    onTap: () => _showWindSpeedDialog(context, ref, settingsState),
                    iconColor: AuraColors.skyBlue,
                  ),
                  const SizedBox(height: 12),

                  SettingsTile(
                    icon: Icons.access_time_rounded,
                    title: 'Time Format',
                    subtitle: settingsState.timeFormatString,
                    onTap: () => _showTimeFormatDialog(context, ref, settingsState),
                    iconColor: AuraColors.skyBlue,
                  ),

                  const SizedBox(height: 32),

                  // Appearance Section
                  _buildSectionHeader('Appearance'),
                  const SizedBox(height: 16),

                  SettingsTile(
                    icon: Icons.animation_rounded,
                    title: 'Weather Animations',
                    subtitle: settingsState.animationsEnabled ? 'Enabled' : 'Disabled',
                    iconColor: AuraColors.twilightPurple,
                    trailing: Switch(
                      value: settingsState.animationsEnabled,
                      onChanged: (value) {
                        ref.read(settingsProvider.notifier).setAnimationsEnabled(value);
                      },
                      activeTrackColor: AuraColors.skyBlue,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // About Section
                  _buildSectionHeader('About'),
                  const SizedBox(height: 16),

                  SettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: 'Version',
                    subtitle: '1.0.0 (Aura)',
                    iconColor: AuraColors.twilightPurple,
                  ),
                  const SizedBox(height: 12),

                  const SizedBox(height: 48),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AuraTypography.title.copyWith(fontSize: 18),
    );
  }

  void _showTemperatureDialog(BuildContext context, WidgetRef ref, SettingsState state) {
    _showOptionsDialog(
      context: context,
      title: 'Temperature Unit',
      options: ['Celsius', 'Fahrenheit', 'Kelvin'],
      currentValue: state.temperatureUnitString,
      onSelected: (value) {
        final unit = value == 'Celsius'
            ? TemperatureUnit.celsius
            : value == 'Fahrenheit'
                ? TemperatureUnit.fahrenheit
                : TemperatureUnit.kelvin;
        ref.read(settingsProvider.notifier).setTemperatureUnit(unit);
      },
    );
  }

  void _showWindSpeedDialog(BuildContext context, WidgetRef ref, SettingsState state) {
    _showOptionsDialog(
      context: context,
      title: 'Wind Speed Unit',
      options: ['m/s', 'km/h', 'mph'],
      currentValue: state.windSpeedUnitString,
      onSelected: (value) {
        final unit = value == 'm/s'
            ? WindSpeedUnit.metersPerSecond
            : value == 'km/h'
                ? WindSpeedUnit.kilometersPerHour
                : WindSpeedUnit.milesPerHour;
        ref.read(settingsProvider.notifier).setWindSpeedUnit(unit);
      },
    );
  }

  void _showTimeFormatDialog(BuildContext context, WidgetRef ref, SettingsState state) {
    _showOptionsDialog(
      context: context,
      title: 'Time Format',
      options: ['24-hour', '12-hour'],
      currentValue: state.timeFormatString,
      onSelected: (value) {
        final format = value == '24-hour'
            ? TimeFormat.twentyFourHour
            : TimeFormat.twelveHour;
        ref.read(settingsProvider.notifier).setTimeFormat(format);
      },
    );
  }

  void _showOptionsDialog({
    required BuildContext context,
    required String title,
    required List<String> options,
    required String currentValue,
    required Function(String) onSelected,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AuraColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          title,
          style: AuraTypography.title,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            final isSelected = option == currentValue;
            return GestureDetector(
              onTap: () {
                onSelected(option);
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AuraColors.skyBlue.withOpacity(0.25)
                      : AuraColors.glassLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text(
                      option,
                      style: AuraTypography.bodyLarge.copyWith(
                        color: isSelected
                            ? AuraColors.skyBlue
                            : AuraColors.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    if (isSelected)
                      Icon(
                        Icons.check_circle_rounded,
                        color: AuraColors.skyBlue,
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
