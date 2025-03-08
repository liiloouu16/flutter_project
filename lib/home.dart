import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_project/app_store.dart';
import 'customform.dart';

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
      appBar:
          PreferredSize(preferredSize: Size.fromHeight(100.0), child:
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
        MyCustomForm()
      ]),
    );
  }
}
