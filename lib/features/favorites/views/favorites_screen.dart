import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites', style: AppTextStyles.title),
        backgroundColor: AppColors.skyBlue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_border,
              size: 64,
              color: AppColors.skyBlue,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              'No favorites yet',
              style: AppTextStyles.headline,
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              'Add locations to your favorites',
              style: AppTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }
}
