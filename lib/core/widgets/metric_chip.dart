import 'package:flutter/material.dart';
import '../theme/aura_colors.dart';
import '../theme/aura_typography.dart';
import 'glass_card.dart';

/// Compact metric display chip with icon and value
class MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  final bool compact;

  const MetricChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: 16,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: iconColor ?? AuraColors.skyBlue,
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: AuraTypography.bodySmall.copyWith(
                color: AuraColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return GlassCard(
      padding: const EdgeInsets.all(18),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (iconColor ?? AuraColors.skyBlue).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 22,
              color: iconColor ?? AuraColors.skyBlue,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AuraTypography.metricValue.copyWith(fontSize: 24),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AuraTypography.metricLabel.copyWith(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
