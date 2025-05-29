import 'package:flutter/material.dart';
import 'movie.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //IMAGE
            Stack(
              children: [
                Image.network(
                  movie.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black,
                        ],
                        stops: [0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            //INFOS
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Date de sortie : ${movie.releaseDate}",
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Durée : ${movie.runtime}",
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Synopsis
                  const Text(
                    "Synopsis",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview ?? "Synopsis non disponible.",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
