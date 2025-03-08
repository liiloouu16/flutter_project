import 'package:flutter/material.dart';
import 'package:scrumlab_flutter_tindercard/scrumlab_flutter_tindercard.dart';

class SwipeMovie extends StatefulWidget {
  const SwipeMovie({super.key});

  @override
  State<SwipeMovie> createState() => _SwipeMovieState();
}

class _SwipeMovieState extends State<SwipeMovie>{

  List<String> movieImage = [
    'assets/swiper_img/aff1.jpg',
    'assets/swiper_img/aff2.jpg',
    'assets/swiper_img/aff3.jpg',
    'assets/swiper_img/aff4.jpg',
    'assets/swiper_img/aff5.jpg',
    'assets/swiper_img/aff6.jpg',
  ];

  @override
  Widget build(BuildContext context) {

    CardController controller;

    return Scaffold(
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: TinderSwapCard(
            swipeUp: true,
              swipeDown: true,
              orientation: AmassOrientation.bottom,
              totalNum: movieImage.length,
            stackNum: 2,
            swipeEdge: 4.0,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
            minWidth: MediaQuery.of(context).size.width * 0.8,
            minHeight: MediaQuery.of(context).size.width * 0.8,
            cardBuilder: (context, index) => Card(
              child: Image.asset(movieImage[index]),
            ),
            cardController: controller = CardController(),
            swipeUpdateCallback: (DragUpdateDetails details, Alignment align){
              //si swipe a gauche
              if(align.x < 0){

              }else if(align.x > 0){

              }
            },
            swipeCompleteCallback: (CardSwipeOrientation orientation, int index){
            },
          ),
        ),
      ),
    );
  }
}
