import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:movie_review_app/domain/entities/user_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserReviewProvider extends ChangeNotifier {
  static const String _key = 'user_reviews';

  // movieId → UserReview (একটা movie তে একটাই review)
  Map<int, UserReview> _reviews = {};

  UserReviewProvider() {
    _loadFromPrefs();
  }

  UserReview? getReview(int movieId) => _reviews[movieId];

  bool hasReview(int movieId) => _reviews.containsKey(movieId);

  Future<void> saveReview(UserReview review) async {
    _reviews[review.movieId] = review;
    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> deleteReview(int movieId) async {
    _reviews.remove(movieId);
    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _reviews.values
        .map((r) => jsonEncode(r.toJson()))
        .toList();
    await prefs.setStringList(_key, encoded);
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    _reviews = {
      for (final s in list)
        (jsonDecode(s)['movieId'] as int): UserReview.fromJson(jsonDecode(s))
    };
    notifyListeners();
  }
}