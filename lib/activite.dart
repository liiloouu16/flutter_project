import 'package:flutter/material.dart';

class ActivitePage extends StatefulWidget {
  @override
  _ActivitePageState createState() => _ActivitePageState();
}

class _ActivitePageState extends State<ActivitePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> likedMovies = [
    {
      'title': 'Inception',
      'year': '2010',
      'poster':
      'https://image.tmdb.org/t/p/w500/qmDpIHrmpJINaRKAfWQfftjCdyi.jpg',
    },
    {
      'title': 'Interstellar',
      'year': '2014',
      'poster':
      'https://image.tmdb.org/t/p/w500/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg',
    },
  ];

  final List<Map<String, String>> watchLaterMovies = [
    {
      'title': 'Dune',
      'year': '2021',
      'poster':
      'https://image.tmdb.org/t/p/w500/d5NXSklXo0qyIYkgV94XAgMIckC.jpg',
    },
    {
      'title': 'The Batman',
      'year': '2022',
      'poster':
      'https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg',
    },
  ];

  final List<Map<String, String>> watchedMovies = [
    {
      'title': 'The Dark Knight',
      'year': '2008',
      'poster':
      'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
    },
    {
      'title': 'Avengers: Endgame',
      'year': '2019',
      'poster':
      'https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildMovieList(List<Map<String, String>> movies) {
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
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                  movie['poster']!,
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
                movie['title']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              subtitle: Text(
                'Sorti en ${movie['year']}',
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
                // TODO: Action quand on clique sur un film
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
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF4A148C),
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
        child: TabBarView(
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
