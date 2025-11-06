import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/model/genres.dart';
import 'package:movie_app/provider/favorite_provider.dart';
import 'package:movie_app/provider/movies_details_provider.dart';
import 'package:movie_app/screens/favorite_screen.dart';
import 'package:movie_app/widgets/choose_genre.dart';
import 'package:movie_app/widgets/movies_gridview.dart';

class MoviesListScreen extends ConsumerStatefulWidget {
  const MoviesListScreen({super.key});

  @override
  ConsumerState<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends ConsumerState<MoviesListScreen> {
  int? selectedGenre;
  int pageNum = 1;

  String getGenreName() {
    if (selectedGenre != null) {
      final genre = genres.where(
        (g) => g.id == selectedGenre,
      );
      return genre.first.genreName;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final movieState = ref.watch(moviesListProvider);
    final favoriteMovies = ref.watch(favoriteMovieProvider);
    Widget content = Center(child: CircularProgressIndicator());
    if (movieState is MovieError) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Something went wrong.\n Check your interner connection',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(moviesListProvider.notifier)
                    .fetchPopularMovies(pageNum, selectedGenre);
              },
              child: Text('Try again'),
            ),
          ],
        ),
      );
    }
    if (movieState is MovieData) {
      content = const MoviesGridview();
    }
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                backgroundColor: Colors.lightBlue,
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
                                MaterialPageRoute(
                                  builder: (ctx) => FavoriteScreen(),
                                ),
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
                              child: Center(
                                child: Text('${favoriteMovies.length}'),
                              ),
                            ),
                        ],
                      ),
                      IconButton(
                        onPressed: () async {
                          final choosengenre =
                              await showCupertinoModalPopup<int>(
                                barrierDismissible: false,
                                context: context,
                                builder: (ctx) => const ChooseGenre(),
                              );
                          if (choosengenre != null) {
                            selectedGenre = choosengenre;
                            pageNum = 1;
                            ref
                                .read(moviesListProvider.notifier)
                                .fetchPopularMovies(pageNum, selectedGenre);
                          } else {
                            selectedGenre = null;
                            pageNum = 1;
                            ref
                                .read(moviesListProvider.notifier)
                                .fetchPopularMovies(pageNum, selectedGenre);
                          }
                        },
                        icon: Icon(Icons.more_horiz),
                      ),
                    ],
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.lightBlue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        selectedGenre == null
                            ? 'genre:No genre selected'
                            : getGenreName(),
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'page($pageNum/500)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: content,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          if (value == 0 && pageNum != 1) {
            pageNum--;
            ref
                .read(moviesListProvider.notifier)
                .fetchPopularMovies(pageNum, selectedGenre);
          }
          if (value == 1) {
            pageNum++;
            ref
                .read(moviesListProvider.notifier)
                .fetchPopularMovies(pageNum, selectedGenre);
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
