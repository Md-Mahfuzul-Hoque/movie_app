import 'package:flutter/material.dart';
import 'package:movie_review_app/core/app_colors.dart';
import 'package:movie_review_app/presentation/provider/movie_provider.dart';
import 'package:movie_review_app/presentation/screens/movie_card.dart';
import 'package:movie_review_app/presentation/screens/movie_card_shimmer.dart';
import 'package:movie_review_app/presentation/screens/movie_details.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Search',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 4),
            TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search movies...',
                hintStyle:
                const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.cardBg,
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.textSecondary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear_rounded,
                      color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    Provider.of<MovieProvider>(context,
                        listen: false)
                        .searchMovies('');
                    setState(() {});
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: (value) {
                setState(() {});
                Provider.of<MovieProvider>(context, listen: false)
                    .searchMovies(value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<MovieProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return ListView.builder(
                      itemCount: 4,
                      itemBuilder: (_, __) => const MovieCardShimmer(),
                    );
                  }

                  if (_searchController.text.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.movie_filter_outlined,
                            color:
                            AppColors.textSecondary.withOpacity(0.3),
                            size: 72,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Search for movies',
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.searchResults.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off_rounded,
                              color:
                              AppColors.textSecondary.withOpacity(0.4),
                              size: 56),
                          const SizedBox(height: 12),
                          Text(
                            'No results for "${_searchController.text}"',
                            style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: provider.searchResults.length,
                    itemBuilder: (context, index) {
                      return MovieCard(
                        movie: provider.searchResults[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetails(
                                movie: provider.searchResults[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}