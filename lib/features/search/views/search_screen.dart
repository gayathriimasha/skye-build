import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/search_viewmodel.dart';
import '../../home/viewmodels/home_viewmodel.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Location', style: AppTextStyles.title),
        backgroundColor: AppColors.skyBlue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a city...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
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
                  Future.delayed(const Duration(milliseconds: 300), () {
                    ref.read(searchProvider.notifier).searchLocation(value);
                  });
                }
              },
            ),
          ),
          Expanded(
            child: searchState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : searchState.error != null
                    ? Center(child: Text(searchState.error!))
                    : searchState.results.isEmpty
                        ? const Center(
                            child: Text('Search for a city to see results'),
                          )
                        : ListView.builder(
                            itemCount: searchState.results.length,
                            itemBuilder: (context, index) {
                              final location = searchState.results[index];
                              return ListTile(
                                leading: const Icon(Icons.location_on,
                                    color: AppColors.skyBlue),
                                title: Text(
                                  location.name,
                                  style: AppTextStyles.bodyLarge
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  location.displayName,
                                  style: AppTextStyles.body,
                                ),
                                onTap: () {
                                  ref
                                      .read(homeProvider.notifier)
                                      .loadWeatherForLocation(
                                        location.lat,
                                        location.lon,
                                      );
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
