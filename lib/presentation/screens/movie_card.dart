import 'package:flutter/material.dart';
import 'package:movie_review_app/core/app_colors.dart';
import 'package:movie_review_app/domain/entities/movie.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie, required this.onTap});
  final Movie movie;
  final VoidCallback onTap;

  String get _year {
    if (movie.releaseDate.length >= 4) return movie.releaseDate.substring(0, 4);
    return movie.releaseDate;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: movie.posterPath != null
                    ? Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  height: 130,
                  width: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _posterPlaceholder(),
                )
                    : _posterPlaceholder(),
              ),
              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _year,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppColors.accent, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _posterPlaceholder() {
    return Container(
      height: 130,
      width: 90,
      color: AppColors.surface,
      child: const Icon(Icons.movie, color: AppColors.textSecondary, size: 32),
    );
  }
}