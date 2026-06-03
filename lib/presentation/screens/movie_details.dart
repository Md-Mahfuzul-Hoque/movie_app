import 'package:flutter/material.dart';
import 'package:movie_review_app/core/app_colors.dart';
import 'package:movie_review_app/domain/entities/movie.dart';
import 'package:movie_review_app/presentation/provider/movie_provider.dart';
import 'package:movie_review_app/presentation/provider/user_review_provider.dart';
import 'package:movie_review_app/presentation/provider/watchlist_provider.dart';
import 'package:movie_review_app/presentation/screens/review_card.dart';
import 'package:movie_review_app/presentation/screens/user_review_card.dart';
import 'package:movie_review_app/presentation/screens/write_review_screen.dart';
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
      body: Consumer3<MovieProvider, WatchlistProvider, UserReviewProvider>(
        builder: (context, movieProvider, watchlistProvider, reviewProvider, _) {
          final details = movieProvider.movieDetails;
          final inWatchlist = watchlistProvider.isInWatchlist(widget.movie.id);
          final userReview = reviewProvider.getReview(widget.movie.id);

          return CustomScrollView(
            slivers: [
              // ── SliverAppBar ──
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppColors.primary,
                iconTheme: const IconThemeData(color: Colors.white),
                actions: [
                  GestureDetector(
                    onTap: () => watchlistProvider.toggleWatchlist(widget.movie),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: inWatchlist
                            ? AppColors.accent
                            : Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            inWatchlist
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_outline_rounded,
                            color: inWatchlist ? Colors.black : Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            inWatchlist ? 'Saved' : 'Watchlist',
                            style: TextStyle(
                              color: inWatchlist ? Colors.black : Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (widget.movie.backdropPath != null)
                        Image.network(
                          'https://image.tmdb.org/t/p/w500${widget.movie.backdropPath}',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: AppColors.surface),
                        ),
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
                      // ── Poster + info ──
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: widget.movie.posterPath != null
                                ? Image.network(
                              'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                              height: 150,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 150,
                                width: 100,
                                color: AppColors.surface,
                              ),
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
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded,
                                        color: AppColors.accent, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.movie.voteAverage.toStringAsFixed(1),
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
                                _metaRow(
                                  Icons.calendar_today_outlined,
                                  widget.movie.releaseDate.isNotEmpty
                                      ? widget.movie.releaseDate
                                      : 'Unknown',
                                ),
                                const SizedBox(height: 4),
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

                      // ── My Review section ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'My Review',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (userReview == null)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => WriteReviewScreen(
                                      movie: widget.movie,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.edit_rounded,
                                        color: Colors.black, size: 14),
                                    SizedBox(width: 5),
                                    Text(
                                      'Write',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              // ── My review card or empty prompt ──
              if (userReview != null)
                SliverToBoxAdapter(
                  child: UserReviewCard(
                    review: userReview,
                    movie: widget.movie,
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    child: Text(
                      "You haven't reviewed this movie yet.",
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ),
                ),

              // ── TMDB Reviews ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 28, 16, 4),
                  child: Row(
                    children: [
                      const Text(
                        'Community Reviews',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (movieProvider.movieReviews.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${movieProvider.movieReviews.length}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              if (movieProvider.isReviewsLoading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    ),
                  ),
                )
              else if (movieProvider.movieReviews.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'No community reviews available yet.',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => ReviewCard(
                        review: movieProvider.movieReviews[index]),
                    childCount: movieProvider.movieReviews.length,
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