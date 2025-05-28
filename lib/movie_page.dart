import 'package:flutter/material.dart';
import 'movie.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(movie.imageUrl),
            const SizedBox(height: 12),
            Text("Date de sortie : ${movie.releaseDate}"),
            Text("Durée : ${movie.runtime}"),
            const SizedBox(height: 20),
            const Text("Synopsis :",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(movie.overview ?? "Synopsis non disponible."),
          ],
        ),
      ),
    );
  }
}
