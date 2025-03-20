import 'package:flutter/material.dart';
import 'package:flutter_project/searchbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Recherche extends StatefulWidget {
  const Recherche({super.key});

  @override
  State<Recherche> createState() => _RechercheState();
}

class _RechercheState extends State<Recherche> {
  List<Map<String, String>> movieImage = [];
  List<Map<String, String>> displayedMovies = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  static const String apiKey = "ee1d2e42bc7d50154cba81d702754cda";

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
        "tv/top_rated"
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
      print("Erreur récupération films/séries : $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, String>>> fetchMovies(String category) async {
    try {
      final String url = "https://api.themoviedb.org/3/$category?api_key=$apiKey&language=fr-FR&page=1";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception("Erreur ${response.statusCode} : ${response.reasonPhrase}");
      }
      final dataUrl = json.decode(response.body);
      List<Map<String, String>> movies = (dataUrl["results"] as List)
          .where((movie) => movie["poster_path"] != null)
          .map((movie) => {
        "image": "https://image.tmdb.org/t/p/original${movie["poster_path"]}",
        "title": (movie["title"] ?? movie["name"] ?? "Sans titre").toString(),
        "release_date": (movie["release_date"] ?? movie["first_air_date"]).toString(),
        "runtime": "${movie["runtime"]?.toString() ?? "Durée inconnue"} min",
      })
          .toList();
      movies.shuffle();
      return movies;
    } catch (e) {
      print("Erreur lors de la récupération des films : $e");
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
      final String url = "https://api.themoviedb.org/3/search/movie?query=$query&api_key=$apiKey&language=fr-FR&page=1";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception("Erreur ${response.statusCode} : ${response.reasonPhrase}");
      }
      final dataUrl = json.decode(response.body);
      setState(() {
        displayedMovies = (dataUrl["results"] as List)
            .where((movie) => movie["poster_path"] != null)
            .map((movie) => {
          "image": "https://image.tmdb.org/t/p/original${movie["poster_path"]}",
          "title": (movie["title"] ?? movie["name"] ?? "Sans titre").toString(),
          "release_date": (movie["release_date"] ?? movie["first_air_date"]).toString(),
          "runtime": "${movie["runtime"]?.toString() ?? "Durée inconnue"} min",
        })
            .toList();
      });
    } catch (e) {
      print("Erreur lors de la recherche : $e");
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
          ? const Center(child: Text("Aucun film trouvé", style: TextStyle(fontSize: 18)))
          : ListView.builder(
        itemCount: displayedMovies.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    displayedMovies[index]["image"]!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayedMovies[index]["title"] ?? "Titre inconnu",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Date de sortie : ${displayedMovies[index]["release_date"] ?? "Inconnue"}",
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        "Durée : ${displayedMovies[index]["runtime"] ?? "Durée inconnue"}",
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
