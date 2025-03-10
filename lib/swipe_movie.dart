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
  List<Map<String, String>> movieImage = [];
  bool isLoading = true;

  //variable pour l'URL de l'API
  static const String apiKey = "ee1d2e42bc7d50154cba81d702754cda";
  CardController controller = CardController();

  @override
  void initState(){
    super.initState();
    //appel initial pour récuperer tous les films/séries
    fetchAll();
  }

  //fonction qui récupère tout (film+série)
  Future<void> fetchAll() async{
    try{
      //liste de toutes les catégories
      final allCategories = [
        "movie/popular",
        "movie/now_playing",
        "movie/top_rated",
        "tv/top_rated"
      ];

      setState(() {
        isLoading = true;
      });

      //récupère toutes les catégories
      final results = await Future.wait(allCategories.map(fetchMovies));

      //fusionne toutes les images en liste et maj
      setState(() {
        movieImage = results.expand((list) => list).toList()..shuffle();
        isLoading = false; //fin du chargement
      });
    } catch (e) {
      print("Erreur récupération films/séries : $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  //fonction qui récupère les films
  Future<List<Map<String, String>>> fetchMovies(String category) async{
    try{
      //construction de l'url
      final String url = "https://api.themoviedb.org/3/$category?api_key=$apiKey&language=fr-FR&page=1";

      //envoie de la requête GET
      final response = await http.get(Uri.parse(url));

      //si aucune réponse est retournée
      if (response.statusCode != 200) {
        throw Exception("Erreur ${response.statusCode} : ${response.reasonPhrase}");
      }

      //sinon décode la réponse
      final dataUrl = json.decode(response.body);
      print(dataUrl);

      //informations des films
      List<Map<String,String>> movies = (dataUrl["results"] as List)
        //évite erreur nulles
        .where((movie) => movie["poster_path"] != null)
        .map((movie) => {
          "image": "https://image.tmdb.org/t/p/original${movie["poster_path"]}",
          "title":( movie["title"] ?? movie["name"] ?? "Sans titre").toString(),
          "release_date": (movie["release_date"] ?? movie["first_air_date"]).toString(),
          "runtime":  " ${movie["runtime"].toString()} min" ?? "Durée inconnue",
        })
        .toList()
      ;

      //mélange les images aléatoirement
      movies.shuffle();

      return movies;
    }
    catch(e){
      print("Erreur lors de la récupération des films : $e");
      return [];
    }
  }

  //fonction qui change l'url selon onglet selected
  void updateUrl(int index) async{
    String category;
    try {
      //si onglet "tout" cliqué
      if (index == 0) {
        await fetchAll();
      }
      else {
        switch (index) {
          case 1:
            category = "movie/now_playing";
            break;
          case 2:
            category = "movie/top_rated";
            break;
          case 3:
            category = "tv/top_rated";
            break;
          default:
            category = "movie/popular";
        }
        final newImages = await fetchMovies(category);
        setState(() {
          movieImage = newImages;
        });
      }
    }catch(e){
      print("Erreur lors de la mise à jour des films : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    //onglet de sélection
    return DefaultTabController(
      length: 4, //nombre d'onglets
      child: Scaffold(
        appBar: AppBar(
          title: Text("Trouve ton film ou ta série"),
          bottom: TabBar(
            //onglet cliqué -> maj l'url
            onTap: (index) {
              updateUrl(index);
            },
            tabs: [
              Tab(text: "Tout"),
              Tab(text: "Au cinéma"),
              Tab(text: "Mieux noté"),
              Tab(text: "Série"),
            ],
          ),
        ),
        //contenu en dessous de l'onglet
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),//enlève le défilement entre les tabs
          children: [
            buildMovieList(),
            buildMovieList(),
            buildMovieList(),
            buildMovieList(),
          ],
        ),
      ),
    );
  }


  //affichage les films
  Widget buildMovieList(){
    return Center(
      child: isLoading ? const CircularProgressIndicator()
      : movieImage.isEmpty? const Text("Aucun film trouvé", style: TextStyle(fontSize: 18),)
          : SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: TinderSwapCard(
              swipeUp: true,
              swipeDown: true,
              orientation: AmassOrientation.bottom,
              totalNum: movieImage.length,
              stackNum: 5,
              swipeEdge: 2.0,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
              minWidth: MediaQuery.of(context).size.width * 0.8,
              minHeight: MediaQuery.of(context).size.width * 0.8,
              cardBuilder: (context, index) => Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, //aligner à gauche
                  children: [
                    Expanded(child:
                      Image.network(
                        movieImage[index]["image"]!,
                        fit: BoxFit.cover,
                        width: double.infinity,//éviter bord blanc
                      ),
                    ),
                    //TITRE
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        movieImage[index]["title"] ?? "Titre inconnu",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    //DATE et DUREE
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
                      child: Row(
                        children: [
                          Text(
                            movieImage[index]["release_date"] ?? "Date inconnue",
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            movieImage[index]["runtime"] ?? "Durée inconnue",
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              cardController: controller,
              swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {},
              swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {},
          ),
        ),
    );
  }
}
