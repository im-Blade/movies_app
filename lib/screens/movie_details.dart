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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.lightBlueAccent,
            pinned: false,
            floating: true,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Container(color: Colors.amber),
              title: Text(
                movieDetails["title"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    movieDetails["title"],
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      ' ⭐ ${vote.toStringAsFixed(1)}',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      '${movieDetails["release_date"]}',
                      softWrap: true,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
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
          ),
        ],
      ),
    );
  }
}
// ListView(

//         children: [
//           Hero(
//             tag: '${movieDetails["id"]}',
//             child: CachedNetworkImage(
//               imageUrl:
//                   'https://image.tmdb.org/t/p/original${movieDetails["poster_path"]}',
//               fit: BoxFit.cover,
//               width: double.infinity,
//               placeholder: (context, url) =>
//                   Center(child: CircularProgressIndicator()),
//               errorWidget: (context, url, error) => Icon(Icons.error),
//             ),
//           ),
//           const SizedBox(height: 15),
//           Row(
//             children: [
//               Text(
//                 ' ⭐ ${vote.toStringAsFixed(1)}',
//                 style: TextStyle(fontSize: 18),
//               ),
//               const SizedBox(width: 15),
//               Text(
//                 '${movieDetails["release_date"]}',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ],
//           ),

//           const SizedBox(height: 15),
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 movieDetails["overview"],
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         ],
//       ),
