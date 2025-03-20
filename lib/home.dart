import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_project/video.dart';
import 'package:flutter_project/customform.dart';  // Ton formulaire personnalisé
import 'package:flutter_project/api.dart';  // Assure-toi d'importer l'API

// ConsumerWidget pour la page d'accueil
class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Récupère l'état du FutureProvider (filmProvider)
    final filmAsyncValue = ref.watch(filmProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          centerTitle: true,
          title: const Text('🎬Filmania',
              style: TextStyle(
                color: Colors.white,
                fontSize: 60,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: Colors.purple[800],
        ),
      ),
      body: Column(
        children: [
          const MyCustomForm(),  // Ton formulaire personnalisé
          // Utilisation de AsyncValue.when pour gérer l'état
          filmAsyncValue.when(
            data: (video) {
              return Text(video.title);  // Affiche le titre du film
            },
            loading: () {
              return const CircularProgressIndicator();  // Affiche un indicateur de chargement
            },
            error: (error, stackTrace) {
              return Text('Erreur: $error');  // Affiche l'erreur
            },
          ),
        ],
      ),
    );
  }
}
