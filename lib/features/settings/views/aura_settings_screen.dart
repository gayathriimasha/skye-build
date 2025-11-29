import 'package:flutter/material.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/settings_tile.dart';

class AuraSettingsScreen extends StatefulWidget {
  const AuraSettingsScreen({super.key});

  @override
  State<AuraSettingsScreen> createState() => _AuraSettingsScreenState();
}

class _AuraSettingsScreenState extends State<AuraSettingsScreen> {
  bool _animationsEnabled = true;
  String _temperatureUnit = 'Celsius';
  String _windSpeedUnit = 'm/s';
  String _timeFormat = '24-hour';

  @override
  Widget build(BuildContext context) {
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
                    subtitle: _temperatureUnit,
                    onTap: _showTemperatureDialog,
                    iconColor: AuraColors.skyBlue,
                  ),
                  const SizedBox(height: 12),

                  SettingsTile(
                    icon: Icons.air_rounded,
                    title: 'Wind Speed',
                    subtitle: _windSpeedUnit,
                    onTap: _showWindSpeedDialog,
                    iconColor: AuraColors.skyBlue,
                  ),
                  const SizedBox(height: 12),

                  SettingsTile(
                    icon: Icons.access_time_rounded,
                    title: 'Time Format',
                    subtitle: _timeFormat,
                    onTap: _showTimeFormatDialog,
                    iconColor: AuraColors.skyBlue,
                  ),

                  const SizedBox(height: 32),

                  // Appearance Section
                  _buildSectionHeader('Appearance'),
                  const SizedBox(height: 16),

                  SettingsTile(
                    icon: Icons.animation_rounded,
                    title: 'Weather Animations',
                    subtitle: _animationsEnabled ? 'Enabled' : 'Disabled',
                    iconColor: AuraColors.twilightPurple,
                    trailing: Switch(
                      value: _animationsEnabled,
                      onChanged: (value) {
                        setState(() => _animationsEnabled = value);
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

  void _showTemperatureDialog() {
    _showOptionsDialog(
      title: 'Temperature Unit',
      options: ['Celsius', 'Fahrenheit', 'Kelvin'],
      currentValue: _temperatureUnit,
      onSelected: (value) {
        setState(() => _temperatureUnit = value);
      },
    );
  }

  void _showWindSpeedDialog() {
    _showOptionsDialog(
      title: 'Wind Speed Unit',
      options: ['m/s', 'km/h', 'mph'],
      currentValue: _windSpeedUnit,
      onSelected: (value) {
        setState(() => _windSpeedUnit = value);
      },
    );
  }

  void _showTimeFormatDialog() {
    _showOptionsDialog(
      title: 'Time Format',
      options: ['24-hour', '12-hour'],
      currentValue: _timeFormat,
      onSelected: (value) {
        setState(() => _timeFormat = value);
      },
    );
  }

  void _showOptionsDialog({
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
