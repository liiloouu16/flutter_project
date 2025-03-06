import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Rectangle extends StatelessWidget {
  const Rectangle({super.key, required this.color, this.width = 100, this.height, required this.text});
  final Color color;
  final double width;
  final double? height;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: color,
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Text(text)
    );
  }
}

// mettre required devant un paramètre le rend obligatoire
// mettre un point d'interrogation juste après le type, on le rend nullable (si height est nulle, il prend toute la hauteur disponible)