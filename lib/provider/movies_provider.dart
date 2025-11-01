import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

const apiKey =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyZTE4MDJjNTA0ZDQ5ZGYwZWFkZWQ4YjQzN2E5YTE2NCIsIm5iZiI6MTc2MTgyNTIzMC41MzEwMDAxLCJzdWIiOiI2OTAzNTFjZWQ4MTYxYmVjYWM2ZTg5YTUiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.SumwrGMzSvRnqT4_Alsy81cclddd_h3BQ8OwUOqf8sY';

class MoviesListNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  MoviesListNotifier() : super([]);

  void fetchPopularMovies(int num) async {
    final url = Uri.https('api.themoviedb.org', '/3/movie/popular', {
      'page': '$num',
    });
    final headers = {
      'Authorization': 'Bearer $apiKey ',
      'accept': 'application/json',
    };
    state = [];

    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      state = [...data['results']];
    }
  }
}

final moviesListProvider =
    StateNotifierProvider<MoviesListNotifier, List<Map<String, dynamic>>>((
      ref,
    ) {
      return MoviesListNotifier();
    });
