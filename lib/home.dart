import 'package:flutter/material.dart';
import 'package:flutter_project/listeFilm.dart';
import 'package:flutter_project/searchbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  void handleSearch(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: const Text(
            "FILMANIA",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A148C),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SearchBarWidget(
            controller: _searchController,
            onSearch: handleSearch,
          ),
        ),
      ),
      body: ListFilm(query: searchQuery),
      //backgroundColor: Colors.black87,
    );
  }
}
