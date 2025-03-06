import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_project/app_store.dart';
import 'imc.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  final double weightKg = 80;
  final double heightCm = 180;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStoreState state = ref.watch(appStoreProvider);
    final AppStore store = ref.read(appStoreProvider.notifier);

    double weight = state.weightKg;
    double height = state.heightCm;

    return Scaffold(
      appBar: AppBar(
        elevation: 300,
        title: const Text('Home',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.red,
      ),
      body: Column(children: [
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Rechercher ici',
          ),
        )
      ]),
    );
  }
}
