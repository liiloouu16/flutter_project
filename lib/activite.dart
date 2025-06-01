import 'package:flutter/material.dart';
import 'movie.dart';
import 'local_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'appconst.dart';
import 'movie_page.dart';

class ActivitePage extends StatefulWidget {
  @override
  _ActivitePageState createState() => _ActivitePageState();
}

class _ActivitePageState extends State<ActivitePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Movie> likedMovies = [];
  List<Movie> watchLaterMovies = [];
  List<Movie> watchedMovies = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadMoviesFromStorage();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<Movie?> fetchMovieDetails(int id) async {
    final apiKey = '${Appconst.apiKey}';  // Remplace par ta clé TMDB
    final url =
        'https://api.themoviedb.org/3/movie/$id?api_key=$apiKey&language=fr-FR';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Movie.fromJson(data);
    } else {
      print("Erreur API film $id : ${response.statusCode}");
      return null;
    }
  }

  Future<void> loadMoviesFromStorage() async {
    setState(() {
      isLoading = true;
    });

    final likedList = await LocalStorage.getLikedMovies();
    final watchLaterList = await LocalStorage.getWatchLaterMovies();
    final watchedList = await LocalStorage.getWatchedMovies();

    final likedFutures = likedList.map((json) => fetchMovieDetails(json['id'])).toList();
    final watchLaterFutures = watchLaterList.map((json) => fetchMovieDetails(json['id'])).toList();
    final watchedFutures = watchedList.map((json) => fetchMovieDetails(json['id'])).toList();

    final likedResults = await Future.wait(likedFutures);
    final watchLaterResults = await Future.wait(watchLaterFutures);
    final watchedResults = await Future.wait(watchedFutures);

    setState(() {
      likedMovies = likedResults.whereType<Movie>().toList();
      watchLaterMovies = watchLaterResults.whereType<Movie>().toList();
      watchedMovies = watchedResults.whereType<Movie>().toList();
      isLoading = false;
    });
  }

  Widget buildMovieList(List<Movie> movies) {
    if (movies.isEmpty) {
      return Center(
        child: Text(
          'Aucun film dans cette catégorie.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          shadowColor: Colors.black54,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade700,
                  Colors.deepPurple.shade900,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  movie.imageUrl,
                  width: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.movie,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                ),
              ),
              title: Text(
                movie.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              subtitle: Text(
                'Sorti en ${movie.releaseDate}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              trailing: const Icon(
                Icons.favorite,
                color: Colors.redAccent,
                size: 28,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieDetailPage(movie: movie),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mon activité',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A148C),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.pinkAccent,
          labelColor: Colors.pinkAccent,
          unselectedLabelColor: Colors.white,
          tabs: const [
            Tab(text: 'Film likés'),
            Tab(text: 'À regarder'),
            Tab(text: 'Regardés'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9C27B0), Color(0xFF4A148C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
          controller: _tabController,
          children: [
            buildMovieList(likedMovies),
            buildMovieList(watchLaterMovies),
            buildMovieList(watchedMovies),
          ],
        ),
      ),
    );
  }
}
