import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_project/app_store.dart';
import 'package:flutter_project/rectangle.dart';
import 'package:flutter_project/appconst.dart';

class IMCVisualisator extends ConsumerWidget {
  const IMCVisualisator ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    AppStoreState state = ref.watch(appStoreProvider);
    final AppStore store = ref.read(appStoreProvider.notifier);
    double? weight = state.weightKg;
    double? height = state.heightCm;

    final double imc = weight! / ((height!/100) * (height!/100));

    double ratio = (weight - Appconst.poidsMin) / (Appconst.poidsMax - Appconst.poidsMin);
    double largeur = 0.2 + ratio * 0.6;
    largeur = largeur * MediaQuery.of(context).size.width;

    return Rectangle(
        color : store.modifyColor(imc),
        width: MediaQuery.of(context).size.width * 0.8 * ((weight / 2.5) / 80),
        height: height,
        text: imc.toStringAsFixed(1));
  }
}