import 'package:flutter/material.dart';
import 'dart:convert'; //pour décoder la réponse json
import 'package:http/http.dart' as http; //pour les requêtes http
import 'package:scrumlab_flutter_tindercard/scrumlab_flutter_tindercard.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class SwipeMovie extends StatefulWidget {
  const SwipeMovie({super.key});
  @override
  State<SwipeMovie> createState() => _SwipeMovieState();
}

class _SwipeMovieState extends State<SwipeMovie> {
  //liste d'images récupérées depuis l'API
  List<Map<String, String>> movieDetails = [];
  List<Map<String, String>> lastSwiped = [];
  bool isLoading = true;

  //variable pour l'URL de l'API
  static const String apiKey = "ee1d2e42bc7d50154cba81d702754cda";
  CardController controller = CardController();

  @override
  void initState() {
    super.initState();
    //appel initial pour récuperer tous les films/séries
    fetchAll();
  }

  //fonction qui récupère tout (film+série)
  Future<void> fetchAll() async {
    try {
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
      logger.e("Erreur récupération films/séries : $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  //fonction qui récupère les films
  Future<List<Map<String, String>>> fetchMovies(String category) async {
    try {
      //construction de l'url
      final String url =
          "https://api.themoviedb.org/3/$category?api_key=$apiKey&language=fr-FR&page=1";

      //envoie de la requête GET
      final response = await http.get(Uri.parse(url));

      //si aucune réponse est retournée
      if (response.statusCode != 200) {
        throw Exception(
            "Erreur ${response.statusCode} : ${response.reasonPhrase}");
      }

      //sinon décode la réponse
      final dataUrl = json.decode(response.body);

      //informations des films
      List<Map<String, String>> movies = await Future.wait(
        (dataUrl["results"] as List)
            //évite erreur nulles
            .where((movie) => movie["poster_path"] != null)
            .map((movie) async => {
                  "image":
                      "https://image.tmdb.org/t/p/original${movie["poster_path"]}",
                  "title": (movie["title"] ?? movie["name"] ?? "Sans titre")
                      .toString(),
                  "release_date":
                      (movie["release_date"] ?? movie["first_air_date"])
                          .toString(),
                  "runtime": await fetchRuntime(movie["id"]),
                })
            .toList(),
      );

      //mélange les images aléatoirement
      movies.shuffle();

      return movies;
    } catch (e) {
      logger.e("Erreur lors de la récupération des films : $e");
      return [];
    }
  }

  //fonction qui change l'url selon onglet selected
  void updateUrl(int index) async {
    String category;
    try {
      //si onglet "tout" cliqué
      if (index == 0) {
        await fetchAll();
      } else {
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
    } catch (e) {
      logger.e("Erreur lors de la mise à jour des films : $e");
    }
  }

  //récupère la durée du film
  Future<String> fetchRuntime(int movieId) async {
    try {
      //création de la requête
      final String url =
          "https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&language=fr-FR";

      //envoie de la requête GET
      final response = await http.get(Uri.parse(url));

      //si aucune réponse est retournée
      if (response.statusCode != 200) {
        throw Exception(
            "Erreur ${response.statusCode} : ${response.reasonPhrase}");
      }

      //sinon décode la réponse
      final dataUrl = json.decode(response.body);
      int runtime = dataUrl["runtime"] ?? 0;

      if (runtime == 0) return "Durée inconnue ici";

      //conversion en heure
      int hours = runtime ~/ 60;
      int minutes = runtime % 60;

      //si la conversion est nécéssaire
      return hours > 0
          ? "$hours h ${minutes.toString().padLeft(2, '0')} min"
          : "$minutes min";
    } catch (e) {
      logger.e("Erreur lors de la récupération des runtime : $e");
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
          title: Text(
            "Trouve ton film ou ta série",
            style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),),
          centerTitle: true,
          backgroundColor: Color(0xFF4A148C),
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Colors.pinkAccent,
            labelColor: Colors.pinkAccent,
            unselectedLabelColor: Colors.white,
            isScrollable: false,
            onTap: (index) => updateUrl(index),
            tabs: const [
              Tab(text: "Tout"),
              Tab(text: "Cinéma"),
              Tab(text: "Top"),
              Tab(text: "Séries"),
            ],
          ),
        ),
        //contenu en dessous de l'onglet
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF9C27B0), Color(0xFF4A148C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.03,
          ),
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
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
  Widget buildMovieList() {
    return Center(
      //chargement
      child: isLoading
          ? const CircularProgressIndicator()
          : movieDetails.isEmpty
              ? const Text(
                  "Aucun film trouvé",
                  style: TextStyle(fontSize: 18),
                )
              //Moviecard
              : Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: TinderSwapCard(
                        swipeUp: false,
                        swipeDown: false,
                        orientation: AmassOrientation.top,
                        totalNum: movieDetails.length,
                        stackNum: 3,
                        swipeEdge: 3.0,
                        maxWidth: MediaQuery.of(context).size.width * 0.85,
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                        minWidth: MediaQuery.of(context).size.width * 0.75,
                        minHeight: MediaQuery.of(context).size.height * 0.7,
                        cardBuilder: (context, index) => Card(
                          color: Colors.deepPurple.withAlpha(77),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, //aligner à gauche
                            children: [
                              //IMAGE
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  child: Container(
                                    child: Image.network(
                                      movieDetails[index]["image"]!,
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                              ),
                              //BAS (INFOS)
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xFF4A148C),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //TITRE
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, top: 7.0, bottom: 1),
                                      child: Text(
                                        movieDetails[index]["title"] ??
                                            "Titre inconnu",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    //DATE
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15.0),
                                      child: Text(
                                        "Date de sortie : ${movieDetails[index]["release_date"] ?? "Date inconnue"}",
                                        style: const TextStyle(
                                            fontSize: 16, color: Color(0xFFCFCFCF)),
                                      ),
                                    ),
                                    //DUREE
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, bottom: 7),
                                      child: Text(
                                        "Durée : ${movieDetails[index]["runtime"] ?? "Durée inconnue"}",
                                        style: const TextStyle(
                                            fontSize: 16,  color: Color(0xFFCFCFCF)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        cardController: controller,
                        swipeCompleteCallback:
                            (CardSwipeOrientation orientation, int index) {
                          if (orientation == CardSwipeOrientation.left ||
                              orientation == CardSwipeOrientation.right) {
                            setState(() {
                              lastSwiped.clear();
                              logger.e("ici");
                              logger.e(lastSwiped);
                              lastSwiped.add(movieDetails[index]);
                              logger.e("la");
                              logger.e(lastSwiped);
                            });
                          }
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
                          onPressed: () {
                            if (lastSwiped.isNotEmpty) {
                              setState(() {
                                movieDetails.insert(0, lastSwiped.last);
                                lastSwiped.removeLast();
                              });
                              controller.triggerLeft();
                            }
                          },
                          style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: const BorderSide(
                                      color: Color(0xFFEAEAEA), width: 1.7))),
                        ),
                        SizedBox(width: 20),
                        //FAVORIS
                        IconButton(
                          icon: const Icon(
                            Icons.favorite_rounded,
                            color: Colors.green,
                            size: 55,
                          ),
                          onPressed: () {
                            controller.triggerRight();
                          },
                          style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: const BorderSide(
                                      color: Color(0xFFEAEAEA), width: 1.7))),
                        ),
                        SizedBox(width: 20),
                        //SKIP
                        IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.red,
                            size: 40,
                          ),
                          onPressed: () {
                            controller.triggerLeft();
                          },
                          style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: const BorderSide(
                                      color: Color(0xFFEAEAEA), width: 1.7))),
                        ),
                      ],
                    )
                  ],
                ),
    );
  }
}
