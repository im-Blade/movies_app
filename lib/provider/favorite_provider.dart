import 'package:flutter_riverpod/legacy.dart';

class FavoriteLMoviesNotifier
    extends StateNotifier<List<Map<String, dynamic>>> {
  FavoriteLMoviesNotifier() : super([]);
  void addFavorite(Map<String, dynamic> movieDetails) {
    final movieIsFavorite = state.contains(movieDetails);
    if (movieIsFavorite) {
      state = state.where((m) => m['id'] != movieDetails['id']).toList();
    } else {
      state = [...state, movieDetails];
    }
  }
}

final favoriteMovieProvider =
    StateNotifierProvider<FavoriteLMoviesNotifier, List<Map<String, dynamic>>>((
      ref,
    ) {
      return FavoriteLMoviesNotifier();
    });
