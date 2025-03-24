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
  List<Map<String, String>> movieDetails = [];
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

      //fusionne toutes les images en liste et maj et les mélange
      setState(() {
        movieDetails = results.expand((list) => list).toList()..shuffle();
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

      //informations des films
      List<Map<String,String>> movies = await Future.wait(
        (dataUrl["results"] as List)
          //évite erreur nulles
          .where((movie) => movie["poster_path"] != null)
          .map((movie) async => {
            "image": "https://image.tmdb.org/t/p/original${movie["poster_path"]}",
            "title": ( movie["title"] ?? movie["name"] ?? "Sans titre").toString(),
            "release_date": (movie["release_date"] ?? movie["first_air_date"]).toString(),
            "runtime": await fetchRuntime(movie["id"]),
          })
          .toList(),
      );

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
          movieDetails = newImages;
        });
      }
    }catch(e){
      print("Erreur lors de la mise à jour des films : $e");
    }
  }

  //récupère la durée du film
  Future<String> fetchRuntime (int movieId) async{
    try {
      //création de la requête
      final String url = "https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&language=fr-FR";

      //envoie de la requête GET
      final response = await http.get(Uri.parse(url));

      //si aucune réponse est retournée
      if (response.statusCode != 200) {
        throw Exception(
            "Erreur ${response.statusCode} : ${response.reasonPhrase}");
      }

      //sinon décode la réponse
      final dataUrl = json.decode(response.body);
      int runtime =  dataUrl["runtime"] ?? 0;

      if (runtime == 0) return "Durée inconnue ici";

      //conversion en heure
      int hours = runtime ~/ 60;
      int minutes = runtime % 60;

      //si la conversion est nécéssaire
      return hours > 0
        ? "$hours h ${minutes.toString().padLeft(2, '0')} min"
        : "$minutes min";


    } catch(e){
      print("Erreur lors de la récupération des runtime : $e");
      return "Durée inconnue";
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
        body: Padding(
          padding: const EdgeInsets.only(top:20),
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),//enlève le défilement entre les tabs
            children: [
              buildMovieList(),
              buildMovieList(),
              buildMovieList(),
              buildMovieList(),
            ],
          ),
        ),
      ),
    );
  }


  //affichage
  Widget buildMovieList(){
    return Center(
      //chargement
      child: isLoading ? const CircularProgressIndicator()
      : movieDetails.isEmpty? const Text("Aucun film trouvé", style: TextStyle(fontSize: 18),)
        //Moviecard
        : Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: TinderSwapCard(
                  swipeUp: false,
                  swipeDown: false,
                  orientation: AmassOrientation.top,
                  totalNum: movieDetails.length,
                  stackNum: 3,
                  swipeEdge: 3.0,
                  maxWidth: MediaQuery.of(context).size.width * 0.85,
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                  minWidth: MediaQuery.of(context).size.width * 0.75,
                  minHeight: MediaQuery.of(context).size.height * 0.6,

                  cardBuilder: (context, index) => Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, //aligner à gauche
                      children: [
                        Expanded(child:
                          Image.network(
                            movieDetails[index]["image"]!,
                            fit: BoxFit.cover,
                            width: double.infinity,//éviter bord blanc
                          ),
                        ),
                        //TITRE
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 7.0, bottom: 1),
                          child: Text(
                            movieDetails[index]["title"] ?? "Titre inconnu",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        //DATE
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            "Date de sortie : ${movieDetails[index]["release_date"] ?? "Date inconnue"}",
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                        //DUREE
                        Padding(padding: const EdgeInsets.only(left: 15.0, bottom: 7),
                          child: Text(
                            "Durée : ${movieDetails[index]["runtime"] ?? "Durée inconnue"}",
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ),
                  cardController: controller,
                  swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
                    if (align.x < 0) {
                      print("Swiping Left");
                    } else if (align.x > 0) {
                      print("Swiping Right");
                    }
                  },
                  swipeCompleteCallback:
                      (CardSwipeOrientation orientation, int index) {
                    print("Card $index swiped $orientation");
                  },
              ),
            ),
            SizedBox(height: 20),
            //BOUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //RETOUR
                IconButton(
                  icon: const Icon(
                    Icons.rotate_left,
                    color: Colors.amber,
                    size: 40,
                  ),
                  onPressed: (){
                    print("retour");
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: const BorderSide(color: Color(0xFFEAEAEA), width:1.7)
                    )
                  ),
                ),
                SizedBox(width: 20),
                //FAVORIS
                IconButton(
                  icon: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.green,
                    size: 55,
                  ),
                  onPressed: (){
                    print("mettre en favoris");
                  },
                  style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: const BorderSide(color: Color(0xFFEAEAEA), width:1.7)
                      )
                  ),
                ),
                SizedBox(width: 20),
                //SKIP
                IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.red,
                    size: 40,
                  ),
                  onPressed: (){
                    print("passer");
                  },
                  style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: const BorderSide(color: Color(0xFFEAEAEA), width:1.7)
                      )
                  ),
                ),
              ],
            )
          ],
        ),
    );
  }
}
