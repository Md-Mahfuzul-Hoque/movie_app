class UserReview {
  final int movieId;
  final String movieTitle;
  final double rating;
  final String content;
  final DateTime createdAt;

  UserReview({
    required this.movieId,
    required this.movieTitle,
    required this.rating,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'movieId': movieId,
    'movieTitle': movieTitle,
    'rating': rating,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserReview.fromJson(Map<String, dynamic> json) => UserReview(
    movieId: json['movieId'],
    movieTitle: json['movieTitle'],
    rating: (json['rating'] as num).toDouble(),
    content: json['content'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}