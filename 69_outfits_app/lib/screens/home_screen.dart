import 'package:flutter/material.dart';
import '../data/session.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = ProductRepository();
  final _searchCtrl = TextEditingController();
  final List<String> _tabs = ['All Items', 'Women', 'Men', 'Kid'];

  List<Product> _allProducts = [];
  List<Product> _filtered = [];
  String _selectedCategory = 'All Items';

  @override
  void initState() {
    super.initState();
    // Load products and initialize lists
    _repo.loadProducts().then((list) {
      setState(() {
        _allProducts = list;
        _filtered = list;
      });
    });
    // Re-apply filters whenever the search text changes
    _searchCtrl.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final query = _searchCtrl.text.toLowerCase();
    var temp = _allProducts;

    // Category filter
    if (_selectedCategory != 'All Items') {
      temp = temp.where((p) => p.category == _selectedCategory).toList();
    }
    // Search filter
    if (query.isNotEmpty) {
      temp = temp.where((p) => p.name.toLowerCase().contains(query)).toList();
    }

    setState(() {
      _filtered = temp;
    });
  }

  void _filterCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    // Pull the username from session
    final username = Session().username ?? 'Guest';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting with username
            Text('Hello, $username 👋',
                style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Display the username here, too
                Text(username,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const CircleAvatar(
                  radius: 16,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Search + filter icon
          Row(children: [
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Search clothes...',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.filter_list, color: Colors.white),
            ),
          ]),
          const SizedBox(height: 16),
          // Category tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _tabs.map((tab) {
                final isSelected = tab == _selectedCategory;
                return GestureDetector(
                  onTap: () => _filterCategory(tab),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      tab,
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          // Product grid
          Expanded(
            child: GridView.builder(
              itemCount: _filtered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16),
              itemBuilder: (_, i) {
                final product = _filtered[i];
                return ProductCard(
                  product: product,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: product)),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
