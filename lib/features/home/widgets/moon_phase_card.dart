import 'package:flutter/material.dart';
import 'package:moon_phase_plus/moon_phase_plus.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/utils/moon_phase_utils.dart';

class MoonPhaseCard extends StatelessWidget {
  const MoonPhaseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final moonPhase = MoonPhaseUtils.calculateMoonPhase(now);
    final phaseName = MoonPhaseUtils.getMoonPhaseName(moonPhase);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AuraColors.twilightPurple.withOpacity(0.3),
                          AuraColors.moonLight.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.nightlight_round,
                      color: AuraColors.moonLight,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Moon Phase',
                    style: AuraTypography.title.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Main Content: Moon + Details
              Column(
                children: [
                  // Beautiful 3D-like Moon (centered and large)
                  _buildMoonDisplay(now, moonPhase),

                  const SizedBox(height: 24),

                  // Phase Name
                  Text(
                    phaseName,
                    style: AuraTypography.headline.copyWith(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoonDisplay(DateTime date, double moonPhase) {
    return Container(
      width: 320,
      height: 320,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AuraColors.deepSpace.withOpacity(0.3),
            AuraColors.deepSpace.withOpacity(0.1),
            Colors.transparent,
          ],
          stops: const [0.6, 0.8, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AuraColors.moonLight.withOpacity(0.3),
            blurRadius: 80,
            spreadRadius: 20,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow effect
          Container(
            width: 310,
            height: 310,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AuraColors.moonLight.withOpacity(0.25),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Moon widget with custom styling
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 16,
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: MoonWidget(
                date: date,
                moonColor: const Color(0xFFF5F5DC), // Beige moon color
                earthshineColor: const Color(0xFF2A2A3E), // Dark blue-gray
                resolution: 1024,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
