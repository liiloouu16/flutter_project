import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const SearchBarWidget(
      {super.key, required this.controller, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[Colors.deepPurpleAccent, Colors.purpleAccent],
            ),
          ),
        ),
        title: TextField(
          controller: controller,
          onSubmitted: onSearch,
          style: const TextStyle(color: Colors.black), // <- Texte noir
          decoration: const InputDecoration(
            hintText: 'Rechercher un film...',
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
          ),
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
