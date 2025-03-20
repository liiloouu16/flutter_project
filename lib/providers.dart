import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_project/api.dart';
import 'package:flutter_project/video.dart';

// Provider pour récupérer un Film via l'API
final filmProvider = FutureProvider<Video>((ref) async {
  return fetchFilm();  // Appelle la méthode fetchFilm de l'API pour récupérer les données
});
