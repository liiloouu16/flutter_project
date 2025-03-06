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
      appBar:
          PreferredSize(preferredSize: Size.fromHeight(205.0), child:
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
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  store.decreaseWeight(store, weight, state);
                },
                child: Text('-5kg')),
            Expanded(child: Text('$weight kg', textAlign: TextAlign.center)),
            ElevatedButton(
                onPressed: () {
                  store.increaseWeight(store, weight, state);
                },
                child: Text('+5kg')),
          ],
        ),
        Container(
            height: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(store.calculImc(weight, height))),
              color: store.modifyColor(store.calculImc(weight, height)),
            ),
            child: Center(
              child: IMCVisualisator(),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  store.modifyHeight(-5, height);
                },
                child: Text('-5cm')),
            Expanded(
                child: Text(
                  '$height cm',
                  textAlign: TextAlign.center,
                )),
            ElevatedButton(
                onPressed: () {
                  store.modifyHeight(5, height);
                },
                child: Text('+5cm')),
          ],
        ),
      ]),
      floatingActionButton: store.shouldShowResetBtn(state)
          ? Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              onPressed: () {
                store.resetValues(store);
              },
              child: Icon(Icons.clear)),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () => null,
            child: Icon(Icons.save),
          )
        ],
      )
          : SizedBox(),
    );
  }
}
