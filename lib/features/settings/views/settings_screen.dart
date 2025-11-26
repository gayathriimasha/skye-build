import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.title),
        backgroundColor: AppColors.skyBlue,
      ),
      body: ListView(
        children: [
          const SizedBox(height: AppSpacing.m),
          _buildSection('Units'),
          _buildSettingTile(
            icon: Icons.thermostat,
            title: 'Temperature',
            subtitle: 'Celsius',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.air,
            title: 'Wind Speed',
            subtitle: 'm/s',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.access_time,
            title: 'Time Format',
            subtitle: '24-hour',
            onTap: () {},
          ),
          const Divider(),
          _buildSection('Appearance'),
          _buildSettingTile(
            icon: Icons.animation,
            title: 'Animations',
            subtitle: 'Enable weather animations',
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
          const Divider(),
          _buildSection('About'),
          _buildSettingTile(
            icon: Icons.info,
            title: 'Version',
            subtitle: '1.0.0',
          ),
          _buildSettingTile(
            icon: Icons.code,
            title: 'Developed by',
            subtitle: 'Skye Weather Team',
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.m, AppSpacing.l, AppSpacing.m, AppSpacing.s),
      child: Text(
        title,
        style: AppTextStyles.title.copyWith(fontSize: 18),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.skyBlue),
      title: Text(title, style: AppTextStyles.bodyLarge),
      subtitle: Text(subtitle, style: AppTextStyles.body),
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }
}
