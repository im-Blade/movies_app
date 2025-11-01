import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/provider/favorite_provider.dart';
import 'package:movie_app/provider/movies_provider.dart';
import 'package:movie_app/screens/favorite_screen.dart';
import 'package:movie_app/widgets/movies_gridview.dart';

class MoviesListScreen extends ConsumerStatefulWidget {
  const MoviesListScreen({super.key});

  @override
  ConsumerState<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends ConsumerState<MoviesListScreen> {
  int pageNum = 1;
  @override
  Widget build(BuildContext context) {
    final movies = ref.watch(moviesListProvider);
    final favoriteMovies = ref.watch(favoriteMovieProvider);
    Widget content = Center(child: CircularProgressIndicator());
    if (movies.isNotEmpty) {
      content = MoviesGridview();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          'List Page',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 26,
          ),
        ),
        actions: [
          Row(
            children: [
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => FavoriteScreen()),
                      );
                    },
                    icon: Icon(Icons.favorite, size: 28),
                  ),
                  if (favoriteMovies.isNotEmpty)
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(child: Text('${favoriteMovies.length}')),
                    ),
                ],
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
            ],
          ),
        ],
      ),
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          if (value == 0 && pageNum != 1) {
            pageNum--;
            ref.read(moviesListProvider.notifier).fetchPopularMovies(pageNum);
          }
          if (value == 1) {
            pageNum++;
            ref.read(moviesListProvider.notifier).fetchPopularMovies(pageNum);
          }
        },
        selectedItemColor: const Color.fromARGB(255, 110, 110, 110),
        unselectedItemColor: const Color.fromARGB(255, 110, 110, 110),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'backward',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward),
            label: 'forward',
          ),
        ],
      ),
    );
  }
}
