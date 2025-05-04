import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/cart.dart';
import '../data/favorites.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int qty = 1, _page = 0;
  String? _selectedSize;
  String? _selectedColor;
  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
    // default to first options if available
    _selectedSize =
        widget.product.sizes.isNotEmpty ? widget.product.sizes.first : null;
    _selectedColor =
        widget.product.colors.isNotEmpty ? widget.product.colors.first : null;
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final isFav = Favorites.contains(p);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Carousel ───────────────────────────────────────────
            SizedBox(
              height: 300,
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                children: p.imageUrls
                    .map((url) => ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(url, fit: BoxFit.cover),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(p.imageUrls.length, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _page == i ? 12 : 8,
                  height: _page == i ? 12 : 8,
                  decoration: BoxDecoration(
                    color: _page == i ? Colors.black : Colors.black26,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),
            // ─── Title & Description ────────────────────────────────
            Text(p.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(p.description, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),

            // ─── Size Selector ───────────────────────────────────────
            if (p.sizes.isNotEmpty) ...[
              const Text("Select Size",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: p.sizes.map((s) {
                  final selected = s == _selectedSize;
                  return ChoiceChip(
                    label: Text(s),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedSize = s),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // ─── Color Selector ──────────────────────────────────────
            if (p.colors.isNotEmpty) ...[
              const Text("Select Color",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: p.colors.map((c) {
                  final selected = c == _selectedColor;
                  return ChoiceChip(
                    label: Text(c),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedColor = c),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // ─── Quantity Selector ───────────────────────────────────
            Row(
              children: [
                IconButton(
                    onPressed: () => setState(() {
                          if (qty > 1) qty--;
                        }),
                    icon: const Icon(Icons.remove_circle_outline)),
                Text('$qty', style: const TextStyle(fontSize: 18)),
                IconButton(
                    onPressed: () => setState(() => qty++),
                    icon: const Icon(Icons.add_circle_outline)),
              ],
            ),
            const SizedBox(height: 24),

            // ─── Add to Cart + Favorite Row ─────────────────────────
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      if (_selectedSize == null || _selectedColor == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Please select size and color first')),
                        );
                        return;
                      }
                      for (var i = 0; i < qty; i++) {
                        cart.addItem(p,
                            size: _selectedSize!, color: _selectedColor!);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart')));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CartScreen()));
                    },
                    child: Text(
                      'Add to Cart | \$${(p.price * qty).toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFav ? Colors.red.shade400 : Colors.grey.shade200,
                    foregroundColor: isFav ? Colors.white : Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    setState(() {
                      if (isFav) {
                        Favorites.remove(p);
                      } else {
                        Favorites.add(p);
                      }
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isFav
                            ? 'Removed from favorites'
                            : 'Added to favorites'),
                      ),
                    );
                  },
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
