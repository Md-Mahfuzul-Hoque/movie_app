import 'package:flutter/material.dart';
import 'package:movie_review_app/core/app_colors.dart';
import 'package:movie_review_app/domain/entities/movie.dart';
import 'package:movie_review_app/presentation/provider/movie_provider.dart';
import 'package:movie_review_app/presentation/screens/review_card.dart';
import 'package:provider/provider.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key, required this.movie});
  final Movie movie;

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<MovieProvider>(context, listen: false);
      provider.fetchMovieDetails(widget.movie.id);
      provider.fetchMovieReviews(widget.movie.id);
    });
  }

  String _formatRuntime(int? minutes) {
    if (minutes == null || minutes == 0) return 'N/A';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}m';
    return '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Consumer<MovieProvider>(
        builder: (context, provider, _) {
          final details = provider.movieDetails;

          return CustomScrollView(
            slivers: [
              // ── App Bar with backdrop ──
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppColors.primary,
                iconTheme: const IconThemeData(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (widget.movie.backdropPath != null)
                        Image.network(
                          'https://image.tmdb.org/t/p/w500${widget.movie.backdropPath}',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.surface,
                          ),
                        ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.primary.withOpacity(0.95),
                            ],
                            stops: const [0.4, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Poster + info row ──
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Poster
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: widget.movie.posterPath != null
                                ? Image.network(
                              'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                              height: 150,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              height: 150,
                              width: 100,
                              color: AppColors.surface,
                              child: const Icon(Icons.movie,
                                  color: AppColors.textSecondary),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Title + meta
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.movie.title,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Rating row
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded,
                                        color: AppColors.accent, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.movie.voteAverage
                                          .toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: AppColors.accent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      ' / 10',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.4),
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Release date
                                _metaRow(
                                  Icons.calendar_today_outlined,
                                  widget.movie.releaseDate.isNotEmpty
                                      ? widget.movie.releaseDate
                                      : 'Unknown',
                                ),
                                const SizedBox(height: 4),
                                // Runtime from details
                                if (details.isNotEmpty)
                                  _metaRow(
                                    Icons.access_time_rounded,
                                    _formatRuntime(details['runtime'] as int?),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ── Genres ──
                      if (details.isNotEmpty &&
                          details['genres'] != null &&
                          (details['genres'] as List).isNotEmpty) ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: (details['genres'] as List).map((g) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                g['name'] ?? '',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // ── Overview ──
                      const Text(
                        'Overview',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.movie.overview.isNotEmpty
                            ? widget.movie.overview
                            : 'No overview available.',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Reviews section ──
                      const Text(
                        'Reviews',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),

              // ── Reviews list ──
              if (provider.isReviewsLoading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                )
              else if (provider.movieReviews.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      'No reviews available yet.',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return ReviewCard(
                          review: provider.movieReviews[index]);
                    },
                    childCount: provider.movieReviews.length,
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }

  Widget _metaRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 14),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}