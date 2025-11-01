import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/provider/favorite_provider.dart';
import 'package:movie_app/provider/movies_provider.dart';
import 'package:movie_app/screens/movie_details.dart';

class MoviesGridview extends ConsumerWidget {
  const MoviesGridview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(moviesListProvider);
    final favoriteMovies = ref.watch(favoriteMovieProvider);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 0.7,
      ),
      itemCount: movies.length,
      itemBuilder: (ctx, index) {
        final movie = movies[index];
        final vote = movie["vote_average"] as double;
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => MovieDetailsScreen(movieDetails: movie),
              ),
            );
          },
          child: Stack(
            children: [
              Hero(
                tag: '${movie["id"]}',
                child: CachedNetworkImage(
                  useOldImageOnUrlChange: true,
                  imageUrl:
                      'https://image.tmdb.org/t/p/original${movie["poster_path"]}',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              if (favoriteMovies.any((m) => m['id'] == movie['id']))
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Icon(Icons.favorite, color: Colors.red, size: 35),
                ),
              Positioned(
                right: 0,
                bottom: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(10, 0, 0, 0),
                        Colors.black54,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 44,
                    vertical: 5,
                  ),
                  child: Column(
                    children: [
                      Text(
                        movie["original_title"],
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        vote.toStringAsFixed(1),
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '${movie["original_language"]}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
