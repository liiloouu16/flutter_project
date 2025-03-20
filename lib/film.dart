import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'appconst.dart';

class Film extends ConsumerWidget {
  const Film ({super.key});

  final double weightKg = 80;
  final double heightCm = 180;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar:
      PreferredSize(preferredSize: Size.fromHeight(85.0), child:
      AppBar(
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
      body: Column(children:[
        Image.network(Appconst.imageBaseUrl),
      ]),
    );
  }
}
