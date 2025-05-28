import 'package:flutter/material.dart';
import 'home.dart';
import 'searchbar.dart';
import 'swipe_movie.dart';
import 'affichageapi.dart';
import 'searchbar.dart';

class NavBar extends StatefulWidget {
  final int selectedIndex;

  const NavBar({super.key, required this.selectedIndex});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  void _onItemTapped(int index) {
    if (index == widget.selectedIndex) return;

    Widget nextPage;
    switch (index) {
      case 0:
        nextPage = const Home();
        break;
      case 1:
        nextPage = const Recherche();
        break;
      case 2:
        nextPage = const SwipeMovie();
        break;
      default:
        nextPage = const Home();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.movie_creation_outlined), label: 'Movies'),
        BottomNavigationBarItem(icon: Icon(Icons.swipe), label: 'Swipe'),
        BottomNavigationBarItem(
            icon: Icon(Icons.question_mark_outlined), label: 'Random'),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.deepPurpleAccent,
      onTap: _onItemTapped,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Liste des pages associées aux index
  final List<Widget> _pages = [
    const Home(),
    const MoviesPage(),
    const SwipeMovie(),
    const Recherche(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Change l’index pour afficher la bonne page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Affiche la page correspondant à l’index
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.movie_creation_outlined), label: 'Movies'),
          BottomNavigationBarItem(icon: Icon(Icons.swipe), label: 'Swipe'),
          BottomNavigationBarItem(
              icon: Icon(Icons.question_mark_outlined), label: 'Random'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Recherche'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurpleAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
