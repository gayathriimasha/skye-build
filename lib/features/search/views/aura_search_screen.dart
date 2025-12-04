import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../viewmodels/search_viewmodel.dart';
import '../../home/viewmodels/home_viewmodel.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';

export '../viewmodels/search_viewmodel.dart' show RegionFilter;

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

            // Filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // Region filter
                  Expanded(
                    child: _buildRegionFilter(searchState),
                  ),
                  const SizedBox(width: 12),
                  // Favorites toggle
                  _buildFavoritesToggle(searchState),
                ],
              ),
            ),

            const SizedBox(height: 16),

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
                      : searchState.filteredResults.isEmpty
                          ? _buildEmptyState(searchState.showFavoritesOnly)
                          : _buildResultsList(searchState.filteredResults),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionFilter(SearchState searchState) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AuraColors.glassLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AuraColors.glassBorder,
          width: 1,
        ),
      ),
      child: DropdownButton<RegionFilter>(
        value: searchState.regionFilter,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: AuraColors.surfaceDark,
        icon: Icon(
          Icons.arrow_drop_down_rounded,
          color: AuraColors.textTertiary,
        ),
        style: AuraTypography.body,
        items: [
          DropdownMenuItem(
            value: RegionFilter.all,
            child: Row(
              children: [
                Icon(Icons.public_rounded, size: 20, color: AuraColors.skyBlue),
                const SizedBox(width: 12),
                Text('All Regions', style: AuraTypography.body),
              ],
            ),
          ),
          DropdownMenuItem(
            value: RegionFilter.africa,
            child: Row(
              children: [
                Icon(Icons.explore_rounded, size: 20, color: AuraColors.skyBlue),
                const SizedBox(width: 12),
                Text('Africa', style: AuraTypography.body),
              ],
            ),
          ),
          DropdownMenuItem(
            value: RegionFilter.asia,
            child: Row(
              children: [
                Icon(Icons.explore_rounded, size: 20, color: AuraColors.skyBlue),
                const SizedBox(width: 12),
                Text('Asia', style: AuraTypography.body),
              ],
            ),
          ),
          DropdownMenuItem(
            value: RegionFilter.europe,
            child: Row(
              children: [
                Icon(Icons.explore_rounded, size: 20, color: AuraColors.skyBlue),
                const SizedBox(width: 12),
                Text('Europe', style: AuraTypography.body),
              ],
            ),
          ),
          DropdownMenuItem(
            value: RegionFilter.northAmerica,
            child: Row(
              children: [
                Icon(Icons.explore_rounded, size: 20, color: AuraColors.skyBlue),
                const SizedBox(width: 12),
                Text('N. America', style: AuraTypography.body),
              ],
            ),
          ),
          DropdownMenuItem(
            value: RegionFilter.southAmerica,
            child: Row(
              children: [
                Icon(Icons.explore_rounded, size: 20, color: AuraColors.skyBlue),
                const SizedBox(width: 12),
                Text('S. America', style: AuraTypography.body),
              ],
            ),
          ),
          DropdownMenuItem(
            value: RegionFilter.oceania,
            child: Row(
              children: [
                Icon(Icons.explore_rounded, size: 20, color: AuraColors.skyBlue),
                const SizedBox(width: 12),
                Text('Oceania', style: AuraTypography.body),
              ],
            ),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            ref.read(searchProvider.notifier).setRegionFilter(value);
          }
        },
      ),
    );
  }

  Widget _buildFavoritesToggle(SearchState searchState) {
    return GestureDetector(
      onTap: () {
        ref.read(searchProvider.notifier).toggleShowFavorites();
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: searchState.showFavoritesOnly
              ? AuraColors.skyBlue.withOpacity(0.2)
              : AuraColors.glassLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: searchState.showFavoritesOnly
                ? AuraColors.skyBlue
                : AuraColors.glassBorder,
            width: 1,
          ),
        ),
        child: Icon(
          searchState.showFavoritesOnly
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          color: searchState.showFavoritesOnly
              ? AuraColors.skyBlue
              : AuraColors.textTertiary,
          size: 24,
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
        final isFav = ref.read(searchProvider.notifier).isFavorite(location);
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
                  IconButton(
                    onPressed: () {
                      ref.read(searchProvider.notifier).toggleFavorite(location);
                    },
                    icon: Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFav ? AuraColors.skyBlue : AuraColors.textMuted,
                      size: 24,
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

  Widget _buildEmptyState(bool showingFavorites) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              showingFavorites ? Icons.favorite_border_rounded : Icons.search_rounded,
              size: 64,
              color: AuraColors.textMuted,
            ),
            const SizedBox(height: 24),
            Text(
              showingFavorites ? 'No favorites yet' : 'Search for a city',
              style: AuraTypography.title,
            ),
            const SizedBox(height: 12),
            Text(
              showingFavorites
                  ? 'Add cities to favorites to see them here'
                  : 'Enter at least 3 characters to search',
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
