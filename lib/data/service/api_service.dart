import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:movie_review_app/core/app_strings.dart';
import 'package:movie_review_app/data/model/movie_model.dart';
import 'package:movie_review_app/domain/entities/movie.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final Map<String, String> _headers = {
    'Authorization': AppStrings.authorizationToken,
    'accept': 'application/json',
  };

  Future<List<Movie>> getTrendingMovies() async {
    final url = Uri.parse('${AppStrings.baseUrl}/trending/all/week');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List results = json['results'];
      return results.map((e) => MovieModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.parse('${AppStrings.baseUrl}/search/movie?query=$query');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List results = json['results'];
      return results.map((e) => MovieModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }

  Map<String, dynamic> parseMovieDetails(String responseBody) {
    return jsonDecode(responseBody);
  }

  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    final url = Uri.parse('${AppStrings.baseUrl}/movie/$movieId');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      return compute(parseMovieDetails, response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  // New: fetch reviews for a movie
  Future<List<Map<String, dynamic>>> getMovieReviews(int movieId) async {
    final url = Uri.parse('${AppStrings.baseUrl}/movie/$movieId/reviews');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List results = json['results'];
      return results.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load movie reviews');
    }
  }
}