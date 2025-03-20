import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project/affichageapi.dart';
import 'package:flutter_project/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Colors.deepPurpleAccent, Colors.purpleAccent],
              ),
            ),
          ),
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
          Recherche()
        ],
      ),
    );
  }
}
