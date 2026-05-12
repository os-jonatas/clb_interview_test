import 'package:flutter/material.dart';

/// Tela de favoritos — exibe apenas o texto "Favoritos" como placeholder.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('Favoritos')),
    );
  }
}
