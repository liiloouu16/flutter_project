import 'package:flutter/material.dart';
import 'home.dart';
import 'swipe_movie.dart';
import 'affichageapi.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const Home(),
    const SwipeMovie(),
    const Recherche()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Produits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Courses',
          ),
        ],
      ),
    );
  }
}
