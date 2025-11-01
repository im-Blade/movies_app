import 'package:flutter/material.dart';
import 'package:movie_app/screens/favorite_screen.dart';

class OnePageScreen extends StatefulWidget {
  const OnePageScreen({super.key});

  @override
  State<OnePageScreen> createState() => _OnePageScreenState();
}

class _OnePageScreenState extends State<OnePageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          'List Page',
          style: TextStyle(color: Colors.white, fontSize: 26),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (ctx) => FavoriteScreen()));
                },
                icon: Icon(Icons.favorite),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
            ],
          ),
        ],
      ),
      // use gridview
      body: Text('Hello one page'),
    );
  }
}
