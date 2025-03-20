import 'package:flutter/material.dart';
import 'package:flutter_project/affichageapi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_project/home.dart';
import 'film.dart';
import 'swipe_movie.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}