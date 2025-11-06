import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/model/genres.dart';

class ChooseGenre extends StatefulWidget {
  const ChooseGenre({super.key});

  @override
  State<ChooseGenre> createState() => _ChooseGenreState();
}

class _ChooseGenreState extends State<ChooseGenre> {
  int? choosengenre;
  final page = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      width: double.infinity,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoPicker(
            scrollController: FixedExtentScrollController(
              initialItem: choosengenre ?? 0,
            ),
            itemExtent: 32,
            onSelectedItemChanged: (index) {
              setState(() {
                choosengenre = genres[index].id;
              });
            },
            children: genres
                .map((g) => Text(g.genreName.toUpperCase()))
                .toList(),
          ),
          CupertinoButton(
            child: const Text("Apply"),
            onPressed: () {
              Navigator.of(context).pop(choosengenre);
            },
          ),
        ],
      ),
    );
  }
}
