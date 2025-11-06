import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

const _apiKey =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyZTE4MDJjNTA0ZDQ5ZGYwZWFkZWQ4YjQzN2E5YTE2NCIsIm5iZiI6MTc2MTgyNTIzMC41MzEwMDAxLCJzdWIiOiI2OTAzNTFjZWQ4MTYxYmVjYWM2ZTg5YTUiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.SumwrGMzSvRnqT4_Alsy81cclddd_h3BQ8OwUOqf8sY';

abstract class MovieState {
  const MovieState();
}

class MovieInitial extends MovieState {
  const MovieInitial();
}

class MovieLoading extends MovieState {
  const MovieLoading();
}

class MovieData extends MovieState {
  final List<Map<String, dynamic>> movies;
  const MovieData({required this.movies});
}

class MovieError extends MovieState {
  final String errorMessage;
  const MovieError({required this.errorMessage});
}

class MoviesListNotifier extends StateNotifier<MovieState> {
  MoviesListNotifier() : super(const MovieInitial());

  void fetchPopularMovies(int num, int? genre) async {
    state = MovieLoading();
    if (genre != null) {
      final url = Uri.https('api.themoviedb.org', '/3/discover/movie', {
        'page': '$num',
        'with_genres': '$genre',
      });
      final headers = {
        'Authorization': 'Bearer $_apiKey',
        'accept': 'application/json',
      };
      try {
        var response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          state = MovieData(movies: [...data['results']]);
        } else {
          state = MovieError(errorMessage: 'somethins wnet wrong');
        }
      } catch (e) {
        state = MovieError(errorMessage: '$e');
      }
    } else {
      final url = Uri.https('api.themoviedb.org', '/3/discover/movie', {
        'page': '$num',
      });
      final headers = {
        'Authorization': 'Bearer $_apiKey',
        'accept': 'application/json',
      };
      try {
        var response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          state = MovieData(movies: [...data['results']]);
        } else {
          state = MovieError(errorMessage: 'somethins wnet wrong');
        }
      } catch (e) {
        state = MovieError(errorMessage: '$e');
      }
    }
  }
}

final moviesListProvider =
    StateNotifierProvider<MoviesListNotifier, MovieState>((
      ref,
    ) {
      return MoviesListNotifier();
    });
