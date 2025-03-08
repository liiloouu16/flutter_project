import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_project/appconst.dart';

final appStoreProvider = StateNotifierProvider<AppStore, AppStoreState>((ref)  {
  return AppStore();
});

// Objet permettant la modification du state
class AppStore extends StateNotifier<AppStoreState>{
  AppStore() : super(AppStoreState.init())  {}

  AppStoreState getState() {
    return state;
  }
}

// Objet contenant toutes les valeurs du state
class AppStoreState  {
  final double weightKg;
  final double heightCm;

  AppStoreState({required this.weightKg, required this.heightCm});
  
  AppStoreState copyWith({double? weightKg, double? heightCm})  {
    return AppStoreState(weightKg: weightKg ?? this.weightKg, heightCm: heightCm ?? this.heightCm);
  }

  factory AppStoreState.init()  {
    return AppStoreState(weightKg: Appconst.poidsDefault, heightCm: Appconst.tailleDefault);
  }
}
