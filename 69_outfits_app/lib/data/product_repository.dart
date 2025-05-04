import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/product.dart';

class ProductRepository {
  Future<List<Product>> loadProducts() async {
    // 1. Read the raw JSON file from assets
    final raw = await rootBundle.loadString('assets/products.json');

    // 2. Decode to a List<dynamic>
    final List<dynamic> list = json.decode(raw) as List<dynamic>;

    // 3. Map each entry into a Product
    final products =
        list.map((m) => Product.fromJson(m as Map<String, dynamic>)).toList();

    return products;
  }
}
