import 'package:flutter/foundation.dart';
import 'package:movie_review_app/data/service/api_service.dart';
import 'package:movie_review_app/domain/entities/movie.dart';

class MovieProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Movie> _trendingMovies = [];
  List<Movie> get trendingMovies => _trendingMovies;

  List<Movie> _searchResults = [];
  List<Movie> get searchResults => _searchResults;

  Map<String, dynamic> _movieDetails = {};
  Map<String, dynamic> get movieDetails => _movieDetails;

  List<Map<String, dynamic>> _movieReviews = [];
  List<Map<String, dynamic>> get movieReviews => _movieReviews;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isReviewsLoading = false;
  bool get isReviewsLoading => _isReviewsLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchTrendingMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      _trendingMovies = await _apiService.getTrendingMovies();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _apiService.searchMovies(query);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMovieDetails(int movieId) async {
    _isLoading = true;
    _movieDetails = {};
    notifyListeners();

    try {
      _movieDetails = await _apiService.getMovieDetails(movieId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMovieReviews(int movieId) async {
    _isReviewsLoading = true;
    _movieReviews = [];
    notifyListeners();

    try {
      _movieReviews = await _apiService.getMovieReviews(movieId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isReviewsLoading = false;
      notifyListeners();
    }
  }
}