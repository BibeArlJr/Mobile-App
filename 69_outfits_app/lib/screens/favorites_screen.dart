// lib/screens/favorites_screen.dart

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/favorites.dart';
import 'product_detail_screen.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Product> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _favorites = Favorites.items;
    });
  }

  void _removeFavorite(Product p) {
    Favorites.remove(p);
    _loadFavorites();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed from favorites')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_favorites.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Your Favorites')),
        body: const Center(child: Text('No favorites yet!')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Favorites')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: _favorites.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (_, i) {
            final product = _favorites[i];
            return Stack(
              children: [
                ProductCard(
                  product: product,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailScreen(product: product),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeFavorite(product),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
