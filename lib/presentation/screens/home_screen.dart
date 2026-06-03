import 'package:flutter/material.dart';
import 'package:movie_review_app/core/app_colors.dart';
import 'package:movie_review_app/presentation/provider/movie_provider.dart';
import 'package:movie_review_app/presentation/screens/movie_card.dart';
import 'package:movie_review_app/presentation/screens/movie_details.dart';
import 'package:movie_review_app/presentation/screens/search_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => Provider.of<MovieProvider>(context, listen: false)
          .fetchTrendingMovies(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Trending',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            icon: const Icon(Icons.search_rounded,
                color: AppColors.textPrimary, size: 26),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.textSecondary, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Something went wrong.',
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () => provider.fetchTrendingMovies(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.trendingMovies.isEmpty) {
            return const Center(
              child: Text(
                'No movies found.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            itemCount: provider.trendingMovies.length,
            itemBuilder: (context, index) {
              return MovieCard(
                movie: provider.trendingMovies[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetails(
                        movie: provider.trendingMovies[index],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}