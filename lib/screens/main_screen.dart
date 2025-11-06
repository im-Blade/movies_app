import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/provider/favorite_provider.dart';
import 'package:movie_app/provider/movies_details_provider.dart';
import 'package:movie_app/screens/favorite_screen.dart';
import 'package:movie_app/screens/movies_list.dart';
import 'package:movie_app/widgets/button.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = 1;
    final favoriteMovies = ref.watch(favoriteMovieProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Movies',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 26,
          ),
        ),

        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MyButton(
              name: 'Movies List',
              onPress: () {
                ref
                    .read(moviesListProvider.notifier)
                    .fetchPopularMovies(count, null);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const MoviesListScreen()),
                );
              },
            ),
            Stack(
              children: [
                MyButton(
                  name: 'Favorite Movies',
                  onPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const FavoriteScreen(),
                      ),
                    );
                  },
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
          ],
        ),
      ),
    );
  }
}
