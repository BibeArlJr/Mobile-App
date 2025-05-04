import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import '../data/product_repository.dart';

class ProductGridScreen extends StatefulWidget {
  const ProductGridScreen({super.key});
  @override State<ProductGridScreen> createState() => _ProductGridScreenState();
}

class _ProductGridScreenState extends State<ProductGridScreen> {
  final _repo = ProductRepository();
  List<Product> _allProducts = [], _filtered = [];
  String _selectedCategory = 'All Items';
  final List<String> _tabs = ['All Items', 'Women', 'Men', 'Kid'];

  @override
  void initState() {
    super.initState();
    _repo.loadProducts().then((list) {
      setState(() {
        _allProducts = list;
        _filtered = list;
      });
    });
  }

  void _filter(String category) {
    setState(() {
      _selectedCategory = category;
      _filtered = category == 'All Items'
        ? _allProducts
        : _allProducts.where((p) => p.category == category).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Hello, Welcome 👋', style: TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 4),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Albert Stevano', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const CircleAvatar(radius: 16, backgroundImage: NetworkImage('https://via.placeholder.com/150')),
          ]),
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Search row
          Row(children: [
            Expanded(child: TextField(
              decoration: InputDecoration(
                hintText: 'Search clothes...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            )),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.filter_list, color: Colors.white),
            ),
          ]),
          const SizedBox(height: 16),
          // Category filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: _tabs.map((e) {
              final sel = e == _selectedCategory;
              return GestureDetector(
                onTap: () => _filter(e),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: sel ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(e, style: TextStyle(color: sel ? Colors.white : Colors.black)),
                ),
              );
            }).toList()),
          ),
          const SizedBox(height: 16),
          // Product grid
          Expanded(child: GridView.builder(
            itemCount: _filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.6, crossAxisSpacing: 16, mainAxisSpacing: 16),
            itemBuilder: (_, i) {
              final product = _filtered[i];
              return ProductCard(
                product: product,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
                ),
              );
            },
          )),
        ]),
      ),
    );
  }
}
