import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:movie_review_app/domain/entities/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WatchlistProvider extends ChangeNotifier {
  static const String _key = 'watchlist';

  List<Movie> _watchlist = [];
  List<Movie> get watchlist => _watchlist;

  WatchlistProvider() {
    _loadFromPrefs();
  }

  bool isInWatchlist(int movieId) {
    return _watchlist.any((m) => m.id == movieId);
  }

  Future<void> toggleWatchlist(Movie movie) async {
    if (isInWatchlist(movie.id)) {
      _watchlist.removeWhere((m) => m.id == movie.id);
    } else {
      _watchlist.add(movie);
    }
    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _watchlist.map((m) => jsonEncode({
      'id': m.id,
      'title': m.title,
      'overview': m.overview,
      'posterPath': m.posterPath,
      'backdropPath': m.backdropPath,
      'voteAverage': m.voteAverage,
      'releaseDate': m.releaseDate,
      'genreIds': m.genreIds,
    })).toList();
    await prefs.setStringList(_key, encoded);
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    _watchlist = list.map((s) {
      final json = jsonDecode(s);
      return Movie(
        id: json['id'],
        title: json['title'],
        overview: json['overview'],
        posterPath: json['posterPath'],
        backdropPath: json['backdropPath'],
        voteAverage: (json['voteAverage'] as num).toDouble(),
        releaseDate: json['releaseDate'],
        genreIds: List<int>.from(json['genreIds']),
      );
    }).toList();
    notifyListeners();
  }
}