import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/provider/favorite_provider.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final movieDetails = ref.watch(favoriteMovieProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          'Favorite Page',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 26,
            color: Colors.white,
          ),
        ),
      ),
      body: movieDetails.isEmpty
          ? Center(
              child: Text(
                'No movies added to the favorites yet...',
                style: TextStyle(color: Colors.black),
              ),
            )
          : ListView.builder(
              itemCount: movieDetails.length,
              itemBuilder: (ctx, index) {
                final movie = movieDetails[index];
                return Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/original${movie["poster_path"]}',
                            fit: BoxFit.cover,
                            width: 100,
                            height: 170,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(movie["original_title"]),
                            subtitle: Text(movie["overview"]),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  movieDetails.removeAt(index);
                                });
                              },
                              icon: Icon(Icons.close),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                );
              },
            ),
    );
  }
}
