import 'package:flutter/material.dart';
import 'movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(movie.imageUrl, width: 200),
        title: Text(movie.title),
        subtitle: Text(movie.releaseDate),
      ),
    );
  }
}
