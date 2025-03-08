import 'package:flutter/material.dart';
import 'dart:convert'; //pour décoder la réponse json
import 'package:http/http.dart' as http; //pour les requêtes http
import 'package:scrumlab_flutter_tindercard/scrumlab_flutter_tindercard.dart';

class SwipeMovie extends StatefulWidget {
  const SwipeMovie({super.key});
  @override
  State<SwipeMovie> createState() => _SwipeMovieState();
}

class _SwipeMovieState extends State<SwipeMovie>{

  //liste d'images récupérées depuis l'API
  List<String> movieImage = [];
  bool isLoading = true;

  //variable pour l'URL de l'API
  String url = "https://api.themoviedb.org/3/movie/popular?api_key=ee1d2e42bc7d50154cba81d702754cda&language=fr-FR&page=1";

  CardController controller = CardController();

  @override
  void initState(){
    super.initState();
    //appel initial pour récuperer les films
    fetchMovies();
  }

  //fonction qui récupère les films
  Future<void> fetchMovies() async{
    const String apiKey = "ee1d2e42bc7d50154cba81d702754cda";
    try{
      //envoie de la requête GET
      final response = await http.get(Uri.parse(url));

      //si une réponse est retournée
      if (response.statusCode == 200){
        //décode la réponse
        final dataUrl = json.decode(response.body);

        //accède à la liste des films
        List<String> images = (dataUrl["results"] as List)
          //construction de l'url complète
          .map((movie) => "https://image.tmdb.org/t/p/original${movie["poster_path"]}")
          //évite erreur nulles
          .where((url) => url.isNotEmpty)
          .toList()
        ;

        //met à jour l'état avec de nouvelles img
        setState(() {
          movieImage = images;
          //fin du chargement
          isLoading = false;
        });

      }else{
        print("Erreur ${response.statusCode} : ${response.reasonPhrase}");
      }
    }
    catch(e){
      print("Erreur lors de la récupération des films : $e");
      setState(() {
        //arrête le chargement en cas d'erreur
        isLoading = false;
      });
    }
  }

  //fonction qui change l'url selon onglet selected
  void updateUrl(int index){
    String newUrl;
    switch(index){
      case 0://
        newUrl = "https://api.themoviedb.org/3/movie/popular?api_key=ee1d2e42bc7d50154cba81d702754cda&language=fr-FR&page=1";
        break;
      case 1://du moment
        newUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key=ee1d2e42bc7d50154cba81d702754cda&language=fr-FR&page=1";
        break;
      case 2://populaire
        newUrl = "https://api.themoviedb.org/3/movie/top_rated?api_key=ee1d2e42bc7d50154cba81d702754cda&language=fr-FR&page=1";
        break;
      case 3://émission/série
        newUrl = "https://api.themoviedb.org/3/tv/top_rated?api_key=ee1d2e42bc7d50154cba81d702754cda&language=fr-FR&page=1";
        break;
      default:
        newUrl = "https://api.themoviedb.org/3/movie/popular?api_key=ee1d2e42bc7d50154cba81d702754cda&language=fr-FR&page=1";
    }
    setState(() {
      url = newUrl;
      isLoading = true;
      movieImage.clear();
    });
    fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // nombre d'onglets
      child: Scaffold(
        appBar: AppBar(
          title: Text("Films à swiper"),
          bottom: TabBar(
            onTap: (index) {
              updateUrl(index); // Mettre à jour l'URL lorsqu'un onglet est sélectionné
            },
            tabs: [
              Tab(text: "Tout"),
              Tab(text: "Du moment"),
              Tab(text: "Populaire"),
              Tab(text: "Emission télé"),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),//enlève le défilement entre les tabs
          children: [
            buildMovieList(),
            buildMovieList(),
            buildMovieList(),
            buildMovieList(),
            buildMovieList(),
          ],
        ),
      ),
    );
  }


  //affiche les films
  Widget buildMovieList(){
    return Center(
      child: movieImage.isEmpty
        ? const CircularProgressIndicator()
        : SizedBox(
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
              child: Image.network(
                movieImage[index],
                fit: BoxFit.cover,
              ),
            ),
            cardController: controller = CardController(),
            swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {},
            swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {},
        ),
      ),
    );
  }
}
