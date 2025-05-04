import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import '../data/product_repository.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});
  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _category = 'Women';
  final List<String> _sizes = [];
  final List<String> _colors = [];
  final List<XFile> _images = [];
  final _picker = ImagePicker();
  final List<Product> _products = [];
  final _repo = ProductRepository();

  @override
  void initState() {
    super.initState();
    // load existing products from JSON
    _repo.loadProducts().then((list) {
      setState(() => _products.addAll(list));
    });
  }

  Future<void> _pickImages() async {
    final imgs = await _picker.pickMultiImage();
    if (imgs.isNotEmpty) {
      setState(() => _images.addAll(imgs));
    }
  }

  Future<void> _addProduct() async {
    // Build a new Product instance with all required fields:
    final newProduct = Product(
      id: _products.length + 1,
      name: _nameCtrl.text,
      category: _category,
      price: double.tryParse(_priceCtrl.text) ?? 0.0,
      description: _descCtrl.text,
      imageUrls: _images.map((x) => x.path).toList(),
      rating: 0.0,               // default for new items
      sizes: List.of(_sizes),    // copy selected sizes
      colors: List.of(_colors),  // copy selected colors
    );

    setState(() {
      _products.add(newProduct);

      // clear the form
      _nameCtrl.clear();
      _priceCtrl.clear();
      _descCtrl.clear();
      _sizes.clear();
      _colors.clear();
      _images.clear();
      _category = 'Women';
    });

    // optionally: persist back to disk with _repo.saveProducts(_products);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Name
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Product Name'),
          ),
          const SizedBox(height: 8),

          // Category
          DropdownButtonFormField<String>(
            value: _category,
            decoration: const InputDecoration(labelText: 'Category'),
            items: ['Women', 'Men', 'Kid']
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _category = v!),
          ),
          const SizedBox(height: 8),

          // Price
          TextField(
            controller: _priceCtrl,
            decoration: const InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),

          // Description
          TextField(
            controller: _descCtrl,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          // Sizes selection
          const Text('Sizes'),
          Wrap(
            spacing: 8,
            children: ['S', 'M', 'L', 'XL'].map((s) {
              final selected = _sizes.contains(s);
              return FilterChip(
                label: Text(s),
                selected: selected,
                onSelected: (_) {
                  setState(() {
                    if (selected) {
                      _sizes.remove(s);
                    } else {
                      _sizes.add(s);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Colors selection
          const Text('Colors'),
          Wrap(
            spacing: 8,
            children: ['Black', 'White', 'Blue', 'Red'].map((c) {
              final selected = _colors.contains(c);
              return FilterChip(
                label: Text(c),
                selected: selected,
                onSelected: (_) {
                  setState(() {
                    if (selected) {
                      _colors.remove(c);
                    } else {
                      _colors.add(c);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Image picker
          ElevatedButton.icon(
            onPressed: _pickImages,
            icon: const Icon(Icons.photo),
            label: const Text('Select Photos'),
          ),
          const SizedBox(height: 12),

          // Add button
          Center(
            child: ElevatedButton(
              onPressed: _addProduct,
              child: const Text('Add Product'),
            ),
          ),
          const Divider(height: 32),

          // Data table of existing products
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Action')),
              ],
              rows: _products.map((p) {
                return DataRow(cells: [
                  DataCell(Text(p.name)),
                  DataCell(Text(p.category)),
                  DataCell(IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() => _products.remove(p));
                    },
                  )),
                ]);
              }).toList(),
            ),
          ),
        ]),
      ),
    );
  }
}
