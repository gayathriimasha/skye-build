import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/aura_colors.dart';
import '../theme/aura_typography.dart';

/// Floating glassmorphic search bar
class AuraSearchBar extends StatelessWidget {
  final String hint;
  final VoidCallback? onTap;
  final bool enabled;

  const AuraSearchBar({
    super.key,
    this.hint = 'Search city or location',
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: AuraColors.textPrimary.withOpacity(0.9),
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hint,
                    style: AuraTypography.body.copyWith(
                      color: AuraColors.textPrimary.withOpacity(0.85),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
