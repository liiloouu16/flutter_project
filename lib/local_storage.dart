import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'movie.dart';

enum MovieCategory {
  liked,
  watchLater,
  watched,
}

class LocalStorage {
  static const _fileName = 'movies_data.json';

  static Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  static Future<Map<String, List<Movie>>> readData() async {
    try {
      final file = await _getLocalFile();
      if (!(await file.exists())) {
        // Création fichier vide avec structure JSON minimale
        await file.writeAsString(jsonEncode({
          'liked': [],
          'watchLater': [],
          'watched': [],
        }));
      }

      final jsonString = await file.readAsString();
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

      return {
        'liked': (jsonMap['liked'] as List<dynamic>?)
            ?.map((e) => Movie.fromJson(e))
            .toList() ??
            [],
        'watchLater': (jsonMap['watchLater'] as List<dynamic>?)
            ?.map((e) => Movie.fromJson(e))
            .toList() ??
            [],
        'watched': (jsonMap['watched'] as List<dynamic>?)
            ?.map((e) => Movie.fromJson(e))
            .toList() ??
            [],
      };
    } catch (e) {
      print("Erreur de lecture: $e");
      return {'liked': [], 'watchLater': [], 'watched': []};
    }
  }

  static Future<void> saveData({
    required List<Movie> liked,
    required List<Movie> watchLater,
    required List<Movie> watched,
  }) async {
    final file = await _getLocalFile();
    final jsonMap = {
      'liked': liked.map((m) => m.toJson()).toList(),
      'watchLater': watchLater.map((m) => m.toJson()).toList(),
      'watched': watched.map((m) => m.toJson()).toList(),
    };
    await file.writeAsString(jsonEncode(jsonMap));
  }

  static Future<void> addMovie(Movie movie, MovieCategory category) async {
    final data = await readData();
    final key = _getKey(category);
    final list = data[key] ?? [];

    if (list.any((m) => m.id == movie.id)) return;

    list.add(movie);

    await saveData(
      liked: key == 'liked' ? list : data['liked']!,
      watchLater: key == 'watchLater' ? list : data['watchLater']!,
      watched: key == 'watched' ? list : data['watched']!,
    );
  }

  static Future<void> removeMovie(int movieId, MovieCategory category) async {
    final data = await readData();
    final key = _getKey(category);
    final list = data[key] ?? [];

    list.removeWhere((m) => m.id == movieId);

    await saveData(
      liked: key == 'liked' ? list : data['liked']!,
      watchLater: key == 'watchLater' ? list : data['watchLater']!,
      watched: key == 'watched' ? list : data['watched']!,
    );
  }

  // Méthodes pour récupérer chaque liste individuellement
  static Future<List<Map<String, dynamic>>> getLikedMovies() async {
    final data = await readData();
    return data['liked']!.map((movie) => movie.toJson()).toList();
  }

  static Future<List<Map<String, dynamic>>> getWatchLaterMovies() async {
    final data = await readData();
    return data['watchLater']!.map((movie) => movie.toJson()).toList();
  }

  static Future<List<Map<String, dynamic>>> getWatchedMovies() async {
    final data = await readData();
    return data['watched']!.map((movie) => movie.toJson()).toList();
  }

  static String _getKey(MovieCategory cat) {
    switch (cat) {
      case MovieCategory.liked:
        return 'liked';
      case MovieCategory.watchLater:
        return 'watchLater';
      case MovieCategory.watched:
        return 'watched';
    }
  }
}
