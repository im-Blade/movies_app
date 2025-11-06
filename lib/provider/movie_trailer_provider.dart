import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

const _apiKey =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyZTE4MDJjNTA0ZDQ5ZGYwZWFkZWQ4YjQzN2E5YTE2NCIsIm5iZiI6MTc2MTgyNTIzMC41MzEwMDAxLCJzdWIiOiI2OTAzNTFjZWQ4MTYxYmVjYWM2ZTg5YTUiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.SumwrGMzSvRnqT4_Alsy81cclddd_h3BQ8OwUOqf8sY';

abstract class TrailerState {
  const TrailerState();
}

class InitialTrailer extends TrailerState {
  const InitialTrailer();
}

class LoadingTrailer extends TrailerState {
  const LoadingTrailer();
}

class TrailerData extends TrailerState {
  final Map<String, dynamic> trailerData;
  const TrailerData({required this.trailerData});
}

class TrailerError extends TrailerState {
  final String errorMessage;
  const TrailerError({required this.errorMessage});
}

class MovieTraillerNotifier extends StateNotifier<TrailerState> {
  MovieTraillerNotifier() : super(const InitialTrailer());
  void fetchMovieTrailler(int movieId) async {
    state = LoadingTrailer();

    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/$movieId/videos?language=en-US',
    );
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json;charset=utf-8',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;
        final officalTrailler = results
            .where(
              (t) =>
                  t["site"] == "YouTube" &&
                  t["type"] == "Trailer" &&
                  t["official"] == true,
            )
            .toList();
        if (officalTrailler.isNotEmpty) {
          final mainTrailler = officalTrailler.first;
          state = TrailerData(trailerData: mainTrailler);
        } else {
          state = TrailerError(errorMessage: 'Something went wrong');
        }
      } else {
        state = TrailerError(errorMessage: 'Something wrong happened.');
      }
    } catch (e) {
      state = TrailerError(errorMessage: '$e');
    }
  }
}

final movieTraillerProvider =
    StateNotifierProvider<MovieTraillerNotifier, TrailerState>((
      ref,
    ) {
      return MovieTraillerNotifier();
    });
