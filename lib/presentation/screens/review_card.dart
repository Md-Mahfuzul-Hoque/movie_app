import 'package:flutter/material.dart';
import 'package:movie_review_app/core/app_colors.dart';

class ReviewCard extends StatefulWidget {
  const ReviewCard({super.key, required this.review});
  final Map<String, dynamic> review;

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _expanded = false;

  String get _authorName =>
      widget.review['author'] ?? 'Anonymous';

  String get _content =>
      widget.review['content'] ?? '';

  double? get _rating {
    final details = widget.review['author_details'];
    if (details == null) return null;
    final r = details['rating'];
    if (r == null) return null;
    return (r as num).toDouble();
  }

  String get _avatarPath {
    final details = widget.review['author_details'];
    if (details == null) return '';
    final path = details['avatar_path'] as String?;
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('/https')) return path.substring(1);
    return 'https://image.tmdb.org/t/p/w200$path';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.surface,
                backgroundImage:
                _avatarPath.isNotEmpty ? NetworkImage(_avatarPath) : null,
                child: _avatarPath.isEmpty
                    ? Text(
                  _authorName.isNotEmpty
                      ? _authorName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _authorName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    if (_rating != null)
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppColors.accent, size: 14),
                          const SizedBox(width: 3),
                          Text(
                            '$_rating / 10',
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Review content
          Text(
            _content,
            maxLines: _expanded ? null : 4,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          if (_content.length > 200)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  _expanded ? 'Show less' : 'Read more',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}