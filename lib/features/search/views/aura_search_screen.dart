import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../viewmodels/search_viewmodel.dart';
import '../../home/viewmodels/home_viewmodel.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';

class AuraSearchScreen extends ConsumerStatefulWidget {
  const AuraSearchScreen({super.key});

  @override
  ConsumerState<AuraSearchScreen> createState() => _AuraSearchScreenState();
}

class _AuraSearchScreenState extends ConsumerState<AuraSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      backgroundColor: AuraColors.deepSpace,
      body: SafeArea(
        child: Column(
          children: [
            // Search header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: AuraColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      style: AuraTypography.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Search city or location...',
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: AuraColors.textTertiary,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear_rounded,
                                  color: AuraColors.textTertiary,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  ref.read(searchProvider.notifier).clear();
                                  setState(() {});
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        setState(() {});
                        if (value.length >= 3) {
                          Future.delayed(const Duration(milliseconds: 400), () {
                            if (_searchController.text == value) {
                              ref
                                  .read(searchProvider.notifier)
                                  .searchLocation(value);
                            }
                          });
                        } else {
                          ref.read(searchProvider.notifier).clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Search results
            Expanded(
              child: searchState.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AuraColors.skyBlue,
                      ),
                    )
                  : searchState.error != null
                      ? _buildErrorState(searchState.error!)
                      : searchState.results.isEmpty
                          ? _buildEmptyState()
                          : _buildResultsList(searchState.results),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(List<dynamic> results) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final location = results[index];
        return FadeInUp(
          duration: const Duration(milliseconds: 400),
          delay: Duration(milliseconds: index * 50),
          child: GestureDetector(
            onTap: () {
              ref.read(homeProvider.notifier).loadWeatherForLocation(
                    location.lat,
                    location.lon,
                  );
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AuraColors.glassLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AuraColors.skyBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: AuraColors.skyBlue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location.name,
                          style: AuraTypography.subtitle,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          location.displayName,
                          style: AuraTypography.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AuraColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_rounded,
              size: 64,
              color: AuraColors.textMuted,
            ),
            const SizedBox(height: 24),
            Text(
              'Search for a city',
              style: AuraTypography.title,
            ),
            const SizedBox(height: 12),
            Text(
              'Enter at least 3 characters to search',
              style: AuraTypography.body.copyWith(
                color: AuraColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
              'Search failed',
              style: AuraTypography.title,
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: AuraTypography.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
