import 'package:flutter/material.dart';
import 'package:flutter_project/searchbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'appconst.dart';
import 'movie_card.dart';
import 'movie_page.dart';
import 'movie.dart';
import 'dart:developer' as dev;

class Recherche extends StatefulWidget {
  const Recherche({super.key});

  @override
  State<Recherche> createState() => _RechercheState();
}

class _RechercheState extends State<Recherche> {
  List<Movie> movieImage = [];
  List<Movie> displayedMovies = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAll();
  }

  Future<void> fetchAll() async {
    try {
      final allCategories = [
        "movie/popular",
        "movie/now_playing",
        "movie/top_rated",
      ];

      setState(() {
        isLoading = true;
      });

      final results = await Future.wait(allCategories.map(fetchMovies));
      setState(() {
        movieImage = results.expand((list) => list).toList()..shuffle();
        displayedMovies = List.from(movieImage);
        isLoading = false;
      });
    } catch (e) {
      dev.log("Erreur récupération films/séries : $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Movie>> fetchMovies(String category) async {
    try {
      final String url =
          "https://api.themoviedb.org/3/$category?api_key=${Appconst.apiKey}&language=fr-FR&page=1";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception(
            "Erreur ${response.statusCode} : ${response.reasonPhrase}");
      }

      final data = json.decode(response.body);
      List<Movie> movies = (data["results"] as List)
          .where((movie) => movie["poster_path"] != null)
          .map((movie) => Movie.fromJson(movie))
          .toList();

      movies.shuffle();
      return movies;
    } catch (e) {
      dev.log("Erreur lors de la récupération des films : $e");
      return [];
    }
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        displayedMovies = List.from(movieImage);
      });
      return;
    }
    try {
      final String url =
          "https://api.themoviedb.org/3/search/movie?query=$query&api_key=${Appconst.apiKey}&language=fr-FR&page=1";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception(
            "Erreur ${response.statusCode} : ${response.reasonPhrase}");
      }
      final dataUrl = json.decode(response.body);
      setState(() {
        displayedMovies = (dataUrl["results"] as List)
            .where((movie) => movie["poster_path"] != null)
            .map((movie) => Movie.fromJson(movie))
            .toList();
      });
    } catch (e) {
      dev.log("Erreur lors de la recherche : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBarWidget(
          controller: searchController,
          onSearch: searchMovies,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: buildMovieList(),
        ),
      ],
    );
  }

  Widget buildMovieList() {
    return Expanded(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : displayedMovies.isEmpty
              ? const Center(
                  child:
                      Text("Aucun film trouvé", style: TextStyle(fontSize: 18)))
              : ListView.builder(
                  itemCount: displayedMovies.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailPage(
                                  movie: displayedMovies[index]),
                            ),
                          );
                        },
                        child: MovieCard(movie: displayedMovies[index]));
                  },
                ),
    );
  }
}
