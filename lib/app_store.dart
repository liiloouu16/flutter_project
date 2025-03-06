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
  AppStore() : super(AppStoreState.init())  {
    SharedPreferences.getInstance().then((prefs)  {
      double? prevHeight = prefs.getDouble(Appconst.heightKey);
      setHeightCm(prevHeight);
    });
  }

  AppStoreState getState()  {
    return state;
  }

  void saveValues()  {
    Future<SharedPreferences> future = SharedPreferences.getInstance();
    future.then((SharedPreferences prefs)  {
      prefs.setDouble(Appconst.weightKey, state.weightKg);
      prefs.setDouble(Appconst.heightKey, state.heightCm);
    });
  }

  void setWeightKg(double? value)  {
    state = state.copyWith(weightKg: value);
  }

  void setHeightCm(double? value)  {
    state = state.copyWith(heightCm: value);
  }

  bool shouldShowResetBtn(AppStoreState state){
    var isHeightDifferent = state.heightCm != Appconst.tailleDefault;
    var isWeightDifferent = state.weightKg != Appconst.poidsDefault;
    return isHeightDifferent || isWeightDifferent;
  }


  void modifyWeight(final double offset, final double value, AppStoreState state){
    double valeur = value+offset;

    if (valeur < Appconst.poidsMin) setWeightKg(Appconst.poidsMin);
    else if (valeur > Appconst.poidsMax) setWeightKg(Appconst.poidsMax);
    else{setWeightKg(valeur);}
  }

  void increaseWeight(AppStore store, final double value, AppStoreState state){
    modifyWeight(5, value, state);
  }

  void decreaseWeight(AppStore store, final double value, AppStoreState state){
    modifyWeight(-5, value, state);
  }

  void modifyHeight(final double offset, final double value){
    double valeur = value+offset;

    if (valeur < Appconst.poidsMin) setHeightCm(Appconst.poidsMin);
    else if (valeur > Appconst.poidsMax) setHeightCm(Appconst.poidsMax);
    else{setHeightCm(value+offset);}
  }

  void resetValues(final AppStore store)  {
    setWeightKg(Appconst.poidsDefault);
    setHeightCm(Appconst.tailleDefault);
  }

  Color modifyColor(double imc)  {
    if ((imc > 18) & (imc < 24.9))  {return Colors.green;}
    else if ((imc > 25) & (imc < 29.9))  {return Colors.yellow;}
    else if ((imc > 30) & (imc < 34.9))  {return Colors.orange;}
    else if ((imc > 35) & (imc < 40))  {return Colors.red;}
    else if ((imc > 40) & (imc < 49.9))  {return Colors.purple;}
    else if ((imc > 50))  {return Colors.black;}
    else  {return Colors.pink;}
  }

  double calculImc(double weight, double height)  {
    var imc = weight / ((height / 100.00) * (height / 100.00));
    return imc;
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
