import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MovieApp());

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MovieScreen(),
    );
  }
}

class MovieScreen extends StatefulWidget {
  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  List movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/search/movie?query=avengers'),
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1OWIyNDMzM2UzOWIxNGQ0ODBlZjNmOTQyOTRmYWFkOSIsIm5iZiI6MTc0MDQxMjUwNS43OTcsInN1YiI6IjY3YmM5NjU5NDEwNjBhOGQ4ZmJlYjFkYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.4S6CaXIN-1yhOiX46JvyTxw__WV5353UxGYGLVBnGzw',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        movies = data['results'];
      });
    } else {
      throw Exception('Échec de chargement des films - Code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Films Avengers'),
      ),
      body: movies.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: movie['poster_path'] != null
                  ? Image.network(
                'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                width: 50,
                fit: BoxFit.cover,
              )
                  : Icon(Icons.movie),
              title: Text(movie['title']),
              subtitle: Text(movie['overview'] ?? 'Aucun résumé disponible'),
            ),
          );
        },
      ),
    );
  }
}