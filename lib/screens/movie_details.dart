import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/provider/favorite_provider.dart';
import 'package:movie_app/provider/movie_trailer_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailsScreen extends ConsumerStatefulWidget {
  const MovieDetailsScreen({super.key, required this.movieDetails});
  final Map<String, dynamic> movieDetails;

  @override
  ConsumerState<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends ConsumerState<MovieDetailsScreen> {
  YoutubePlayerController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref
        .watch(favoriteMovieProvider)
        .any((m) => m['id'] == widget.movieDetails['id']);
    final trailer = ref.watch(movieTraillerProvider);
    Widget? content;
    if (trailer is LoadingTrailer) {
      content = AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (trailer is TrailerData) {
      final key = trailer.trailerData['key'];
      if (_controller == null || _controller!.initialVideoId != key) {
        _controller = YoutubePlayerController(
          initialVideoId: key,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            forceHD: false,
            enableCaption: false,
            showLiveFullscreenButton: false,
          ),
        );
      }
      content = Padding(
        padding: EdgeInsetsGeometry.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: YoutubePlayer(controller: _controller!),
      );
    }
    if (trailer is TrailerError) {
      content = AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(
          child: Text('Somthing went wrong...'),
        ),
      );
    }
    final vote = widget.movieDetails["vote_average"] as double;
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
                widget.movieDetails["title"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  ref
                      .read(favoriteMovieProvider.notifier)
                      .addFavorite(widget.movieDetails);
                },
                icon: isFavorite
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
                  tag: '${widget.movieDetails["id"]}',
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/original${widget.movieDetails["poster_path"]}',
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
                    widget.movieDetails["title"],
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
                      '${widget.movieDetails["release_date"]}',
                      softWrap: true,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
                    child: Text(
                      widget.movieDetails["overview"],
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.amberAccent,
                  thickness: 2,
                  indent: 70,
                  endIndent: 70,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: const Text(
                    'Trailer',
                    style: TextStyle(fontSize: 34),
                  ),
                ),

                if (content != null) content,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
