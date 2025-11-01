import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/provider/favorite_provider.dart';

class MovieDetailsScreen extends ConsumerWidget {
  const MovieDetailsScreen({super.key, required this.movieDetails});
  final Map<String, dynamic> movieDetails;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vote = movieDetails["vote_average"] as double;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          movieDetails["original_title"],
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .read(favoriteMovieProvider.notifier)
                  .addFavorite(movieDetails);
            },
            icon:
                ref
                    .watch(favoriteMovieProvider)
                    .any((m) => m['id'] == movieDetails['id'])
                ? Icon(Icons.favorite, color: Colors.red)
                : Icon(Icons.favorite),
          ),
        ],
      ),
      body: ListView(
        children: [
          Hero(
            tag: '${movieDetails["id"]}',
            child: CachedNetworkImage(
              imageUrl:
                  'https://image.tmdb.org/t/p/original${movieDetails["poster_path"]}',
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(
              'vote average: ${vote.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                movieDetails["overview"],
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
