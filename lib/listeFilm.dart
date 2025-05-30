import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'appconst.dart';
import 'movie_card.dart';
import 'movie_page.dart';
import 'movie.dart';
import 'dart:developer' as dev;

class ListFilm extends StatefulWidget {
  final String query;
  const ListFilm({super.key, required this.query});

  @override
  State<ListFilm> createState() => _ListFilmState();
}

class _ListFilmState extends State<ListFilm> {
  Map<String, List<Movie>> categorizedMovies = {};
  List<Movie> searchResults = [];
  bool isLoading = true;

  final Map<String, String> categoryTitles = {
    "movie/popular": "Populaires",
    "movie/now_playing": "Au cinéma",
    "movie/top_rated": "Les mieux notés",
  };

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void didUpdateWidget(ListFilm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != oldWidget.query) {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);

    if (widget.query.isNotEmpty) {
      await searchMovies(widget.query);
    } else {
      await fetchAllCategories();
    }

    setState(() => isLoading = false);
  }

  Future<void> fetchAllCategories() async {
    final categories = categoryTitles.keys;

    try {
      final results = await Future.wait(categories.map(fetchMovies));
      categorizedMovies = Map.fromIterables(categories, results);
    } catch (e) {
      dev.log("Erreur récupération films : $e");
    }
  }

  Future<List<Movie>> fetchMovies(String category) async {
    final url =
        "https://api.themoviedb.org/3/$category?api_key=${Appconst.apiKey}&language=fr-FR&page=1";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Erreur ${response.statusCode}");
    }

    final data = json.decode(response.body);
    return (data["results"] as List)
        .where((m) => m["poster_path"] != null)
        .map((m) => Movie.fromJson(m))
        .toList();
  }

  Future<void> searchMovies(String query) async {
    try {
      final url =
          "https://api.themoviedb.org/3/search/movie?query=$query&api_key=${Appconst.apiKey}&language=fr-FR&page=1";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception("Erreur ${response.statusCode}");
      }

      final data = json.decode(response.body);
      searchResults = (data["results"] as List)
          .where((m) => m["poster_path"] != null)
          .map((m) => Movie.fromJson(m))
          .toList();
    } catch (e) {
      dev.log("Erreur recherche : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (widget.query.isNotEmpty) {
      if (searchResults.isEmpty) {
        return const Center(child: Text("Aucun film trouvé"));
      }
      return buildCategorySection("Résultats de recherche", searchResults);
    }

    return ListView(
      children: categoryTitles.entries.map((entry) {
        final category = entry.key;
        final title = entry.value;
        final movies = categorizedMovies[category] ?? [];
        return buildCategorySection(title, movies);
      }).toList(),
    );
  }

  Widget buildCategorySection(String title, List<Movie> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MovieDetailPage(movie: movie)),
                  );
                },
                child: MovieCard(movie: movie),
              );
            },
          ),
        ),
      ],
    );
  }
}
